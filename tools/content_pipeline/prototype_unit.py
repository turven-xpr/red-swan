#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
prototype_unit.py — builds output/deutschy_prototype.db for ONE unit
(default: A1 "Familie & Leute").  It creates:
  words, sentences (Tatoeba, i+1 rule), units, lessons, lesson_items, exercises,
  and then imports the hand-written stories/texts from manual_content/stories/*.json
  (see import_stories.py).

Run:
  pip install -r requirements.txt
  python -m spacy download de_core_news_md
  python prototype_unit.py

Quick test WITHOUT spaCy (rough matching, only for checking the plumbing):
  python prototype_unit.py --no-spacy --max-sentences 50000

Expected files in raw/ :
  deu_sentences.tsv  eng_sentences.tsv  ara_sentences.tsv  links.csv   (Tatoeba, unpacked)
  leipzig_words.txt  (optional, Leipzig words file: rank<TAB>word<TAB>frequency)
"""
from __future__ import annotations

import argparse
import difflib
import json
import random
import re
import sqlite3
import sys
from pathlib import Path

try:
    from tqdm import tqdm
except ImportError:  # tqdm is optional
    def tqdm(it, **kw):
        return it

# --------------------------------------------------------------------------- config
UNITS = {
    "a1_family": dict(level="A1", unit_number=3, topic_key="family",
                      title_de="Familie & Leute", title_en="Family & People",
                      title_ar="العائلة والناس"),
}
WORDS_PER_LESSON = 10
SENTENCES_PER_WORD = 3
MIN_SENTENCES = 2
LESSON_EXERCISES = 8
TEST_EXERCISES = 12
SKILLS = ("listening", "reading", "writing", "speaking")          # order of the weight tuples
LESSON_WEIGHTS = {                                                  # listening, reading, writing, speaking
    "A1": (0.40, 0.25, 0.15, 0.20),
    "A2": (0.35, 0.25, 0.18, 0.22),
    "B1": (0.30, 0.25, 0.20, 0.25),
    "B2": (0.25, 0.25, 0.25, 0.25),
}
TEST_WEIGHTS = (0.25, 0.25, 0.25, 0.25)
# Closed-class / non-content tokens count as "known" for the i+1 rule.
CLOSED_POS = {"DET", "PRON", "ADP", "CCONJ", "SCONJ", "AUX", "PART", "PUNCT",
              "NUM", "SYM", "PROPN", "INTJ", "SPACE"}

# Function words: "free known" for sentence selection (taught formally in grammar lessons).
FUNCTION_WORDS = {
    "der": "the (m.)", "die": "the (f./pl.)", "das": "the (n.)", "ein": "a / an",
    "ich": "I", "du": "you (informal)", "er": "he", "sie": "she / they", "es": "it",
    "wir": "we", "ihr": "you (pl.) / her", "mein": "my", "dein": "your (informal)",
    "sein": "to be / his", "haben": "to have", "werden": "to become",
    "können": "can", "müssen": "must", "wollen": "to want", "und": "and",
    "oder": "or", "aber": "but", "nicht": "not", "kein": "no / not any",
    "ja": "yes", "nein": "no", "in": "in", "an": "at / on", "auf": "on",
    "mit": "with", "von": "from / of", "zu": "to", "für": "for", "aus": "out of / from",
    "bei": "at / with", "nach": "after / to", "um": "around / at", "über": "over / about",
    "auch": "also", "nur": "only", "sehr": "very", "wie": "how / like", "was": "what",
    "wer": "who", "wo": "where", "wann": "when", "warum": "why", "hier": "here",
    "da": "there", "dann": "then", "wenn": "if / when", "weil": "because",
    "dass": "that", "noch": "still / yet", "schon": "already", "man": "one (pronoun)",
}

PROFANITY = re.compile(
    r"scheiß|scheiss|fick|arsch|wichs|hure|nutte|schlampe|nazi|hitler|porn|titten|"
    r"pimmel|fotze|neger|kanake|sterb|selbstmord|umbring|töte|ermord|\bmord|waffe|bombe|terror",
    re.I)


# --------------------------------------------------------------------------- stable ids
class Registry:
    """Persistent key -> id map so ids never change between builds (user progress depends on it)."""

    def __init__(self, path: Path):
        self.path = path
        self.data = {"next": {}, "ids": {}}
        if path.exists():
            self.data = json.loads(path.read_text(encoding="utf-8"))

    def get(self, ns: str, key: str) -> int:
        ids = self.data["ids"].setdefault(ns, {})
        if key not in ids:
            nxt = self.data["next"].get(ns, 1)
            ids[key] = nxt
            self.data["next"][ns] = nxt + 1
        return ids[key]

    def save(self):
        self.path.write_text(json.dumps(self.data, ensure_ascii=False, indent=2, sort_keys=True),
                             encoding="utf-8")


# --------------------------------------------------------------------------- text helpers
def norm(text: str) -> str:
    return re.sub(r"[^\w\s]", "", text.lower()).strip()


def is_valid_sentence(text: str) -> bool:
    words = text.split()
    if not 3 <= len(words) <= 10:
        return False
    if not text[0].isupper() or text.endswith("..."):
        return False
    if text[-1] not in ".!?":
        return False
    if PROFANITY.search(text):
        return False
    return True


def display(w: dict) -> str:
    return f"{w['article']} {w['lemma']}" if w["article"] else w["lemma"]


def meaning(w: dict) -> str:
    return w["ar"] or w["en"]


def tr(s: dict) -> str:
    return s["ar"] or s["en"]


# --------------------------------------------------------------------------- loaders
def read_sentences(path: Path) -> dict[int, str]:
    out = {}
    with open(path, encoding="utf-8", newline="") as f:
        for line in f:
            p = line.rstrip("\r\n").split("\t")
            if len(p) >= 3 and p[0].isdigit():
                out[int(p[0])] = p[2]
    return out


def read_links(path: Path, wanted: set[int]) -> dict[int, list[int]]:
    links: dict[int, list[int]] = {}
    with open(path, encoding="utf-8") as f:
        for line in f:
            p = line.rstrip("\r\n").split("\t")
            if len(p) >= 2 and p[0].isdigit() and p[1].isdigit():
                a = int(p[0])
                if a in wanted:
                    links.setdefault(a, []).append(int(p[1]))
    return links


def load_topic(path: Path) -> list[dict]:
    words, seen = [], set()
    for ln, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        line = line.split("#", 1)[0].strip()
        if not line:
            continue
        p = [x.strip() for x in line.split("|")]
        if len(p) < 6:
            print(f"WARN {path.name}:{ln}: expected at least 6 columns, skipped")
            continue
        p += [""] * (7 - len(p))
        lemma, pos, art, plural, en, ar, flag = p[:7]
        if (lemma, pos) in seen:
            print(f"WARN {path.name}:{ln}: duplicate {lemma}/{pos}, skipped")
            continue
        seen.add((lemma, pos))
        words.append(dict(lemma=lemma, pos=pos, article=art,
                          plural=None if plural in ("", "-") else plural,
                          en=en, ar=ar, is_ai_ar=0 if flag.upper() == "H" else 1,
                          rank=None, sentences=[]))
    return words


def load_leipzig(path: Path):
    ranks, top = {}, []
    if not path.exists():
        return ranks, top
    with open(path, encoding="utf-8") as f:
        for i, line in enumerate(f, 1):
            p = line.rstrip("\r\n").split("\t")
            if len(p) < 2:
                continue
            word = p[1].lower()
            rank = int(p[0]) if p[0].isdigit() else i
            ranks.setdefault(word, rank)
            if len(top) < 100:
                top.append(word)
    return ranks, top


class Lemmatizer:
    """spaCy lemmatizer; with use_spacy=False a crude fallback is used (testing only)."""

    def __init__(self, use_spacy: bool = True):
        self.nlp = None
        if use_spacy:
            import spacy
            self.nlp = spacy.load("de_core_news_md", disable=["parser", "ner"])

    def analyze(self, texts):
        """yield, per text, a list of (surface, lemma_lower, pos)"""
        if self.nlp:
            for doc in self.nlp.pipe(texts, batch_size=500):
                yield [(t.text, t.lemma_.lower(), t.pos_) for t in doc]
        else:
            for text in texts:
                toks = re.findall(r"[\wäöüßÄÖÜ]+|[^\w\s]", text)
                out = []
                for t in toks:
                    if not (t[0].isalnum() or t[0] == "_"):
                        out.append((t, t, "PUNCT"))
                    elif t.isdigit():
                        out.append((t, t, "NUM"))
                    else:
                        out.append((t, t.lower(), "X"))
                yield out


# --------------------------------------------------------------------------- sentence selection (i+1)
def unknown_in(toks, known: set, target: str) -> set:
    return {lem for _, lem, pos in toks
            if pos not in CLOSED_POS and lem not in known and lem != target}


def select_sentences(word: dict, cand_ids, valid, analysis, known: set) -> list[dict]:
    target = word["lemma"].lower()
    scored = []
    for sid in cand_ids:
        unk = unknown_in(analysis[sid], known, target)
        if len(unk) > 2:
            continue
        s = valid[sid]
        n = len(s["de"].split())
        scored.append((len(unk), abs(n - 6), 0 if s["ar"] else 1, sid))
    scored.sort()
    chosen = []
    for extra, _, _, sid in scored:
        if len(chosen) >= MIN_SENTENCES and extra > 0:
            break                                   # tier 2/3 only when tier 1 is not enough
        key = norm(valid[sid]["de"])
        if any(difflib.SequenceMatcher(None, key, norm(c["de"])).ratio() > 0.9 for c in chosen):
            continue                                # candidate-only fuzzy de-duplication
        s = valid[sid]
        chosen.append(dict(id=sid, de=s["de"], en=s["en"], ar=s["ar"],
                           tier=extra + 1, tokens=analysis[sid]))
        if len(chosen) >= SENTENCES_PER_WORD:
            break
    return chosen


def find_surface(s: dict, lemma: str):
    for surf, lem, _ in s["tokens"]:
        if lem == lemma.lower():
            return surf
    return None


def blank_sentence(text: str, surface: str):
    pat = re.compile(r"(?<!\w)" + re.escape(surface) + r"(?!\w)")
    new, n = pat.subn("___", text, count=1)
    return new if n else None


# --------------------------------------------------------------------------- exercises
class Ctx:
    def __init__(self, words, pool_words, sent_pool, rng, alt=False):
        self.words, self.pool_words, self.sent_pool = words, pool_words, sent_pool
        self.rng, self.alt, self.counter = rng, alt, 0


def sent_for(ctx: Ctx, w: dict):
    ss = w["sentences"]
    if not ss:
        return None
    return ss[1] if (ctx.alt and len(ss) > 1) else ss[0]


def distract(ctx: Ctx, w: dict, k: int, key):
    same = [x for x in ctx.pool_words if x is not w and x["pos"] == w["pos"]]
    other = [x for x in ctx.pool_words if x is not w and x["pos"] != w["pos"]]
    ctx.rng.shuffle(same)
    ctx.rng.shuffle(other)
    out, seen = [], {key(w)}
    for x in same + other:
        v = key(x)
        if v not in seen:
            out.append(v)
            seen.add(v)
        if len(out) == k:
            break
    return out


def ex_listen_choose(ctx, n):
    w = ctx.words[n % len(ctx.words)]
    opts = [display(w)] + distract(ctx, w, 3, display)
    if len(opts) < 3:
        return None
    ctx.rng.shuffle(opts)
    return dict(skill="listening", type="listen_choose", prompt="", audio_text=display(w),
                correct=display(w), options=opts)


def ex_listen_dictation(ctx, n):
    s = sent_for(ctx, ctx.words[n % len(ctx.words)])
    if not s:
        return None
    return dict(skill="listening", type="listen_dictation", prompt="", audio_text=s["de"],
                correct=s["de"], options=None)


def ex_match_pairs(ctx, n):
    picks, seen = [], set()
    for i in range(len(ctx.words)):
        w = ctx.words[(n + i) % len(ctx.words)]
        if display(w) not in seen:
            picks.append(w)
            seen.add(display(w))
        if len(picks) == 4:
            break
    if len(picks) < 3:
        return None
    lefts = [display(w) for w in picks]
    rights = [meaning(w) for w in picks]
    shuffled = rights[:]
    ctx.rng.shuffle(shuffled)
    return dict(skill="reading", type="match_pairs", prompt="", audio_text=None,
                correct=dict(zip(lefts, rights)), options=dict(left=lefts, right=shuffled))


def ex_read_translate(ctx, n):
    s = sent_for(ctx, ctx.words[n % len(ctx.words)])
    if not s:
        return None
    has_ar = bool(s["ar"])
    others = [tr(x) for x in ctx.sent_pool if x["id"] != s["id"] and bool(x["ar"]) == has_ar]
    ctx.rng.shuffle(others)
    opts = [tr(s)] + [o for o in dict.fromkeys(others) if o != tr(s)][:3]
    if len(opts) < 3:
        return None
    ctx.rng.shuffle(opts)
    return dict(skill="reading", type="read_translate", prompt=s["de"], audio_text=None,
                correct=tr(s), options=opts)


def ex_chip_word_order(ctx, n):
    s = sent_for(ctx, ctx.words[n % len(ctx.words)])
    if not s:
        return None
    tokens = s["de"].split()
    chips = tokens[:]
    for _ in range(10):
        ctx.rng.shuffle(chips)
        if chips != tokens:
            break
    return dict(skill="reading", type="chip_word_order", prompt=tr(s), audio_text=None,
                correct=s["de"], options=chips)


def _blank_parts(ctx, n):
    w = ctx.words[n % len(ctx.words)]
    s = sent_for(ctx, w)
    if not s:
        return None
    surface = find_surface(s, w["lemma"])
    if not surface:
        return None
    blanked = blank_sentence(s["de"], surface)
    if not blanked:
        return None
    return w, s, surface, blanked


def ex_chip_fill_blank(ctx, n):
    parts = _blank_parts(ctx, n)
    if not parts:
        return None
    w, s, surface, blanked = parts
    opts = [surface] + [d for d in distract(ctx, w, 3, lambda x: x["lemma"]) if d != surface]
    if len(opts) < 3:
        return None
    ctx.rng.shuffle(opts)
    return dict(skill="reading", type="chip_fill_blank", prompt=blanked, audio_text=None,
                correct=surface, options=opts)


def ex_type_translate(ctx, n):
    w = ctx.words[n % len(ctx.words)]
    return dict(skill="writing", type="type_translate", prompt=meaning(w), audio_text=None,
                correct=display(w), options=None)


def ex_type_fill_blank(ctx, n):
    parts = _blank_parts(ctx, n)
    if not parts:
        return None
    w, s, surface, blanked = parts
    return dict(skill="writing", type="type_fill_blank", prompt=blanked, audio_text=None,
                correct=surface, options=None)


def ex_repeat_prompt(ctx, n):
    s = sent_for(ctx, ctx.words[n % len(ctx.words)])
    if not s:
        return None
    return dict(skill="speaking", type="repeat_prompt", prompt=s["de"], audio_text=s["de"],
                correct=s["de"], options=None)


def ex_answer_prompt(ctx, n):
    w = ctx.words[n % len(ctx.words)]
    return dict(skill="speaking", type="answer_prompt", prompt=meaning(w), audio_text=None,
                correct=display(w), options=None)


SKILL_BUILDERS = {
    "listening": [ex_listen_choose, ex_listen_dictation],
    "reading": [ex_match_pairs, ex_read_translate, ex_chip_word_order, ex_chip_fill_blank],
    "writing": [ex_type_translate, ex_type_fill_blank],
    "speaking": [ex_repeat_prompt, ex_answer_prompt],
}


def allocate(total: int, weights) -> list[int]:
    raw = [total * w for w in weights]
    base = [int(x) for x in raw]
    order = sorted(range(len(raw)), key=lambda i: raw[i] - base[i], reverse=True)
    for i in order[: total - sum(base)]:
        base[i] += 1
    return base


def build_exercises(ctx: Ctx, total: int, weights, shuffle: bool) -> list[dict]:
    out, seen = [], set()
    for skill, count in zip(SKILLS, allocate(total, weights)):
        builders = SKILL_BUILDERS[skill]
        made = k = tries = 0
        while made < count and tries < count * len(builders) * 6:
            ex = builders[k % len(builders)](ctx, ctx.counter)
            k += 1
            tries += 1
            ctx.counter += 1
            if ex is None:
                continue
            sig = (ex["type"], ex["prompt"], ex["audio_text"], json.dumps(ex["correct"], sort_keys=True))
            if sig in seen:
                continue
            seen.add(sig)
            out.append(ex)
            made += 1
    if shuffle:
        ctx.rng.shuffle(out)
    return out


# --------------------------------------------------------------------------- lesson plan
def build_plan(words: list[dict], grammar_notes: list[dict]) -> list[dict]:
    chunks = [words[i:i + WORDS_PER_LESSON] for i in range(0, len(words), WORDS_PER_LESSON)]
    plan, group, g, r = [], [], 0, 0

    def review(grp):
        nonlocal r
        r += 1
        plan.append(dict(type="review", title_de=f"Wiederholung {r}", title_en=f"Review {r}",
                         words=[w for c in grp for w in c], grammar=None))

    for i, chunk in enumerate(chunks, 1):
        plan.append(dict(type="vocabulary", title_de=f"Wortschatz {i}", title_en=f"Vocabulary {i}",
                         words=chunk, grammar=None))
        group.append(chunk)
        if i % 3 == 0:
            g += 1
            note = grammar_notes[g - 1] if g - 1 < len(grammar_notes) else {}
            plan.append(dict(type="grammar",
                             title_de=note.get("title_de", f"Grammatik {g}"),
                             title_en=note.get("title_en", f"Grammar {g}"),
                             words=[], grammar=note.get("markdown", "TODO: write the grammar note (in Arabic)")))
            review(group)
            group = []
    if len(group) >= 2:
        review(group)
    plan.append(dict(type="unit_test", title_de="Abschlusstest", title_en="Unit Test",
                     words=[w for c in chunks for w in c], grammar=None))
    return plan


# --------------------------------------------------------------------------- schema
SCHEMA = """
CREATE TABLE function_words (
    id INTEGER PRIMARY KEY, lemma TEXT NOT NULL UNIQUE, pos TEXT,
    translation_en TEXT NOT NULL, translation_ar TEXT);

CREATE TABLE words (
    id INTEGER PRIMARY KEY, lemma TEXT NOT NULL, level TEXT NOT NULL, topic TEXT NOT NULL,
    pos TEXT NOT NULL, gender TEXT, plural TEXT, conjugation TEXT,
    translation_en TEXT NOT NULL, translation_ar TEXT NOT NULL,
    is_ai_ar INTEGER DEFAULT 0, frequency_rank INTEGER,
    UNIQUE(lemma, pos));

CREATE TABLE sentences (
    id INTEGER PRIMARY KEY, text_de TEXT NOT NULL, text_en TEXT NOT NULL, text_ar TEXT,
    word_count INTEGER NOT NULL, quality_tier INTEGER DEFAULT 1);

CREATE TABLE word_sentence (
    word_id INTEGER REFERENCES words(id), sentence_id INTEGER REFERENCES sentences(id),
    PRIMARY KEY (word_id, sentence_id));

CREATE TABLE units (
    id INTEGER PRIMARY KEY, level TEXT NOT NULL, unit_number INTEGER NOT NULL,
    title_de TEXT NOT NULL, title_en TEXT NOT NULL, title_ar TEXT, topic_key TEXT NOT NULL);

CREATE TABLE lessons (
    id INTEGER PRIMARY KEY, unit_id INTEGER REFERENCES units(id), level TEXT NOT NULL,
    title_de TEXT NOT NULL, title_en TEXT NOT NULL, sort_order INTEGER NOT NULL,
    lesson_type TEXT NOT NULL, pass_threshold REAL DEFAULT 0.70, grammar_content TEXT);

CREATE TABLE lesson_items (
    id INTEGER PRIMARY KEY, lesson_id INTEGER REFERENCES lessons(id),
    word_id INTEGER REFERENCES words(id), sentence_id INTEGER REFERENCES sentences(id),
    item_type TEXT NOT NULL, sort_order INTEGER NOT NULL);

-- Texts, dialogues and stories (hand-written, imported from manual_content/stories/*.json)
CREATE TABLE content_items (
    id INTEGER PRIMARY KEY, kind TEXT NOT NULL,              -- 'text' | 'dialogue' | 'story'
    level TEXT NOT NULL, unit_id INTEGER REFERENCES units(id), slug TEXT NOT NULL UNIQUE,
    title_de TEXT NOT NULL, title_ar TEXT NOT NULL, summary_ar TEXT,
    est_minutes INTEGER, audio_file TEXT, sort_order INTEGER NOT NULL);

CREATE TABLE content_segments (
    id INTEGER PRIMARY KEY, content_id INTEGER REFERENCES content_items(id),
    sort_order INTEGER NOT NULL, speaker TEXT, text_de TEXT NOT NULL, text_ar TEXT NOT NULL,
    note_ar TEXT, audio_start_ms INTEGER, audio_end_ms INTEGER);

CREATE TABLE segment_glossary (
    segment_id INTEGER REFERENCES content_segments(id), surface TEXT NOT NULL,
    lemma TEXT, gloss_ar TEXT NOT NULL, word_id INTEGER REFERENCES words(id),
    PRIMARY KEY (segment_id, surface));

CREATE TABLE exercises (
    id INTEGER PRIMARY KEY, lesson_id INTEGER REFERENCES lessons(id),
    content_id INTEGER REFERENCES content_items(id),
    skill TEXT NOT NULL, exercise_type TEXT NOT NULL, prompt TEXT NOT NULL, audio_text TEXT,
    correct_answer TEXT NOT NULL, options TEXT, explanation_ar TEXT,
    is_graded INTEGER DEFAULT 1, is_test_pool INTEGER DEFAULT 0, sort_order INTEGER NOT NULL);

CREATE TABLE skill_weights (
    level TEXT NOT NULL, context TEXT NOT NULL, listening REAL NOT NULL, reading REAL NOT NULL,
    writing REAL NOT NULL, speaking REAL NOT NULL, PRIMARY KEY (level, context));

CREATE TABLE credits (
    source TEXT PRIMARY KEY, license TEXT NOT NULL, url TEXT NOT NULL, attribution TEXT NOT NULL);
"""


def dump(v):
    if v is None:
        return None
    return v if isinstance(v, str) else json.dumps(v, ensure_ascii=False)


# --------------------------------------------------------------------------- main
def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--topic", default="a1_family")
    ap.add_argument("--root", default=str(Path(__file__).parent))
    ap.add_argument("--no-spacy", action="store_true", help="testing only: crude lemmatizer")
    ap.add_argument("--max-sentences", type=int, default=0, help="limit sentences analysed (testing)")
    ap.add_argument("--skip-stories", action="store_true")
    args = ap.parse_args()

    root = Path(args.root)
    raw, out_dir = root / "raw", root / "output"
    out_dir.mkdir(exist_ok=True)
    unit = UNITS[args.topic]
    level = unit["level"]
    rng = random.Random(42)

    # ---- inputs
    topic_file = root / "topic_lists" / f"{args.topic}.txt"
    needed = [raw / n for n in ("deu_sentences.tsv", "eng_sentences.tsv", "ara_sentences.tsv", "links.csv")]
    missing = [str(p) for p in [topic_file] + needed if not p.exists()]
    if missing:
        sys.exit("Missing files:\n  " + "\n  ".join(missing))

    words = load_topic(topic_file)
    ranks, top_words = load_leipzig(raw / "leipzig_words.txt")
    for w in words:
        w["rank"] = ranks.get(w["lemma"].lower())
    # Frequency (Leipzig) orders words inside the unit; without it the curated list order is kept.
    order_in_list = {id(w): i for i, w in enumerate(words)}
    words.sort(key=lambda w: (w["rank"] or 10 ** 9, order_in_list[id(w)]))
    print(f"{len(words)} words in topic list; Leipzig ranks found for "
          f"{sum(1 for w in words if w['rank'])}")

    print("Reading Tatoeba ...")
    de = read_sentences(raw / "deu_sentences.tsv")
    en = read_sentences(raw / "eng_sentences.tsv")
    ar = read_sentences(raw / "ara_sentences.tsv")
    valid_ids = {sid for sid, t in de.items() if is_valid_sentence(t)}
    links = read_links(raw / "links.csv", valid_ids)
    valid = {}
    for sid in sorted(valid_ids):
        tgt = links.get(sid, [])
        en_t = next((en[i] for i in tgt if i in en), None)
        if not en_t:
            continue
        valid[sid] = dict(de=de[sid], en=en_t, ar=next((ar[i] for i in tgt if i in ar), None))
    print(f"{len(valid)} valid German sentences with an English translation")

    # ---- lemmatise + index candidates for our target words
    lem = Lemmatizer(use_spacy=not args.no_spacy)
    target_lemmas = {w["lemma"].lower() for w in words}
    index = {t: [] for t in target_lemmas}
    analysis = {}
    ids = sorted(valid)[: args.max_sentences or None]
    print("Lemmatising ...")
    for sid, toks in zip(ids, lem.analyze([valid[i]["de"] for i in tqdm(ids)])):
        hit = {l for _, l, _ in toks} & target_lemmas
        if hit:
            analysis[sid] = toks
            for h in hit:
                index[h].append(sid)

    # ---- lesson plan + sentence selection (i+1)
    grammar_file = root / "manual_content" / "a1_grammar_articles.json"
    grammar_notes = json.loads(grammar_file.read_text(encoding="utf-8")) if grammar_file.exists() else []
    plan = build_plan(words, grammar_notes)

    base_known = set(FUNCTION_WORDS) | set(top_words)
    extra = root / "topic_lists" / "known_extra.txt"          # optional: words taught in earlier units
    if extra.exists():
        base_known |= {x.strip().lower() for x in extra.read_text(encoding="utf-8").splitlines()
                       if x.strip() and not x.startswith("#")}
    taught = set()
    for lesson in plan:
        if lesson["type"] != "vocabulary":
            continue
        lemmas = {w["lemma"].lower() for w in lesson["words"]}
        known = base_known | taught | lemmas
        for w in lesson["words"]:
            w["sentences"] = select_sentences(w, index[w["lemma"].lower()], valid, analysis, known)
        taught |= lemmas

    sent_pool = {}
    for w in words:
        for s in w["sentences"]:
            sent_pool[s["id"]] = s
    sent_pool = list(sent_pool.values())

    # ---- exercises
    for no, lesson in enumerate(plan, 1):
        lesson["sort_order"] = no
        if lesson["type"] in ("vocabulary", "review"):
            ctx = Ctx(lesson["words"], words, sent_pool, rng)
            lesson["exercises"] = build_exercises(ctx, LESSON_EXERCISES, LESSON_WEIGHTS[level], shuffle=True)
        elif lesson["type"] == "unit_test":
            ctx = Ctx(lesson["words"], words, sent_pool, rng, alt=True)
            lesson["exercises"] = build_exercises(ctx, TEST_EXERCISES, TEST_WEIGHTS, shuffle=False)
        else:
            lesson["exercises"] = []

    # ---- write DB
    db_path = out_dir / "deutschy_prototype.db"
    if db_path.exists():
        db_path.unlink()
    reg = Registry(root / "id_registry.json")
    con = sqlite3.connect(db_path)
    con.executescript(SCHEMA)

    for lemma, en_t in FUNCTION_WORDS.items():
        con.execute("INSERT INTO function_words(lemma,translation_en) VALUES (?,?)", (lemma, en_t))

    unit_id = reg.get("unit", unit["topic_key"])
    con.execute("INSERT INTO units VALUES (?,?,?,?,?,?,?)",
                (unit_id, level, unit["unit_number"], unit["title_de"], unit["title_en"],
                 unit["title_ar"], unit["topic_key"]))

    for w in words:
        w["id"] = reg.get("word", f"{w['lemma']}::{w['pos']}")
        con.execute("INSERT INTO words VALUES (?,?,?,?,?,?,?,?,?,?,?,?)",
                    (w["id"], w["lemma"], level, unit["topic_key"], w["pos"], w["article"] or None,
                     w["plural"], None, w["en"], w["ar"], w["is_ai_ar"], w["rank"]))

    for s in sent_pool:
        con.execute("INSERT INTO sentences VALUES (?,?,?,?,?,?)",
                    (s["id"], s["de"], s["en"], s["ar"], len(s["de"].split()), s["tier"]))
    for w in words:
        for s in w["sentences"]:
            con.execute("INSERT OR IGNORE INTO word_sentence VALUES (?,?)", (w["id"], s["id"]))

    ex_counts = {k: 0 for k in SKILLS}
    for lesson in plan:
        lid = reg.get("lesson", f"{unit['topic_key']}_{lesson['type']}_{lesson['sort_order']}")
        con.execute("INSERT INTO lessons VALUES (?,?,?,?,?,?,?,?,?)",
                    (lid, unit_id, level, lesson["title_de"], lesson["title_en"], lesson["sort_order"],
                     lesson["type"], 0.70, lesson["grammar"]))
        order = 0
        if lesson["type"] == "vocabulary":
            used = set()
            for w in lesson["words"]:
                order += 1
                con.execute("INSERT INTO lesson_items(lesson_id,word_id,sentence_id,item_type,sort_order) "
                            "VALUES (?,?,?,?,?)", (lid, w["id"], None, "word_intro", order))
                for s in w["sentences"]:
                    if s["id"] in used:
                        continue
                    used.add(s["id"])
                    order += 1
                    con.execute("INSERT INTO lesson_items(lesson_id,word_id,sentence_id,item_type,sort_order) "
                                "VALUES (?,?,?,?,?)", (lid, w["id"], s["id"], "sentence_practice", order))
        elif lesson["type"] == "review":
            for w in lesson["words"]:
                order += 1
                con.execute("INSERT INTO lesson_items(lesson_id,word_id,sentence_id,item_type,sort_order) "
                            "VALUES (?,?,?,?,?)", (lid, w["id"], None, "fallback_review", order))
        is_test = lesson["type"] == "unit_test"
        for i, ex in enumerate(lesson["exercises"], 1):
            graded = 0 if (is_test and ex["skill"] == "speaking") else 1   # app decides if STT is available
            con.execute("INSERT INTO exercises(lesson_id,content_id,skill,exercise_type,prompt,audio_text,"
                        "correct_answer,options,explanation_ar,is_graded,is_test_pool,sort_order) "
                        "VALUES (?,?,?,?,?,?,?,?,?,?,?,?)",
                        (lid, None, ex["skill"], ex["type"], ex["prompt"], ex["audio_text"],
                         dump(ex["correct"]), dump(ex["options"]), None, graded, int(is_test), i))
            ex_counts[ex["skill"]] += 1

    for lv, wts in LESSON_WEIGHTS.items():
        con.execute("INSERT INTO skill_weights VALUES (?,?,?,?,?,?)", (lv, "lesson", *wts))
        con.execute("INSERT INTO skill_weights VALUES (?,?,?,?,?,?)", (lv, "gate_test", *TEST_WEIGHTS))

    con.execute("INSERT INTO credits VALUES (?,?,?,?)",
                ("tatoeba", "CC BY 2.0 FR (some sentences CC0)", "https://tatoeba.org",
                 "Example sentences from Tatoeba contributors"))
    if ranks:
        con.execute("INSERT INTO credits VALUES (?,?,?,?)",
                    ("leipzig", "Check the license of the corpus file you downloaded",
                     "https://wortschatz.uni-leipzig.de", "Word frequency data: Leipzig Corpora Collection"))
    con.commit()

    # ---- stories / texts
    story_report = None
    stories_dir = root / "manual_content" / "stories"
    if not args.skip_stories and stories_dir.exists():
        sys.path.insert(0, str(Path(__file__).parent))
        import import_stories
        story_report = import_stories.import_all(con, stories_dir, reg, lem, words, base_known)
        con.commit()

    con.execute("PRAGMA user_version = 1")
    con.commit()
    con.close()
    reg.save()

    # ---- report
    tiers = [0, 0, 0, 0]
    for s in sent_pool:
        tiers[s["tier"]] += 1
    weak = [display(w) for w in words if len(w["sentences"]) < MIN_SENTENCES]
    with_ar = sum(1 for s in sent_pool if s["ar"])
    print("\n=== REPORT ===")
    print(f"DB: {db_path}")
    print(f"Lessons: {len(plan)}  (vocabulary {sum(l['type']=='vocabulary' for l in plan)}, "
          f"grammar {sum(l['type']=='grammar' for l in plan)}, review {sum(l['type']=='review' for l in plan)}, "
          "1 unit test)")
    print(f"Sentences used: {len(sent_pool)}  (tier1 {tiers[1]}, tier2 {tiers[2]}, tier3 {tiers[3]}); "
          f"with Arabic from Tatoeba: {with_ar}")
    print(f"Exercises by skill: {ex_counts}")
    print(f"Words with fewer than {MIN_SENTENCES} sentences ({len(weak)}): {', '.join(weak) or '-'}")
    if story_report:
        print(story_report)


if __name__ == "__main__":
    main()
