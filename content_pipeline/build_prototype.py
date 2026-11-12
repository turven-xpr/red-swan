#!/usr/bin/env python3
"""
Deutschy Content Pipeline — Prototype Unit Builder
===================================================
Generates `deutschy_prototype.db` from:
  1. A curated topic word list  (topic_lists/a1_family.tsv)
  2. Embedded sample sentences  (hardcoded below for prototype)

Run:
    cd content_pipeline
    python build_prototype.py

Output:
    output/deutschy_prototype.db   (~200 KB)

This prototype covers Unit 3 "Familie & Leute" with:
  - 65 vocabulary words
  - ~150 sample sentences
  - 7 vocabulary lessons + 1 grammar + 1 review + 1 unit test
  - ~60 exercises across 4 skills
  - Skill weights, credits, function words
"""

import csv
import json
import os
import random
import sqlite3
import sys
from pathlib import Path

# ──────────────────────────────────────────────
# PATHS
# ──────────────────────────────────────────────
SCRIPT_DIR = Path(__file__).resolve().parent
TOPIC_FILE = SCRIPT_DIR / "topic_lists" / "a1_family.tsv"
REGISTRY_FILE = SCRIPT_DIR / "id_registry.json"
OUTPUT_DB = SCRIPT_DIR / "output" / "deutschy_prototype.db"
OUTPUT_JSON = SCRIPT_DIR / "output" / "deutschy_content.json"

DB_VERSION = 1  # PRAGMA user_version

# ──────────────────────────────────────────────
# STABLE ID REGISTRY
# ──────────────────────────────────────────────
class IdRegistry:
    """Assigns permanent integer IDs keyed by a stable string.
    Once an ID is assigned it never changes, even across rebuilds."""

    def __init__(self, path: Path):
        self.path = path
        if path.exists():
            with open(path, "r", encoding="utf-8") as f:
                self._data: dict = json.load(f)
        else:
            self._data = {"_next_word": 1, "_next_lesson": 10001,
                          "_next_sentence": 20001, "_next_exercise": 30001,
                          "_next_unit": 50001, "_next_passage": 60001,
                          "words": {}, "lessons": {}, "sentences": {},
                          "exercises": {}, "units": {}, "passages": {}}

    def word_id(self, lemma: str, pos: str) -> int:
        key = f"{lemma}::{pos}"
        if key not in self._data["words"]:
            self._data["words"][key] = self._data["_next_word"]
            self._data["_next_word"] += 1
        return self._data["words"][key]

    def lesson_id(self, key: str) -> int:
        if key not in self._data["lessons"]:
            self._data["lessons"][key] = self._data["_next_lesson"]
            self._data["_next_lesson"] += 1
        return self._data["lessons"][key]

    def sentence_id(self, key: str) -> int:
        if key not in self._data["sentences"]:
            self._data["sentences"][key] = self._data["_next_sentence"]
            self._data["_next_sentence"] += 1
        return self._data["sentences"][key]

    def exercise_id(self, key: str) -> int:
        if key not in self._data["exercises"]:
            self._data["exercises"][key] = self._data["_next_exercise"]
            self._data["_next_exercise"] += 1
        return self._data["exercises"][key]

    def unit_id(self, key: str) -> int:
        if key not in self._data["units"]:
            self._data["units"][key] = self._data["_next_unit"]
            self._data["_next_unit"] += 1
        return self._data["units"][key]

    def passage_id(self, key: str) -> int:
        if key not in self._data["passages"]:
            self._data["passages"][key] = self._data["_next_passage"]
            self._data["_next_passage"] += 1
        return self._data["passages"][key]

    def save(self):
        with open(self.path, "w", encoding="utf-8") as f:
            json.dump(self._data, f, ensure_ascii=False, indent=2)


# ──────────────────────────────────────────────
# SCHEMA CREATION
# ──────────────────────────────────────────────
SCHEMA_SQL = """
PRAGMA journal_mode = WAL;

-- 1. Function words
CREATE TABLE IF NOT EXISTS function_words (
    id              INTEGER PRIMARY KEY,
    lemma           TEXT NOT NULL UNIQUE,
    pos             TEXT,
    translation_en  TEXT NOT NULL,
    translation_ar  TEXT NOT NULL
);

-- 2. Vocabulary
CREATE TABLE IF NOT EXISTS words (
    id              INTEGER PRIMARY KEY,
    lemma           TEXT NOT NULL,
    level           TEXT NOT NULL,
    topic           TEXT NOT NULL,
    pos             TEXT NOT NULL,
    gender          TEXT,
    plural          TEXT,
    conjugation     TEXT,
    translation_en  TEXT NOT NULL,
    translation_ar  TEXT NOT NULL,
    is_ai_ar        INTEGER DEFAULT 0,
    frequency_rank  INTEGER,
    UNIQUE(lemma, pos)
);

-- 3. Sentences
CREATE TABLE IF NOT EXISTS sentences (
    id              INTEGER PRIMARY KEY,
    text_de         TEXT NOT NULL,
    text_en         TEXT NOT NULL,
    text_ar         TEXT,
    word_count      INTEGER NOT NULL,
    quality_tier    INTEGER DEFAULT 1
);

-- 4. Word-Sentence map
CREATE TABLE IF NOT EXISTS word_sentence (
    word_id         INTEGER REFERENCES words(id),
    sentence_id     INTEGER REFERENCES sentences(id),
    PRIMARY KEY (word_id, sentence_id)
);

-- 5. Units
CREATE TABLE IF NOT EXISTS units (
    id              INTEGER PRIMARY KEY,
    level           TEXT NOT NULL,
    unit_number     INTEGER NOT NULL,
    title_de        TEXT NOT NULL,
    title_en        TEXT NOT NULL,
    title_ar        TEXT,
    topic_key       TEXT NOT NULL
);

-- 6. Lessons
CREATE TABLE IF NOT EXISTS lessons (
    id              INTEGER PRIMARY KEY,
    unit_id         INTEGER REFERENCES units(id),
    level           TEXT NOT NULL,
    title_de        TEXT NOT NULL,
    title_en        TEXT NOT NULL,
    sort_order      INTEGER NOT NULL,
    lesson_type     TEXT NOT NULL,
    pass_threshold  REAL DEFAULT 0.70,
    grammar_content TEXT
);

-- 7. Lesson items
CREATE TABLE IF NOT EXISTS lesson_items (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    lesson_id       INTEGER REFERENCES lessons(id),
    word_id         INTEGER REFERENCES words(id),
    sentence_id     INTEGER REFERENCES sentences(id),
    item_type       TEXT NOT NULL,
    sort_order      INTEGER NOT NULL
);

-- 8. Reading passages
CREATE TABLE IF NOT EXISTS reading_passages (
    id              INTEGER PRIMARY KEY,
    level           TEXT NOT NULL,
    unit_id         INTEGER REFERENCES units(id),
    title_de        TEXT NOT NULL,
    text_de         TEXT NOT NULL,
    text_ar         TEXT
);

-- 9. Exercises
CREATE TABLE IF NOT EXISTS exercises (
    id              INTEGER PRIMARY KEY,
    lesson_id       INTEGER REFERENCES lessons(id),
    passage_id      INTEGER REFERENCES reading_passages(id),
    skill           TEXT NOT NULL,
    exercise_type   TEXT NOT NULL,
    prompt          TEXT NOT NULL,
    audio_text      TEXT,
    correct_answer  TEXT NOT NULL,
    options         TEXT,
    is_graded       INTEGER DEFAULT 1,
    is_test_pool    INTEGER DEFAULT 0,
    sort_order      INTEGER NOT NULL
);

-- 10. Skill weights
CREATE TABLE IF NOT EXISTS skill_weights (
    level           TEXT NOT NULL,
    context         TEXT NOT NULL,
    listening       REAL NOT NULL,
    reading         REAL NOT NULL,
    writing         REAL NOT NULL,
    speaking        REAL NOT NULL,
    PRIMARY KEY (level, context)
);

-- 11. Credits
CREATE TABLE IF NOT EXISTS credits (
    source          TEXT PRIMARY KEY,
    license         TEXT NOT NULL,
    url             TEXT NOT NULL,
    attribution     TEXT NOT NULL
);
"""

