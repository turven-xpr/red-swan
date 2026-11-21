import json
from pathlib import Path

CONTENT_PATH = Path(r"c:\Users\HP\3D Objects\Deutschy-main\Deutschy-main\assets\deutschy_content.json")

with open(CONTENT_PATH, "r", encoding="utf-8") as f:
    data = json.load(f)

# 1. Register Unit 9
if not any(u["id"] == 50005 for u in data["units"]):
    data["units"].append({
        "id": 50005,
        "level": "A1",
        "unit_number": 9,
        "title_de": "Schule & Beruf",
        "title_en": "School & Work",
        "title_ar": "الدراسة والعمل",
        "title_es": "Estudios y profesión",
        "topic_key": "school_work"
    })

# 2. Add Vocabulary for Unit 9 (IDs 1200-1224)
unit9_words = [
    {"id": 1200, "lemma": "Arbeit", "level": "A1", "topic": "school_work", "pos": "noun", "gender": "die", "plural": "Arbeiten", "conjugation": None, "translation_en": "work / job", "translation_ar": "عمل / شغل", "translation_es": "trabajo", "frequency_rank": 200},
    {"id": 1201, "lemma": "Beruf", "level": "A1", "topic": "school_work", "pos": "noun", "gender": "der", "plural": "Berufe", "conjugation": None, "translation_en": "profession / occupation", "translation_ar": "مهنة", "translation_es": "profesión", "frequency_rank": 201},
    {"id": 1202, "lemma": "Arzt", "level": "A1", "topic": "school_work", "pos": "noun", "gender": "der", "plural": "Ärzte", "conjugation": None, "translation_en": "male doctor", "translation_ar": "طبيب", "translation_es": "médico", "frequency_rank": 202},
    {"id": 1203, "lemma": "Ärztin", "level": "A1", "topic": "school_work", "pos": "noun", "gender": "die", "plural": "Ärztinnen", "conjugation": None, "translation_en": "female doctor", "translation_ar": "طبيبة", "translation_es": "médica", "frequency_rank": 203},
    {"id": 1204, "lemma": "Lehrer", "level": "A1", "topic": "school_work", "pos": "noun", "gender": "der", "plural": "Lehrer", "conjugation": None, "translation_en": "male teacher", "translation_ar": "معلم / أستاذ", "translation_es": "profesor", "frequency_rank": 204},
    {"id": 1205, "lemma": "Lehrerin", "level": "A1", "topic": "school_work", "pos": "noun", "gender": "die", "plural": "Lehrerinnen", "conjugation": None, "translation_en": "female teacher", "translation_ar": "معلمة / أستاذة", "translation_es": "profesora", "frequency_rank": 205},
    {"id": 1206, "lemma": "Kollege", "level": "A1", "topic": "school_work", "pos": "noun", "gender": "der", "plural": "Kollegen", "conjugation": None, "translation_en": "male colleague", "translation_ar": "زميل عمل", "translation_es": "colega (m.)", "frequency_rank": 206},
    {"id": 1207, "lemma": "Kollegin", "level": "A1", "topic": "school_work", "pos": "noun", "gender": "die", "plural": "Kolleginnen", "conjugation": None, "translation_en": "female colleague", "translation_ar": "زميلة عمل", "translation_es": "colega (f.)", "frequency_rank": 207},
    {"id": 1208, "lemma": "Büro", "level": "A1", "topic": "school_work", "pos": "noun", "gender": "das", "plural": "Büros", "conjugation": None, "translation_en": "office", "translation_ar": "مكتب", "translation_es": "oficina", "frequency_rank": 208},
    {"id": 1209, "lemma": "Firma", "level": "A1", "topic": "school_work", "pos": "noun", "gender": "die", "plural": "Firmen", "conjugation": None, "translation_en": "company", "translation_ar": "شركة", "translation_es": "empresa", "frequency_rank": 209},
    {"id": 1210, "lemma": "Chef", "level": "A1", "topic": "school_work", "pos": "noun", "gender": "der", "plural": "Chefs", "conjugation": None, "translation_en": "boss", "translation_ar": "رئيس العمل / مدير", "translation_es": "jefe", "frequency_rank": 210},
    {"id": 1211, "lemma": "Pause", "level": "A1", "topic": "school_work", "pos": "noun", "gender": "die", "plural": "Pausen", "conjugation": None, "translation_en": "break / pause", "translation_ar": "استراحة", "translation_es": "pausa / descanso", "frequency_rank": 211},
    {"id": 1212, "lemma": "Schule", "level": "A1", "topic": "school_work", "pos": "noun", "gender": "die", "plural": "Schulen", "conjugation": None, "translation_en": "school", "translation_ar": "مدرسة", "translation_es": "escuela", "frequency_rank": 212},
    {"id": 1213, "lemma": "Universität", "level": "A1", "topic": "school_work", "pos": "noun", "gender": "die", "plural": "Universitäten", "conjugation": None, "translation_en": "university", "translation_ar": "جامعة", "translation_es": "universidad", "frequency_rank": 213},
    {"id": 1214, "lemma": "Stelle", "level": "A1", "topic": "school_work", "pos": "noun", "gender": "die", "plural": "Stellen", "conjugation": None, "translation_en": "job / position", "translation_ar": "وظيفة / منصب", "translation_es": "puesto de trabajo", "frequency_rank": 214},
    {"id": 1215, "lemma": "Praktikum", "level": "A1", "topic": "school_work", "pos": "noun", "gender": "das", "plural": "Praktika", "conjugation": None, "translation_en": "internship", "translation_ar": "تدريب عملي", "translation_es": "prácticas", "frequency_rank": 215},
    {"id": 1216, "lemma": "arbeiten", "level": "A1", "topic": "school_work", "pos": "verb", "gender": None, "plural": None, "conjugation": "arbeitet", "translation_en": "to work", "translation_ar": "يعمل", "translation_es": "trabajar", "frequency_rank": 216},
    {"id": 1217, "lemma": "lernen", "level": "A1", "topic": "school_work", "pos": "verb", "gender": None, "plural": None, "conjugation": "lernt", "translation_en": "to learn / study", "translation_ar": "يتعلم", "translation_es": "aprender", "frequency_rank": 217},
    {"id": 1218, "lemma": "studieren", "level": "A1", "topic": "school_work", "pos": "verb", "gender": None, "plural": None, "conjugation": "studiert", "translation_en": "to study (at university)", "translation_ar": "يدرس بالجامعة", "translation_es": "estudiar en la universidad", "frequency_rank": 218},
    {"id": 1219, "lemma": "suchen", "level": "A1", "topic": "school_work", "pos": "verb", "gender": None, "plural": None, "conjugation": "sucht", "translation_en": "to search / look for", "translation_ar": "يبحث عن", "translation_es": "buscar", "frequency_rank": 219},
    {"id": 1220, "lemma": "finden", "level": "A1", "topic": "school_work", "pos": "verb", "gender": None, "plural": None, "conjugation": "findet", "translation_en": "to find", "translation_ar": "يجد", "translation_es": "encontrar", "frequency_rank": 220},
    {"id": 1221, "lemma": "verdienen", "level": "A1", "topic": "school_work", "pos": "verb", "gender": None, "plural": None, "conjugation": "verdient", "translation_en": "to earn", "translation_ar": "يكسب (مالاً)", "translation_es": "ganar (dinero)", "frequency_rank": 221},
    {"id": 1222, "lemma": "arbeitslos", "level": "A1", "topic": "school_work", "pos": "adjective", "gender": None, "plural": None, "conjugation": None, "translation_en": "unemployed", "translation_ar": "عاطل عن العمل", "translation_es": "desempleado", "frequency_rank": 222},
    {"id": 1223, "lemma": "fleißig", "level": "A1", "topic": "school_work", "pos": "adjective", "gender": None, "plural": None, "conjugation": None, "translation_en": "hardworking", "translation_ar": "مجتهد", "translation_es": "trabajador", "frequency_rank": 223},
    {"id": 1224, "lemma": "wichtig", "level": "A1", "topic": "school_work", "pos": "adjective", "gender": None, "plural": None, "conjugation": None, "translation_en": "important", "translation_ar": "مهم", "translation_es": "importante", "frequency_rank": 224},
]

