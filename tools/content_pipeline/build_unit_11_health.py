import json
from pathlib import Path

CONTENT_PATH = Path(r"c:\Users\HP\3D Objects\Deutschy-main\Deutschy-main\assets\deutschy_content.json")

with open(CONTENT_PATH, "r", encoding="utf-8") as f:
    data = json.load(f)

# 1. Register Unit 11
if not any(u["id"] == 50007 for u in data["units"]):
    data["units"].append({
        "id": 50007,
        "level": "A1",
        "unit_number": 11,
        "title_de": "Körper & Gesundheit",
        "title_en": "Body & Health",
        "title_ar": "الجسم والصحة",
        "title_es": "Cuerpo y salud",
        "topic_key": "health"
    })

# 2. Add Vocabulary for Unit 11 (IDs 1260-1284)
unit11_words = [
    {"id": 1260, "lemma": "Körper", "level": "A1", "topic": "health", "pos": "noun", "gender": "der", "plural": "Körper", "conjugation": None, "translation_en": "body", "translation_ar": "جسم / جسد", "translation_es": "cuerpo", "frequency_rank": 260},
    {"id": 1261, "lemma": "Kopf", "level": "A1", "topic": "health", "pos": "noun", "gender": "der", "plural": "Köpfe", "conjugation": None, "translation_en": "head", "translation_ar": "رأس", "translation_es": "cabeza", "frequency_rank": 261},
    {"id": 1262, "lemma": "Auge", "level": "A1", "topic": "health", "pos": "noun", "gender": "das", "plural": "Augen", "conjugation": None, "translation_en": "eye", "translation_ar": "عين", "translation_es": "ojo", "frequency_rank": 262},
    {"id": 1263, "lemma": "Ohr", "level": "A1", "topic": "health", "pos": "noun", "gender": "das", "plural": "Ohren", "conjugation": None, "translation_en": "ear", "translation_ar": "أذن", "translation_es": "oreja / oído", "frequency_rank": 263},
    {"id": 1264, "lemma": "Mund", "level": "A1", "topic": "health", "pos": "noun", "gender": "der", "plural": "Münder", "conjugation": None, "translation_en": "mouth", "translation_ar": "فم", "translation_es": "boca", "frequency_rank": 264},
    {"id": 1265, "lemma": "Zahn", "level": "A1", "topic": "health", "pos": "noun", "gender": "der", "plural": "Zähne", "conjugation": None, "translation_en": "tooth", "translation_ar": "سن / ضرس", "translation_es": "diente", "frequency_rank": 265},
    {"id": 1266, "lemma": "Hals", "level": "A1", "topic": "health", "pos": "noun", "gender": "der", "plural": "Hälse", "conjugation": None, "translation_en": "throat / neck", "translation_ar": "حلق / عنق", "translation_es": "cuello / garganta", "frequency_rank": 266},
    {"id": 1267, "lemma": "Hand", "level": "A1", "topic": "health", "pos": "noun", "gender": "die", "plural": "Hände", "conjugation": None, "translation_en": "hand", "translation_ar": "يد", "translation_es": "mano", "frequency_rank": 267},
    {"id": 1268, "lemma": "Arm", "level": "A1", "topic": "health", "pos": "noun", "gender": "der", "plural": "Arme", "conjugation": None, "translation_en": "arm", "translation_ar": "ذراع", "translation_es": "brazo", "frequency_rank": 268},
    {"id": 1269, "lemma": "Bein", "level": "A1", "topic": "health", "pos": "noun", "gender": "das", "plural": "Beine", "conjugation": None, "translation_en": "leg", "translation_ar": "ساق / رجل", "translation_es": "pierna", "frequency_rank": 269},
    {"id": 1270, "lemma": "Fuß", "level": "A1", "topic": "health", "pos": "noun", "gender": "der", "plural": "Füße", "conjugation": None, "translation_en": "foot", "translation_ar": "قدم", "translation_es": "pie", "frequency_rank": 270},
    {"id": 1271, "lemma": "Bauch", "level": "A1", "topic": "health", "pos": "noun", "gender": "der", "plural": "Bäuche", "conjugation": None, "translation_en": "stomach / belly", "translation_ar": "بطن", "translation_es": "barriga / estómago", "frequency_rank": 271},
    {"id": 1272, "lemma": "Rücken", "level": "A1", "topic": "health", "pos": "noun", "gender": "der", "plural": "Rücken", "conjugation": None, "translation_en": "back", "translation_ar": "ظهر", "translation_es": "espalda", "frequency_rank": 272},
    {"id": 1273, "lemma": "Fieber", "level": "A1", "topic": "health", "pos": "noun", "gender": "das", "plural": None, "conjugation": None, "translation_en": "fever", "translation_ar": "حمى / حرارة مرتفعة", "translation_es": "fiebre", "frequency_rank": 273},
    {"id": 1274, "lemma": "Schmerz", "level": "A1", "topic": "health", "pos": "noun", "gender": "der", "plural": "Schmerzen", "conjugation": None, "translation_en": "pain", "translation_ar": "ألم / وجع", "translation_es": "dolor", "frequency_rank": 274},
    {"id": 1275, "lemma": "Medikament", "level": "A1", "topic": "health", "pos": "noun", "gender": "das", "plural": "Medikamente", "conjugation": None, "translation_en": "medication / medicine", "translation_ar": "دواء", "translation_es": "medicamento", "frequency_rank": 275},
    {"id": 1276, "lemma": "Apotheke", "level": "A1", "topic": "health", "pos": "noun", "gender": "die", "plural": "Apotheken", "conjugation": None, "translation_en": "pharmacy", "translation_ar": "صيدلية", "translation_es": "farmacia", "frequency_rank": 276},
    {"id": 1277, "lemma": "Krankenhaus", "level": "A1", "topic": "health", "pos": "noun", "gender": "das", "plural": "Krankenhäuser", "conjugation": None, "translation_en": "hospital", "translation_ar": "مستشفى", "translation_es": "hospital", "frequency_rank": 277},
    {"id": 1278, "lemma": "wehtun", "level": "A1", "topic": "health", "pos": "verb", "gender": None, "plural": None, "conjugation": "tut weh", "translation_en": "to hurt / ache", "translation_ar": "يؤلم", "translation_es": "doler", "frequency_rank": 278},
    {"id": 1279, "lemma": "dürfen", "level": "A1", "topic": "health", "pos": "verb", "gender": None, "plural": None, "conjugation": "darf, darfst, darf, dürfen", "translation_en": "may / to be allowed to", "translation_ar": "يُسمح له / يجوز", "translation_es": "poder / tener permiso", "frequency_rank": 279},
    {"id": 1280, "lemma": "krank", "level": "A1", "topic": "health", "pos": "adjective", "gender": None, "plural": None, "conjugation": None, "translation_en": "sick / ill", "translation_ar": "مريض", "translation_es": "enfermo", "frequency_rank": 280},
    {"id": 1281, "lemma": "gesund", "level": "A1", "topic": "health", "pos": "adjective", "gender": None, "plural": None, "conjugation": None, "translation_en": "healthy", "translation_ar": "صحي / معافى", "translation_es": "sano", "frequency_rank": 281},
    {"id": 1282, "lemma": "müde", "level": "A1", "topic": "health", "pos": "adjective", "gender": None, "plural": None, "conjugation": None, "translation_en": "tired", "translation_ar": "متعب / نعسان", "translation_es": "cansado", "frequency_rank": 282},
    {"id": 1283, "lemma": "Tablette", "level": "A1", "topic": "health", "pos": "noun", "gender": "die", "plural": "Tabletten", "conjugation": None, "translation_en": "tablet / pill", "translation_ar": "حبة دواء", "translation_es": "pastilla", "frequency_rank": 283},
    {"id": 1284, "lemma": "Rezept", "level": "A1", "topic": "health", "pos": "noun", "gender": "das", "plural": "Rezepte", "conjugation": None, "translation_en": "medical prescription", "translation_ar": "وصفة طبية / روشتة", "translation_es": "receta médica", "frequency_rank": 284},
]

