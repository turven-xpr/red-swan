import json
from pathlib import Path

CONTENT_PATH = Path(r"c:\Users\HP\3D Objects\Deutschy-main\Deutschy-main\assets\deutschy_content.json")

with open(CONTENT_PATH, "r", encoding="utf-8") as f:
    data = json.load(f)

# 1. Register Unit 10
if not any(u["id"] == 50006 for u in data["units"]):
    data["units"].append({
        "id": 50006,
        "level": "A1",
        "unit_number": 10,
        "title_de": "Einkaufen & Geld",
        "title_en": "Shopping & Money",
        "title_ar": "التسوق والمال",
        "title_es": "Compras y dinero",
        "topic_key": "shopping"
    })

# 2. Add Vocabulary for Unit 10 (IDs 1230-1254)
unit10_words = [
    {"id": 1230, "lemma": "Geld", "level": "A1", "topic": "shopping", "pos": "noun", "gender": "das", "plural": None, "conjugation": None, "translation_en": "money", "translation_ar": "نقود / مال", "translation_es": "dinero", "frequency_rank": 230},
    {"id": 1231, "lemma": "Euro", "level": "A1", "topic": "shopping", "pos": "noun", "gender": "der", "plural": "Euro", "conjugation": None, "translation_en": "euro", "translation_ar": "يورو", "translation_es": "euro", "frequency_rank": 231},
    {"id": 1232, "lemma": "Cent", "level": "A1", "topic": "shopping", "pos": "noun", "gender": "der", "plural": "Cent", "conjugation": None, "translation_en": "cent", "translation_ar": "سنت", "translation_es": "céntimo", "frequency_rank": 232},
    {"id": 1233, "lemma": "Preis", "level": "A1", "topic": "shopping", "pos": "noun", "gender": "der", "plural": "Preise", "conjugation": None, "translation_en": "price", "translation_ar": "سعر / ثمن", "translation_es": "precio", "frequency_rank": 233},
    {"id": 1234, "lemma": "Kasse", "level": "A1", "topic": "shopping", "pos": "noun", "gender": "die", "plural": "Kassen", "conjugation": None, "translation_en": "cash register / checkout", "translation_ar": "خزينة الدفع / كاشير", "translation_es": "caja", "frequency_rank": 234},
    {"id": 1235, "lemma": "Kunde", "level": "A1", "topic": "shopping", "pos": "noun", "gender": "der", "plural": "Kunden", "conjugation": None, "translation_en": "customer (m.)", "translation_ar": "زبون / عميل", "translation_es": "cliente", "frequency_rank": 235},
    {"id": 1236, "lemma": "Kundin", "level": "A1", "topic": "shopping", "pos": "noun", "gender": "die", "plural": "Kundinnen", "conjugation": None, "translation_en": "customer (f.)", "translation_ar": "زبونة / عميلة", "translation_es": "clienta", "frequency_rank": 236},
    {"id": 1237, "lemma": "Verkäufer", "level": "A1", "topic": "shopping", "pos": "noun", "gender": "der", "plural": "Verkäufer", "conjugation": None, "translation_en": "salesman", "translation_ar": "بائع", "translation_es": "vendedor", "frequency_rank": 237},
    {"id": 1238, "lemma": "Verkäuferin", "level": "A1", "topic": "shopping", "pos": "noun", "gender": "die", "plural": "Verkäuferinnen", "conjugation": None, "translation_en": "saleswoman", "translation_ar": "بائعة", "translation_es": "vendedora", "frequency_rank": 238},
    {"id": 1239, "lemma": "Größe", "level": "A1", "topic": "shopping", "pos": "noun", "gender": "die", "plural": "Größen", "conjugation": None, "translation_en": "size", "translation_ar": "مقاس / حجم", "translation_es": "talla / tamaño", "frequency_rank": 239},
    {"id": 1240, "lemma": "Farbe", "level": "A1", "topic": "shopping", "pos": "noun", "gender": "die", "plural": "Farben", "conjugation": None, "translation_en": "color", "translation_ar": "لون", "translation_es": "color", "frequency_rank": 240},
    {"id": 1241, "lemma": "Angebot", "level": "A1", "topic": "shopping", "pos": "noun", "gender": "das", "plural": "Angebote", "conjugation": None, "translation_en": "special offer / sale", "translation_ar": "عرض خاص / تخفيض", "translation_es": "oferta", "frequency_rank": 241},
    {"id": 1242, "lemma": "Tasche", "level": "A1", "topic": "shopping", "pos": "noun", "gender": "die", "plural": "Taschen", "conjugation": None, "translation_en": "bag", "translation_ar": "حقيبة", "translation_es": "bolsa / bolso", "frequency_rank": 242},
    {"id": 1243, "lemma": "Schuh", "level": "A1", "topic": "shopping", "pos": "noun", "gender": "der", "plural": "Schuhe", "conjugation": None, "translation_en": "shoe", "translation_ar": "حذاء", "translation_es": "zapato", "frequency_rank": 243},
    {"id": 1244, "lemma": "Kleid", "level": "A1", "topic": "shopping", "pos": "noun", "gender": "das", "plural": "Kleider", "conjugation": None, "translation_en": "dress", "translation_ar": "فستان", "translation_es": "vestido", "frequency_rank": 244},
    {"id": 1245, "lemma": "Hose", "level": "A1", "topic": "shopping", "pos": "noun", "gender": "die", "plural": "Hosen", "conjugation": None, "translation_en": "pants / trousers", "translation_ar": "بنطال", "translation_es": "pantalón", "frequency_rank": 245},
    {"id": 1246, "lemma": "Hemd", "level": "A1", "topic": "shopping", "pos": "noun", "gender": "das", "plural": "Hemden", "conjugation": None, "translation_en": "shirt", "translation_ar": "قميص", "translation_es": "camisa", "frequency_rank": 246},
    {"id": 1247, "lemma": "kosten", "level": "A1", "topic": "shopping", "pos": "verb", "gender": None, "plural": None, "conjugation": "kostet", "translation_en": "to cost", "translation_ar": "يكلف", "translation_es": "costar", "frequency_rank": 247},
    {"id": 1248, "lemma": "bezahlen", "level": "A1", "topic": "shopping", "pos": "verb", "gender": None, "plural": None, "conjugation": "bezahlt", "translation_en": "to pay", "translation_ar": "يدفع (الحساب)", "translation_es": "pagar", "frequency_rank": 248},
    {"id": 1249, "lemma": "passen", "level": "A1", "topic": "shopping", "pos": "verb", "gender": None, "plural": None, "conjugation": "passt", "translation_en": "to fit", "translation_ar": "يناسب المقاس", "translation_es": "quedar bien", "frequency_rank": 249},
    {"id": 1250, "lemma": "anprobieren", "level": "A1", "topic": "shopping", "pos": "verb", "gender": None, "plural": None, "conjugation": "probiert an", "translation_en": "to try on", "translation_ar": "يقيس (ملابس)", "translation_es": "probarse", "frequency_rank": 250},
    {"id": 1251, "lemma": "brauchen", "level": "A1", "topic": "shopping", "pos": "verb", "gender": None, "plural": None, "conjugation": "braucht", "translation_en": "to need", "translation_ar": "يحتاج", "translation_es": "necesitar", "frequency_rank": 251},
    {"id": 1252, "lemma": "billig", "level": "A1", "topic": "shopping", "pos": "adjective", "gender": None, "plural": None, "conjugation": None, "translation_en": "cheap", "translation_ar": "رخيص", "translation_es": "barato", "frequency_rank": 252},
    {"id": 1253, "lemma": "teuer", "level": "A1", "topic": "shopping", "pos": "adjective", "gender": None, "plural": None, "conjugation": None, "translation_en": "expensive", "translation_ar": "غالي الثمن", "translation_es": "caro", "frequency_rank": 253},
    {"id": 1254, "lemma": "günstig", "level": "A1", "topic": "shopping", "pos": "adjective", "gender": None, "plural": None, "conjugation": None, "translation_en": "favorable / affordable", "translation_ar": "مناسب السعر / اقتصادي", "translation_es": "económico", "frequency_rank": 254},
]