# ──────────────────────────────────────────────
# FUNCTION WORDS (taught in A0/grammar but "free" for i+1)
# ──────────────────────────────────────────────
FUNCTION_WORDS = [
    ("sein", "verb", "to be", "يكون"),
    ("haben", "verb", "to have", "يملك"),
    ("werden", "verb", "to become", "يصبح"),
    ("können", "verb", "can", "يستطيع"),
    ("müssen", "verb", "must", "يجب"),
    ("wollen", "verb", "to want", "يريد"),
    ("sollen", "verb", "should", "ينبغي"),
    ("dürfen", "verb", "may", "يجوز / يُسمح"),
    ("machen", "verb", "to do/make", "يفعل / يصنع"),
    ("gehen", "verb", "to go", "يذهب"),
    ("kommen", "verb", "to come", "يأتي"),
    ("sagen", "verb", "to say", "يقول"),
    ("geben", "verb", "to give", "يعطي"),
    ("ich", "pronoun", "I", "أنا"),
    ("du", "pronoun", "you (informal)", "أنتَ / أنتِ"),
    ("er", "pronoun", "he", "هو"),
    ("sie", "pronoun", "she / they", "هي / هم"),
    ("es", "pronoun", "it", "هو / هي (للأشياء)"),
    ("wir", "pronoun", "we", "نحن"),
    ("ihr", "pronoun", "you (plural)", "أنتم"),
    ("mein", "pronoun", "my", "ـي (ملكية)"),
    ("dein", "pronoun", "your", "ـكَ / ـكِ (ملكية)"),
    ("sein", "pronoun", "his", "ـهُ (ملكية)"),
    ("ihr", "pronoun", "her/their", "ـها / ـهم (ملكية)"),
    ("unser", "pronoun", "our", "ـنا (ملكية)"),
    ("der", "article", "the (masc.)", "الـ (مذكر)"),
    ("die", "article", "the (fem./pl.)", "الـ (مؤنث/جمع)"),
    ("das", "article", "the (neut.)", "الـ (محايد)"),
    ("ein", "article", "a/an (masc./neut.)", "واحد / أداة نكرة"),
    ("eine", "article", "a/an (fem.)", "واحدة / أداة نكرة"),
    ("und", "conjunction", "and", "و"),
    ("aber", "conjunction", "but", "لكن"),
    ("oder", "conjunction", "or", "أو"),
    ("weil", "conjunction", "because", "لأنّ"),
    ("dass", "conjunction", "that", "أنّ"),
    ("wenn", "conjunction", "if / when", "إذا / عندما"),
    ("nicht", "adverb", "not", "لا / ليس"),
    ("auch", "adverb", "also", "أيضاً"),
    ("sehr", "adverb", "very", "جداً"),
    ("schon", "adverb", "already", "بالفعل"),
    ("noch", "adverb", "still / yet", "لا يزال / بعدُ"),
    ("hier", "adverb", "here", "هنا"),
    ("da", "adverb", "there", "هناك"),
    ("jetzt", "adverb", "now", "الآن"),
    ("heute", "adverb", "today", "اليوم"),
    ("in", "preposition", "in", "في"),
    ("auf", "preposition", "on", "على"),
    ("mit", "preposition", "with", "مع"),
    ("von", "preposition", "from / of", "من"),
    ("zu", "preposition", "to", "إلى"),
    ("an", "preposition", "at / on", "عند / على"),
    ("für", "preposition", "for", "لـ / من أجل"),
    ("über", "preposition", "over / about", "فوق / عن"),
    ("nach", "preposition", "after / to", "بعد / إلى"),
    ("bei", "preposition", "at / near", "عند / لدى"),
    ("aus", "preposition", "from / out of", "من / خارج"),
    ("um", "preposition", "around / at (time)", "حول / في (الوقت)"),
    ("was", "pronoun", "what", "ماذا"),
    ("wer", "pronoun", "who", "مَن"),
    ("wie", "adverb", "how", "كيف"),
    ("wo", "adverb", "where", "أين"),
    ("ja", "particle", "yes", "نعم"),
    ("nein", "particle", "no", "لا"),
    ("bitte", "particle", "please", "من فضلك"),
    ("danke", "particle", "thank you", "شكراً"),
    ("kein", "article", "no / not a", "لا (نفي النكرة)"),
    ("alle", "pronoun", "all / everyone", "كلّ / جميع"),
    ("man", "pronoun", "one / people", "المرء"),
    ("sich", "pronoun", "oneself (reflexive)", "نفسه (ضمير انعكاسي)"),
    ("diese", "pronoun", "this / these", "هذا / هذه / هؤلاء"),
]