existing_w_ids = {w["id"] for w in data["words"]}
for w in unit11_words:
    if w["id"] not in existing_w_ids:
        data["words"].append(w)

# 3. Add Lessons for Unit 11 (11101 - 11106)
unit11_lessons = [
    {
        "id": 11101, "unit_id": 50007, "level": "A1", "title_de": "Der Körper & Schmerzen", "title_en": "Body Parts & Aches",
        "sort_order": 1, "lesson_type": "vocabulary", "pass_threshold": 0.7, "grammar_content": None, "content_json": None
    },
    {
        "id": 11102, "unit_id": 50007, "level": "A1", "title_de": "Beim Arzt & in der Apotheke", "title_en": "At the Doctor & Pharmacy",
        "sort_order": 2, "lesson_type": "vocabulary", "pass_threshold": 0.7, "grammar_content": None, "content_json": None
    },
    {
        "id": 11103, "unit_id": 50007, "level": "A1", "title_de": "Grammatik: Wehtun & Beschwerden äußern", "title_en": "Grammar: Expressing Ailments (wehtun)",
        "sort_order": 3, "lesson_type": "grammar", "pass_threshold": 0.7,
        "grammar_content": "# التعبير عن الأوجاع والأعراض — Wehtun & Schmerzen\n# Expressing Pain and Illness\n\n## 🇩🇪 Deutsch | 🇬🇧 English | 🇸🇦 عربي\n\n### 1. الفعل المنفصل wehtun (يؤلم):\n- مفرد: *Mein Kopf **tut weh**.* (رأسي يؤلمني)\n- مفرد: *Mein Bauch **tut weh**.* (بطني يؤلمني)\n- جمع: *Meine Augen **tun weh**.* (عيناي تؤلماني)\n- جمع: *Meine Ohren **tun weh**.* (أذناي تؤلماني)\n\n### 2. التعبير بكلمة Schmerzen مع اسم العضو:\n- *Ich habe **Kopfschmerzen**.* (عندي صداع / ألم بالرأس)\n- *Ich habe **Bauchschmerzen**.* (عندي مغص / ألم بالبطن)\n- *Ich habe **Halsschmerzen**.* (عندي ألم في الحلق)\n- *Ich habe **Fieber**.* (عندي حمى / حرارة)",
        "content_json": None
    },
    {
        "id": 11104, "unit_id": 50007, "level": "A1", "title_de": "Grammatik: dürfen & man", "title_en": "Grammar: Modal Verb dürfen & Impersonal man",
        "sort_order": 4, "lesson_type": "grammar", "pass_threshold": 0.7,
        "grammar_content": "# الفعل dürfen والضمير غير الشخصي man\n# Modal Verb dürfen & The Impersonal Pronoun man\n\n## 🇩🇪 Deutsch | 🇬🇧 English | 🇸🇦 عربي\n\n### 1. الفعل الناقص dürfen (يُسمح له / يجوز):\n| الضمير | تصريف dürfen | مثال |\n|---|---|---|\n| **ich** | **darf** | Ich darf nach Hause gehen. |\n| **du** | **darfst** | Du darfst keine Cola trinken. |\n| **er / sie / es** | **darf** | Der Patient darf aufstehen. |\n| **wir** | **dürfen** | Dürfen wir hier warten? |\n| **ihr** | **dürft** | Ihr dürft nicht laut sein. |\n| **Sie / sie** | **dürfen** | Sie dürfen das Rezept abholen. |\n\n### 2. الضمير man (المرء / الناس عموماً):\nيُصرَّف الفعل مع **man** مثل ضمير الغائب المفرد (er / sie / es):\n- *Hier **darf man nicht** rauchen.* (هنا لا يجوز التدخين / ممنوع التدخين)\n- *Was **kann man** hier machen?* (ماذا يستطيع المرء أن يفعل هنا؟)",
        "content_json": None
    },
    {
        "id": 11105, "unit_id": 50007, "level": "A1", "title_de": "Gesundheitstipps & Krankmeldungen", "title_en": "Health Advice & Sick Notes",
        "sort_order": 5, "lesson_type": "text", "pass_threshold": 0.7, "grammar_content": None, "content_json": None
    },
    {
        "id": 11106, "unit_id": 50007, "level": "A1", "title_de": "Einheitstest: Körper & Gesundheit", "title_en": "Unit Test: Body & Health",
        "sort_order": 6, "lesson_type": "unit_test", "pass_threshold": 0.75, "grammar_content": None, "content_json": None
    }
]