existing_w_ids = {w["id"] for w in data["words"]}
for w in unit10_words:
    if w["id"] not in existing_w_ids:
        data["words"].append(w)

# 3. Add Lessons for Unit 10 (11001 - 11006)
unit10_lessons = [
    {
        "id": 11001, "unit_id": 50006, "level": "A1", "title_de": "Kleidung, Farben & Größen", "title_en": "Clothes, Colors & Sizes",
        "sort_order": 1, "lesson_type": "vocabulary", "pass_threshold": 0.7, "grammar_content": None, "content_json": None
    },
    {
        "id": 11002, "unit_id": 50006, "level": "A1", "title_de": "Preise, Geld & an der Kasse", "title_en": "Prices, Money & Checkout",
        "sort_order": 2, "lesson_type": "vocabulary", "pass_threshold": 0.7, "grammar_content": None, "content_json": None
    },
    {
        "id": 11003, "unit_id": 50006, "level": "A1", "title_de": "Grammatik: Demonstrativpronomen (dieser, diese, dieses)", "title_en": "Grammar: Demonstratives (dieser, diese, dieses)",
        "sort_order": 3, "lesson_type": "grammar", "pass_threshold": 0.7,
        "grammar_content": "# أسماء الإشارة — Demonstrativpronomen: dieser, diese, dieses\n# Demonstrative Pronouns: this / these\n\n## 🇩🇪 Deutsch | 🇬🇧 English | 🇸🇦 عربي\n\nتأخذ أسماء الإشارة في الألمانية نفس نهايات أداة التعريف المحددة (der, die, das) في حالتي الفاعل والمفعول به:\nIn German, demonstratives (*this / that*) share the exact same case endings as the definite articles:\n\n### 1. في حالة الرفع (Nominativ):\n- مذكر (der): * **Dieser** Pullover ist sehr schön.* (هذه السترة جميلة جداً)\n- محايد (das): * **Dieses** Kleid gefällt mir.* (هذا الفستان يعجبني)\n- مؤنث (die): * **Diese** Hose passt perfekt.* (هذا البنطال يناسب تماماً)\n- جمع (die): * **Diese** Schuhe sind teuer.* (هذه الأحذية غالية)\n\n### 2. في حالة النصب (Akkusativ — المفعول به):\n- مذكر (den): *Ich nehme **diesen** Rock.* (سآخذ هذه التنورة)\n- محايد (das): *Ich kaufe **dieses** Hemd.* (سأشتري هذا القميص)\n- مؤنث (die): *Ich probiere **diese** Jacke an.* (سأقيس هذه السترة)\n\n### 3. أداة الاستفهام welcher / welche / welches:\n- * **Welcher** Mantel gefällt dir?* — * **Dieser** Mantel.*\n- * **Welches** Hemd nehmen Sie?* — * **Dieses** Hemd.*",
        "content_json": None
    },
    {
        "id": 11004, "unit_id": 50006, "level": "A1", "title_de": "Verkaufsgespräche & Beratung", "title_en": "Shopping Conversations & Advice",
        "sort_order": 4, "lesson_type": "grammar", "pass_threshold": 0.7,
        "grammar_content": "# حوارات الشراء وطلب المساعدة في المتجر\n# In the Store: Asking for Help and Trying Clothes\n\n## 🇩🇪 Deutsch | 🇬🇧 English | 🇸🇦 عربي\n\n### عبارات أساسية للبائع والمشتري:\n- البائع: *Kann ich Ihnen helfen?* (هل يمكنني مساعدة حضرتك؟)\n- المشتري: *Ich suche eine Jacke in Größe M.* (أبحث عن سترة بمقاس M)\n- القياس: *Kann ich das anprobieren?* (هل يمكنني قياس هذا؟)\n- المقاس: *Die Hose passt mir nicht. Haben Sie Größe 38?* (البنطال لا يناسبني، هل لديكم مقاس 38؟)\n- الدفع: *Kann ich mit Karte zahlen?* (هل يمكنني الدفع بالبطاقة؟)",
        "content_json": None
    },
    {
        "id": 11005, "unit_id": 50006, "level": "A1", "title_de": "Sonderangebote & Einkaufszettel", "title_en": "Discounts, Receipts & Shopping Lists",
        "sort_order": 5, "lesson_type": "text", "pass_threshold": 0.7, "grammar_content": None, "content_json": None
    },
    {
        "id": 11006, "unit_id": 50006, "level": "A1", "title_de": "Einheitstest: Einkaufen & Geld", "title_en": "Unit Test: Shopping & Money",
        "sort_order": 6, "lesson_type": "unit_test", "pass_threshold": 0.75, "grammar_content": None, "content_json": None
    }
]

