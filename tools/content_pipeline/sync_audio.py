import base64
import hashlib
import json
import os
import sys
import time
from pathlib import Path
import requests

ROOT = Path(__file__).resolve().parent.parent.parent
CONTENT_PATH = ROOT / "assets" / "deutschy_content.json"
AUDIO_DIR = ROOT / "assets" / "audio"
MANIFEST_PATH = AUDIO_DIR / "manifest.json"

API_KEY = os.environ.get("GOOGLE_TTS_API_KEY")
if not API_KEY and len(sys.argv) > 1 and sys.argv[1].startswith("AIza"):
    API_KEY = sys.argv[1]

if not API_KEY:
    print("Error: GOOGLE_TTS_API_KEY not provided.")
    sys.exit(1)

manifest = json.loads(MANIFEST_PATH.read_text(encoding="utf-8")) if MANIFEST_PATH.exists() else {"clips": {}}
clips = manifest.setdefault("clips", {})

content = json.loads(CONTENT_PATH.read_text(encoding="utf-8"))

texts = set()
for e in content.get("exercises", []):
    t = e.get("audio_text")
    if t and t.strip():
        texts.add(t.strip())

for w in content.get("words", []):
    art = w.get("gender")
    lemma = w.get("lemma")
    if lemma:
        texts.add(lemma)
        if art:
            texts.add(f"{art} {lemma}")

unique_texts = sorted(texts)
voices = {"f1": "de-DE-Neural2-G", "m1": "de-DE-Neural2-H"}

todo = []
for idx, t in enumerate(unique_texts):
    v_key = "f1" if idx % 2 == 0 else "m1"
    key = f"{v_key}|{t}"
    if key not in clips or not (AUDIO_DIR / clips[key]["file"]).exists():
        todo.append((v_key, t))

print(f"Total unique texts: {len(unique_texts)}, Missing clips to generate: {len(todo)}")

def synth(voice_name, text):
    body = {
        "input": {"text": text},
        "voice": {"languageCode": "de-DE", "name": voice_name},
        "audioConfig": {"audioEncoding": "MP3", "speakingRate": 0.9}
    }
    r = requests.post(
        "https://texttospeech.googleapis.com/v1/text:synthesize",
        params={"key": API_KEY},
        json=body,
        timeout=30
    )
    if r.status_code != 200:
        raise RuntimeError(f"Google TTS API {r.status_code}: {r.text[:200]}")
    return base64.b64decode(r.json()["audioContent"])

done = 0
failed = 0

for v_key, text in todo:
    voice_name = voices[v_key]
    out_dir = AUDIO_DIR / v_key
    out_dir.mkdir(parents=True, exist_ok=True)
    h = hashlib.sha256(f"{v_key}|{text}".encode("utf-8")).hexdigest()[:16]
    rel_path = f"{v_key}/{h}.mp3"
    full_path = AUDIO_DIR / rel_path
    
    try:
        audio_bytes = synth(voice_name, text)
        full_path.write_bytes(audio_bytes)
        clips[f"{v_key}|{text}"] = {
            "file": rel_path,
            "text": text,
            "voice": v_key,
            "provider": "google",
            "voice_id": voice_name,
            "bytes": len(audio_bytes)
        }
        done += 1
        print(f"[{done}/{len(todo)}] [{v_key}] {text}")
        time.sleep(0.12)
    except Exception as e:
        failed += 1
        print(f"Failed [{v_key}] {text}: {e}")

MANIFEST_PATH.write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8")
print(f"Sync complete. Generated: {done}, Failed: {failed}. Total clips in manifest: {len(clips)}")