# ──────────────────────────────────────────────
# SAMPLE SENTENCES (for prototype — will be Tatoeba in production)
# Key: German word (lemma) → list of (DE, EN, AR)
# ──────────────────────────────────────────────
SAMPLE_SENTENCES: dict[str, list[tuple[str, str, str]]] = {
    "Mutter": [
        ("Meine Mutter kocht sehr gut.", "My mother cooks very well.", "أمي تطبخ جيداً جداً."),
        ("Die Mutter liest ein Buch.", "The mother is reading a book.", "الأم تقرأ كتاباً."),
        ("Ich liebe meine Mutter.", "I love my mother.", "أحبّ أمي."),
    ],
    "Vater": [
        ("Mein Vater arbeitet in Berlin.", "My father works in Berlin.", "أبي يعمل في برلين."),
        ("Der Vater spielt mit dem Kind.", "The father plays with the child.", "الأب يلعب مع الطفل."),
    ],
    "Bruder": [
        ("Mein Bruder ist zwölf Jahre alt.", "My brother is twelve years old.", "أخي عمره اثنا عشر عاماً."),
        ("Ich habe einen Bruder.", "I have a brother.", "لديّ أخ."),
    ],
    "Schwester": [
        ("Meine Schwester wohnt in München.", "My sister lives in Munich.", "أختي تسكن في ميونيخ."),
        ("Die Schwester ist sehr nett.", "The sister is very nice.", "الأخت لطيفة جداً."),
    ],
    "Kind": [
        ("Das Kind spielt im Garten.", "The child plays in the garden.", "الطفل يلعب في الحديقة."),
        ("Wir haben zwei Kinder.", "We have two children.", "لدينا طفلان."),
        ("Das Kind ist müde.", "The child is tired.", "الطفل متعب."),
    ],
    "Eltern": [
        ("Meine Eltern kommen aus Syrien.", "My parents come from Syria.", "والداي من سوريا."),
        ("Die Eltern sind stolz.", "The parents are proud.", "الوالدان فخوران."),
    ],
    "Sohn": [
        ("Mein Sohn geht in die Schule.", "My son goes to school.", "ابني يذهب إلى المدرسة."),
        ("Der Sohn hilft seinem Vater.", "The son helps his father.", "الابن يساعد أباه."),
    ],
    "Tochter": [
        ("Meine Tochter lernt Deutsch.", "My daughter is learning German.", "ابنتي تتعلم الألمانية."),
        ("Die Tochter ist fünf Jahre alt.", "The daughter is five years old.", "الابنة عمرها خمس سنوات."),
    ],
    "Großmutter": [
        ("Meine Großmutter macht den besten Kuchen.", "My grandmother makes the best cake.", "جدتي تصنع أفضل كعكة."),
        ("Die Großmutter erzählt eine Geschichte.", "The grandmother tells a story.", "الجدة تروي قصة."),
    ],
    "Großvater": [
        ("Mein Großvater liest die Zeitung.", "My grandfather reads the newspaper.", "جدي يقرأ الجريدة."),
        ("Der Großvater ist achtzig Jahre alt.", "The grandfather is eighty years old.", "الجد عمره ثمانون عاماً."),
    ],
    "Baby": [
        ("Das Baby schläft.", "The baby is sleeping.", "الطفل الرضيع نائم."),
        ("Das Baby weint.", "The baby is crying.", "الطفل الرضيع يبكي."),
    ],
    "Onkel": [
        ("Mein Onkel wohnt in Hamburg.", "My uncle lives in Hamburg.", "عمّي يسكن في هامبورغ."),
        ("Der Onkel kommt zu Besuch.", "The uncle comes to visit.", "العمّ يأتي للزيارة."),
    ],
    "Tante": [
        ("Meine Tante hat drei Kinder.", "My aunt has three children.", "عمّتي لديها ثلاثة أطفال."),
        ("Die Tante bringt Geschenke.", "The aunt brings gifts.", "العمّة تحضر هدايا."),
    ],
    "Cousin": [
        ("Mein Cousin studiert Medizin.", "My cousin studies medicine.", "ابن عمّي يدرس الطب."),
        ("Der Cousin kommt aus Marokko.", "The cousin comes from Morocco.", "ابن العمّ من المغرب."),
    ],
    "Cousine": [
        ("Meine Cousine ist Lehrerin.", "My cousin (f.) is a teacher.", "ابنة عمّي معلمة."),
    ],
    "Mann": [
        ("Der Mann trinkt Kaffee.", "The man drinks coffee.", "الرجل يشرب القهوة."),
        ("Mein Mann arbeitet viel.", "My husband works a lot.", "زوجي يعمل كثيراً."),
    ],
    "Frau": [
        ("Die Frau liest ein Buch.", "The woman reads a book.", "المرأة تقرأ كتاباً."),
        ("Meine Frau spricht drei Sprachen.", "My wife speaks three languages.", "زوجتي تتحدث ثلاث لغات."),
    ],
    "Freund": [
        ("Mein Freund heißt Ali.", "My friend is called Ali.", "صديقي اسمه علي."),
        ("Ich treffe meinen Freund.", "I am meeting my friend.", "ألتقي بصديقي."),
    ],
    "Freundin": [
        ("Meine Freundin kommt heute.", "My friend (f.) is coming today.", "صديقتي تأتي اليوم."),
    ],
    "Nachbar": [
        ("Mein Nachbar ist sehr freundlich.", "My neighbor is very friendly.", "جاري ودود جداً."),
        ("Der Nachbar hat einen Hund.", "The neighbor has a dog.", "الجار لديه كلب."),
    ],
    "Familie": [
        ("Meine Familie ist groß.", "My family is big.", "عائلتي كبيرة."),
        ("Die Familie isst zusammen.", "The family eats together.", "العائلة تأكل معاً."),
        ("Familie ist wichtig.", "Family is important.", "العائلة مهمة."),
    ],
    "Geschwister": [
        ("Ich habe drei Geschwister.", "I have three siblings.", "لديّ ثلاثة إخوة."),
        ("Die Geschwister spielen zusammen.", "The siblings play together.", "الإخوة يلعبون معاً."),
    ],
    "Ehemann": [
        ("Ihr Ehemann ist Arzt.", "Her husband is a doctor.", "زوجها طبيب."),
    ],
    "Ehefrau": [
        ("Seine Ehefrau ist Ingenieurin.", "His wife is an engineer.", "زوجته مهندسة."),
    ],
    "Paar": [
        ("Das Paar lebt in Köln.", "The couple lives in Cologne.", "الزوجان يعيشان في كولن."),
    ],
    "Mensch": [
        ("Jeder Mensch ist anders.", "Every person is different.", "كلّ إنسان مختلف."),
        ("Der Mensch braucht Wasser.", "The human needs water.", "الإنسان يحتاج الماء."),
    ],
    "Leute": [
        ("Die Leute sind nett hier.", "The people are nice here.", "الناس لطيفون هنا."),
        ("Viele Leute sprechen Deutsch.", "Many people speak German.", "كثير من الناس يتحدثون الألمانية."),
    ],
    "Junge": [
        ("Der Junge spielt Fußball.", "The boy plays football.", "الولد يلعب كرة القدم."),
    ],
    "Mädchen": [
        ("Das Mädchen lacht.", "The girl laughs.", "الفتاة تضحك."),
        ("Das Mädchen liest gern.", "The girl likes to read.", "الفتاة تحبّ القراءة."),
    ],
    "Name": [
        ("Wie ist Ihr Name?", "What is your name?", "ما اسمك؟"),
        ("Mein Name ist Deutschy.", "My name is Deutschy.", "اسمي دويتشي."),
    ],
    "Geburtstag": [
        ("Heute ist mein Geburtstag.", "Today is my birthday.", "اليوم عيد ميلادي."),
        ("Alles Gute zum Geburtstag!", "Happy birthday!", "عيد ميلاد سعيد!"),
    ],
    "Hochzeit": [
        ("Die Hochzeit ist im Juni.", "The wedding is in June.", "حفل الزفاف في يونيو."),
    ],
    "Geschenk": [
        ("Das Geschenk ist schön.", "The gift is beautiful.", "الهدية جميلة."),
        ("Ich bringe ein Geschenk.", "I bring a gift.", "أحضر هدية."),
    ],
    "Foto": [
        ("Wir machen ein Foto.", "We take a photo.", "نلتقط صورة."),
    ],
    "Besuch": [
        ("Wir bekommen Besuch.", "We are getting visitors.", "سيأتينا زوار."),
    ],
    "Gespräch": [
        ("Das Gespräch ist interessant.", "The conversation is interesting.", "المحادثة مثيرة للاهتمام."),
    ],
    "Einladung": [
        ("Danke für die Einladung.", "Thank you for the invitation.", "شكراً على الدعوة."),
    ],
    "Verwandte": [
        ("Meine Verwandten leben in Ägypten.", "My relatives live in Egypt.", "أقاربي يعيشون في مصر."),
    ],
    "lieben": [
        ("Ich liebe meine Familie.", "I love my family.", "أحبّ عائلتي."),
        ("Sie liebt Schokolade.", "She loves chocolate.", "هي تحبّ الشوكولاتة."),
    ],
    "leben": [
        ("Wir leben in Deutschland.", "We live in Germany.", "نعيش في ألمانيا."),
        ("Er lebt allein.", "He lives alone.", "يعيش وحده."),
    ],
    "wohnen": [
        ("Ich wohne in Berlin.", "I live in Berlin.", "أسكن في برلين."),
        ("Wo wohnst du?", "Where do you live?", "أين تسكن؟"),
    ],
    "heißen": [
        ("Wie heißt du?", "What is your name?", "ما اسمك؟"),
        ("Ich heiße Ahmad.", "My name is Ahmad.", "اسمي أحمد."),
    ],
    "sprechen": [
        ("Ich spreche Deutsch und Arabisch.", "I speak German and Arabic.", "أتحدث الألمانية والعربية."),
        ("Sprichst du Englisch?", "Do you speak English?", "هل تتحدث الإنجليزية؟"),
    ],
    "spielen": [
        ("Die Kinder spielen draußen.", "The children play outside.", "الأطفال يلعبون في الخارج."),
    ],
    "besuchen": [
        ("Ich besuche meine Großmutter.", "I visit my grandmother.", "أزور جدتي."),
        ("Wir besuchen Freunde.", "We visit friends.", "نزور الأصدقاء."),
    ],
    "helfen": [
        ("Kannst du mir helfen?", "Can you help me?", "هل يمكنك مساعدتي؟"),
        ("Die Tochter hilft der Mutter.", "The daughter helps the mother.", "الابنة تساعد الأم."),
    ],
    "kennen": [
        ("Ich kenne diese Familie.", "I know this family.", "أعرف هذه العائلة."),
    ],
    "feiern": [
        ("Wir feiern Geburtstag.", "We celebrate a birthday.", "نحتفل بعيد الميلاد."),
    ],
    "einladen": [
        ("Ich lade dich ein.", "I invite you.", "أدعوك."),
    ],
    "schenken": [
        ("Ich schenke ihm ein Buch.", "I give him a book as a gift.", "أهديه كتاباً."),
    ],
    "vorstellen": [
        ("Darf ich mich vorstellen?", "May I introduce myself?", "هل يمكنني أن أقدّم نفسي؟"),
    ],
    "erzählen": [
        ("Er erzählt eine Geschichte.", "He tells a story.", "يروي قصة."),
    ],
    "lachen": [
        ("Die Kinder lachen laut.", "The children laugh loudly.", "الأطفال يضحكون بصوت عالٍ."),
    ],
    "weinen": [
        ("Das Baby weint laut.", "The baby cries loudly.", "الطفل الرضيع يبكي بصوت عالٍ."),
    ],
    "heiraten": [
        ("Sie heiraten im Sommer.", "They are getting married in summer.", "يتزوجان في الصيف."),
    ],
    "vermissen": [
        ("Ich vermisse meine Familie.", "I miss my family.", "أفتقد عائلتي."),
    ],
    "alt": [
        ("Mein Großvater ist alt.", "My grandfather is old.", "جدي كبير في السن."),
        ("Wie alt bist du?", "How old are you?", "كم عمرك؟"),
    ],
    "jung": [
        ("Die Mutter ist noch jung.", "The mother is still young.", "الأم لا تزال شابة."),
    ],
    "groß": [
        ("Mein Bruder ist sehr groß.", "My brother is very tall.", "أخي طويل جداً."),
        ("Die Familie ist groß.", "The family is big.", "العائلة كبيرة."),
    ],
    "klein": [
        ("Das Kind ist noch klein.", "The child is still small.", "الطفل لا يزال صغيراً."),
    ],
    "nett": [
        ("Die Nachbarin ist sehr nett.", "The neighbor (f.) is very nice.", "الجارة لطيفة جداً."),
    ],
    "freundlich": [
        ("Die Leute sind freundlich.", "The people are friendly.", "الناس ودودون."),
    ],
    "lieb": [
        ("Sie ist ein liebes Kind.", "She is a dear child.", "هي طفلة محبوبة."),
    ],
    "verheiratet": [
        ("Er ist verheiratet.", "He is married.", "هو متزوج."),
    ],
    "ledig": [
        ("Sie ist ledig.", "She is single.", "هي عزباء."),
    ],
    "zusammen": [
        ("Wir essen zusammen.", "We eat together.", "نأكل معاً."),
        ("Wir leben zusammen.", "We live together.", "نعيش معاً."),
    ],
    "allein": [
        ("Er wohnt allein.", "He lives alone.", "يسكن وحده."),
    ],
    "gern": [
        ("Ich spiele gern mit den Kindern.", "I like to play with the children.", "أحبّ اللعب مع الأطفال."),
    ],
}


