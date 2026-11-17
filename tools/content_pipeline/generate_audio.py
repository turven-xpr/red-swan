#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
generate_audio.py — generate every audio clip ONCE and keep it forever.

The app never calls a TTS API.  This script runs on YOUR PC:
  1. reads every German text that needs sound from output/deutschy_prototype.db
     (words with their article, sentences, story/dialogue lines, exercise audio_text)
     + optional extra lines from a text file (e.g. A0 letters/numbers);
  2. for each (voice, text) it creates ONE mp3 file in audio/<voice>/<hash>.mp3
     -- but only if that exact clip does not exist yet (audio/manifest.json is the cache);
  3. fills the table audio_clips(voice, text_de, file) in the DB, so the app can find the file.

Re-running is free: existing clips are never regenerated.  If you rebuild the DB with
prototype_unit.py, just run this script again: it re-links the cached files without any API call.

Setup
  pip install requests
  cp audio_config.sample.json audio_config.json        (edit voices, see --list-voices)
  Azure : set env AZURE_SPEECH_KEY       (region in audio_config.json)
  Google: set env GOOGLE_TTS_API_KEY
  Piper : install piper + ffmpeg, put the .onnx voices in models/
  NEVER put keys in the app or in Git.

Usage
  python generate_audio.py --list-voices                 # show real German voice names
  python generate_audio.py --dry-run                     # count clips and characters only
  python generate_audio.py --level A0 --extra manual_content/a0_audio.txt
  python generate_audio.py --limit 5                     # try 5 clips first (recommended)
  python generate_audio.py                               # everything missing