existing_l_ids = {l["id"] for l in data["lessons"]}
for l in unit10_lessons:
    if l["id"] not in existing_l_ids:
        data["lessons"].append(l)

# 4. Add Exercises for Unit 10 (40801 - 40845)
existing_ex_ids = {e["id"] for e in data["exercises"]}
unit10_exercises = []

# --- LESSON 11001: Kleidung, Farben & Größen (7 exercises) ---
unit10_exercises.append({
    "id": 40801, "lesson_id": 11001, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Kleid", "gender": "das", "question_en": "What does 'das Kleid' mean?", "question_ar": "ما معنى \u2066'das Kleid'\u2069؟", "question_es": "¿Qué significa 'das Kleid'?"}, ensure_ascii=False),
    "audio_text": "das Kleid", "correct_answer": "dress", "options": json.dumps(["dress", "shirt", "shoe", "pants"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit10_exercises.append({
    "id": 40802, "lesson_id": 11001, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Hose", "gender": "die", "question_en": "What does 'die Hose' mean?", "question_ar": "ما معنى \u2066'die Hose'\u2069؟", "question_es": "¿Qué significa 'die Hose'?"}, ensure_ascii=False),
    "audio_text": "die Hose", "correct_answer": "pants / trousers", "options": json.dumps(["pants / trousers", "dress", "shoe", "bag"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit10_exercises.append({
    "id": 40803, "lesson_id": 11001, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Ich brauche ein weißes Hemd.", "question_en": "Listen and select the clothing item.", "question_ar": "استمع واختر قطعة الملابس المطلوبة.", "question_es": "Escucha y selecciona la prenda requerida."}, ensure_ascii=False),
    "audio_text": "Ich brauche ein weißes Hemd.", "correct_answer": "Ich brauche ein weißes Hemd.", "options": json.dumps(["Ich brauche ein weißes Hemd.", "Ich brauche eine neue Hose.", "Ich kaufe ein rotes Kleid.", "Ich habe keine Schuhe."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit10_exercises.append({
    "id": 40804, "lesson_id": 11001, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Größe", "gender": "die", "question_en": "What does 'die Größe' mean in clothing?", "question_ar": "ما معنى \u2066'die Größe'\u2069 في الملابس؟", "question_es": "¿Qué significa 'die Größe'?"}, ensure_ascii=False),
    "audio_text": "die Größe", "correct_answer": "size", "options": json.dumps(["size", "price", "color", "offer"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit10_exercises.append({
    "id": 40805, "lesson_id": 11001, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Welche ___ möchten Sie? (Größe)", "question_en": "Fill in 'Größe' (size).", "question_ar": "املأ الفراغ بكلمة المقاس: \u2066'Größe'\u2069.", "question_es": "Rellena con 'Größe'."}, ensure_ascii=False),
    "audio_text": "Welche Größe möchten Sie?", "correct_answer": "Größe", "options": json.dumps(["Größe", "Farbe", "Hose", "Tasche"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit10_exercises.append({
    "id": 40806, "lesson_id": 11001, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Schuh", "gender": "der", "question_en": "What does 'der Schuh' mean?", "question_ar": "ما معنى \u2066'der Schuh'\u2069؟", "question_es": "¿Qué significa 'der Schuh'?"}, ensure_ascii=False),
    "audio_text": "der Schuh", "correct_answer": "shoe", "options": json.dumps(["shoe", "dress", "shirt", "pants"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit10_exercises.append({
    "id": 40807, "lesson_id": 11001, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Haben Sie diese Jacke in Schwarz?", "question_en": "Repeat: 'Haben Sie diese Jacke in Schwarz?'", "question_ar": "ردد: \u2066'Haben Sie diese Jacke in Schwarz?'\u2069", "question_es": "Repite: 'Haben Sie diese Jacke in Schwarz?'"}, ensure_ascii=False),
    "audio_text": "Haben Sie diese Jacke in Schwarz?", "correct_answer": "Haben Sie diese Jacke in Schwarz?", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 11002: Preise, Geld & an der Kasse (7 exercises) ---
unit10_exercises.append({
    "id": 40808, "lesson_id": 11002, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Geld", "gender": "das", "question_en": "What does 'das Geld' mean?", "question_ar": "ما معنى \u2066'das Geld'\u2069؟", "question_es": "¿Qué significa 'das Geld'?"}, ensure_ascii=False),
    "audio_text": "das Geld", "correct_answer": "money", "options": json.dumps(["money", "price", "checkout", "discount"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit10_exercises.append({
    "id": 40809, "lesson_id": 11002, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Das kostet 29 Euro und 50 Cent.", "question_en": "Listen and select the exact price.", "question_ar": "استمع واختر السعر الدقيق المسموع.", "question_es": "Escucha y selecciona el precio exacto."}, ensure_ascii=False),
    "audio_text": "Das kostet 29 Euro und 50 Cent.", "correct_answer": "Das kostet 29 Euro und 50 Cent.", "options": json.dumps(["Das kostet 29 Euro und 50 Cent.", "Das kostet 19 Euro und 50 Cent.", "Das kostet 39 Euro.", "Das kostet 29 Euro und 90 Cent."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit10_exercises.append({
    "id": 40810, "lesson_id": 11002, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Kasse", "gender": "die", "question_en": "What does 'die Kasse' mean?", "question_ar": "ما معنى \u2066'die Kasse'\u2069؟", "question_es": "¿Qué significa 'die Kasse'?"}, ensure_ascii=False),
    "audio_text": "die Kasse", "correct_answer": "cash register / checkout", "options": json.dumps(["cash register / checkout", "bank", "supermarket", "shelf"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit10_exercises.append({
    "id": 40811, "lesson_id": 11002, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Ich möchte mit Karte ___ . (bezahlen)", "question_en": "Fill in 'bezahlen' (to pay).", "question_ar": "املأ الفراغ بكلمة الدفع: \u2066'bezahlen'\u2069.", "question_es": "Rellena con 'bezahlen'."}, ensure_ascii=False),
    "audio_text": "Ich möchte mit Karte bezahlen.", "correct_answer": "bezahlen", "options": json.dumps(["bezahlen", "kaufen", "kosten", "nehmen"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit10_exercises.append({
    "id": 40812, "lesson_id": 11002, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "billig", "question_en": "What does 'billig' mean?", "question_ar": "ما معنى \u2066'billig'\u2069؟", "question_es": "¿Qué significa 'billig'?"}, ensure_ascii=False),
    "audio_text": "billig", "correct_answer": "cheap", "options": json.dumps(["cheap", "expensive", "big", "small"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit10_exercises.append({
    "id": 40813, "lesson_id": 11002, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "teuer", "question_en": "What does 'teuer' mean?", "question_ar": "ما معنى \u2066'teuer'\u2069؟", "question_es": "¿Qué significa 'teuer'?"}, ensure_ascii=False),
    "audio_text": "teuer", "correct_answer": "expensive", "options": json.dumps(["expensive", "cheap", "new", "old"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit10_exercises.append({
    "id": 40814, "lesson_id": 11002, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Kann ich bitte die Quittung haben?", "question_en": "Repeat politely: 'Kann ich bitte die Quittung haben?'", "question_ar": "ردد بأدب طلب الإيصال: \u2066'Kann ich bitte die Quittung haben?'\u2069", "question_es": "Repite: 'Kann ich bitte die Quittung haben?'"}, ensure_ascii=False),
    "audio_text": "Kann ich bitte die Quittung haben?", "correct_answer": "Kann ich bitte die Quittung haben?", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 11003: Grammatik: Demonstrativpronomen (7 exercises) ---
unit10_exercises.append({
    "id": 40815, "lesson_id": 11003, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "___ Pullover gefällt mir sehr gut. (Dieser - maskulin Nominativ)", "question_en": "Fill in masculine demonstrative 'Dieser'.", "question_ar": "اختر اسم الإشارة للمذكر المرفوع: \u2066'Dieser'\u2069.", "question_es": "Rellena con 'Dieser'."}, ensure_ascii=False),
    "audio_text": "Dieser Pullover gefällt mir sehr gut.", "correct_answer": "Dieser", "options": json.dumps(["Dieser", "Dieses", "Diese", "Diesen"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit10_exercises.append({
    "id": 40816, "lesson_id": 11003, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Ich nehme ___ Rock. (diesen - maskulin Akkusativ)", "question_en": "Fill in accusative masculine demonstrative 'diesen'.", "question_ar": "اختر اسم الإشارة للمذكر المنصوب: \u2066'diesen'\u2069.", "question_es": "Rellena con 'diesen'."}, ensure_ascii=False),
    "audio_text": "Ich nehme diesen Rock.", "correct_answer": "diesen", "options": json.dumps(["diesen", "dieser", "dieses", "diese"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit10_exercises.append({
    "id": 40817, "lesson_id": 11003, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "___ Kleid steht dir ausgezeichnet! (Dieses - neutral)", "question_en": "Fill in neuter demonstrative 'Dieses'.", "question_ar": "اختر اسم الإشارة للمحايد: \u2066'Dieses'\u2069.", "question_es": "Rellena con 'Dieses'."}, ensure_ascii=False),
    "audio_text": "Dieses Kleid steht dir ausgezeichnet!", "correct_answer": "Dieses", "options": json.dumps(["Dieses", "Dieser", "Diese", "Diesen"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit10_exercises.append({
    "id": 40818, "lesson_id": 11003, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Welches Hemd möchten Sie kaufen?", "question_en": "Listen and select the question.", "question_ar": "استمع واختر السؤال المسموع.", "question_es": "Escucha y selecciona la pregunta."}, ensure_ascii=False),
    "audio_text": "Welches Hemd möchten Sie kaufen?", "correct_answer": "Welches Hemd möchten Sie kaufen?", "options": json.dumps(["Welches Hemd möchten Sie kaufen?", "Welche Hose möchten Sie kaufen?", "Dieser Schuh ist zu klein.", "Dieses Kleid ist sehr teuer."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit10_exercises.append({
    "id": 40819, "lesson_id": 11003, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "___ Schuhe sind sehr bequem. (Diese - Plural)", "question_en": "Fill in plural demonstrative 'Diese'.", "question_ar": "اختر اسم الإشارة للجمع: \u2066'Diese'\u2069.", "question_es": "Rellena con 'Diese' para plural."}, ensure_ascii=False),
    "audio_text": "Diese Schuhe sind sehr bequem.", "correct_answer": "Diese", "options": json.dumps(["Diese", "Dieser", "Dieses", "Diesen"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit10_exercises.append({
    "id": 40820, "lesson_id": 11003, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Angebot", "gender": "das", "question_en": "What does 'das Angebot' mean?", "question_ar": "ما معنى \u2066'das Angebot'\u2069؟", "question_es": "¿Qué significa 'das Angebot'?"}, ensure_ascii=False),
    "audio_text": "das Angebot", "correct_answer": "special offer / sale", "options": json.dumps(["special offer / sale", "full price", "checkout", "receipt"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit10_exercises.append({
    "id": 40821, "lesson_id": 11003, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Ich nehme dieses Hemd.", "question_en": "Repeat: 'Ich nehme dieses Hemd.'", "question_ar": "ردد: \u2066'Ich nehme dieses Hemd.'\u2069", "question_es": "Repite: 'Ich nehme dieses Hemd.'"}, ensure_ascii=False),
    "audio_text": "Ich nehme dieses Hemd.", "correct_answer": "Ich nehme dieses Hemd.", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 11004: Verkaufsgespräche & Beratung (7 exercises) ---
unit10_exercises.append({
    "id": 40822, "lesson_id": 11004, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Kann ich das ___ ? (anprobieren)", "question_en": "Fill in 'anprobieren' (to try on).", "question_ar": "املأ الفراغ بفعل القياس: \u2066'anprobieren'\u2069.", "question_es": "Rellena con 'anprobieren'."}, ensure_ascii=False),
    "audio_text": "Kann ich das anprobieren?", "correct_answer": "anprobieren", "options": json.dumps(["anprobieren", "bezahlen", "kaufen", "nehmen"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit10_exercises.append({
    "id": 40823, "lesson_id": 11004, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Die Hose ___ mir perfekt! (passt - passen)", "question_en": "Conjugate 'passen' for die Hose: passt.", "question_ar": "صرف الفعل \u2066passen\u2069 مع البنطال: \u2066'passt'\u2069.", "question_es": "Conjuga 'passen': passt."}, ensure_ascii=False),
    "audio_text": "Die Hose passt mir perfekt!", "correct_answer": "passt", "options": json.dumps(["passt", "passen", "kostet", "steht"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit10_exercises.append({
    "id": 40824, "lesson_id": 11004, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Kann ich Ihnen helfen?", "question_en": "Listen to the salesperson greeting.", "question_ar": "استمع لسؤال البائع عند عرض المساعدة.", "question_es": "Escucha la oferta de ayuda del dependiente."}, ensure_ascii=False),
    "audio_text": "Kann ich Ihnen helfen?", "correct_answer": "Kann ich Ihnen helfen?", "options": json.dumps(["Kann ich Ihnen helfen?", "Was kostet das?", "Wo ist die Kasse?", "Haben Sie Größe L?"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit10_exercises.append({
    "id": 40825, "lesson_id": 11004, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Kunde", "gender": "der", "question_en": "What does 'der Kunde' mean?", "question_ar": "ما معنى \u2066'der Kunde'\u2069؟", "question_es": "¿Qué significa 'der Kunde'?"}, ensure_ascii=False),
    "audio_text": "der Kunde", "correct_answer": "customer (m.)", "options": json.dumps(["customer (m.)", "salesman", "boss", "colleague"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit10_exercises.append({
    "id": 40826, "lesson_id": 11004, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Haben Sie das auch in einer anderen ___ ? (Farbe)", "question_en": "Fill in 'Farbe' (color).", "question_ar": "املأ الفراغ بكلمة اللون: \u2066'Farbe'\u2069.", "question_es": "Rellena con 'Farbe'."}, ensure_ascii=False),
    "audio_text": "Haben Sie das auch in einer anderen Farbe?", "correct_answer": "Farbe", "options": json.dumps(["Farbe", "Größe", "Kasse", "Tasche"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit10_exercises.append({
    "id": 40827, "lesson_id": 11004, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Tasche", "gender": "die", "question_en": "What does 'die Tasche' mean?", "question_ar": "ما معنى \u2066'die Tasche'\u2069؟", "question_es": "¿Qué significa 'die Tasche'?"}, ensure_ascii=False),
    "audio_text": "die Tasche", "correct_answer": "bag", "options": json.dumps(["bag", "shoe", "dress", "hat"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit10_exercises.append({
    "id": 40828, "lesson_id": 11004, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Wo ist die Umkleidekabine?", "question_en": "Repeat: 'Wo ist die Umkleidekabine?'", "question_ar": "ردد سؤال غرفة القياس: \u2066'Wo ist die Umkleidekabine?'\u2069", "question_es": "Repite: 'Wo ist die Umkleidekabine?'"}, ensure_ascii=False),
    "audio_text": "Wo ist die Umkleidekabine?", "correct_answer": "Wo ist die Umkleidekabine?", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 11005: Sonderangebote & Einkaufszettel (7 exercises) ---
unit10_exercises.append({
    "id": 40829, "lesson_id": 11005, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "günstig", "question_en": "What does 'günstig' mean?", "question_ar": "ما معنى \u2066'günstig'\u2069؟", "question_es": "¿Qué significa 'günstig'?"}, ensure_ascii=False),
    "audio_text": "günstig", "correct_answer": "favorable / affordable", "options": json.dumps(["favorable / affordable", "very expensive", "bad quality", "broken"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit10_exercises.append({
    "id": 40830, "lesson_id": 11005, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Heute gibt es 20 Prozent Rabatt.", "question_en": "Listen and select the discount offer.", "question_ar": "استمع واختر نسبة الخصم المعلنة.", "question_es": "Escucha y selecciona la oferta de descuento."}, ensure_ascii=False),
    "audio_text": "Heute gibt es 20 Prozent Rabatt.", "correct_answer": "Heute gibt es 20 Prozent Rabatt.", "options": json.dumps(["Heute gibt es 20 Prozent Rabatt.", "Heute gibt es 50 Prozent Rabatt.", "Alles ist sehr teuer.", "Das Geschäft ist geschlossen."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit10_exercises.append({
    "id": 40831, "lesson_id": 11005, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Das ist ein tolles ___ ! (Angebot)", "question_en": "Fill in 'Angebot' (offer).", "question_ar": "املأ الفراغ بكلمة عرض رائع: \u2066'Angebot'\u2069.", "question_es": "Rellena con 'Angebot'."}, ensure_ascii=False),
    "audio_text": "Das ist ein tolles Angebot!", "correct_answer": "Angebot", "options": json.dumps(["Angebot", "Geld", "Preis", "Kleid"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit10_exercises.append({
    "id": 40832, "lesson_id": 11005, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Preis", "gender": "der", "question_en": "What does 'der Preis' mean?", "question_ar": "ما معنى \u2066'der Preis'\u2069؟", "question_es": "¿Qué significa 'der Preis'?"}, ensure_ascii=False),
    "audio_text": "der Preis", "correct_answer": "price", "options": json.dumps(["price", "size", "money", "receipt"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit10_exercises.append({
    "id": 40833, "lesson_id": 11005, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Ich nehme die Schuhe und die Tasche.", "question_en": "Listen and select the purchases.", "question_ar": "استمع واختر المشتريات.", "question_es": "Escucha y selecciona las compras."}, ensure_ascii=False),
    "audio_text": "Ich nehme die Schuhe und die Tasche.", "correct_answer": "Ich nehme die Schuhe und die Tasche.", "options": json.dumps(["Ich nehme die Schuhe und die Tasche.", "Ich nehme das Kleid und das Hemd.", "Ich kaufe nur die Hose.", "Ich brauche keine Tasche."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit10_exercises.append({
    "id": 40834, "lesson_id": 11005, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Zahlen Sie bar oder mit ___ ? (Karte)", "question_en": "Fill in 'Karte' (card).", "question_ar": "املأ الفراغ بكلمة البطاقة: \u2066'Karte'\u2069.", "question_es": "Rellena con 'Karte'."}, ensure_ascii=False),
    "audio_text": "Zahlen Sie bar oder mit Karte?", "correct_answer": "Karte", "options": json.dumps(["Karte", "Geld", "Euro", "Cent"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit10_exercises.append({
    "id": 40835, "lesson_id": 11005, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Das ist mir leider zu teuer.", "question_en": "Repeat: 'Das ist mir leider zu teuer.'", "question_ar": "ردد: \u2066'Das ist mir leider zu teuer.'\u2069", "question_es": "Repite: 'Das ist mir leider zu teuer.'"}, ensure_ascii=False),
    "audio_text": "Das ist mir leider zu teuer.", "correct_answer": "Das ist mir leider zu teuer.", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 11006: Einheitstest: Einkaufen & Geld (10 exercises) ---
test_pool_10 = [
    ("das Kleid", ["dress", "shirt", "shoe", "pants"], "dress", "match_pairs", "What does 'das Kleid' mean?", "ما معنى \u2066'das Kleid'\u2069؟", "¿Qué significa 'das Kleid'?"),
    ("die Hose", ["pants / trousers", "bag", "dress", "skirt"], "pants / trousers", "match_pairs", "What does 'die Hose' mean?", "ما معنى \u2066'die Hose'\u2069؟", "¿Qué significa 'die Hose'?"),
    ("Ich nehme diesen Rock.", ["diesen", "dieser", "dieses", "diese"], "diesen", "type_fill_blank", "Fill in accusative 'diesen'.", "اختر اسم الإشارة للمذكر المنصوب: \u2066'diesen'\u2069.", "Elige 'diesen'."),
    ("Dieses Kleid steht dir ausgezeichnet!", ["Dieses", "Dieser", "Diese", "Diesen"], "Dieses", "type_fill_blank", "Fill in neuter 'Dieses'.", "اختر اسم الإشارة للمحايد: \u2066'Dieses'\u2069.", "Elige 'Dieses'."),
    ("Das kostet 29 Euro und 50 Cent.", ["Das kostet 29 Euro und 50 Cent.", "Das kostet 19 Euro.", "Das kostet 39 Euro.", "Das kostet 49 Euro."], "Das kostet 29 Euro und 50 Cent.", "listen_choose", "Listen to the price.", "استمع للسعر.", "Escucha el precio."),
    ("Kann ich Ihnen helfen?", ["Kann ich Ihnen helfen?", "Was kostet das?", "Wo ist die Kasse?", "Ich brauche Hilfe."], "Kann ich Ihnen helfen?", "listen_choose", "Listen to the salesperson.", "استمع للبائع.", "Escucha al dependiente."),
    ("Ich möchte mit Karte bezahlen.", ["bezahlen", "kaufen", "kosten", "nehmen"], "bezahlen", "type_fill_blank", "Fill in 'bezahlen'.", "املأ الفراغ بكلمة الدفع: \u2066'bezahlen'\u2069.", "Rellena con 'bezahlen'."),
    ("das Angebot", ["special offer / sale", "price", "checkout", "receipt"], "special offer / sale", "match_pairs", "What does 'das Angebot' mean?", "ما معنى \u2066'das Angebot'\u2069؟", "¿Qué significa 'das Angebot'?"),
    ("Das ist mir leider zu teuer.", None, "Das ist mir leider zu teuer.", "repeat_prompt", "Repeat: 'Das ist mir leider zu teuer.'", "ردد: \u2066'Das ist mir leider zu teuer.'\u2069", "Repite: 'Das ist mir leider zu teuer.'"),
    ("Haben Sie diese Jacke in Schwarz?", None, "Haben Sie diese Jacke in Schwarz?", "repeat_prompt", "Repeat: 'Haben Sie diese Jacke in Schwarz?'", "ردد: \u2066'Haben Sie diese Jacke in Schwarz?'\u2069", "Repite: 'Haben Sie diese Jacke in Schwarz?'")
]

for idx, (audio, opts, ans, extype, q_en, q_ar, q_es) in enumerate(test_pool_10, start=1):
    unit10_exercises.append({
        "id": 40835 + idx,
        "lesson_id": 11006,
        "passage_id": None,
        "skill": "listening" if extype == "listen_choose" else ("speaking" if extype == "repeat_prompt" else "reading"),
        "exercise_type": extype,
        "prompt": json.dumps({
            "de": audio,
            "question_en": f"Unit 10 Test ({idx}/10): {q_en}",
            "question_ar": f"اختبار الوحدة 10 ({idx}/10): {q_ar}",
            "question_es": f"Test Unidad 10 ({idx}/10): {q_es}"
        }, ensure_ascii=False),
        "audio_text": audio,
        "correct_answer": ans,
        "options": json.dumps(opts, ensure_ascii=False) if opts else None,
        "is_graded": 1,
        "is_test_pool": 1,
        "sort_order": idx
    })

for ex in unit10_exercises:
    if ex["id"] not in existing_ex_ids:
        data["exercises"].append(ex)
        existing_ex_ids.add(ex["id"])

with open(CONTENT_PATH, "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print(f"Successfully built Unit 10 (Einkaufen & Geld)! Total exercises added: {len(unit10_exercises)}")
