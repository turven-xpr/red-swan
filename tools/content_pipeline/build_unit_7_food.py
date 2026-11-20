import json
from pathlib import Path

CONTENT_PATH = Path(r"c:\Users\HP\3D Objects\Deutschy-main\Deutschy-main\assets\deutschy_content.json")

with open(CONTENT_PATH, "r", encoding="utf-8") as f:
    data = json.load(f)

# 1. Register Unit 7 if not present
if not any(u["id"] == 50003 for u in data["units"]):
    data["units"].append({
        "id": 50003,
        "level": "A1",
        "unit_number": 7,
        "title_de": "Essen & Trinken",
        "title_en": "Food & Drinks",
        "title_ar": "الطعام والشراب",
        "title_es": "Comida y bebidas",
        "topic_key": "food"
    })

# 2. Add Vocabulary for Unit 7 (IDs 1140-1165)
unit7_words = [
    {"id": 1140, "lemma": "Essen", "level": "A1", "topic": "food", "pos": "noun", "gender": "das", "plural": None, "conjugation": None, "translation_en": "food / meal", "translation_ar": "طعام", "translation_es": "comida", "frequency_rank": 140},
    {"id": 1141, "lemma": "Getränk", "level": "A1", "topic": "food", "pos": "noun", "gender": "das", "plural": "Getränke", "conjugation": None, "translation_en": "drink / beverage", "translation_ar": "مشروب", "translation_es": "bebida", "frequency_rank": 141},
    {"id": 1142, "lemma": "Brot", "level": "A1", "topic": "food", "pos": "noun", "gender": "das", "plural": "Brote", "conjugation": None, "translation_en": "bread", "translation_ar": "خبز", "translation_es": "pan", "frequency_rank": 142},
    {"id": 1143, "lemma": "Brötchen", "level": "A1", "topic": "food", "pos": "noun", "gender": "das", "plural": "Brötchen", "conjugation": None, "translation_en": "bread roll", "translation_ar": "خبز صغير / لفة", "translation_es": "panecillo", "frequency_rank": 143},
    {"id": 1144, "lemma": "Milch", "level": "A1", "topic": "food", "pos": "noun", "gender": "die", "plural": None, "conjugation": None, "translation_en": "milk", "translation_ar": "حليب", "translation_es": "leche", "frequency_rank": 144},
    {"id": 1145, "lemma": "Saft", "level": "A1", "topic": "food", "pos": "noun", "gender": "der", "plural": "Säfte", "conjugation": None, "translation_en": "juice", "translation_ar": "عصير", "translation_es": "zumo / jugo", "frequency_rank": 145},
    {"id": 1146, "lemma": "Banane", "level": "A1", "topic": "food", "pos": "noun", "gender": "die", "plural": "Bananen", "conjugation": None, "translation_en": "banana", "translation_ar": "موزة", "translation_es": "plátano", "frequency_rank": 146},
    {"id": 1147, "lemma": "Käse", "level": "A1", "topic": "food", "pos": "noun", "gender": "der", "plural": None, "conjugation": None, "translation_en": "cheese", "translation_ar": "جبن", "translation_es": "queso", "frequency_rank": 147},
    {"id": 1148, "lemma": "Fleisch", "level": "A1", "topic": "food", "pos": "noun", "gender": "das", "plural": None, "conjugation": None, "translation_en": "meat", "translation_ar": "لحم", "translation_es": "carne", "frequency_rank": 148},
    {"id": 1149, "lemma": "Ei", "level": "A1", "topic": "food", "pos": "noun", "gender": "das", "plural": "Eier", "conjugation": None, "translation_en": "egg", "translation_ar": "بيضة", "translation_es": "huevo", "frequency_rank": 149},
    {"id": 1150, "lemma": "Zucker", "level": "A1", "topic": "food", "pos": "noun", "gender": "der", "plural": None, "conjugation": None, "translation_en": "sugar", "translation_ar": "سكر", "translation_es": "azúcar", "frequency_rank": 150},
    {"id": 1151, "lemma": "Salz", "level": "A1", "topic": "food", "pos": "noun", "gender": "das", "plural": None, "conjugation": None, "translation_en": "salt", "translation_ar": "ملح", "translation_es": "sal", "frequency_rank": 151},
    {"id": 1152, "lemma": "Butter", "level": "A1", "topic": "food", "pos": "noun", "gender": "die", "plural": None, "conjugation": None, "translation_en": "butter", "translation_ar": "زبدة", "translation_es": "mantequilla", "frequency_rank": 152},
    {"id": 1153, "lemma": "Supermarkt", "level": "A1", "topic": "food", "pos": "noun", "gender": "der", "plural": "Supermärkte", "conjugation": None, "translation_en": "supermarket", "translation_ar": "سوبرماركت", "translation_es": "supermercado", "frequency_rank": 153},
    {"id": 1154, "lemma": "Markt", "level": "A1", "topic": "food", "pos": "noun", "gender": "der", "plural": "Märkte", "conjugation": None, "translation_en": "market", "translation_ar": "سوق", "translation_es": "mercado", "frequency_rank": 154},
    {"id": 1155, "lemma": "Restaurant", "level": "A1", "topic": "food", "pos": "noun", "gender": "das", "plural": "Restaurants", "conjugation": None, "translation_en": "restaurant", "translation_ar": "مطعم", "translation_es": "restaurante", "frequency_rank": 155},
    {"id": 1156, "lemma": "Rechnung", "level": "A1", "topic": "food", "pos": "noun", "gender": "die", "plural": "Rechnungen", "conjugation": None, "translation_en": "bill / check", "translation_ar": "فاتورة / حساب", "translation_es": "cuenta", "frequency_rank": 156},
    {"id": 1157, "lemma": "essen", "level": "A1", "topic": "food", "pos": "verb", "gender": None, "plural": None, "conjugation": "du isst, er isst", "translation_en": "to eat", "translation_ar": "يأكل", "translation_es": "comer", "frequency_rank": 157},
    {"id": 1158, "lemma": "trinken", "level": "A1", "topic": "food", "pos": "verb", "gender": None, "plural": None, "conjugation": "trinkt", "translation_en": "to drink", "translation_ar": "يشرب", "translation_es": "beber", "frequency_rank": 158},
    {"id": 1159, "lemma": "kaufen", "level": "A1", "topic": "food", "pos": "verb", "gender": None, "plural": None, "conjugation": "kauft", "translation_en": "to buy", "translation_ar": "يشتري", "translation_es": "comprar", "frequency_rank": 159},
    {"id": 1160, "lemma": "kochen", "level": "A1", "topic": "food", "pos": "verb", "gender": None, "plural": None, "conjugation": "kocht", "translation_en": "to cook", "translation_ar": "يطبخ", "translation_es": "cocinar", "frequency_rank": 160},
    {"id": 1161, "lemma": "schmecken", "level": "A1", "topic": "food", "pos": "verb", "gender": None, "plural": None, "conjugation": "schmeckt", "translation_en": "to taste good", "translation_ar": "يعجب المذاق / يستسيغ", "translation_es": "gustar (sabor)", "frequency_rank": 161},
    {"id": 1162, "lemma": "nehmen", "level": "A1", "topic": "food", "pos": "verb", "gender": None, "plural": None, "conjugation": "du nimmst, er nimmt", "translation_en": "to take", "translation_ar": "يأخذ", "translation_es": "tomar", "frequency_rank": 162},
    {"id": 1163, "lemma": "gern", "level": "A1", "topic": "food", "pos": "adverb", "gender": None, "plural": None, "conjugation": None, "translation_en": "gladly / with pleasure", "translation_ar": "بسرور / بحب", "translation_es": "con gusto", "frequency_rank": 163},
    {"id": 1164, "lemma": "lieber", "level": "A1", "topic": "food", "pos": "adverb", "gender": None, "plural": None, "conjugation": None, "translation_en": "rather / prefer", "translation_ar": "يُفضّل", "translation_es": "preferiblemente", "frequency_rank": 164},
]