# ──────────────────────────────────────────────
# GRAMMAR NOTE (A1 — Articles & Family)
# ──────────────────────────────────────────────
GRAMMAR_ARTICLES = """# أدوات التعريف في الألمانية — Der, Die, Das
# German Definite Articles

## 🇩🇪 Deutsch | 🇬🇧 English | 🇸🇦 عربي

كلّ اسم في الألمانية له **جنس نحوي**: مذكر أو مؤنث أو محايد.
Every noun in German has a **grammatical gender**: masculine, feminine, or neuter.

| Article | Gender | Example | Translation |
|---------|--------|---------|-------------|
| **der** | مذكر (masculine) | der Vater | الأب |
| **die** | مؤنث (feminine) | die Mutter | الأم |
| **das** | محايد (neuter) | das Kind | الطفل |
| **die** | جمع (plural) | die Eltern | الوالدان |

### 💡 نصيحة / Tip
احفظ كلّ اسم مع أداته! لا تقل *Mutter* فقط، بل قل **die Mutter**.
Always memorize nouns with their article! Don't just say *Mutter*, say **die Mutter**.

### العائلة مع الأدوات / Family with Articles
| الألمانية | المعنى | English |
|-----------|--------|---------|
| **der** Vater | الأب | father |
| **die** Mutter | الأم | mother |
| **das** Kind | الطفل | child |
| **der** Bruder | الأخ | brother |
| **die** Schwester | الأخت | sister |
| **der** Sohn | الابن | son |
| **die** Tochter | الابنة | daughter |
| **die** Eltern | الوالدان | parents |
"""