existing_w_ids = {w["id"] for w in data["words"]}
for w in unit9_words:
    if w["id"] not in existing_w_ids:
        data["words"].append(w)

# 3. Add Lessons for Unit 9 (10901 - 10906)
unit9_lessons = [
    {
        "id": 10901, "unit_id": 50005, "level": "A1", "title_de": "Berufe & Arbeitsorte", "title_en": "Professions & Workplaces",
        "sort_order": 1, "lesson_type": "vocabulary", "pass_threshold": 0.7, "grammar_content": None, "content_json": None
    },
    {
        "id": 10902, "unit_id": 50005, "level": "A1", "title_de": "Schule, Studium & Ausbildung", "title_en": "School, University & Training",
        "sort_order": 2, "lesson_type": "vocabulary", "pass_threshold": 0.7, "grammar_content": None, "content_json": None
    },
    {
        "id": 10903, "unit_id": 50005, "level": "A1", "title_de": "Grammatik: Präteritum von sein & haben (war & hatte)", "title_en": "Grammar: Past of sein & haben (war & hatte)",
        "sort_order": 3, "lesson_type": "grammar", "pass_threshold": 0.7,
        "grammar_content": "# الماضي البسيط لفعل الكينونة والملكية — Präteritum: sein & haben\n# Simple Past of sein and haben in A1\n\n## 🇩🇪 Deutsch | 🇬🇧 English | 🇸🇦 عربي\n\nفي المستوى A1 لا يُطلب منك تصريف جميع الأفعال في الماضي البسيط، بل يقتصر على فعلي **sein** (كان) و **haben** (كان يملك / كان عنده)، وهما الأكثر استخداماً في المحادثة:\nIn A1, the only simple past verbs required are **war** (was) and **hatte** (had):\n\n### 1. تصريف الفعل sein في الماضي (war - كان):\n| الضمير | الماضي البسيط / Präteritum | مثال / Example |\n|---|---|---|\n| **ich** | **war** | Ich war gestern im Büro. (كنت بالأمس في المكتب) |\n| **du** | **warst** | Wo warst du gestern? (أين كنت بالأمس؟) |\n| **er / sie / es** | **war** | Er war sehr müde. (كان متعباً جداً) |\n| **wir** | **waren** | Wir waren in der Schule. (كنا في المدرسة) |\n| **ihr** | **wart** | Wart ihr zu Hause? (هل كنتم في المنزل؟) |\n| **Sie / sie** | **waren** | Sie waren im Urlaub. (كانوا في عطلة) |\n\n---\n\n### 2. تصريف الفعل haben في الماضي (hatte - كان عنده / ملك):\n- *ich **hatte** gestern keine Zeit.* (لم يكن لدي وقت بالأمس)\n- *du **hattest** einen Termin.* (كان لديك موعد)\n- *er **hatte** viel Arbeit.* (كان لديه عمل كثير)\n- *wir **hatten** eine Pause.* (كانت لدينا استراحة)",
        "content_json": None
    },
    {
        "id": 10904, "unit_id": 50005, "level": "A1", "title_de": "Über den Beruf sprechen: als & bei", "title_en": "Talking About Your Job: als & bei",
        "sort_order": 4, "lesson_type": "grammar", "pass_threshold": 0.7,
        "grammar_content": "# التحدث عن المهنة والشركة — Präpositionen: als & bei\n# Prepositions for Profession and Company\n\n## 🇩🇪 Deutsch | 🇬🇧 English | 🇸🇦 عربي\n\nعند الحديث عن مهنتك ومكان عملك في مقابلات التعارف وامتحان A1 Sprechen Teil 1:\n\n### 1. استخدام als مع المسمى الوظيفي:\n- *Ich arbeite **als** Arzt.* (أعمل كطبيب)\n- *Sie arbeitet **als** Lehrerin.* (تعمل كمعلمة)\n\n### 2. استخدام bei مع الشركة أو صاحب العمل:\n- *Ich arbeite **bei** Siemens.* (أعمل لدى شركة سيمنز)\n- *Er macht ein Praktikum **bei** BMW.* (يجري تدريباً عملياً لدى بي إم دبليو)\n\n### 3. السؤال عن المهنة:\n- *Was sind Sie von Beruf?* (ما مهنة حضرتك؟)\n- *Was machst du beruflich?* (ماذا تعمل في مهنتك؟)",
        "content_json": None
    },
    {
        "id": 10905, "unit_id": 50005, "level": "A1", "title_de": "Stellenanzeigen & Arbeitsalltag", "title_en": "Job Advertisements & Daily Work",
        "sort_order": 5, "lesson_type": "text", "pass_threshold": 0.7, "grammar_content": None, "content_json": None
    },
    {
        "id": 10906, "unit_id": 50005, "level": "A1", "title_de": "Einheitstest: Schule & Beruf", "title_en": "Unit Test: School & Work",
        "sort_order": 6, "lesson_type": "unit_test", "pass_threshold": 0.75, "grammar_content": None, "content_json": None
    }
]