existing_w_ids = {w["id"] for w in data["words"]}
for w in unit7_words:
    if w["id"] not in existing_w_ids:
        data["words"].append(w)

# 3. Add Lessons for Unit 7 (10701 - 10706)
unit7_lessons = [
    {
        "id": 10701, "unit_id": 50003, "level": "A1", "title_de": "Lebensmittel & Getränke", "title_en": "Groceries & Drinks",
        "sort_order": 1, "lesson_type": "vocabulary", "pass_threshold": 0.7, "grammar_content": None, "content_json": None
    },
    {
        "id": 10702, "unit_id": 50003, "level": "A1", "title_de": "Im Supermarkt einkaufen", "title_en": "Shopping at the Supermarket",
        "sort_order": 2, "lesson_type": "vocabulary", "pass_threshold": 0.7, "grammar_content": None, "content_json": None
    },
    {
        "id": 10703, "unit_id": 50003, "level": "A1", "title_de": "Grammatik: Verben mit Vokalwechsel", "title_en": "Grammar: Stem-Changing Verbs (essen & nehmen)",
        "sort_order": 3, "lesson_type": "grammar", "pass_threshold": 0.7,
        "grammar_content": "# الأفعال ذات التغيير الصوتي — Verben mit Vokalwechsel\n# German Stem-Changing Verbs: essen & nehmen\n\n## 🇩🇪 Deutsch | 🇬🇧 English | 🇸🇦 عربي\n\nبعض الأفعال القوية في الألمانية يتغير حرف العلة في جذرها مع الضميرين **du** و **er / sie / es** في زمن المضارع.\nSome strong German verbs change their root vowel in the present tense for **du** and **er/sie/es**.\n\n### 1. الفعل essen (يأكل) — يتحول e إلى i:\n| الضمير / Pronoun | تصريف الفعل / Conjugation | مثال / Example |\n|---|---|---|\n| **ich** | **esse** | Ich esse einen Apfel. |\n| **du** | **isst** | Was **isst** du gern? |\n| **er / sie / es** | **isst** | Er **isst** Brot mit Käse. |\n| **wir** | **essen** | Wir essen zusammen. |\n| **ihr** | **esst** | Was esst ihr? |\n| **Sie / sie** | **essen** | Essen Sie Fleisch? |\n\n---\n\n### 2. الفعل nehmen (يأخذ / يطلب في المطعم) — يتحول e إلى imm:\n- *ich **nehme** einen Kaffee.*\n- *du **nimmst** den Tee.*\n- *er **nimmt** ein Brötchen.*\n- *wir **nehmen** die Rechnung, bitte.*",
        "content_json": None
    },
    {
        "id": 10704, "unit_id": 50003, "level": "A1", "title_de": "Vorlieben ausdrücken: gern & lieber", "title_en": "Expressing Preferences: gern & lieber",
        "sort_order": 4, "lesson_type": "grammar", "pass_threshold": 0.7,
        "grammar_content": "# التعبير عن التفضيل — gern & lieber\n# Expressing Likes and Preferences\n\n## 🇩🇪 Deutsch | 🇬🇧 English | 🇸🇦 عربي\n\nفي الألمانية لا نحتاج دائماً لفعل \"يحب\" (lieben)، بل نستخدم الظرف **gern** بعد الفعل للتعبير عن الاستمتاع بعمل الشيء:\nIn German, we express liking an activity by placing **gern** right after the conjugated verb:\n\n- *Ich trinke **gern** Kaffee.* (أحب شرب القهوة)\n- *Ich esse **gern** Fisch.* (أحب أكل السمك)\n\n### المقارنة والتفضيل مع lieber:\nعند الاختيار بين أمرين، نستخدم **lieber** بمعنى \"أُفضّل\":\n- *Ich trinke gern Tee, aber ich trinke **lieber** Kaffee.*\n  (أحب الشاي، ولكنني أُفضّل القهوة)\n- *Was isst du lieber: Fleisch oder Fisch?*\n  (ماذا تفضل أن تأكل: اللحم أم السمك؟)",
        "content_json": None
    },
    {
        "id": 10705, "unit_id": 50003, "level": "A1", "title_de": "Im Restaurant & Bestellen", "title_en": "In the Restaurant & Ordering",
        "sort_order": 5, "lesson_type": "text", "pass_threshold": 0.7, "grammar_content": None, "content_json": None
    },
    {
        "id": 10706, "unit_id": 50003, "level": "A1", "title_de": "Einheitstest: Essen & Trinken", "title_en": "Unit Test: Food & Drinks",
        "sort_order": 6, "lesson_type": "unit_test", "pass_threshold": 0.75, "grammar_content": None, "content_json": None
    }
]

