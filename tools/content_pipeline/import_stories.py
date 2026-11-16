#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
import_stories.py — imports hand-written texts / dialogues / stories into the content DB.

It is called automatically by prototype_unit.py, or you can run it alone on an existing DB:
  python import_stories.py --db output/deutschy_prototype.db

Authoring format: one JSON file per item in manual_content/stories/  (see the samples there).

{
  "slug": "a1_family_text",          unique, never change it after release (stable id)
  "kind": "text" | "dialogue" | "story",
  "level": "A1",
  "unit": "family",                  topic_key of the unit it belongs to
  "title_de": "...", "title_ar": "...", "summary_ar": "...",
  "est_minutes": 5,                  optional (computed if missing)
  "segments": [                      one sentence (or short paragraph) per segment
    {"speaker": null, "de": "...", "ar": "...", "note_ar": "optional explanation",
     "glossary": [{"w": "Jahre", "ar": "سنوات"}]}
  ],
  "exercises": [
    {"skill": "reading", "type": "comprehension_mc", "prompt": "...", "options": ["a","b","c"],
     "answer": "a", "explain_ar": "..."},
    {"skill": "reading", "type": "true_false", "prompt": "...", "answer": true, "explain_ar": "..."},
    {"skill": "reading", "type": "order_events", "prompt": "...", "answer": ["first","second","third"]},
    {"skill": "reading", "type": "match_pairs", "prompt": "", "pairs": [["Bruder","أخ"],["Schwester","أخت"]]},
    {"skill": "writing", "type": "type_fill_blank", "prompt": "Ich ___ einen Bruder.", "answer": "habe"},
    {"skill": "speaking", "type": "answer_prompt", "prompt": "...", "answer": "model answer"}
  ]
}
"""
from __future__ import annotations

import argparse
import json
import math
import random
import sqlite3
import sys
from pathlib import Path

ALLOWED_TYPES = {
    "comprehension_mc", "true_false", "order_events", "vocab_in_context", "match_pairs",
    "type_fill_blank", "type_translate", "answer_prompt", "chip_fill_blank", "listen_choose",
}
SKILLS = {"listening", "reading", "writing", "speaking"}
SKIP_POS = {"PUNCT", "SPACE", "NUM", "SYM"}
CLOSED_POS = {"DET", "PRON", "ADP", "CCONJ", "SCONJ", "AUX", "PART", "PUNCT",
              "NUM", "SYM", "PROPN", "INTJ", "SPACE"}


def _dump(v):
    if v is None:
        return None
    return v if isinstance(v, str) else json.dumps(v, ensure_ascii=False)


def validate(item: dict, fname: str):
    errs = []
    for k in ("slug", "kind", "level", "unit", "title_de", "title_ar", "segments"):
        if not item.get(k):
            errs.append(f"missing '{k}'")
    if item.get("kind") not in ("text", "dialogue", "story"):
        errs.append("kind must be text / dialogue / story")
    for i, s in enumerate(item.get("segments", []), 1):
        if not s.get("de") or not s.get("ar"):
            errs.append(f"segment {i}: 'de' and 'ar' are both required")
    for i, ex in enumerate(item.get("exercises", []), 1):
        t = ex.get("type")
        if ex.get("skill") not in SKILLS:
            errs.append(f"exercise {i}: bad skill")
        if t not in ALLOWED_TYPES:
            errs.append(f"exercise {i}: unknown type '{t}'")
        if t in ("comprehension_mc", "vocab_in_context", "chip_fill_blank", "listen_choose"):
            if ex.get("answer") not in ex.get("options", []):
                errs.append(f"exercise {i}: 'answer' must be one of 'options'")
        if t == "true_false" and not isinstance(ex.get("answer"), bool):
            errs.append(f"exercise {i}: true_false needs a boolean answer")
        if t == "order_events" and (not isinstance(ex.get("answer"), list) or len(ex["answer"]) < 3):
            errs.append(f"exercise {i}: order_events needs an 'answer' list (correct order, >= 3 items)")
        if t == "match_pairs" and len(ex.get("pairs", [])) < 3:
            errs.append(f"exercise {i}: match_pairs needs at least 3 'pairs'")
        if t not in ("match_pairs",) and "answer" not in ex:
            errs.append(f"exercise {i}: missing 'answer'")
    if errs:
        raise ValueError(f"{fname}: " + "; ".join(errs))


def import_all(con: sqlite3.Connection, stories_dir: Path, reg, lem, words: list[dict], base_known: set) -> str:
    unit_ids = {t: i for i, t in con.execute("SELECT id, topic_key FROM units")}
    by_lemma = {w["lemma"].lower(): w for w in words}
    by_plural = {w["plural"].lower(): w for w in words if w.get("plural")}
    known = set(base_known) | set(by_lemma)

    files = sorted(stories_dir.glob("*.json"))
    lines = [f"\n--- Stories & texts: {len(files)} file(s) ---"]
    order = 0
    for f in files:
        item = json.loads(f.read_text(encoding="utf-8"))
        validate(item, f.name)
        if item["unit"] not in unit_ids:
            raise ValueError(f"{f.name}: unknown unit '{item['unit']}' (known: {', '.join(unit_ids)})")
        rng = random.Random(item["slug"])
        cid = reg.get("content", item["slug"])
        order += 1
        segs = item["segments"]
        n_words = sum(len(s["de"].split()) for s in segs)
        minutes = item.get("est_minutes") or max(1, math.ceil(n_words / 60))
        con.execute("INSERT INTO content_items VALUES (?,?,?,?,?,?,?,?,?,?,?)",
                    (cid, item["kind"], item["level"], unit_ids[item["unit"]], item["slug"],
                     item["title_de"], item["title_ar"], item.get("summary_ar"), minutes, None, order))

        analyses = list(lem.analyze([s["de"] for s in segs]))
        total = known_cnt = 0
        unglossed: dict[str, int] = {}
        for no, (s, toks) in enumerate(zip(segs, analyses), 1):
            seg_id = con.execute(
                "INSERT INTO content_segments(content_id,sort_order,speaker,text_de,text_ar,note_ar,"
                "audio_start_ms,audio_end_ms) VALUES (?,?,?,?,?,?,?,?)",
                (cid, no, s.get("speaker"), s["de"], s["ar"], s.get("note_ar"), None, None)).lastrowid

            manual = {}
            covered = set()
            for g in s.get("glossary", []):
                manual[g["w"].lower()] = g
                for part in g["w"].lower().split():
                    covered.add(part)
            written = set()
            for g in s.get("glossary", []):
                if g["w"].lower() in s["de"].lower() or " " not in g["w"]:
                    con.execute("INSERT OR IGNORE INTO segment_glossary VALUES (?,?,?,?,?)",
                                (seg_id, g["w"], g.get("lemma"), g["ar"], None))
                    written.add(g["w"].lower())

            for surf, lemma, pos in toks:
                if pos in SKIP_POS:
                    continue
                total += 1
                sl = surf.lower()
                w = by_lemma.get(lemma) or by_plural.get(sl) or by_lemma.get(sl)
                if w is not None and sl not in written:
                    con.execute("INSERT OR IGNORE INTO segment_glossary VALUES (?,?,?,?,?)",
                                (seg_id, surf, w["lemma"], w["ar"], w.get("id")))
                    written.add(sl)
                if (pos in CLOSED_POS or lemma in known or sl in covered or w is not None):
                    known_cnt += 1
                else:
                    unglossed[lemma] = unglossed.get(lemma, 0) + 1

        for i, ex in enumerate(item.get("exercises", []), 1):
            t, answer, options = ex["type"], ex.get("answer"), ex.get("options")
            if t == "true_false":
                answer, options = ("true" if answer else "false"), None
            elif t == "order_events":
                options = answer[:]
                for _ in range(10):
                    rng.shuffle(options)
                    if options != answer:
                        break
            elif t == "match_pairs":
                lefts = [p[0] for p in ex["pairs"]]
                rights = [p[1] for p in ex["pairs"]]
                shuffled = rights[:]
                rng.shuffle(shuffled)
                answer, options = dict(zip(lefts, rights)), dict(left=lefts, right=shuffled)
            elif options:
                options = options[:]
                rng.shuffle(options)
            con.execute("INSERT INTO exercises(lesson_id,content_id,skill,exercise_type,prompt,audio_text,"
                        "correct_answer,options,explanation_ar,is_graded,is_test_pool,sort_order) "
                        "VALUES (?,?,?,?,?,?,?,?,?,?,?,?)",
                        (None, cid, ex["skill"], t, ex.get("prompt", ""), ex.get("audio_text"),
                         _dump(answer), _dump(options), ex.get("explain_ar"), 1, 0, i))

        pct = 100 * known_cnt / total if total else 100
        flag = "" if pct >= 90 else "   <-- below 90%: too hard for this level, simplify or add glossary"
        lines.append(f"{item['slug']}: {len(segs)} segments, {n_words} words, ~{minutes} min, "
                     f"{len(item.get('exercises', []))} exercises, vocabulary coverage {pct:.0f}%{flag}")
        if unglossed:
            top = ", ".join(f"{k}" for k, _ in sorted(unglossed.items(), key=lambda kv: -kv[1])[:15])
            lines.append(f"    words not known/glossed: {top}")
    return "\n".join(lines)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=str(Path(__file__).parent))
    ap.add_argument("--db", default="output/deutschy_prototype.db")
    ap.add_argument("--no-spacy", action="store_true")
    args = ap.parse_args()
    root = Path(args.root)

    sys.path.insert(0, str(Path(__file__).parent))
    import prototype_unit as pu

    con = sqlite3.connect(root / args.db)
    for t in ("segment_glossary", "content_segments", "content_items"):
        con.execute(f"DELETE FROM {t}")
    con.execute("DELETE FROM exercises WHERE content_id IS NOT NULL")
    words = [dict(id=i, lemma=l, plural=p, ar=a)
             for i, l, p, a in con.execute("SELECT id, lemma, plural, translation_ar FROM words")]
    base_known = set(pu.FUNCTION_WORDS)
    extra = root / "topic_lists" / "known_extra.txt"
    if extra.exists():
        base_known |= {x.strip().lower() for x in extra.read_text(encoding="utf-8").splitlines()
                       if x.strip() and not x.startswith("#")}
    reg = pu.Registry(root / "id_registry.json")
    print(import_all(con, root / "manual_content" / "stories", reg, pu.Lemmatizer(not args.no_spacy),
                     words, base_known))
    con.commit()
    con.close()
    reg.save()


if __name__ == "__main__":
    main()