existing_l_ids = {l["id"] for l in data["lessons"]}
for l in unit9_lessons:
    if l["id"] not in existing_l_ids:
        data["lessons"].append(l)

# 4. Add Exercises for Unit 9 (40701 - 40745)
existing_ex_ids = {e["id"] for e in data["exercises"]}
unit9_exercises = []

# --- LESSON 10901: Berufe & Arbeitsorte (7 exercises) ---
unit9_exercises.append({
    "id": 40701, "lesson_id": 10901, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Arzt", "gender": "der", "question_en": "What does 'der Arzt' mean?", "question_ar": "ما معنى \u2066'der Arzt'\u2069؟", "question_es": "¿Qué significa 'der Arzt'?"}, ensure_ascii=False),
    "audio_text": "der Arzt", "correct_answer": "male doctor", "options": json.dumps(["male doctor", "male teacher", "male colleague", "boss"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit9_exercises.append({
    "id": 40702, "lesson_id": 10901, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Lehrerin", "gender": "die", "question_en": "What does 'die Lehrerin' mean?", "question_ar": "ما معنى \u2066'die Lehrerin'\u2069؟", "question_es": "¿Qué significa 'die Lehrerin'?"}, ensure_ascii=False),
    "audio_text": "die Lehrerin", "correct_answer": "female teacher", "options": json.dumps(["female teacher", "female doctor", "female colleague", "student"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit9_exercises.append({
    "id": 40703, "lesson_id": 10901, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Ich arbeite in einem Büro.", "question_en": "Listen and select the workplace.", "question_ar": "استمع واختر مكان العمل.", "question_es": "Escucha y selecciona el lugar de trabajo."}, ensure_ascii=False),
    "audio_text": "Ich arbeite in einem Büro.", "correct_answer": "Ich arbeite in einem Büro.", "options": json.dumps(["Ich arbeite in einem Büro.", "Ich arbeite in einer Schule.", "Ich lerne in der Universität.", "Ich bin zu Hause."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit9_exercises.append({
    "id": 40704, "lesson_id": 10901, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Firma", "gender": "die", "question_en": "What does 'die Firma' mean?", "question_ar": "ما معنى \u2066'die Firma'\u2069؟", "question_es": "¿Qué significa 'die Firma'?"}, ensure_ascii=False),
    "audio_text": "die Firma", "correct_answer": "company", "options": json.dumps(["company", "office", "school", "hospital"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit9_exercises.append({
    "id": 40705, "lesson_id": 10901, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Mein Kollege ist sehr ___ . (fleißig)", "question_en": "Fill in 'fleißig' (hardworking).", "question_ar": "املأ الفراغ بكلمة مجتهد: \u2066'fleißig'\u2069.", "question_es": "Rellena con 'fleißig'."}, ensure_ascii=False),
    "audio_text": "Mein Kollege ist sehr fleißig.", "correct_answer": "fleißig", "options": json.dumps(["fleißig", "müde", "krank", "alt"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit9_exercises.append({
    "id": 40706, "lesson_id": 10901, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Chef", "gender": "der", "question_en": "What does 'der Chef' mean?", "question_ar": "ما معنى \u2066'der Chef'\u2069؟", "question_es": "¿Qué significa 'der Chef'?"}, ensure_ascii=False),
    "audio_text": "der Chef", "correct_answer": "boss", "options": json.dumps(["boss", "doctor", "colleague", "teacher"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit9_exercises.append({
    "id": 40707, "lesson_id": 10901, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Was sind Sie von Beruf?", "question_en": "Repeat formal profession question: 'Was sind Sie von Beruf?'", "question_ar": "ردد سؤال المهنة الرسمي: \u2066'Was sind Sie von Beruf?'\u2069", "question_es": "Repite: 'Was sind Sie von Beruf?'"}, ensure_ascii=False),
    "audio_text": "Was sind Sie von Beruf?", "correct_answer": "Was sind Sie von Beruf?", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 10902: Schule, Studium & Ausbildung (7 exercises) ---
unit9_exercises.append({
    "id": 40708, "lesson_id": 10902, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Schule", "gender": "die", "question_en": "What does 'die Schule' mean?", "question_ar": "ما معنى \u2066'die Schule'\u2069؟", "question_es": "¿Qué significa 'die Schule'?"}, ensure_ascii=False),
    "audio_text": "die Schule", "correct_answer": "school", "options": json.dumps(["school", "university", "office", "company"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit9_exercises.append({
    "id": 40709, "lesson_id": 10902, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Universität", "gender": "die", "question_en": "What does 'die Universität' mean?", "question_ar": "ما معنى \u2066'die Universität'\u2069؟", "question_es": "¿Qué significa 'die Universität'?"}, ensure_ascii=False),
    "audio_text": "die Universität", "correct_answer": "university", "options": json.dumps(["university", "school", "internship", "office"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit9_exercises.append({
    "id": 40710, "lesson_id": 10902, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Ich ___ an der Universität Informatik. (studieren - ich studiere)", "question_en": "Conjugate 'studieren' for 'ich': studiere.", "question_ar": "صرف الفعل \u2066studieren\u2069 مع \u2066ich\u2069: \u2066'studiere'\u2069.", "question_es": "Conjuga 'studieren' para 'ich': studiere."}, ensure_ascii=False),
    "audio_text": "Ich studiere an der Universität Informatik.", "correct_answer": "studiere", "options": json.dumps(["studiere", "lerne", "arbeite", "mache"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit9_exercises.append({
    "id": 40711, "lesson_id": 10902, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Die Kinder gehen in die Schule.", "question_en": "Listen and select where the children are going.", "question_ar": "استمع واختر إلى أين يذهب الأطفال.", "question_es": "Escucha y selecciona adónde van los niños."}, ensure_ascii=False),
    "audio_text": "Die Kinder gehen in die Schule.", "correct_answer": "Die Kinder gehen in die Schule.", "options": json.dumps(["Die Kinder gehen in die Schule.", "Die Kinder spielen im Garten.", "Die Kinder schlafen zu Hause.", "Die Kinder sind im Büro."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit9_exercises.append({
    "id": 40712, "lesson_id": 10902, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Praktikum", "gender": "das", "question_en": "What does 'das Praktikum' mean?", "question_ar": "ما معنى \u2066'das Praktikum'\u2069؟", "question_es": "¿Qué significa 'das Praktikum'?"}, ensure_ascii=False),
    "audio_text": "das Praktikum", "correct_answer": "internship", "options": json.dumps(["internship", "study", "exam", "vacation"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit9_exercises.append({
    "id": 40713, "lesson_id": 10902, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Wir machen eine ___ . (Pause)", "question_en": "Fill in 'Pause' (break).", "question_ar": "املأ الفراغ بكلمة استراحة: \u2066'Pause'\u2069.", "question_es": "Rellena con 'Pause'."}, ensure_ascii=False),
    "audio_text": "Wir machen eine Pause.", "correct_answer": "Pause", "options": json.dumps(["Pause", "Arbeit", "Schule", "Stelle"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit9_exercises.append({
    "id": 40714, "lesson_id": 10902, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Ich mache ein Praktikum in Deutschland.", "question_en": "Repeat: 'Ich mache ein Praktikum in Deutschland.'", "question_ar": "ردد: \u2066'Ich mache ein Praktikum in Deutschland.'\u2069", "question_es": "Repite: 'Ich mache ein Praktikum in Deutschland.'"}, ensure_ascii=False),
    "audio_text": "Ich mache ein Praktikum in Deutschland.", "correct_answer": "Ich mache ein Praktikum in Deutschland.", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 10903: Grammatik: Präteritum von sein & haben (7 exercises) ---
unit9_exercises.append({
    "id": 40715, "lesson_id": 10903, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Ich ___ gestern nicht im Büro. (sein - ich war)", "question_en": "Fill in past of sein for ich: 'war'.", "question_ar": "صرف فعل الكينونة في الماضي مع ich: \u2066'war'\u2069.", "question_es": "Rellena con el pasado de sein: 'war'."}, ensure_ascii=False),
    "audio_text": "Ich war gestern nicht im Büro.", "correct_answer": "war", "options": json.dumps(["war", "warst", "waren", "bin"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit9_exercises.append({
    "id": 40716, "lesson_id": 10903, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Wo ___ du gestern Abend? (sein - du warst)", "question_en": "Fill in past of sein for du: 'warst'.", "question_ar": "صرف فعل الكينونة في الماضي مع du: \u2066'warst'\u2069.", "question_es": "Rellena con 'warst'."}, ensure_ascii=False),
    "audio_text": "Wo warst du gestern Abend?", "correct_answer": "warst", "options": json.dumps(["warst", "war", "wart", "bist"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit9_exercises.append({
    "id": 40717, "lesson_id": 10903, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Ich ___ gestern keine Zeit. (haben - ich hatte)", "question_en": "Fill in past of haben for ich: 'hatte'.", "question_ar": "صرف فعل الملكية في الماضي مع ich: \u2066'hatte'\u2069.", "question_es": "Rellena con 'hatte'."}, ensure_ascii=False),
    "audio_text": "Ich hatte gestern keine Zeit.", "correct_answer": "hatte", "options": json.dumps(["hatte", "hattest", "hatten", "habe"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit9_exercises.append({
    "id": 40718, "lesson_id": 10903, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Wir waren gestern in Berlin.", "question_en": "Listen and select where they were yesterday.", "question_ar": "استمع واختر أين كانوا بالأمس.", "question_es": "Escucha y selecciona dónde estuvieron ayer."}, ensure_ascii=False),
    "audio_text": "Wir waren gestern in Berlin.", "correct_answer": "Wir waren gestern in Berlin.", "options": json.dumps(["Wir waren gestern in Berlin.", "Wir sind heute in Berlin.", "Wir waren gestern im Büro.", "Wir hatten viel Zeit."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit9_exercises.append({
    "id": 40719, "lesson_id": 10903, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Er ___ gestern viel Arbeit. (haben - er hatte)", "question_en": "Fill in 'hatte' for er.", "question_ar": "صرف الفعل الماضي مع er: \u2066'hatte'\u2069.", "question_es": "Rellena con 'hatte' para er."}, ensure_ascii=False),
    "audio_text": "Er hatte gestern viel Arbeit.", "correct_answer": "hatte", "options": json.dumps(["hatte", "hattest", "waren", "hat"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit9_exercises.append({
    "id": 40720, "lesson_id": 10903, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "arbeitslos", "question_en": "What does 'arbeitslos' mean?", "question_ar": "ما معنى \u2066'arbeitslos'\u2069؟", "question_es": "¿Qué significa 'arbeitslos'?"}, ensure_ascii=False),
    "audio_text": "arbeitslos", "correct_answer": "unemployed", "options": json.dumps(["unemployed", "hardworking", "employed", "student"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit9_exercises.append({
    "id": 40721, "lesson_id": 10903, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Gestern hatte ich frei.", "question_en": "Repeat: 'Gestern hatte ich frei.'", "question_ar": "ردد: \u2066'Gestern hatte ich frei.'\u2069", "question_es": "Repite: 'Gestern hatte ich frei.'"}, ensure_ascii=False),
    "audio_text": "Gestern hatte ich frei.", "correct_answer": "Gestern hatte ich frei.", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 10904: Über den Beruf sprechen: als & bei (7 exercises) ---
unit9_exercises.append({
    "id": 40722, "lesson_id": 10904, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Ich arbeite ___ Arzt. (als - Beruf)", "question_en": "Fill in preposition 'als' for profession.", "question_ar": "اختر حرف الجر مع المسمى الوظيفي: \u2066'als'\u2069.", "question_es": "Rellena con 'als' para la profesión."}, ensure_ascii=False),
    "audio_text": "Ich arbeite als Arzt.", "correct_answer": "als", "options": json.dumps(["als", "bei", "in", "mit"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit9_exercises.append({
    "id": 40723, "lesson_id": 10904, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Er arbeitet ___ Siemens. (bei - Firma)", "question_en": "Fill in preposition 'bei' for company.", "question_ar": "اختر حرف الجر مع اسم الشركة: \u2066'bei'\u2069.", "question_es": "Rellena con 'bei' para la empresa."}, ensure_ascii=False),
    "audio_text": "Er arbeitet bei Siemens.", "correct_answer": "bei", "options": json.dumps(["bei", "als", "zu", "an"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit9_exercises.append({
    "id": 40724, "lesson_id": 10904, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Sie arbeitet als Lehrerin in Köln.", "question_en": "Listen and select her profession and city.", "question_ar": "استمع واختر مهنتها ومدينتها.", "question_es": "Escucha y selecciona su profesión y ciudad."}, ensure_ascii=False),
    "audio_text": "Sie arbeitet als Lehrerin in Köln.", "correct_answer": "Sie arbeitet als Lehrerin in Köln.", "options": json.dumps(["Sie arbeitet als Lehrerin in Köln.", "Sie arbeitet als Ärztin in Berlin.", "Sie studiert in München.", "Sie ist arbeitslos in Hamburg."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit9_exercises.append({
    "id": 40725, "lesson_id": 10904, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "verdienen", "question_en": "What does verb 'verdienen' mean?", "question_ar": "ما معنى الفعل \u2066'verdienen'\u2069؟", "question_es": "¿Qué significa 'verdienen'?"}, ensure_ascii=False),
    "audio_text": "verdienen", "correct_answer": "to earn", "options": json.dumps(["to earn", "to buy", "to find", "to search"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit9_exercises.append({
    "id": 40726, "lesson_id": 10904, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Was machst du ___ ? (beruflich)", "question_en": "Fill in 'beruflich' for profession question.", "question_ar": "املأ الفراغ بكلمة مهنياً: \u2066'beruflich'\u2069.", "question_es": "Rellena con 'beruflich'."}, ensure_ascii=False),
    "audio_text": "Was machst du beruflich?", "correct_answer": "beruflich", "options": json.dumps(["beruflich", "heute", "gern", "neu"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit9_exercises.append({
    "id": 40727, "lesson_id": 10904, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "wichtig", "question_en": "What does 'wichtig' mean?", "question_ar": "ما معنى \u2066'wichtig'\u2069؟", "question_es": "¿Qué significa 'wichtig'?"}, ensure_ascii=False),
    "audio_text": "wichtig", "correct_answer": "important", "options": json.dumps(["important", "difficult", "easy", "correct"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit9_exercises.append({
    "id": 40728, "lesson_id": 10904, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Ich suche eine neue Stelle.", "question_en": "Repeat: 'Ich suche eine neue Stelle.'", "question_ar": "ردد: \u2066'Ich suche eine neue Stelle.'\u2069", "question_es": "Repite: 'Ich suche eine neue Stelle.'"}, ensure_ascii=False),
    "audio_text": "Ich suche eine neue Stelle.", "correct_answer": "Ich suche eine neue Stelle.", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 10905: Stellenanzeigen & Arbeitsalltag (7 exercises) ---
unit9_exercises.append({
    "id": 40729, "lesson_id": 10905, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Stelle", "gender": "die", "question_en": "What does 'die Stelle' mean in job ads?", "question_ar": "ما معنى \u2066'die Stelle'\u2069 في إعلانات التوظيف؟", "question_es": "¿Qué significa 'die Stelle'?"}, ensure_ascii=False),
    "audio_text": "die Stelle", "correct_answer": "job / position", "options": json.dumps(["job / position", "office", "break", "colleague"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit9_exercises.append({
    "id": 40730, "lesson_id": 10905, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Wir suchen ab sofort einen Verkäufer.", "question_en": "Listen to the job opening announcement.", "question_ar": "استمع لإعلان الوظيفة الشاغرة.", "question_es": "Escucha el anuncio de empleo."}, ensure_ascii=False),
    "audio_text": "Wir suchen ab sofort einen Verkäufer.", "correct_answer": "Wir suchen ab sofort einen Verkäufer.", "options": json.dumps(["Wir suchen ab sofort einen Verkäufer.", "Wir brauchen einen Arzt.", "Wir haben keine Arbeit.", "Die Stelle ist besetzt."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit9_exercises.append({
    "id": 40731, "lesson_id": 10905, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Ich habe die Stelle ___ . (gefunden - finden)", "question_en": "Fill in 'gefunden'.", "question_ar": "املأ الفراغ بكلمة وجدتُ: \u2066'gefunden'\u2069.", "question_es": "Rellena con 'gefunden'."}, ensure_ascii=False),
    "audio_text": "Ich habe die Stelle gefunden.", "correct_answer": "gefunden", "options": json.dumps(["gefunden", "gesucht", "gemacht", "gehabt"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit9_exercises.append({
    "id": 40732, "lesson_id": 10905, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Pause", "gender": "die", "question_en": "What does 'die Pause' mean?", "question_ar": "ما معنى \u2066'die Pause'\u2069؟", "question_es": "¿Qué significa 'die Pause'?"}, ensure_ascii=False),
    "audio_text": "die Pause", "correct_answer": "break / pause", "options": json.dumps(["break / pause", "working hours", "salary", "contract"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit9_exercises.append({
    "id": 40733, "lesson_id": 10905, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Die Arbeitszeit ist von 8 bis 17 Uhr.", "question_en": "Listen and select the working hours.", "question_ar": "استمع واختر ساعات العمل.", "question_es": "Escucha y selecciona el horario de trabajo."}, ensure_ascii=False),
    "audio_text": "Die Arbeitszeit ist von 8 bis 17 Uhr.", "correct_answer": "Die Arbeitszeit ist von 8 bis 17 Uhr.", "options": json.dumps(["Die Arbeitszeit ist von 8 bis 17 Uhr.", "Die Arbeitszeit ist von 9 bis 18 Uhr.", "Die Pause ist um 12 Uhr.", "Wir arbeiten nur am Wochenende."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit9_exercises.append({
    "id": 40734, "lesson_id": 10905, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Die Arbeit beginnt ___ 8 Uhr. (um)", "question_en": "Fill in preposition 'um'.", "question_ar": "املأ الفراغ بحرف الجر الزمني: \u2066'um'\u2069.", "question_es": "Rellena con 'um'."}, ensure_ascii=False),
    "audio_text": "Die Arbeit beginnt um 8 Uhr.", "correct_answer": "um", "options": json.dumps(["um", "am", "im", "an"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit9_exercises.append({
    "id": 40735, "lesson_id": 10905, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Meine Kollegen sind sehr nett.", "question_en": "Repeat: 'Meine Kollegen sind sehr nett.'", "question_ar": "ردد: \u2066'Meine Kollegen sind sehr nett.'\u2069", "question_es": "Repite: 'Meine Kollegen sind sehr nett.'"}, ensure_ascii=False),
    "audio_text": "Meine Kollegen sind sehr nett.", "correct_answer": "Meine Kollegen sind sehr nett.", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 10906: Einheitstest: Schule & Beruf (10 exercises) ---
test_pool_9 = [
    ("der Arzt", ["male doctor", "male teacher", "boss", "student"], "male doctor", "match_pairs", "What does 'der Arzt' mean?", "ما معنى \u2066'der Arzt'\u2069؟", "¿Qué significa 'der Arzt'?"),
    ("Ich arbeite in einem Büro.", ["Ich arbeite in einem Büro.", "Ich lerne in der Schule.", "Ich bin zu Hause.", "Ich fahre nach Berlin."], "Ich arbeite in einem Büro.", "listen_choose", "Listen to where they work.", "استمع لمكان العمل.", "Escucha dónde trabajan."),
    ("Ich ___ gestern nicht im Büro.", ["war", "warst", "waren", "bin"], "war", "type_fill_blank", "Fill in past 'war'.", "املأ الفراغ بفعل الماضي: \u2066'war'\u2069.", "Rellena con 'war'."),
    ("Ich hatte gestern keine Zeit.", ["hatte", "hattest", "hatten", "habe"], "hatte", "type_fill_blank", "Fill in past 'hatte'.", "املأ الفراغ بفعل الماضي: \u2066'hatte'\u2069.", "Rellena con 'hatte'."),
    ("Ich arbeite ___ Arzt.", ["als", "bei", "in", "mit"], "als", "type_fill_blank", "Fill in 'als' for profession.", "اختر حرف الجر مع المهنة: \u2066'als'\u2069.", "Elige 'als'."),
    ("Er arbeitet ___ Siemens.", ["bei", "als", "in", "zu"], "bei", "type_fill_blank", "Fill in 'bei' for company.", "اختر حرف الجر مع الشركة: \u2066'bei'\u2069.", "Elige 'bei'."),
    ("die Schule", ["school", "university", "office", "company"], "school", "match_pairs", "What does 'die Schule' mean?", "ما معنى \u2066'die Schule'\u2069؟", "¿Qué significa 'die Schule'?"),
    ("Wir waren gestern in Berlin.", ["Wir waren gestern in Berlin.", "Wir sind heute in Berlin.", "Wir arbeiten in Berlin.", "Wir bleiben zu Hause."], "Wir waren gestern in Berlin.", "listen_choose", "Listen to where they were.", "استمع لأين كانوا بالأمس.", "Escucha dónde estuvieron."),
    ("Meine Kollegen sind sehr nett.", None, "Meine Kollegen sind sehr nett.", "repeat_prompt", "Repeat: 'Meine Kollegen sind sehr nett.'", "ردد: \u2066'Meine Kollegen sind sehr nett.'\u2069", "Repite: 'Meine Kollegen sind sehr nett.'"),
    ("Was sind Sie von Beruf?", None, "Was sind Sie von Beruf?", "repeat_prompt", "Repeat: 'Was sind Sie von Beruf?'", "ردد: \u2066'Was sind Sie von Beruf?'\u2069", "Repite: 'Was sind Sie von Beruf?'")
]

for idx, (audio, opts, ans, extype, q_en, q_ar, q_es) in enumerate(test_pool_9, start=1):
    unit9_exercises.append({
        "id": 40735 + idx,
        "lesson_id": 10906,
        "passage_id": None,
        "skill": "listening" if extype == "listen_choose" else ("speaking" if extype == "repeat_prompt" else "reading"),
        "exercise_type": extype,
        "prompt": json.dumps({
            "de": audio,
            "question_en": f"Unit 9 Test ({idx}/10): {q_en}",
            "question_ar": f"اختبار الوحدة 9 ({idx}/10): {q_ar}",
            "question_es": f"Test Unidad 9 ({idx}/10): {q_es}"
        }, ensure_ascii=False),
        "audio_text": audio,
        "correct_answer": ans,
        "options": json.dumps(opts, ensure_ascii=False) if opts else None,
        "is_graded": 1,
        "is_test_pool": 1,
        "sort_order": idx
    })

for ex in unit9_exercises:
    if ex["id"] not in existing_ex_ids:
        data["exercises"].append(ex)
        existing_ex_ids.add(ex["id"])

with open(CONTENT_PATH, "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print(f"Successfully built Unit 9 (Schule & Beruf)! Total exercises added: {len(unit9_exercises)}")