existing_l_ids = {l["id"] for l in data["lessons"]}
for l in unit7_lessons:
    if l["id"] not in existing_l_ids:
        data["lessons"].append(l)

# 4. Add Exercises for Unit 7 (40501 - 40545)
existing_ex_ids = {e["id"] for e in data["exercises"]}
unit7_exercises = []

# --- LESSON 10701: Lebensmittel & Getränke (7 exercises) ---
unit7_exercises.append({
    "id": 40501, "lesson_id": 10701, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Brot", "gender": "das", "question_en": "What does 'das Brot' mean?", "question_ar": "ما معنى \u2066'das Brot'\u2069؟", "question_es": "¿Qué significa 'das Brot'?"}, ensure_ascii=False),
    "audio_text": "das Brot", "correct_answer": "bread", "options": json.dumps(["bread", "milk", "cheese", "meat"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit7_exercises.append({
    "id": 40502, "lesson_id": 10701, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Milch", "gender": "die", "question_en": "What does 'die Milch' mean?", "question_ar": "ما معنى \u2066'die Milch'\u2069؟", "question_es": "¿Qué significa 'die Milch'?"}, ensure_ascii=False),
    "audio_text": "die Milch", "correct_answer": "milk", "options": json.dumps(["milk", "juice", "water", "tea"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit7_exercises.append({
    "id": 40503, "lesson_id": 10701, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "der Käse", "question_en": "Listen and select the dairy product.", "question_ar": "استمع واختر المكون الغذائي المسموع.", "question_es": "Escucha y selecciona el producto lácteo."}, ensure_ascii=False),
    "audio_text": "der Käse", "correct_answer": "der Käse", "options": json.dumps(["der Käse", "das Brot", "die Milch", "das Ei"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit7_exercises.append({
    "id": 40504, "lesson_id": 10701, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Fleisch", "gender": "das", "question_en": "What does 'das Fleisch' mean?", "question_ar": "ما معنى \u2066'das Fleisch'\u2069؟", "question_es": "¿Qué significa 'das Fleisch'?"}, ensure_ascii=False),
    "audio_text": "das Fleisch", "correct_answer": "meat", "options": json.dumps(["meat", "fish", "egg", "bread"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit7_exercises.append({
    "id": 40505, "lesson_id": 10701, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "der Saft", "question_en": "Listen and choose the beverage.", "question_ar": "استمع واختر المشروب المسموع.", "question_es": "Escucha y elige la bebida."}, ensure_ascii=False),
    "audio_text": "der Saft", "correct_answer": "der Saft", "options": json.dumps(["der Saft", "das Wasser", "der Kaffee", "der Tee"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit7_exercises.append({
    "id": 40506, "lesson_id": 10701, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Zum Frühstück esse ich ein ___ mit Butter. (Brötchen)", "question_en": "Fill in 'Brötchen'.", "question_ar": "املأ الفراغ بكلمة خبز صغير: \u2066'Brötchen'\u2069.", "question_es": "Rellena con 'Brötchen'."}, ensure_ascii=False),
    "audio_text": "Zum Frühstück esse ich ein Brötchen mit Butter.", "correct_answer": "Brötchen", "options": json.dumps(["Brötchen", "Fleisch", "Zucker", "Salz"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit7_exercises.append({
    "id": 40507, "lesson_id": 10701, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Das Essen schmeckt sehr gut.", "question_en": "Repeat clearly: 'Das Essen schmeckt sehr gut.'", "question_ar": "ردد بوضوح: \u2066'Das Essen schmeckt sehr gut.'\u2069", "question_es": "Repite: 'Das Essen schmeckt sehr gut.'"}, ensure_ascii=False),
    "audio_text": "Das Essen schmeckt sehr gut.", "correct_answer": "Das Essen schmeckt sehr gut.", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 10702: Im Supermarkt einkaufen (7 exercises) ---
unit7_exercises.append({
    "id": 40508, "lesson_id": 10702, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Supermarkt", "gender": "der", "question_en": "What does 'der Supermarkt' mean?", "question_ar": "ما معنى \u2066'der Supermarkt'\u2069؟", "question_es": "¿Qué significa 'der Supermarkt'?"}, ensure_ascii=False),
    "audio_text": "der Supermarkt", "correct_answer": "supermarket", "options": json.dumps(["supermarket", "restaurant", "hotel", "bank"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit7_exercises.append({
    "id": 40509, "lesson_id": 10702, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Ich kaufe ___ Apfel. (einen - Akkusativ maskulin)", "question_en": "Choose accusative masculine article 'einen' for 'Apfel'.", "question_ar": "اختر أداة النصب المنونة للمذكر مع كلمة \u2066Apfel\u2069: \u2066'einen'\u2069.", "question_es": "Elige el artículo acusativo masculino 'einen'."}, ensure_ascii=False),
    "audio_text": "Ich kaufe einen Apfel.", "correct_answer": "einen", "options": json.dumps(["einen", "ein", "eine", "einem"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit7_exercises.append({
    "id": 40510, "lesson_id": 10702, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Zucker", "gender": "der", "question_en": "What does 'der Zucker' mean?", "question_ar": "ما معنى \u2066'der Zucker'\u2069؟", "question_es": "¿Qué significa 'der Zucker'?"}, ensure_ascii=False),
    "audio_text": "der Zucker", "correct_answer": "sugar", "options": json.dumps(["sugar", "salt", "butter", "milk"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit7_exercises.append({
    "id": 40511, "lesson_id": 10702, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Wir brauchen Milch und Eier.", "question_en": "Listen and select the groceries needed.", "question_ar": "استمع واختر المشتريات المطلوبة.", "question_es": "Escucha y selecciona la compra necesaria."}, ensure_ascii=False),
    "audio_text": "Wir brauchen Milch und Eier.", "correct_answer": "Wir brauchen Milch und Eier.", "options": json.dumps(["Wir brauchen Milch und Eier.", "Wir kaufen Käse und Brot.", "Wir trinken Saft und Kaffee.", "Wir haben kein Fleisch."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit7_exercises.append({
    "id": 40512, "lesson_id": 10702, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "kaufen", "question_en": "What does verb 'kaufen' mean?", "question_ar": "ما معنى الفعل \u2066'kaufen'\u2069؟", "question_es": "¿Qué significa el verbo 'kaufen'?"}, ensure_ascii=False),
    "audio_text": "kaufen", "correct_answer": "to buy", "options": json.dumps(["to buy", "to cook", "to eat", "to take"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit7_exercises.append({
    "id": 40513, "lesson_id": 10702, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Ich habe ___ Käse mehr. (keinen - Negation maskulin)", "question_en": "Fill in masculine negative article 'keinen'.", "question_ar": "املأ الفراغ بأداة النفي للمذكر: \u2066'keinen'\u2069.", "question_es": "Rellena con 'keinen'."}, ensure_ascii=False),
    "audio_text": "Ich habe keinen Käse mehr.", "correct_answer": "keinen", "options": json.dumps(["keinen", "kein", "keine", "nicht"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit7_exercises.append({
    "id": 40514, "lesson_id": 10702, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Wie viel kostet das Brot?", "question_en": "Repeat supermarket question: 'Wie viel kostet das Brot?'", "question_ar": "ردد سؤال السعر في المتجر: \u2066'Wie viel kostet das Brot?'\u2069", "question_es": "Repite la pregunta: 'Wie viel kostet das Brot?'"}, ensure_ascii=False),
    "audio_text": "Wie viel kostet das Brot?", "correct_answer": "Wie viel kostet das Brot?", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 10703: Grammatik: Verben mit Vokalwechsel (7 exercises) ---
unit7_exercises.append({
    "id": 40515, "lesson_id": 10703, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Was ___ du gern zum Frühstück? (essen - du isst)", "question_en": "Conjugate 'essen' for 'du': isst.", "question_ar": "صرف الفعل \u2066essen\u2069 مع الضمير \u2066du\u2069: \u2066'isst'\u2069.", "question_es": "Conjuga 'essen' para 'du': isst."}, ensure_ascii=False),
    "audio_text": "Was isst du gern zum Frühstück?", "correct_answer": "isst", "options": json.dumps(["isst", "esst", "esse", "essen"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit7_exercises.append({
    "id": 40516, "lesson_id": 10703, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Er ___ ein Brötchen mit Käse. (essen - er isst)", "question_en": "Conjugate 'essen' for 'er': isst.", "question_ar": "صرف الفعل \u2066essen\u2069 مع الضمير \u2066er\u2069: \u2066'isst'\u2069.", "question_es": "Conjuga 'essen' para 'er': isst."}, ensure_ascii=False),
    "audio_text": "Er isst ein Brötchen mit Käse.", "correct_answer": "isst", "options": json.dumps(["isst", "esst", "esse", "nehmen"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit7_exercises.append({
    "id": 40517, "lesson_id": 10703, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Was ___ du? (nehmen - du nimmst)", "question_en": "Conjugate 'nehmen' for 'du': nimmst.", "question_ar": "صرف الفعل \u2066nehmen\u2069 مع الضمير \u2066du\u2069: \u2066'nimmst'\u2069.", "question_es": "Conjuga 'nehmen' para 'du': nimmst."}, ensure_ascii=False),
    "audio_text": "Was nimmst du?", "correct_answer": "nimmst", "options": json.dumps(["nimmst", "nehmst", "nehmt", "nimmt"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit7_exercises.append({
    "id": 40518, "lesson_id": 10703, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Ich nehme einen Kaffee.", "question_en": "Listen and select the order.", "question_ar": "استمع واختر الطلب المذكور.", "question_es": "Escucha y selecciona el pedido."}, ensure_ascii=False),
    "audio_text": "Ich nehme einen Kaffee.", "correct_answer": "Ich nehme einen Kaffee.", "options": json.dumps(["Ich nehme einen Kaffee.", "Ich trinke einen Tee.", "Ich esse einen Apfel.", "Ich nehme das Wasser."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit7_exercises.append({
    "id": 40519, "lesson_id": 10703, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Er ___ den Salat. (nehmen - er nimmt)", "question_en": "Conjugate 'nehmen' for 'er': nimmt.", "question_ar": "صرف الفعل \u2066nehmen\u2069 مع \u2066er\u2069: \u2066'nimmt'\u2069.", "question_es": "Conjuga 'nehmen' para 'er': nimmt."}, ensure_ascii=False),
    "audio_text": "Er nimmt den Salat.", "correct_answer": "nimmt", "options": json.dumps(["nimmt", "nimmst", "nehmt", "nehmen"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit7_exercises.append({
    "id": 40520, "lesson_id": 10703, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "kochen", "question_en": "What does 'kochen' mean?", "question_ar": "ما معنى الفعل \u2066'kochen'\u2069؟", "question_es": "¿Qué significa 'kochen'?"}, ensure_ascii=False),
    "audio_text": "kochen", "correct_answer": "to cook", "options": json.dumps(["to cook", "to eat", "to buy", "to taste"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit7_exercises.append({
    "id": 40521, "lesson_id": 10703, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Ich nehme einen Orangensaft, bitte.", "question_en": "Repeat: 'Ich nehme einen Orangensaft, bitte.'", "question_ar": "ردد: \u2066'Ich nehme einen Orangensaft, bitte.'\u2069", "question_es": "Repite: 'Ich nehme einen Orangensaft, bitte.'"}, ensure_ascii=False),
    "audio_text": "Ich nehme einen Orangensaft, bitte.", "correct_answer": "Ich nehme einen Orangensaft, bitte.", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 10704: Vorlieben ausdrücken: gern & lieber (7 exercises) ---
unit7_exercises.append({
    "id": 40522, "lesson_id": 10704, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "gern", "question_en": "What does adverb 'gern' mean?", "question_ar": "ما معنى الظرف \u2066'gern'\u2069؟", "question_es": "¿Qué significa 'gern'?"}, ensure_ascii=False),
    "audio_text": "gern", "correct_answer": "gladly / with pleasure", "options": json.dumps(["gladly / with pleasure", "never", "always", "sometimes"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit7_exercises.append({
    "id": 40523, "lesson_id": 10704, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "lieber", "question_en": "What does 'lieber' mean when comparing?", "question_ar": "ما معنى \u2066'lieber'\u2069 عند المقارنة والتفضيل؟", "question_es": "¿Qué significa 'lieber'?"}, ensure_ascii=False),
    "audio_text": "lieber", "correct_answer": "rather / prefer", "options": json.dumps(["rather / prefer", "worse", "less", "more expensive"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit7_exercises.append({
    "id": 40524, "lesson_id": 10704, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Ich trinke gern Tee, aber ich trinke ___ Kaffee. (lieber)", "question_en": "Fill in 'lieber' for preference.", "question_ar": "املأ الفراغ بكلمة التفضيل: \u2066'lieber'\u2069.", "question_es": "Rellena con 'lieber'."}, ensure_ascii=False),
    "audio_text": "Ich trinke gern Tee, aber ich trinke lieber Kaffee.", "correct_answer": "lieber", "options": json.dumps(["lieber", "gern", "gut", "sehr"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit7_exercises.append({
    "id": 40525, "lesson_id": 10704, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Ich esse sehr gern Fisch.", "question_en": "Listen to what the speaker likes eating.", "question_ar": "استمع لما يحب المتحدث تناوله.", "question_es": "Escucha lo que al hablante le gusta comer."}, ensure_ascii=False),
    "audio_text": "Ich esse sehr gern Fisch.", "correct_answer": "Ich esse sehr gern Fisch.", "options": json.dumps(["Ich esse sehr gern Fisch.", "Ich esse kein Fleisch.", "Ich trinke gern Saft.", "Ich esse lieber Brot."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit7_exercises.append({
    "id": 40526, "lesson_id": 10704, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "schmecken", "question_en": "What does 'schmecken' mean?", "question_ar": "ما معنى \u2066'schmecken'\u2069؟", "question_es": "¿Qué significa 'schmecken'?"}, ensure_ascii=False),
    "audio_text": "schmecken", "correct_answer": "to taste good", "options": json.dumps(["to taste good", "to drink", "to order", "to pay"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit7_exercises.append({
    "id": 40527, "lesson_id": 10704, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Die Suppe ___ fantastisch! (schmeckt)", "question_en": "Fill in 'schmeckt'.", "question_ar": "املأ الفراغ بكلمة مذاقها رائع: \u2066'schmeckt'\u2069.", "question_es": "Rellena con 'schmeckt'."}, ensure_ascii=False),
    "audio_text": "Die Suppe schmeckt fantastisch!", "correct_answer": "schmeckt", "options": json.dumps(["schmeckt", "schmecken", "isst", "trinkt"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit7_exercises.append({
    "id": 40528, "lesson_id": 10704, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Was isst du lieber: Pizza oder Pasta?", "question_en": "Repeat: 'Was isst du lieber: Pizza oder Pasta?'", "question_ar": "ردد: \u2066'Was isst du lieber: Pizza oder Pasta?'\u2069", "question_es": "Repite: 'Was isst du lieber: Pizza oder Pasta?'"}, ensure_ascii=False),
    "audio_text": "Was isst du lieber: Pizza oder Pasta?", "correct_answer": "Was isst du lieber: Pizza oder Pasta?", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 10705: Im Restaurant & Bestellen (7 exercises) ---
unit7_exercises.append({
    "id": 40529, "lesson_id": 10705, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Rechnung", "gender": "die", "question_en": "What does 'die Rechnung' mean in a restaurant?", "question_ar": "ما معنى \u2066'die Rechnung'\u2069 في المطعم؟", "question_es": "¿Qué significa 'die Rechnung'?"}, ensure_ascii=False),
    "audio_text": "die Rechnung", "correct_answer": "bill / check", "options": json.dumps(["bill / check", "menu", "food", "table"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit7_exercises.append({
    "id": 40530, "lesson_id": 10705, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Wir möchten bitte bezahlen.", "question_en": "Listen to the customer request.", "question_ar": "استمع لطلب الزبون في المطعم.", "question_es": "Escucha la petición del cliente."}, ensure_ascii=False),
    "audio_text": "Wir möchten bitte bezahlen.", "correct_answer": "Wir möchten bitte bezahlen.", "options": json.dumps(["Wir möchten bitte bezahlen.", "Wir möchten bestellen.", "Wir nehmen die Speisekarte.", "Wir haben kein Geld."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit7_exercises.append({
    "id": 40531, "lesson_id": 10705, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Die ___, bitte! (Rechnung)", "question_en": "Fill in 'Rechnung'.", "question_ar": "املأ الفراغ بطلب الحساب: \u2066'Rechnung'\u2069.", "question_es": "Rellena con 'Rechnung'."}, ensure_ascii=False),
    "audio_text": "Die Rechnung, bitte!", "correct_answer": "Rechnung", "options": json.dumps(["Rechnung", "Miete", "Karte", "Suppe"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit7_exercises.append({
    "id": 40532, "lesson_id": 10705, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Restaurant", "gender": "das", "question_en": "What does 'das Restaurant' mean?", "question_ar": "ما معنى \u2066'das Restaurant'\u2069؟", "question_es": "¿Qué significa 'das Restaurant'?"}, ensure_ascii=False),
    "audio_text": "das Restaurant", "correct_answer": "restaurant", "options": json.dumps(["restaurant", "hotel", "supermarket", "café"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit7_exercises.append({
    "id": 40533, "lesson_id": 10705, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Zusammen oder getrennt?", "question_en": "Listen to the waiter's payment question.", "question_ar": "استمع لسؤال النادل حول طريقة الدفع.", "question_es": "Escucha la pregunta del camarero sobre el pago."}, ensure_ascii=False),
    "audio_text": "Zusammen oder getrennt?", "correct_answer": "Zusammen oder getrennt?", "options": json.dumps(["Zusammen oder getrennt?", "Kaffee oder Tee?", "Groß oder klein?", "Bar oder mit Karte?"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit7_exercises.append({
    "id": 40534, "lesson_id": 10705, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Wir zahlen ___ . (zusammen)", "question_en": "Fill in 'zusammen' (together).", "question_ar": "املأ الفراغ بكلمة الدفع معاً: \u2066'zusammen'\u2069.", "question_es": "Rellena con 'zusammen'."}, ensure_ascii=False),
    "audio_text": "Wir zahlen zusammen.", "correct_answer": "zusammen", "options": json.dumps(["zusammen", "getrennt", "allein", "spät"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit7_exercises.append({
    "id": 40535, "lesson_id": 10705, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Ich möchte bitte bestellen.", "question_en": "Repeat: 'Ich möchte bitte bestellen.'", "question_ar": "ردد: \u2066'Ich möchte bitte bestellen.'\u2069", "question_es": "Repite: 'Ich möchte bitte bestellen.'"}, ensure_ascii=False),
    "audio_text": "Ich möchte bitte bestellen.", "correct_answer": "Ich möchte bitte bestellen.", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 10706: Einheitstest: Essen & Trinken (10 exercises) ---
test_pool_7 = [
    ("das Brot", ["bread", "milk", "meat", "water"], "bread", "match_pairs", "What does 'das Brot' mean?", "ما معنى \u2066'das Brot'\u2069؟", "¿Qué significa 'das Brot'?"),
    ("Ich nehme einen Kaffee.", ["Ich nehme einen Kaffee.", "Ich trinke Tee.", "Ich esse Brot.", "Ich habe Wasser."], "Ich nehme einen Kaffee.", "listen_choose", "Listen and choose the order.", "استمع واختر الطلب.", "Escucha y elige el pedido."),
    ("Was isst du gern zum Frühstück?", ["isst", "esst", "esse", "essen"], "isst", "type_fill_blank", "Fill in 'isst'.", "صرف الفعل مع du: \u2066'isst'\u2069.", "Rellena con 'isst'."),
    ("die Milch", ["milk", "juice", "tea", "coffee"], "milk", "match_pairs", "What does 'die Milch' mean?", "ما معنى \u2066'die Milch'\u2069؟", "¿Qué significa 'die Milch'?"),
    ("Ich trinke gern Tee, aber ich trinke lieber Kaffee.", ["lieber", "gern", "gut", "viel"], "lieber", "type_fill_blank", "Fill in preference 'lieber'.", "املأ الفراغ بكلمة التفضيل: \u2066'lieber'\u2069.", "Rellena con 'lieber'."),
    ("Wir möchten bitte bezahlen.", ["Wir möchten bitte bezahlen.", "Wir bestellen jetzt.", "Wir nehmen die Suppe.", "Wir haben Hunger."], "Wir möchten bitte bezahlen.", "listen_choose", "Listen to payment request.", "استمع لطلب الدفع والحساب.", "Escucha la petición de pago."),
    ("der Käse", ["cheese", "bread", "butter", "egg"], "cheese", "match_pairs", "What does 'der Käse' mean?", "ما معنى \u2066'der Käse'\u2069؟", "¿Qué significa 'der Käse'?"),
    ("die Rechnung", ["bill / check", "menu", "supermarket", "order"], "bill / check", "match_pairs", "What does 'die Rechnung' mean?", "ما معنى \u2066'die Rechnung'\u2069؟", "¿Qué significa 'die Rechnung'?"),
    ("Das Essen schmeckt sehr gut.", None, "Das Essen schmeckt sehr gut.", "repeat_prompt", "Repeat: 'Das Essen schmeckt sehr gut.'", "ردد: \u2066'Das Essen schmeckt sehr gut.'\u2069", "Repite: 'Das Essen schmeckt sehr gut.'"),
    ("Ich kaufe einen Apfel.", ["einen", "ein", "eine", "kein"], "einen", "type_fill_blank", "Fill in accusative 'einen'.", "املأ الفراغ بأداة النصب: \u2066'einen'\u2069.", "Rellena con 'einen'.")
]

for idx, (audio, opts, ans, extype, q_en, q_ar, q_es) in enumerate(test_pool_7, start=1):
    unit7_exercises.append({
        "id": 40535 + idx,
        "lesson_id": 10706,
        "passage_id": None,
        "skill": "listening" if extype == "listen_choose" else ("speaking" if extype == "repeat_prompt" else "reading"),
        "exercise_type": extype,
        "prompt": json.dumps({
            "de": audio,
            "question_en": f"Unit 7 Test ({idx}/10): {q_en}",
            "question_ar": f"اختبار الوحدة 7 ({idx}/10): {q_ar}",
            "question_es": f"Test Unidad 7 ({idx}/10): {q_es}"
        }, ensure_ascii=False),
        "audio_text": audio,
        "correct_answer": ans,
        "options": json.dumps(opts, ensure_ascii=False) if opts else None,
        "is_graded": 1,
        "is_test_pool": 1,
        "sort_order": idx
    })

for ex in unit7_exercises:
    if ex["id"] not in existing_ex_ids:
        data["exercises"].append(ex)
        existing_ex_ids.add(ex["id"])

with open(CONTENT_PATH, "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print(f"Successfully built Unit 7 (Essen & Trinken)! Total exercises added: {len(unit7_exercises)}")