# ──────────────────────────────────────────────
# READING PASSAGE (for unit test)
# ──────────────────────────────────────────────
READING_PASSAGE_FAMILY = {
    "title_de": "Meine Familie",
    "text_de": (
        "Hallo! Ich heiße Layla. Ich bin zwanzig Jahre alt und wohne in Berlin. "
        "Meine Familie ist groß. Ich habe einen Bruder und eine Schwester. "
        "Mein Bruder heißt Omar. Er ist fünfzehn. Meine Schwester heißt Sara. "
        "Sie ist zehn Jahre alt. Mein Vater arbeitet als Ingenieur. "
        "Meine Mutter ist Lehrerin. Wir essen jeden Abend zusammen. "
        "Am Wochenende besuchen wir meine Großmutter. Sie macht den besten Kuchen! "
        "Ich liebe meine Familie sehr."
    ),
    "text_ar": (
        "مرحباً! اسمي ليلى. عمري عشرون عاماً وأسكن في برلين. "
        "عائلتي كبيرة. لديّ أخ وأخت. "
        "أخي اسمه عمر. عمره خمسة عشر عاماً. أختي اسمها سارة. "
        "عمرها عشر سنوات. أبي يعمل مهندساً. "
        "أمي معلمة. نأكل كلّ مساء معاً. "
        "في عطلة نهاية الأسبوع نزور جدتي. هي تصنع أفضل كعكة! "
        "أحبّ عائلتي كثيراً."
    ),
}


# ──────────────────────────────────────────────
# SKILL WEIGHTS
# ──────────────────────────────────────────────
SKILL_WEIGHTS = [
    # (level, context, listening, reading, writing, speaking)
    ("A0", "lesson", 0.40, 0.25, 0.15, 0.20),
    ("A0", "gate_test", 0.25, 0.25, 0.25, 0.25),
    ("A1", "lesson", 0.40, 0.25, 0.15, 0.20),
    ("A1", "gate_test", 0.25, 0.25, 0.25, 0.25),
    ("A2", "lesson", 0.35, 0.25, 0.18, 0.22),
    ("A2", "gate_test", 0.25, 0.25, 0.25, 0.25),
    ("B1", "lesson", 0.30, 0.25, 0.20, 0.25),
    ("B1", "gate_test", 0.25, 0.25, 0.25, 0.25),
    ("B2", "lesson", 0.25, 0.25, 0.25, 0.25),
    ("B2", "gate_test", 0.25, 0.25, 0.25, 0.25),
]