existing_l_ids = {l["id"] for l in data["lessons"]}
for l in unit11_lessons:
    if l["id"] not in existing_l_ids:
        data["lessons"].append(l)

# 4. Add Exercises for Unit 11 (40901 - 40945)
existing_ex_ids = {e["id"] for e in data["exercises"]}
unit11_exercises = []

# --- LESSON 11101: Der Körper & Schmerzen (7 exercises) ---
unit11_exercises.append({
    "id": 40901, "lesson_id": 11101, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Kopf", "gender": "der", "question_en": "What does 'der Kopf' mean?", "question_ar": "ما معنى \u2066'der Kopf'\u2069؟", "question_es": "¿Qué significa 'der Kopf'?"}, ensure_ascii=False),
    "audio_text": "der Kopf", "correct_answer": "head", "options": json.dumps(["head", "hand", "foot", "eye"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit11_exercises.append({
    "id": 40902, "lesson_id": 11101, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Auge", "gender": "das", "question_en": "What does 'das Auge' mean?", "question_ar": "ما معنى \u2066'das Auge'\u2069؟", "question_es": "¿Qué significa 'das Auge'?"}, ensure_ascii=False),
    "audio_text": "das Auge", "correct_answer": "eye", "options": json.dumps(["eye", "ear", "mouth", "nose"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit11_exercises.append({
    "id": 40903, "lesson_id": 11101, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Mein Kopf tut weh.", "question_en": "Listen and select the complaint.", "question_ar": "استمع واختر العرض الصحي المسموع.", "question_es": "Escucha y selecciona la molestia."}, ensure_ascii=False),
    "audio_text": "Mein Kopf tut weh.", "correct_answer": "Mein Kopf tut weh.", "options": json.dumps(["Mein Kopf tut weh.", "Mein Bauch tut weh.", "Mein Bein tut weh.", "Ich habe Fieber."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit11_exercises.append({
    "id": 40904, "lesson_id": 11101, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Bauch", "gender": "der", "question_en": "What does 'der Bauch' mean?", "question_ar": "ما معنى \u2066'der Bauch'\u2069؟", "question_es": "¿Qué significa 'der Bauch'?"}, ensure_ascii=False),
    "audio_text": "der Bauch", "correct_answer": "stomach / belly", "options": json.dumps(["stomach / belly", "back", "arm", "throat"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit11_exercises.append({
    "id": 40905, "lesson_id": 11101, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Ich habe starke ___ . (Kopfschmerzen)", "question_en": "Fill in 'Kopfschmerzen' (headache).", "question_ar": "املأ الفراغ بكلمة صداع: \u2066'Kopfschmerzen'\u2069.", "question_es": "Rellena con 'Kopfschmerzen'."}, ensure_ascii=False),
    "audio_text": "Ich habe starke Kopfschmerzen.", "correct_answer": "Kopfschmerzen", "options": json.dumps(["Kopfschmerzen", "Bauchschmerzen", "Fieber", "Husten"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit11_exercises.append({
    "id": 40906, "lesson_id": 11101, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Hand", "gender": "die", "question_en": "What does 'die Hand' mean?", "question_ar": "ما معنى \u2066'die Hand'\u2069؟", "question_es": "¿Qué significa 'die Hand'?"}, ensure_ascii=False),
    "audio_text": "die Hand", "correct_answer": "hand", "options": json.dumps(["hand", "foot", "leg", "arm"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit11_exercises.append({
    "id": 40907, "lesson_id": 11101, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Meine Augen tun weh.", "question_en": "Repeat: 'Meine Augen tun weh.'", "question_ar": "ردد: \u2066'Meine Augen tun weh.'\u2069", "question_es": "Repite: 'Meine Augen tun weh.'"}, ensure_ascii=False),
    "audio_text": "Meine Augen tun weh.", "correct_answer": "Meine Augen tun weh.", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 11102: Beim Arzt & in der Apotheke (7 exercises) ---
unit11_exercises.append({
    "id": 40908, "lesson_id": 11102, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Apotheke", "gender": "die", "question_en": "What does 'die Apotheke' mean?", "question_ar": "ما معنى \u2066'die Apotheke'\u2069؟", "question_es": "¿Qué significa 'die Apotheke'?"}, ensure_ascii=False),
    "audio_text": "die Apotheke", "correct_answer": "pharmacy", "options": json.dumps(["pharmacy", "hospital", "doctor's office", "supermarket"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit11_exercises.append({
    "id": 40909, "lesson_id": 11102, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Medikament", "gender": "das", "question_en": "What does 'das Medikament' mean?", "question_ar": "ما معنى \u2066'das Medikament'\u2069؟", "question_es": "¿Qué significa 'das Medikament'?"}, ensure_ascii=False),
    "audio_text": "das Medikament", "correct_answer": "medication / medicine", "options": json.dumps(["medication / medicine", "prescription", "fever", "pain"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit11_exercises.append({
    "id": 40910, "lesson_id": 11102, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Nehmen Sie diese Tabletten dreimal täglich.", "question_en": "Listen to the doctor's dosage instruction.", "question_ar": "استمع لتعليمات الطبيب حول تناول الدواء.", "question_es": "Escucha las indicaciones del médico."}, ensure_ascii=False),
    "audio_text": "Nehmen Sie diese Tabletten dreimal täglich.", "correct_answer": "Nehmen Sie diese Tabletten dreimal täglich.", "options": json.dumps(["Nehmen Sie diese Tabletten dreimal täglich.", "Gehen Sie sofort ins Krankenhaus.", "Sie dürfen keinen Tee trinken.", "Bleiben Sie heute im Büro."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit11_exercises.append({
    "id": 40911, "lesson_id": 11102, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Der Arzt gibt mir ein ___ . (Rezept)", "question_en": "Fill in 'Rezept' (prescription).", "question_ar": "املأ الفراغ بكلمة روشتة طبية: \u2066'Rezept'\u2069.", "question_es": "Rellena con 'Rezept'."}, ensure_ascii=False),
    "audio_text": "Der Arzt gibt mir ein Rezept.", "correct_answer": "Rezept", "options": json.dumps(["Rezept", "Bett", "Geld", "Buch"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit11_exercises.append({
    "id": 40912, "lesson_id": 11102, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Krankenhaus", "gender": "das", "question_en": "What does 'das Krankenhaus' mean?", "question_ar": "ما معنى \u2066'das Krankenhaus'\u2069؟", "question_es": "¿Qué significa 'das Krankenhaus'?"}, ensure_ascii=False),
    "audio_text": "das Krankenhaus", "correct_answer": "hospital", "options": json.dumps(["hospital", "pharmacy", "hotel", "school"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit11_exercises.append({
    "id": 40913, "lesson_id": 11102, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Ich habe 38,5 Grad ___ . (Fieber)", "question_en": "Fill in 'Fieber' (fever).", "question_ar": "املأ الفراغ بكلمة حمى: \u2066'Fieber'\u2069.", "question_es": "Rellena con 'Fieber'."}, ensure_ascii=False),
    "audio_text": "Ich habe 38,5 Grad Fieber.", "correct_answer": "Fieber", "options": json.dumps(["Fieber", "Schmerz", "Rezept", "Husten"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit11_exercises.append({
    "id": 40914, "lesson_id": 11102, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Gute Besserung!", "question_en": "Repeat wish: 'Gute Besserung!' (Get well soon!)", "question_ar": "ردد أمنية الشفاء: \u2066'Gute Besserung!'\u2069 (بالشفاء العاجل!)", "question_es": "Repite: 'Gute Besserung!'"}, ensure_ascii=False),
    "audio_text": "Gute Besserung!", "correct_answer": "Gute Besserung!", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 11103: Grammatik: Wehtun & Beschwerden äußern (7 exercises) ---
unit11_exercises.append({
    "id": 40915, "lesson_id": 11103, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Mein Rücken ___ weh. (tut - Singular)", "question_en": "Fill in singular 'tut' with Rücken.", "question_ar": "صرف الفعل مع المفرد: \u2066'tut'\u2069.", "question_es": "Rellena con 'tut' para singular."}, ensure_ascii=False),
    "audio_text": "Mein Rücken tut weh.", "correct_answer": "tut", "options": json.dumps(["tut", "tun", "macht", "hat"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit11_exercises.append({
    "id": 40916, "lesson_id": 11103, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Meine Beine ___ weh. (tun - Plural)", "question_en": "Fill in plural 'tun' with Beine.", "question_ar": "صرف الفعل مع الجمع: \u2066'tun'\u2069.", "question_es": "Rellena con 'tun' para plural."}, ensure_ascii=False),
    "audio_text": "Meine Beine tun weh.", "correct_answer": "tun", "options": json.dumps(["tun", "tut", "haben", "sind"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit11_exercises.append({
    "id": 40917, "lesson_id": 11103, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Ich fühle mich heute sehr ___ . (krank)", "question_en": "Fill in 'krank' (sick).", "question_ar": "املأ الفراغ بكلمة مريض: \u2066'krank'\u2069.", "question_es": "Rellena con 'krank'."}, ensure_ascii=False),
    "audio_text": "Ich fühle mich heute sehr krank.", "correct_answer": "krank", "options": json.dumps(["krank", "gesund", "fleißig", "alt"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit11_exercises.append({
    "id": 40918, "lesson_id": 11103, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Was fehlt Ihnen denn?", "question_en": "Listen to the doctor's inquiry.", "question_ar": "استمع لسؤال الطبيب عن الشكوى المرضية.", "question_es": "Escucha la pregunta del médico."}, ensure_ascii=False),
    "audio_text": "Was fehlt Ihnen denn?", "correct_answer": "Was fehlt Ihnen denn?", "options": json.dumps(["Was fehlt Ihnen denn?", "Wie viel kostet das?", "Wo arbeiten Sie?", "Wie spät ist es?"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit11_exercises.append({
    "id": 40919, "lesson_id": 11103, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "gesund", "question_en": "What does 'gesund' mean?", "question_ar": "ما معنى \u2066'gesund'\u2069؟", "question_es": "¿Qué significa 'gesund'?"}, ensure_ascii=False),
    "audio_text": "gesund", "correct_answer": "healthy", "options": json.dumps(["healthy", "sick", "tired", "weak"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit11_exercises.append({
    "id": 40920, "lesson_id": 11103, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Der Zahn tut ___ . (weh - wehtun)", "question_en": "Complete separable verb 'wehtun' with 'weh'.", "question_ar": "أكمل الفعل المنفصل بكلمة: \u2066'weh'\u2069.", "question_es": "Completa con 'weh'."}, ensure_ascii=False),
    "audio_text": "Der Zahn tut weh.", "correct_answer": "weh", "options": json.dumps(["weh", "auf", "an", "aus"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit11_exercises.append({
    "id": 40921, "lesson_id": 11103, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Ich habe starke Halsschmerzen.", "question_en": "Repeat: 'Ich habe starke Halsschmerzen.'", "question_ar": "ردد: \u2066'Ich habe starke Halsschmerzen.'\u2069", "question_es": "Repite: 'Ich habe starke Halsschmerzen.'"}, ensure_ascii=False),
    "audio_text": "Ich habe starke Halsschmerzen.", "correct_answer": "Ich habe starke Halsschmerzen.", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 11104: Grammatik: dürfen & man (7 exercises) ---
unit11_exercises.append({
    "id": 40922, "lesson_id": 11104, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Hier ___ man nicht rauchen. (darf - dürfen)", "question_en": "Conjugate modal 'dürfen' for 'man': darf.", "question_ar": "صرف فعل dürfen مع man: \u2066'darf'\u2069.", "question_es": "Conjuga 'dürfen' para 'man': darf."}, ensure_ascii=False),
    "audio_text": "Hier darf man nicht rauchen.", "correct_answer": "darf", "options": json.dumps(["darf", "darfst", "dürfen", "muss"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit11_exercises.append({
    "id": 40923, "lesson_id": 11104, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "___ ich hier parken? (Darf - ich)", "question_en": "Fill in question modal 'Darf'.", "question_ar": "صرف الفعل في بداية السؤال مع ich: \u2066'Darf'\u2069.", "question_es": "Rellena con 'Darf'."}, ensure_ascii=False),
    "audio_text": "Darf ich hier parken?", "correct_answer": "Darf", "options": json.dumps(["Darf", "Darfst", "Dürfen", "Kann"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit11_exercises.append({
    "id": 40924, "lesson_id": 11104, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Im Krankenhaus darf man nicht laut sein.", "question_en": "Listen and select the hospital rule.", "question_ar": "استمع واختر قاعدة المستشفى.", "question_es": "Escucha y selecciona la norma del hospital."}, ensure_ascii=False),
    "audio_text": "Im Krankenhaus darf man nicht laut sein.", "correct_answer": "Im Krankenhaus darf man nicht laut sein.", "options": json.dumps(["Im Krankenhaus darf man nicht laut sein.", "Im Krankenhaus darf man rauchen.", "Im Krankenhaus muss man arbeiten.", "Hier kann man schlafen."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit11_exercises.append({
    "id": 40925, "lesson_id": 11104, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Sie ___ wieder Sport machen. (dürfen - Sie)", "question_en": "Conjugate 'dürfen' for 'Sie': dürfen.", "question_ar": "صرف الفعل مع صيغة الاحترام Sie: \u2066'dürfen'\u2069.", "question_es": "Conjuga 'dürfen' para 'Sie': dürfen."}, ensure_ascii=False),
    "audio_text": "Sie dürfen wieder Sport machen.", "correct_answer": "dürfen", "options": json.dumps(["dürfen", "darf", "darfst", "könnt"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit11_exercises.append({
    "id": 40926, "lesson_id": 11104, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "müde", "question_en": "What does 'müde' mean?", "question_ar": "ما معنى \u2066'müde'\u2069؟", "question_es": "¿Qué significa 'müde'?"}, ensure_ascii=False),
    "audio_text": "müde", "correct_answer": "tired", "options": json.dumps(["tired", "sick", "healthy", "hungry"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit11_exercises.append({
    "id": 40927, "lesson_id": 11104, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Hier ___ man keinen Alkohol trinken. (darf)", "question_en": "Fill in 'darf'.", "question_ar": "املأ الفراغ بفعل المنع مع man: \u2066'darf'\u2069.", "question_es": "Rellena con 'darf'."}, ensure_ascii=False),
    "audio_text": "Hier darf man keinen Alkohol trinken.", "correct_answer": "darf", "options": json.dumps(["darf", "muss", "kann", "will"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit11_exercises.append({
    "id": 40928, "lesson_id": 11104, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Darf ich eine Frage stellen?", "question_en": "Repeat polite question: 'Darf ich eine Frage stellen?'", "question_ar": "ردد بأدب: \u2066'Darf ich eine Frage stellen?'\u2069 (هل يسمح لي بطرح سؤال؟)", "question_es": "Repite: 'Darf ich eine Frage stellen?'"}, ensure_ascii=False),
    "audio_text": "Darf ich eine Frage stellen?", "correct_answer": "Darf ich eine Frage stellen?", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 11105: Gesundheitstipps & Krankmeldungen (7 exercises) ---
unit11_exercises.append({
    "id": 40929, "lesson_id": 11105, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Tablette", "gender": "die", "question_en": "What does 'die Tablette' mean?", "question_ar": "ما معنى \u2066'die Tablette'\u2069؟", "question_es": "¿Qué significa 'die Tablette'?"}, ensure_ascii=False),
    "audio_text": "die Tablette", "correct_answer": "tablet / pill", "options": json.dumps(["tablet / pill", "prescription", "fever", "pain"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit11_exercises.append({
    "id": 40930, "lesson_id": 11105, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Ich kann heute leider nicht zur Arbeit kommen, weil ich krank bin.", "question_en": "Listen to the sick leave call.", "question_ar": "استمع لرسالة الإبلاغ عن المرض والغياب عن العمل.", "question_es": "Escucha el aviso por enfermedad."}, ensure_ascii=False),
    "audio_text": "Ich kann heute leider nicht zur Arbeit kommen, weil ich krank bin.", "correct_answer": "Ich kann heute leider nicht zur Arbeit kommen, weil ich krank bin.", "options": json.dumps(["Ich kann heute leider nicht zur Arbeit kommen, weil ich krank bin.", "Ich komme heute um 8 Uhr zur Arbeit.", "Ich habe heute Urlaub in Berlin.", "Ich gehe heute ins Restaurant."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit11_exercises.append({
    "id": 40931, "lesson_id": 11105, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Bleiben Sie drei Tage im ___ . (Bett)", "question_en": "Fill in 'Bett' (bed).", "question_ar": "املأ الفراغ بنصيحة الراحة في السرير: \u2066'Bett'\u2069.", "question_es": "Rellena con 'Bett'."}, ensure_ascii=False),
    "audio_text": "Bleiben Sie drei Tage im Bett.", "correct_answer": "Bett", "options": json.dumps(["Bett", "Büro", "Haus", "Zimmer"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit11_exercises.append({
    "id": 40932, "lesson_id": 11105, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Schmerz", "gender": "der", "question_en": "What does 'der Schmerz' mean?", "question_ar": "ما معنى \u2066'der Schmerz'\u2069؟", "question_es": "¿Qué significa 'der Schmerz'?"}, ensure_ascii=False),
    "audio_text": "der Schmerz", "correct_answer": "pain", "options": json.dumps(["pain", "fever", "health", "doctor"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit11_exercises.append({
    "id": 40933, "lesson_id": 11105, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Trinken Sie viel Wasser und Tee.", "question_en": "Listen and select the doctor's advice.", "question_ar": "استمع واختر نصيحة الطبيب.", "question_es": "Escucha y selecciona el consejo médico."}, ensure_ascii=False),
    "audio_text": "Trinken Sie viel Wasser und Tee.", "correct_answer": "Trinken Sie viel Wasser und Tee.", "options": json.dumps(["Trinken Sie viel Wasser und Tee.", "Trinken Sie viel Kaffee.", "Essen Sie viel Fleisch.", "Gehen Sie sofort joggen."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit11_exercises.append({
    "id": 40934, "lesson_id": 11105, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Ich schicke Ihnen die Krankmeldung per ___ . (E-Mail)", "question_en": "Fill in 'E-Mail'.", "question_ar": "املأ الفراغ بكلمة الإيميل: \u2066'E-Mail'\u2069.", "question_es": "Rellena con 'E-Mail'."}, ensure_ascii=False),
    "audio_text": "Ich schicke Ihnen die Krankmeldung per E-Mail.", "correct_answer": "E-Mail", "options": json.dumps(["E-Mail", "Brief", "Telefon", "Karte"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit11_exercises.append({
    "id": 40935, "lesson_id": 11105, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Ich muss zum Arzt gehen.", "question_en": "Repeat: 'Ich muss zum Arzt gehen.'", "question_ar": "ردد: \u2066'Ich muss zum Arzt gehen.'\u2069", "question_es": "Repite: 'Ich muss zum Arzt gehen.'"}, ensure_ascii=False),
    "audio_text": "Ich muss zum Arzt gehen.", "correct_answer": "Ich muss zum Arzt gehen.", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 11106: Einheitstest: Körper & Gesundheit (10 exercises) ---
test_pool_11 = [
    ("der Kopf", ["head", "hand", "foot", "eye"], "head", "match_pairs", "What does 'der Kopf' mean?", "ما معنى \u2066'der Kopf'\u2069؟", "¿Qué significa 'der Kopf'?"),
    ("Mein Kopf tut weh.", ["Mein Kopf tut weh.", "Mein Bein tut weh.", "Mein Bauch tut weh.", "Ich bin gesund."], "Mein Kopf tut weh.", "listen_choose", "Listen to the symptom.", "استمع للعرض الصحي.", "Escucha el síntoma."),
    ("Mein Rücken ___ weh.", ["tut", "tun", "macht", "hat"], "tut", "type_fill_blank", "Fill in singular 'tut'.", "صرف فعل يؤلم مع المفرد: \u2066'tut'\u2069.", "Elige 'tut'."),
    ("Meine Beine ___ weh.", ["tun", "tut", "haben", "sind"], "tun", "type_fill_blank", "Fill in plural 'tun'.", "صرف فعل يؤلم مع الجمع: \u2066'tun'\u2069.", "Elige 'tun'."),
    ("Hier ___ man nicht rauchen.", ["darf", "darfst", "dürfen", "muss"], "darf", "type_fill_blank", "Fill in 'darf' for man.", "صرف فعل dürfen مع man: \u2066'darf'\u2069.", "Elige 'darf'."),
    ("die Apotheke", ["pharmacy", "hospital", "supermarket", "school"], "pharmacy", "match_pairs", "What does 'die Apotheke' mean?", "ما معنى \u2066'die Apotheke'\u2069؟", "¿Qué significa 'die Apotheke'?"),
    ("das Medikament", ["medication / medicine", "prescription", "fever", "pain"], "medication / medicine", "match_pairs", "What does 'das Medikament' mean?", "ما معنى \u2066'das Medikament'\u2069؟", "¿Qué significa 'das Medikament'?"),
    ("Gute Besserung!", None, "Gute Besserung!", "repeat_prompt", "Repeat: 'Gute Besserung!'", "ردد: \u2066'Gute Besserung!'\u2069", "Repite: 'Gute Besserung!'"),
    ("Darf ich hier parken?", ["Darf", "Darfst", "Dürfen", "Kann"], "Darf", "type_fill_blank", "Fill in 'Darf'.", "صرف الفعل مع ich: \u2066'Darf'\u2069.", "Elige 'Darf'."),
    ("Ich muss zum Arzt gehen.", None, "Ich muss zum Arzt gehen.", "repeat_prompt", "Repeat: 'Ich muss zum Arzt gehen.'", "ردد: \u2066'Ich muss zum Arzt gehen.'\u2069", "Repite: 'Ich muss zum Arzt gehen.'")
]

for idx, (audio, opts, ans, extype, q_en, q_ar, q_es) in enumerate(test_pool_11, start=1):
    unit11_exercises.append({
        "id": 40935 + idx,
        "lesson_id": 11106,
        "passage_id": None,
        "skill": "listening" if extype == "listen_choose" else ("speaking" if extype == "repeat_prompt" else "reading"),
        "exercise_type": extype,
        "prompt": json.dumps({
            "de": audio,
            "question_en": f"Unit 11 Test ({idx}/10): {q_en}",
            "question_ar": f"اختبار الوحدة 11 ({idx}/10): {q_ar}",
            "question_es": f"Test Unidad 11 ({idx}/10): {q_es}"
        }, ensure_ascii=False),
        "audio_text": audio,
        "correct_answer": ans,
        "options": json.dumps(opts, ensure_ascii=False) if opts else None,
        "is_graded": 1,
        "is_test_pool": 1,
        "sort_order": idx
    })

for ex in unit11_exercises:
    if ex["id"] not in existing_ex_ids:
        data["exercises"].append(ex)
        existing_ex_ids.add(ex["id"])

with open(CONTENT_PATH, "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print(f"Successfully built Unit 11 (Körper & Gesundheit)! Total exercises added: {len(unit11_exercises)}")