Extra file format (one per line, # = comment):   text      or      voicekey|text
"""
from __future__ import annotations

import argparse
import base64
import hashlib
import json
import os
import sqlite3
import subprocess
import sys
import tempfile
import time
from pathlib import Path
from xml.sax.saxutils import escape


# --------------------------------------------------------------------------- providers
def _post_with_retry(fn, tries=5):
    """call fn() -> requests.Response, retry on rate-limit / temporary errors"""
    for i in range(tries):
        r = fn()
        if r.status_code in (429, 500, 502, 503):
            time.sleep(3 * (i + 1))
            continue
        return r
    return r


def lang_of(voice_id: str) -> str:
    return "-".join(voice_id.split("-")[:2])            # de-DE-KatjaNeural -> de-DE


def synth_azure(cfg, voice_id, text) -> bytes:
    import requests
    key = os.environ["AZURE_SPEECH_KEY"]
    region = cfg["azure"]["region"]
    inner = escape(text)
    if cfg["azure"].get("rate"):
        inner = f'<prosody rate="{cfg["azure"]["rate"]}">{inner}</prosody>'
    ssml = (f"<speak version='1.0' xml:lang='{lang_of(voice_id)}'>"
            f"<voice name='{voice_id}'>{inner}</voice></speak>")
    r = _post_with_retry(lambda: requests.post(
        f"https://{region}.tts.speech.microsoft.com/cognitiveservices/v1",
        headers={"Ocp-Apim-Subscription-Key": key,
                 "Content-Type": "application/ssml+xml",
                 "X-Microsoft-OutputFormat": "audio-24khz-48kbitrate-mono-mp3",
                 "User-Agent": "deutschy-audio"},
        data=ssml.encode("utf-8"), timeout=60))
    if r.status_code != 200:
        raise RuntimeError(f"Azure {r.status_code}: {r.text[:200]}")
    return r.content


def synth_google(cfg, voice_id, text) -> bytes:
    import requests
    key = os.environ["GOOGLE_TTS_API_KEY"]
    body = {"input": {"text": text},
            "voice": {"languageCode": lang_of(voice_id), "name": voice_id},
            "audioConfig": {"audioEncoding": "MP3"}}
    if cfg["google"].get("speaking_rate"):
        body["audioConfig"]["speakingRate"] = cfg["google"]["speaking_rate"]
    r = _post_with_retry(lambda: requests.post(
        "https://texttospeech.googleapis.com/v1/text:synthesize",
        params={"key": key}, json=body, timeout=60))
    if r.status_code != 200:
        raise RuntimeError(f"Google {r.status_code}: {r.text[:200]}")
    return base64.b64decode(r.json()["audioContent"])


def synth_piper(cfg, model_path, text) -> bytes:
    exe = cfg["piper"].get("executable", "piper")
    with tempfile.TemporaryDirectory() as tmp:
        wav, mp3 = Path(tmp) / "o.wav", Path(tmp) / "o.mp3"
        cmd = [exe, "--model", model_path, "--output_file", str(wav)]
        if cfg["piper"].get("length_scale"):
            cmd += ["--length_scale", str(cfg["piper"]["length_scale"])]
        subprocess.run(cmd, input=text.encode("utf-8"), check=True, capture_output=True)
        subprocess.run(["ffmpeg", "-y", "-loglevel", "error", "-i", str(wav), "-ac", "1",
                        "-b:a", "48k", str(mp3)], check=True)
        return mp3.read_bytes()


def synth_fake(cfg, voice_id, text) -> bytes:           # plumbing tests only (not real audio)
    return b"FAKE-AUDIO|" + voice_id.encode() + b"|" + text.encode("utf-8")


PROVIDERS = {"azure": synth_azure, "google": synth_google, "piper": synth_piper, "fake": synth_fake}


def list_voices(cfg, provider):
    import requests
    if provider == "azure":
        r = requests.get(f"https://{cfg['azure']['region']}.tts.speech.microsoft.com/cognitiveservices/voices/list",
                         headers={"Ocp-Apim-Subscription-Key": os.environ["AZURE_SPEECH_KEY"]}, timeout=60)
        r.raise_for_status()
        for v in r.json():
            if v.get("Locale", "").startswith("de-"):
                print(f"{v['ShortName']:34} {v.get('Gender',''):7} {v['Locale']}")
    elif provider == "google":
        r = requests.get("https://texttospeech.googleapis.com/v1/voices",
                         params={"languageCode": "de-DE", "key": os.environ["GOOGLE_TTS_API_KEY"]}, timeout=60)
        r.raise_for_status()
        for v in r.json().get("voices", []):
            print(f"{v['name']:34} {v.get('ssmlGender','')}")
    else:
        print("Piper: voices are the .onnx files you put in models/")


# --------------------------------------------------------------------------- collect texts
def voice_for(cfg, text, speaker=None, is_word=False):
    if is_word and cfg.get("word_voice"):
        return cfg["word_voice"]
    sv = cfg.get("speaker_voice", {})
    if speaker and speaker in sv:
        return sv[speaker]
    pool = cfg["voice_pool"]
    return pool[int(hashlib.sha1(text.encode("utf-8")).hexdigest(), 16) % len(pool)]


def collect(con, cfg, level, extra_file):
    jobs = {}                                           # (voice, text) -> True

    def add(text, speaker=None, is_word=False, voice=None):
        text = (text or "").strip()
        if text:
            jobs[(voice or voice_for(cfg, text, speaker, is_word), text)] = True

    L = (level, level)
    tables = {r[0] for r in con.execute("SELECT name FROM sqlite_master WHERE type='table'").fetchall()}
    cols = {r[1] for r in con.execute("PRAGMA table_info(exercises)").fetchall()} if "exercises" in tables else set()

    if "exercises" in tables:
        if "content_items" in tables and "content_id" in cols:
            for (t,) in con.execute(
                    "SELECT DISTINCT e.audio_text FROM exercises e "
                    "LEFT JOIN lessons l ON l.id=e.lesson_id LEFT JOIN content_items c ON c.id=e.content_id "
                    "WHERE e.audio_text IS NOT NULL AND e.audio_text<>'' AND (? IS NULL OR l.level=? OR c.level=?)",
                    (level, level, level)):
                add(t)
        else:
            for (t,) in con.execute(
                    "SELECT DISTINCT e.audio_text FROM exercises e "
                    "LEFT JOIN lessons l ON l.id=e.lesson_id "
                    "WHERE e.audio_text IS NOT NULL AND e.audio_text<>'' AND (? IS NULL OR l.level=?)",
                    (level, level)):
                add(t)

    if "words" in tables:
        for art, lemma in con.execute("SELECT gender, lemma FROM words WHERE (? IS NULL OR level=?)", L):
            add(f"{art} {lemma}" if art else lemma, is_word=True)

    if "sentences" in tables and "word_sentence" in tables:
        for (t,) in con.execute(
                "SELECT DISTINCT s.text_de FROM sentences s JOIN word_sentence ws ON ws.sentence_id=s.id "
                "JOIN words w ON w.id=ws.word_id WHERE (? IS NULL OR w.level=?)", L):
            add(t)

    if "content_segments" in tables and "content_items" in tables:
        for t, spk in con.execute(
                "SELECT cs.text_de, cs.speaker FROM content_segments cs JOIN content_items c ON c.id=cs.content_id "
                "WHERE (? IS NULL OR c.level=?)", L):
            add(t, speaker=spk)
    if extra_file and Path(extra_file).exists():
        for line in Path(extra_file).read_text(encoding="utf-8").splitlines():
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            if "|" in line and line.split("|", 1)[0].strip() in cfg["voices_all"]:
                v, t = line.split("|", 1)
                add(t, voice=v.strip())
            else:
                add(line, is_word=True)

    json_path = Path(__file__).resolve().parent.parent.parent / "assets" / "deutschy_content.json"
    if json_path.exists():
        try:
            content_data = json.loads(json_path.read_text(encoding="utf-8"))
            for e in content_data.get("exercises", []):
                t = e.get("audio_text")
                if t and t.strip():
                    add(t.strip())
        except Exception as err:
            print("Warning reading deutschy_content.json:", err)

    return list(jobs)


# --------------------------------------------------------------------------- main
def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=str(Path(__file__).parent))
    ap.add_argument("--db", default="output/deutschy_prototype.db")
    ap.add_argument("--config", default="audio_config.json")
    ap.add_argument("--provider", help="override provider from the config (azure/google/piper/fake)")
    ap.add_argument("--level", help="only this level, e.g. A0")
    ap.add_argument("--extra", help="extra text file (letters, numbers, ...)")
    ap.add_argument("--list-voices", action="store_true")
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--audio-dir", help="output directory for audio clips and manifest (default: <root>/audio)")
    ap.add_argument("--limit", type=int, default=0, help="generate at most N new clips (testing)")
    ap.add_argument("--max-chars", type=int, default=0, help="refuse to send more characters than this")
    ap.add_argument("--yes", action="store_true", help="do not ask for confirmation")
    args = ap.parse_args()

    root = Path(args.root)
    cfg_path = root / args.config
    if not cfg_path.exists():
        sys.exit(f"Missing {cfg_path}. Copy audio_config.sample.json to audio_config.json and edit it.")
    cfg = json.loads(cfg_path.read_text(encoding="utf-8"))
    provider = args.provider or cfg["provider"]
    cfg["voices_all"] = set(cfg[provider]["voices"]) if provider in cfg else set()

    if args.list_voices:
        list_voices(cfg, provider)
        return

    audio_dir = Path(args.audio_dir) if args.audio_dir else (root / "audio")
    manifest_path = audio_dir / "manifest.json"
    audio_dir.mkdir(exist_ok=True)
    manifest = json.loads(manifest_path.read_text(encoding="utf-8")) if manifest_path.exists() else {"clips": {}}
    clips = manifest["clips"]

    con = sqlite3.connect(root / args.db)
    con.execute("CREATE TABLE IF NOT EXISTS audio_clips ("
                "voice TEXT NOT NULL, text_de TEXT NOT NULL, file TEXT NOT NULL, PRIMARY KEY (voice, text_de))")

    jobs = collect(con, cfg, args.level, args.extra or (root / "manual_content" / "a0_audio.txt"))
    unknown = sorted({v for v, _ in jobs if v not in cfg[provider]["voices"]})
    if unknown:
        sys.exit(f"Voice keys not defined for provider '{provider}': {unknown} (see audio_config.json)")

    def key(v, t):
        return f"{v}|{t}"

    todo = [(v, t) for v, t in jobs
            if key(v, t) not in clips or not (audio_dir / clips[key(v, t)]["file"]).exists()]
    chars = sum(len(t) for _, t in todo)
    per_voice = {}
    for v, _ in todo:
        per_voice[v] = per_voice.get(v, 0) + 1
    print(f"Provider: {provider}")
    print(f"Clips needed: {len(jobs)}   already cached: {len(jobs) - len(todo)}   to generate: {len(todo)}")
    print(f"Characters to send: {chars}   per voice: {per_voice}")
    if args.dry_run:
        return
    if args.max_chars and chars > args.max_chars:
        sys.exit(f"{chars} characters > --max-chars {args.max_chars}. Use --level / --limit or raise the limit.")
    if args.limit:
        todo = todo[: args.limit]
    if todo and not args.yes:
        if input(f"Generate {len(todo)} clip(s) now? [y/N] ").strip().lower() != "y":
            sys.exit("Cancelled.")

    synth = PROVIDERS[provider]
    interval = 60.0 / cfg[provider]["rpm"] if cfg[provider].get("rpm") else 0.0
    last = 0.0
    done = failed = 0
    for i, (v, t) in enumerate(todo, 1):
        voice_id = cfg[provider]["voices"][v]
        wait = interval - (time.time() - last)
        if wait > 0:
            time.sleep(wait)
        try:
            data = synth(cfg, voice_id, t)
        except Exception as e:                                   # keep going, report at the end
            failed += 1
            print(f"  FAILED [{v}] {t[:50]!r}: {e}")
            last = time.time()
            continue
        last = time.time()
        h = hashlib.sha1(key(v, t).encode("utf-8")).hexdigest()[:16]
        rel = f"{v}/{h}.mp3"
        (audio_dir / v).mkdir(exist_ok=True)
        (audio_dir / rel).write_bytes(data)
        clips[key(v, t)] = {"file": rel, "text": t, "voice": v, "provider": provider,
                            "voice_id": voice_id, "bytes": len(data)}
        done += 1
        if done % 10 == 0:                                       # save progress: safe to interrupt
            manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=1), encoding="utf-8")
        print(f"  [{i}/{len(todo)}] {v}: {t[:60]}")
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=1), encoding="utf-8")

    linked = 0
    for v, t in jobs:
        c = clips.get(key(v, t))
        if c and (audio_dir / c["file"]).exists():
            con.execute("INSERT OR REPLACE INTO audio_clips VALUES (?,?,?)", (v, t, "audio/" + c["file"]))
            linked += 1
    con.commit()
    con.close()

    total_bytes = sum(c["bytes"] for c in clips.values())
    print(f"\nDone. generated {done}, failed {failed}, linked in DB {linked}/{len(jobs)}.")
    print(f"Audio folder: {audio_dir}  ({len(clips)} clips, {total_bytes / 1e6:.1f} MB)")
    print("Copy the audio/ folder and the .db into your Flutter assets.")
    if failed:
        print("Run the script again to retry the failed clips (finished ones are never regenerated).")


if __name__ == "__main__":
    main()