CREDITS = [
    ("tatoeba", "CC BY 2.0 / CC0", "https://tatoeba.org",
     "Sentences from Tatoeba, a free collaborative multilingual sentence database."),
    ("wiktionary", "CC BY-SA 3.0", "https://en.wiktionary.org",
     "Dictionary data from Wiktionary via Kaikki.org. Derived data shares CC BY-SA 3.0 license."),
    ("leipzig", "Various", "https://wortschatz.uni-leipzig.de",
     "Word frequency data from Leipzig Corpora Collection. Check specific file license for commercial use."),
    ("prototype_sentences", "Original", "https://deutschy.app",
     "Sample sentences written for Deutschy prototype. © Deutschy."),
]


# ──────────────────────────────────────────────
# EXERCISE GENERATORS
# ──────────────────────────────────────────────
def gen_match_exercise(word_row: dict, all_words: list[dict], reg: IdRegistry,
                       lesson_id: int, sort_idx: int) -> dict:
    """Reading skill: match German ↔ translation (4 choices)."""
    correct = word_row["translation_en"]
    distractors = [w["translation_en"] for w in all_words
                   if w["lemma"] != word_row["lemma"]]
    random.shuffle(distractors)
    options = [correct] + distractors[:3]
    random.shuffle(options)
    eid = reg.exercise_id(f"match_{lesson_id}_{word_row['lemma']}")
    return {
        "id": eid, "lesson_id": lesson_id, "passage_id": None,
        "skill": "reading", "exercise_type": "match_pairs",
        "prompt": json.dumps({"de": word_row["lemma"],
                               "gender": word_row.get("gender", ""),
                               "question_ar": "ما معنى هذه الكلمة؟",
                               "question_en": "What does this word mean?"},
                              ensure_ascii=False),
        "audio_text": word_row["lemma"],
        "correct_answer": correct,
        "options": json.dumps(options, ensure_ascii=False),
        "is_graded": 1, "is_test_pool": 0, "sort_order": sort_idx,
    }


def gen_listen_choose(sentence: tuple, all_sentences: list[tuple],
                      reg: IdRegistry, lesson_id: int, sort_idx: int,
                      word_lemma: str) -> dict:
    """Listening skill: hear TTS → pick correct German text."""
    de, en, ar = sentence
    distractors = [s[0] for s in all_sentences if s[0] != de]
    random.shuffle(distractors)
    options = [de] + distractors[:3]
    random.shuffle(options)
    eid = reg.exercise_id(f"listen_{lesson_id}_{word_lemma}_{sort_idx}")
    return {
        "id": eid, "lesson_id": lesson_id, "passage_id": None,
        "skill": "listening", "exercise_type": "listen_choose",
        "prompt": json.dumps({"question_ar": "استمع واختر الجملة الصحيحة.",
                               "question_en": "Listen and choose the correct sentence."},
                              ensure_ascii=False),
        "audio_text": de,
        "correct_answer": de,
        "options": json.dumps(options, ensure_ascii=False),
        "is_graded": 1, "is_test_pool": 0, "sort_order": sort_idx,
    }


def gen_type_fill_blank(sentence: tuple, target_word: str,
                        reg: IdRegistry, lesson_id: int,
                        sort_idx: int) -> dict | None:
    """Writing skill (keyboard): fill the blank with the correct word."""
    de, en, ar = sentence
    words_in = de.split()
    # Find the target word in the sentence (case-insensitive match on lemma start)
    target_idx = -1
    for i, w in enumerate(words_in):
        clean = w.strip(".,!?;:")
        if clean.lower().startswith(target_word.lower()[:3]):
            target_idx = i
            break
    if target_idx < 0:
        return None

    removed = words_in[target_idx].strip(".,!?;:")
    blanked = words_in.copy()
    # Preserve punctuation
    punct = ""
    if words_in[target_idx][-1] in ".,!?;:":
        punct = words_in[target_idx][-1]
    blanked[target_idx] = "___" + punct
    prompt_de = " ".join(blanked)

    eid = reg.exercise_id(f"fill_{lesson_id}_{target_word}_{sort_idx}")
    return {
        "id": eid, "lesson_id": lesson_id, "passage_id": None,
        "skill": "writing", "exercise_type": "type_fill_blank",
        "prompt": json.dumps({"sentence_de": prompt_de,
                               "hint_en": en, "hint_ar": ar or "",
                               "question_ar": "اكتب الكلمة الناقصة.",
                               "question_en": "Type the missing word."},
                              ensure_ascii=False),
        "audio_text": de,
        "correct_answer": removed,
        "options": None,
        "is_graded": 1, "is_test_pool": 0, "sort_order": sort_idx,
    }


def gen_speak_repeat(sentence: tuple, reg: IdRegistry, lesson_id: int,
                     sort_idx: int, word_lemma: str) -> dict:
    """Speaking skill: repeat the sentence after TTS."""
    de, en, ar = sentence
    eid = reg.exercise_id(f"speak_{lesson_id}_{word_lemma}_{sort_idx}")
    return {
        "id": eid, "lesson_id": lesson_id, "passage_id": None,
        "skill": "speaking", "exercise_type": "repeat_prompt",
        "prompt": json.dumps({"sentence_de": de,
                               "hint_en": en, "hint_ar": ar or "",
                               "question_ar": "استمع ثم كرّر الجملة بصوت عالٍ.",
                               "question_en": "Listen and repeat the sentence aloud."},
                              ensure_ascii=False),
        "audio_text": de,
        "correct_answer": de,
        "options": None,
        "is_graded": 0, "is_test_pool": 0, "sort_order": sort_idx,
    }


# ──────────────────────────────────────────────
# MAIN BUILD
# ──────────────────────────────────────────────
def main():
    print("=" * 60)
    print("  Deutschy Content Pipeline — Prototype Builder")
    print("=" * 60)

    # ── 1. Load topic word list ──
    if not TOPIC_FILE.exists():
        print(f"ERROR: Topic file not found: {TOPIC_FILE}")
        sys.exit(1)

    words_raw: list[dict] = []
    with open(TOPIC_FILE, "r", encoding="utf-8") as f:
        reader = csv.DictReader(f, delimiter="\t")
        for row in reader:
            if row.get("lemma"):
                words_raw.append(row)

    print(f"  Loaded {len(words_raw)} words from {TOPIC_FILE.name}")

    # ── 2. Initialize ID registry ──
    reg = IdRegistry(REGISTRY_FILE)

    # ── 3. Create DB ──
    OUTPUT_DB.parent.mkdir(parents=True, exist_ok=True)
    if OUTPUT_DB.exists():
        OUTPUT_DB.unlink()

    conn = sqlite3.connect(str(OUTPUT_DB))
    cur = conn.cursor()
    cur.executescript(SCHEMA_SQL)
    cur.execute(f"PRAGMA user_version = {DB_VERSION};")

    # ── 4. Insert function words ──
    for i, (lemma, pos, en, ar) in enumerate(FUNCTION_WORDS, start=1):
        cur.execute(
            "INSERT OR IGNORE INTO function_words (id, lemma, pos, translation_en, translation_ar) "
            "VALUES (?, ?, ?, ?, ?)",
            (i, lemma, pos, en, ar),
        )
    print(f"  Inserted {len(FUNCTION_WORDS)} function words")

    # ── 5. Insert vocabulary words ──
    word_rows = []
    for rank, w in enumerate(words_raw, start=1):
        wid = reg.word_id(w["lemma"], w["pos"])
        cur.execute(
            "INSERT OR IGNORE INTO words "
            "(id, lemma, level, topic, pos, gender, plural, conjugation, "
            "translation_en, translation_ar, is_ai_ar, frequency_rank) "
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
            (wid, w["lemma"], "A1", "family", w["pos"],
             w.get("gender", "") or None,
             w.get("plural", "") or None,
             None,  # conjugation — to be enriched from Wiktionary
             w["translation_en"], w["translation_ar"], 0, rank),
        )
        word_rows.append({**w, "id": wid})
    print(f"  Inserted {len(word_rows)} vocabulary words")

    # ── 6. Insert sentences ──
    all_flat_sentences = []
    for lemma, sents in SAMPLE_SENTENCES.items():
        for de, en, ar in sents:
            sid = reg.sentence_id(de[:50])
            wcount = len(de.split())
            cur.execute(
                "INSERT OR IGNORE INTO sentences "
                "(id, text_de, text_en, text_ar, word_count, quality_tier) "
                "VALUES (?, ?, ?, ?, ?, ?)",
                (sid, de, en, ar, wcount, 1),
            )
            # Link to word
            matching = [wr for wr in word_rows if wr["lemma"] == lemma]
            for wr in matching:
                cur.execute(
                    "INSERT OR IGNORE INTO word_sentence (word_id, sentence_id) "
                    "VALUES (?, ?)", (wr["id"], sid),
                )
            all_flat_sentences.append((de, en, ar))

    print(f"  Inserted {len(all_flat_sentences)} sentences")

    # ── 7. Create Unit ──
    unit_id = reg.unit_id("a1_family")
    cur.execute(
        "INSERT INTO units (id, level, unit_number, title_de, title_en, title_ar, topic_key) "
        "VALUES (?, ?, ?, ?, ?, ?, ?)",
        (unit_id, "A1", 3, "Familie & Leute", "Family & People", "العائلة والناس", "family"),
    )

    # ── 8. Create Lessons ──
    WORDS_PER_LESSON = 10
    lesson_ids = []
    lesson_sort = 1

    # Vocabulary lessons
    for chunk_i in range(0, len(word_rows), WORDS_PER_LESSON):
        chunk = word_rows[chunk_i: chunk_i + WORDS_PER_LESSON]
        lid = reg.lesson_id(f"a1_family_vocab_{chunk_i // WORDS_PER_LESSON + 1}")
        title_num = chunk_i // WORDS_PER_LESSON + 1
        cur.execute(
            "INSERT INTO lessons "
            "(id, unit_id, level, title_de, title_en, sort_order, lesson_type, pass_threshold) "
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
            (lid, unit_id, "A1",
             f"Wortschatz {title_num}", f"Vocabulary {title_num}",
             lesson_sort, "vocabulary", 0.70),
        )
        # Insert lesson items
        for item_i, wr in enumerate(chunk, start=1):
            cur.execute(
                "INSERT INTO lesson_items (lesson_id, word_id, sentence_id, item_type, sort_order) "
                "VALUES (?, ?, NULL, 'word_intro', ?)",
                (lid, wr["id"], item_i),
            )
            # Link sentences
            sents = SAMPLE_SENTENCES.get(wr["lemma"], [])
            for si, (de, en, ar) in enumerate(sents[:3], start=1):
                sid = reg.sentence_id(de[:50])
                cur.execute(
                    "INSERT INTO lesson_items (lesson_id, word_id, sentence_id, item_type, sort_order) "
                    "VALUES (?, ?, ?, 'sentence_practice', ?)",
                    (lid, wr["id"], sid, item_i * 100 + si),
                )

        lesson_ids.append((lid, chunk))
        lesson_sort += 1

        # Insert review lesson every 3 vocab lessons
        if (chunk_i // WORDS_PER_LESSON + 1) % 3 == 0:
            rlid = reg.lesson_id(f"a1_family_review_{lesson_sort}")
            cur.execute(
                "INSERT INTO lessons "
                "(id, unit_id, level, title_de, title_en, sort_order, lesson_type) "
                "VALUES (?, ?, ?, ?, ?, ?, ?)",
                (rlid, unit_id, "A1", "Wiederholung", "Review", lesson_sort, "review"),
            )
            # Static fallback items from previous lessons
            fallback_words = word_rows[max(0, chunk_i - 20): chunk_i + WORDS_PER_LESSON]
            for fi, fw in enumerate(fallback_words[:10], start=1):
                cur.execute(
                    "INSERT INTO lesson_items (lesson_id, word_id, sentence_id, item_type, sort_order) "
                    "VALUES (?, ?, NULL, 'fallback_review', ?)",
                    (rlid, fw["id"], fi),
                )
            lesson_sort += 1

    # Grammar lesson
    gram_lid = reg.lesson_id("a1_family_grammar_1")
    cur.execute(
        "INSERT INTO lessons "
        "(id, unit_id, level, title_de, title_en, sort_order, lesson_type, grammar_content) "
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
        (gram_lid, unit_id, "A1", "Grammatik: Artikel", "Grammar: Articles",
         lesson_sort, "grammar", GRAMMAR_ARTICLES),
    )
    lesson_sort += 1

    # ── 9. Insert reading passage ──
    pass_id = reg.passage_id("a1_family_passage_1")
    cur.execute(
        "INSERT INTO reading_passages (id, level, unit_id, title_de, text_de, text_ar) "
        "VALUES (?, ?, ?, ?, ?, ?)",
        (pass_id, "A1", unit_id,
         READING_PASSAGE_FAMILY["title_de"],
         READING_PASSAGE_FAMILY["text_de"],
         READING_PASSAGE_FAMILY["text_ar"]),
    )

    # Unit test
    test_lid = reg.lesson_id("a1_family_unit_test")
    cur.execute(
        "INSERT INTO lessons "
        "(id, unit_id, level, title_de, title_en, sort_order, lesson_type, pass_threshold) "
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
        (test_lid, unit_id, "A1", "Einheitstest", "Unit Test",
         lesson_sort, "unit_test", 0.70),
    )
    lesson_sort += 1

    # ── 10. Generate exercises ──
    exercise_count = 0
    ex_sort = 1

    for lid, chunk in lesson_ids:
        for wr in chunk:
            # Reading: match word to translation
            ex = gen_match_exercise(wr, word_rows, reg, lid, ex_sort)
            cur.execute(
                "INSERT INTO exercises "
                "(id, lesson_id, passage_id, skill, exercise_type, prompt, audio_text, "
                "correct_answer, options, is_graded, is_test_pool, sort_order) "
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                tuple(ex.values()),
            )
            exercise_count += 1
            ex_sort += 1

            # Get sentences for this word
            sents = SAMPLE_SENTENCES.get(wr["lemma"], [])
            if sents:
                # Listening: hear → pick
                ex2 = gen_listen_choose(sents[0], all_flat_sentences, reg, lid, ex_sort, wr["lemma"])
                cur.execute(
                    "INSERT INTO exercises "
                    "(id, lesson_id, passage_id, skill, exercise_type, prompt, audio_text, "
                    "correct_answer, options, is_graded, is_test_pool, sort_order) "
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                    tuple(ex2.values()),
                )
                exercise_count += 1
                ex_sort += 1

                # Writing: fill blank
                ex3 = gen_type_fill_blank(sents[0], wr["lemma"], reg, lid, ex_sort)
                if ex3:
                    cur.execute(
                        "INSERT INTO exercises "
                        "(id, lesson_id, passage_id, skill, exercise_type, prompt, audio_text, "
                        "correct_answer, options, is_graded, is_test_pool, sort_order) "
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                        tuple(ex3.values()),
                    )
                    exercise_count += 1
                    ex_sort += 1

                # Speaking: repeat
                if len(sents) > 1:
                    ex4 = gen_speak_repeat(sents[1], reg, lid, ex_sort, wr["lemma"])
                    cur.execute(
                        "INSERT INTO exercises "
                        "(id, lesson_id, passage_id, skill, exercise_type, prompt, audio_text, "
                        "correct_answer, options, is_graded, is_test_pool, sort_order) "
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                        tuple(ex4.values()),
                    )
                    exercise_count += 1
                    ex_sort += 1

    # Unit test exercises (test pool — separate from daily lessons)
    test_ex_sort = 1
    test_words_sample = random.sample(word_rows, min(15, len(word_rows)))
    for wr in test_words_sample:
        # Test: match
        ex = gen_match_exercise(wr, word_rows, reg, test_lid, test_ex_sort)
        ex["is_test_pool"] = 1
        ex["id"] = reg.exercise_id(f"test_match_{test_lid}_{wr['lemma']}")
        cur.execute(
            "INSERT INTO exercises "
            "(id, lesson_id, passage_id, skill, exercise_type, prompt, audio_text, "
            "correct_answer, options, is_graded, is_test_pool, sort_order) "
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
            tuple(ex.values()),
        )
        exercise_count += 1
        test_ex_sort += 1

    print(f"  Generated {exercise_count} exercises")

    # ── 11. Insert skill weights ──
    for sw in SKILL_WEIGHTS:
        cur.execute(
            "INSERT OR REPLACE INTO skill_weights "
            "(level, context, listening, reading, writing, speaking) "
            "VALUES (?, ?, ?, ?, ?, ?)", sw,
        )

    # ── 12. Insert credits ──
    for cr in CREDITS:
        cur.execute(
            "INSERT OR REPLACE INTO credits (source, license, url, attribution) "
            "VALUES (?, ?, ?, ?)", cr,
        )

    # ── 13. Export JSON Mirror for Universal Cross-Platform Support ──
    tables_to_dump = [
        "function_words", "words", "sentences", "word_sentence",
        "units", "lessons", "lesson_items", "reading_passages",
        "exercises", "skill_weights", "credits"
    ]
    cur.row_factory = sqlite3.Row
    content_dump = {"version": DB_VERSION}
    for tbl in tables_to_dump:
        cur.execute(f"SELECT * FROM {tbl}")
        content_dump[tbl] = [dict(r) for r in cur.fetchall()]

    with open(OUTPUT_JSON, "w", encoding="utf-8") as jf:
        json.dump(content_dump, jf, ensure_ascii=False, indent=2)
    print(f"  📄 JSON mirror written: {OUTPUT_JSON} ({OUTPUT_JSON.stat().st_size / 1024:.1f} KB)")

    # ── 14. Finalize ──
    conn.commit()
    conn.close()

    # Save ID registry
    reg.save()

    db_size = OUTPUT_DB.stat().st_size / 1024
    print(f"\n  ✅ Database written: {OUTPUT_DB}")
    print(f"  📦 Size: {db_size:.1f} KB")
    print(f"  🔢 DB Version: {DB_VERSION}")
    print(f"  📝 ID Registry: {REGISTRY_FILE}")
    print("=" * 60)


if __name__ == "__main__":
    random.seed(42)  # Reproducible exercise ordering
    main()

