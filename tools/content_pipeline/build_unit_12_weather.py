import json
from pathlib import Path

CONTENT_PATH = Path(r"c:\Users\HP\3D Objects\Deutschy-main\Deutschy-main\assets\deutschy_content.json")

with open(CONTENT_PATH, "r", encoding="utf-8") as f:
    data = json.load(f)

# 1. Register Unit 12
if not any(u["id"] == 50008 for u in data["units"]):
    data["units"].append({
        "id": 50008,
        "level": "A1",
        "unit_number": 12,
        "title_de": "Wetter & Jahreszeiten",
        "title_en": "Weather & Seasons",
        "title_ar": "الطقس وفصول السنة",
        "title_es": "Clima y estaciones del año",
        "topic_key": "weather"
    })

# 2. Add Vocabulary for Unit 12 (IDs 1290-1314)
unit12_words = [
    {"id": 1290, "lemma": "Wetter", "level": "A1", "topic": "weather", "pos": "noun", "gender": "das", "plural": None, "conjugation": None, "translation_en": "weather", "translation_ar": "طقس / جو", "translation_es": "tiempo / clima", "frequency_rank": 290},
    {"id": 1291, "lemma": "Sonne", "level": "A1", "topic": "weather", "pos": "noun", "gender": "die", "plural": None, "conjugation": None, "translation_en": "sun", "translation_ar": "شمس", "translation_es": "sol", "frequency_rank": 291},
    {"id": 1292, "lemma": "Regen", "level": "A1", "topic": "weather", "pos": "noun", "gender": "der", "plural": None, "conjugation": None, "translation_en": "rain", "translation_ar": "مطر", "translation_es": "lluvia", "frequency_rank": 292},
    {"id": 1293, "lemma": "Schnee", "level": "A1", "topic": "weather", "pos": "noun", "gender": "der", "plural": None, "conjugation": None, "translation_en": "snow", "translation_ar": "ثلج", "translation_es": "nieve", "frequency_rank": 293},
    {"id": 1294, "lemma": "Wind", "level": "A1", "topic": "weather", "pos": "noun", "gender": "der", "plural": None, "conjugation": None, "translation_en": "wind", "translation_ar": "رياح / هواء", "translation_es": "viento", "frequency_rank": 294},
    {"id": 1295, "lemma": "Wolke", "level": "A1", "topic": "weather", "pos": "noun", "gender": "die", "plural": "Wolken", "conjugation": None, "translation_en": "cloud", "translation_ar": "سحابة / غيمة", "translation_es": "nube", "frequency_rank": 295},
    {"id": 1296, "lemma": "Grad", "level": "A1", "topic": "weather", "pos": "noun", "gender": "das", "plural": "Grad", "conjugation": None, "translation_en": "degree", "translation_ar": "درجة (حرارة)", "translation_es": "grado", "frequency_rank": 296},
    {"id": 1297, "lemma": "Frühling", "level": "A1", "topic": "weather", "pos": "noun", "gender": "der", "plural": None, "conjugation": None, "translation_en": "spring", "translation_ar": "الربيع", "translation_es": "primavera", "frequency_rank": 297},
    {"id": 1298, "lemma": "Sommer", "level": "A1", "topic": "weather", "pos": "noun", "gender": "der", "plural": None, "conjugation": None, "translation_en": "summer", "translation_ar": "الصيف", "translation_es": "verano", "frequency_rank": 298},
    {"id": 1299, "lemma": "Herbst", "level": "A1", "topic": "weather", "pos": "noun", "gender": "der", "plural": None, "conjugation": None, "translation_en": "autumn / fall", "translation_ar": "الخريف", "translation_es": "otoño", "frequency_rank": 299},
    {"id": 1300, "lemma": "Winter", "level": "A1", "topic": "weather", "pos": "noun", "gender": "der", "plural": None, "conjugation": None, "translation_en": "winter", "translation_ar": "الشتاء", "translation_es": "invierno", "frequency_rank": 300},
    {"id": 1301, "lemma": "Himmel", "level": "A1", "topic": "weather", "pos": "noun", "gender": "der", "plural": None, "conjugation": None, "translation_en": "sky", "translation_ar": "سماء", "translation_es": "cielo", "frequency_rank": 301},
    {"id": 1302, "lemma": "Regenschirm", "level": "A1", "topic": "weather", "pos": "noun", "gender": "der", "plural": "Regenschirme", "conjugation": None, "translation_en": "umbrella", "translation_ar": "مظلة مطر", "translation_es": "paraguas", "frequency_rank": 302},
    {"id": 1303, "lemma": "regnen", "level": "A1", "topic": "weather", "pos": "verb", "gender": None, "plural": None, "conjugation": "regnet", "translation_en": "to rain", "translation_ar": "تمطر", "translation_es": "llover", "frequency_rank": 303},
    {"id": 1304, "lemma": "schneien", "level": "A1", "topic": "weather", "pos": "verb", "gender": None, "plural": None, "conjugation": "schneit", "translation_en": "to snow", "translation_ar": "تثلج", "translation_es": "nevar", "frequency_rank": 304},
    {"id": 1305, "lemma": "scheinen", "level": "A1", "topic": "weather", "pos": "verb", "gender": None, "plural": None, "conjugation": "scheint", "translation_en": "to shine", "translation_ar": "تشرق / يسطع", "translation_es": "brillar", "frequency_rank": 305},
    {"id": 1306, "lemma": "warm", "level": "A1", "topic": "weather", "pos": "adjective", "gender": None, "plural": None, "conjugation": None, "translation_en": "warm", "translation_ar": "دافئ", "translation_es": "cálido", "frequency_rank": 306},
    {"id": 1307, "lemma": "kalt", "level": "A1", "topic": "weather", "pos": "adjective", "gender": None, "plural": None, "conjugation": None, "translation_en": "cold", "translation_ar": "بارد", "translation_es": "frío", "frequency_rank": 307},
    {"id": 1308, "lemma": "heiß", "level": "A1", "topic": "weather", "pos": "adjective", "gender": None, "plural": None, "conjugation": None, "translation_en": "hot", "translation_ar": "حار / ساخن", "translation_es": "caluroso", "frequency_rank": 308},
    {"id": 1309, "lemma": "sonnig", "level": "A1", "topic": "weather", "pos": "adjective", "gender": None, "plural": None, "conjugation": None, "translation_en": "sunny", "translation_ar": "مشمس", "translation_es": "soleado", "frequency_rank": 309},
    {"id": 1310, "lemma": "windig", "level": "A1", "topic": "weather", "pos": "adjective", "gender": None, "plural": None, "conjugation": None, "translation_en": "windy", "translation_ar": "عاصف / ذو رياح", "translation_es": "ventoso", "frequency_rank": 310},
    {"id": 1311, "lemma": "bewölkt", "level": "A1", "topic": "weather", "pos": "adjective", "gender": None, "plural": None, "conjugation": None, "translation_en": "cloudy", "translation_ar": "غائم", "translation_es": "nublado", "frequency_rank": 311},
    {"id": 1312, "lemma": "schön", "level": "A1", "topic": "weather", "pos": "adjective", "gender": None, "plural": None, "conjugation": None, "translation_en": "beautiful / nice", "translation_ar": "جميل / لطيف", "translation_es": "bonito / bueno", "frequency_rank": 312},
    {"id": 1313, "lemma": "schlecht", "level": "A1", "topic": "weather", "pos": "adjective", "gender": None, "plural": None, "conjugation": None, "translation_en": "bad", "translation_ar": "سيء / رديء", "translation_es": "malo", "frequency_rank": 313},
    {"id": 1314, "lemma": "Jahreszeit", "level": "A1", "topic": "weather", "pos": "noun", "gender": "die", "plural": "Jahreszeiten", "conjugation": None, "translation_en": "season of the year", "translation_ar": "فصل من فصول السنة", "translation_es": "estación del año", "frequency_rank": 314},
]

existing_w_ids = {w["id"] for w in data["words"]}
for w in unit12_words:
    if w["id"] not in existing_w_ids:
        data["words"].append(w)

# 3. Add Lessons for Unit 12 (11201 - 11206)
unit12_lessons = [
    {
        "id": 11201, "unit_id": 50008, "level": "A1", "title_de": "Wie ist das Wetter heute?", "title_en": "How is the Weather Today?",
        "sort_order": 1, "lesson_type": "vocabulary", "pass_threshold": 0.7, "grammar_content": None, "content_json": None
    },
    {
        "id": 11202, "unit_id": 50008, "level": "A1", "title_de": "Die vier Jahreszeiten", "title_en": "The Four Seasons",
        "sort_order": 2, "lesson_type": "vocabulary", "pass_threshold": 0.7, "grammar_content": None, "content_json": None
    },
    {
        "id": 11203, "unit_id": 50008, "level": "A1", "title_de": "Grammatik: Unpersönliches 'es' beim Wetter", "title_en": "Grammar: Impersonal 'es' with Weather",
        "sort_order": 3, "lesson_type": "grammar", "pass_threshold": 0.7,
        "grammar_content": "# التعبير عن الطقس بالضمير المحايد es\n# Impersonal 'es' in German Weather Expressions\n\n## 🇩🇪 Deutsch | 🇬🇧 English | 🇸🇦 عربي\n\nفي الألمانية نستخدم الضمير غير الشخصي **es** كفاعل أساسي للتعبير عن ظواهر الطقس ودرجات الحرارة:\nIn German, the impersonal pronoun **es** is always used as the grammatical subject for weather conditions:\n\n### 1. مع أفعال الطقس:\n- *Heute **regnet es** den ganzen Tag.* (اليوم تمطر طوال اليوم)\n- *Im Winter **schneit es** in den Bergen.* (في الشتاء تثلج في الجبال)\n- *Die Sonne **scheint**.* (الشمس تشرق)\n\n### 2. مع الصفات (es ist + Adjektiv):\n- *Es ist sehr **warm** heute.* (الجو دافئ جداً اليوم)\n- *Es ist **kalt** und **windig**.* (الجو بارد وعاصف)\n- *Der Himmel ist **bewölkt**.* (السماء غائمة)\n\n### 3. مع درجات الحرارة:\n- *Wie viel Grad haben wir heute?* (كم درجة الحرارة اليوم؟)\n- *Es sind 22 Grad.* (درجة الحرارة 22 درجة)\n\n### 4. مع فصول السنة (حرف الجر im):\n- * **im Frühling** (في الربيع)* | * **im Sommer** (في الصيف)*\n- * **im Herbst** (في الخريف)* | * **im Winter** (في الشتاء)*",
        "content_json": None
    },
    {
        "id": 11204, "unit_id": 50008, "level": "A1", "title_de": "Wetterbericht & Vorhersage", "title_en": "Weather Forecast & Planning",
        "sort_order": 4, "lesson_type": "grammar", "pass_threshold": 0.7,
        "grammar_content": "# نشرة الأحوال الجوية والتخطيط للأنشطة\n# Weather Forecasts and Activity Planning\n\n## 🇩🇪 Deutsch | 🇬🇧 English | 🇸🇦 عربي\n\n### عبارات شائعة في نشرة الطقس:\n- *Morgen wird es sonnig und warm.* (غداً سيكون الطقس مشمساً ودافئاً)\n- *Am Wochenende gibt es Regen.* (في نهاية الأسبوع هناك أمطار)\n- *Vergiss deinen Regenschirm nicht!* (لا تنسَ مظلتك!)\n- *Bei schönem Wetter machen wir ein Picknick.* (عندما يكون الطقس جميلاً نقوم بنزهة)",
        "content_json": None
    },
    {
        "id": 11205, "unit_id": 50008, "level": "A1", "title_de": "Urlaub & Reisewetter: Lesetext", "title_en": "Vacation & Travel Weather: Reading",
        "sort_order": 5, "lesson_type": "text", "pass_threshold": 0.7, "grammar_content": None, "content_json": None
    },
    {
        "id": 11206, "unit_id": 50008, "level": "A1", "title_de": "Einheitstest: Wetter & Jahreszeiten", "title_en": "Unit Test: Weather & Seasons",
        "sort_order": 6, "lesson_type": "unit_test", "pass_threshold": 0.75, "grammar_content": None, "content_json": None
    }
]

existing_l_ids = {l["id"] for l in data["lessons"]}
for l in unit12_lessons:
    if l["id"] not in existing_l_ids:
        data["lessons"].append(l)

# 4. Add Exercises for Unit 12 (41001 - 41045)
existing_ex_ids = {e["id"] for e in data["exercises"]}
unit12_exercises = []

# --- LESSON 11201: Wie ist das Wetter heute? (7 exercises) ---
unit12_exercises.append({
    "id": 41001, "lesson_id": 11201, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Sonne", "gender": "die", "question_en": "What does 'die Sonne' mean?", "question_ar": "ما معنى \u2066'die Sonne'\u2069؟", "question_es": "¿Qué significa 'die Sonne'?"}, ensure_ascii=False),
    "audio_text": "die Sonne", "correct_answer": "sun", "options": json.dumps(["sun", "rain", "snow", "wind"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit12_exercises.append({
    "id": 41002, "lesson_id": 11201, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Regen", "gender": "der", "question_en": "What does 'der Regen' mean?", "question_ar": "ما معنى \u2066'der Regen'\u2069؟", "question_es": "¿Qué significa 'der Regen'?"}, ensure_ascii=False),
    "audio_text": "der Regen", "correct_answer": "rain", "options": json.dumps(["rain", "sun", "cloud", "snow"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit12_exercises.append({
    "id": 41003, "lesson_id": 11201, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Heute scheint die Sonne.", "question_en": "Listen and select the weather condition.", "question_ar": "استمع واختر حالة الطقس المسموعة.", "question_es": "Escucha y selecciona el tiempo atmosférico."}, ensure_ascii=False),
    "audio_text": "Heute scheint die Sonne.", "correct_answer": "Heute scheint die Sonne.", "options": json.dumps(["Heute scheint die Sonne.", "Heute regnet es stark.", "Heute schneit es in Berlin.", "Es ist sehr kalt und windig."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit12_exercises.append({
    "id": 41004, "lesson_id": 11201, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Es ___ heute sehr stark. (regnet - regnen)", "question_en": "Conjugate 'regnen' with es: regnet.", "question_ar": "صرف فعل تمطر مع es: \u2066'regnet'\u2069.", "question_es": "Conjuga 'regnen': regnet."}, ensure_ascii=False),
    "audio_text": "Es regnet heute sehr stark.", "correct_answer": "regnet", "options": json.dumps(["regnet", "schneit", "scheint", "weht"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit12_exercises.append({
    "id": 41005, "lesson_id": 11201, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Schnee", "gender": "der", "question_en": "What does 'der Schnee' mean?", "question_ar": "ما معنى \u2066'der Schnee'\u2069؟", "question_es": "¿Qué significa 'der Schnee'?"}, ensure_ascii=False),
    "audio_text": "der Schnee", "correct_answer": "snow", "options": json.dumps(["snow", "rain", "sun", "sky"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit12_exercises.append({
    "id": 41006, "lesson_id": 11201, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Wie ist das ___ heute? (Wetter)", "question_en": "Fill in 'Wetter' (weather).", "question_ar": "املأ الفراغ بكلمة الطقس: \u2066'Wetter'\u2069.", "question_es": "Rellena con 'Wetter'."}, ensure_ascii=False),
    "audio_text": "Wie ist das Wetter heute?", "correct_answer": "Wetter", "options": json.dumps(["Wetter", "Wasser", "Essen", "Brot"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit12_exercises.append({
    "id": 41007, "lesson_id": 11201, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Das Wetter ist heute wunderschön.", "question_en": "Repeat: 'Das Wetter ist heute wunderschön.'", "question_ar": "ردد: \u2066'Das Wetter ist heute wunderschön.'\u2069", "question_es": "Repite: 'Das Wetter ist heute wunderschön.'"}, ensure_ascii=False),
    "audio_text": "Das Wetter ist heute wunderschön.", "correct_answer": "Das Wetter ist heute wunderschön.", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 11202: Die vier Jahreszeiten (7 exercises) ---
unit12_exercises.append({
    "id": 41008, "lesson_id": 11202, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Sommer", "gender": "der", "question_en": "What does 'der Sommer' mean?", "question_ar": "ما معنى \u2066'der Sommer'\u2069؟", "question_es": "¿Qué significa 'der Sommer'?"}, ensure_ascii=False),
    "audio_text": "der Sommer", "correct_answer": "summer", "options": json.dumps(["summer", "winter", "spring", "autumn"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit12_exercises.append({
    "id": 41009, "lesson_id": 11202, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Winter", "gender": "der", "question_en": "What does 'der Winter' mean?", "question_ar": "ما معنى \u2066'der Winter'\u2069؟", "question_es": "¿Qué significa 'der Winter'?"}, ensure_ascii=False),
    "audio_text": "der Winter", "correct_answer": "winter", "options": json.dumps(["winter", "summer", "spring", "autumn"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit12_exercises.append({
    "id": 41010, "lesson_id": 11202, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "___ Sommer ist es in Deutschland warm. (Im - Jahreszeit)", "question_en": "Choose preposition 'Im' for seasons.", "question_ar": "اختر حرف الجر مع فصول السنة: \u2066'Im'\u2069.", "question_es": "Elige 'Im' para estaciones."}, ensure_ascii=False),
    "audio_text": "Im Sommer ist es in Deutschland warm.", "correct_answer": "Im", "options": json.dumps(["Im", "Am", "Um", "An"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit12_exercises.append({
    "id": 41011, "lesson_id": 11202, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Im Winter schneit es oft.", "question_en": "Listen and select the season and weather.", "question_ar": "استمع واختر الفصل وحالة الطقس.", "question_es": "Escucha y selecciona la estación y el clima."}, ensure_ascii=False),
    "audio_text": "Im Winter schneit es oft.", "correct_answer": "Im Winter schneit es oft.", "options": json.dumps(["Im Winter schneit es oft.", "Im Sommer ist es sehr heiß.", "Im Frühling regnet es nie.", "Im Herbst scheint die Sonne."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit12_exercises.append({
    "id": 41012, "lesson_id": 11202, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Frühling", "gender": "der", "question_en": "What does 'der Frühling' mean?", "question_ar": "ما معنى \u2066'der Frühling'\u2069؟", "question_es": "¿Qué significa 'der Frühling'?"}, ensure_ascii=False),
    "audio_text": "der Frühling", "correct_answer": "spring", "options": json.dumps(["spring", "autumn", "winter", "summer"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit12_exercises.append({
    "id": 41013, "lesson_id": 11202, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Der ___ kommt nach dem Sommer. (Herbst)", "question_en": "Fill in 'Herbst' (autumn).", "question_ar": "املأ الفراغ بكلمة فصل الخريف: \u2066'Herbst'\u2069.", "question_es": "Rellena con 'Herbst'."}, ensure_ascii=False),
    "audio_text": "Der Herbst kommt nach dem Sommer.", "correct_answer": "Herbst", "options": json.dumps(["Herbst", "Frühling", "Winter", "Sommer"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit12_exercises.append({
    "id": 41014, "lesson_id": 11202, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Meine Lieblingsjahreszeit ist der Frühling.", "question_en": "Repeat: 'Meine Lieblingsjahreszeit ist der Frühling.'", "question_ar": "ردد: \u2066'Meine Lieblingsjahreszeit ist der Frühling.'\u2069", "question_es": "Repite: 'Meine Lieblingsjahreszeit ist der Frühling.'"}, ensure_ascii=False),
    "audio_text": "Meine Lieblingsjahreszeit ist der Frühling.", "correct_answer": "Meine Lieblingsjahreszeit ist der Frühling.", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 11203: Grammatik: Unpersönliches 'es' beim Wetter (7 exercises) ---
unit12_exercises.append({
    "id": 41015, "lesson_id": 11203, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Heute ist ___ sehr kalt draußen. (es)", "question_en": "Fill in impersonal subject 'es'.", "question_ar": "املأ الفراغ بالفاعل غير الشخصي: \u2066'es'\u2069.", "question_es": "Rellena con 'es'."}, ensure_ascii=False),
    "audio_text": "Heute ist es sehr kalt draußen.", "correct_answer": "es", "options": json.dumps(["es", "er", "sie", "man"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit12_exercises.append({
    "id": 41016, "lesson_id": 11203, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Es ___ 25 Grad. (sind - Plural bei Grad)", "question_en": "Fill in 'sind' with plural degrees.", "question_ar": "املأ الفراغ مع درجات الحرارة بصيغة الجمع: \u2066'sind'\u2069.", "question_es": "Rellena con 'sind'."}, ensure_ascii=False),
    "audio_text": "Es sind 25 Grad.", "correct_answer": "sind", "options": json.dumps(["sind", "ist", "hat", "macht"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit12_exercises.append({
    "id": 41017, "lesson_id": 11203, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "sonnig", "question_en": "What does 'sonnig' mean?", "question_ar": "ما معنى \u2066'sonnig'\u2069؟", "question_es": "¿Qué significa 'sonnig'?"}, ensure_ascii=False),
    "audio_text": "sonnig", "correct_answer": "sunny", "options": json.dumps(["sunny", "cloudy", "windy", "cold"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit12_exercises.append({
    "id": 41018, "lesson_id": 11203, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Morgen wird es windig und regnerisch.", "question_en": "Listen and select the forecast.", "question_ar": "استمع واختر حالة الطقس المتوقعة.", "question_es": "Escucha y selecciona el pronóstico."}, ensure_ascii=False),
    "audio_text": "Morgen wird es windig und regnerisch.", "correct_answer": "Morgen wird es windig und regnerisch.", "options": json.dumps(["Morgen wird es windig und regnerisch.", "Morgen wird es sonnig und heiß.", "Es schneit den ganzen Tag.", "Das Wetter bleibt trocken."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit12_exercises.append({
    "id": 41019, "lesson_id": 11203, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "bewölkt", "question_en": "What does 'bewölkt' mean?", "question_ar": "ما معنى \u2066'bewölkt'\u2069؟", "question_es": "¿Qué significa 'bewölkt'?"}, ensure_ascii=False),
    "audio_text": "bewölkt", "correct_answer": "cloudy", "options": json.dumps(["cloudy", "sunny", "warm", "clear"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit12_exercises.append({
    "id": 41020, "lesson_id": 11203, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Nimm deinen ___ mit, es regnet! (Regenschirm)", "question_en": "Fill in 'Regenschirm' (umbrella).", "question_ar": "املأ الفراغ بكلمة مظلة المطر: \u2066'Regenschirm'\u2069.", "question_es": "Rellena con 'Regenschirm'."}, ensure_ascii=False),
    "audio_text": "Nimm deinen Regenschirm mit, es regnet!", "correct_answer": "Regenschirm", "options": json.dumps(["Regenschirm", "Koffer", "Mantel", "Schuh"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit12_exercises.append({
    "id": 41021, "lesson_id": 11203, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Es ist heute sehr heiß.", "question_en": "Repeat: 'Es ist heute sehr heiß.'", "question_ar": "ردد: \u2066'Es ist heute sehr heiß.'\u2069", "question_es": "Repite: 'Es ist heute sehr heiß.'"}, ensure_ascii=False),
    "audio_text": "Es ist heute sehr heiß.", "correct_answer": "Es ist heute sehr heiß.", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 11204: Wetterbericht & Vorhersage (7 exercises) ---
unit12_exercises.append({
    "id": 41022, "lesson_id": 11204, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Wind", "gender": "der", "question_en": "What does 'der Wind' mean?", "question_ar": "ما معنى \u2066'der Wind'\u2069؟", "question_es": "¿Qué significa 'der Wind'?"}, ensure_ascii=False),
    "audio_text": "der Wind", "correct_answer": "wind", "options": json.dumps(["wind", "rain", "sun", "cloud"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit12_exercises.append({
    "id": 41023, "lesson_id": 11204, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Wie viel Grad haben ___ heute? (wir)", "question_en": "Fill in pronoun 'wir'.", "question_ar": "املأ الفراغ بالضمير wir: \u2066'wir'\u2069.", "question_es": "Rellena con 'wir'."}, ensure_ascii=False),
    "audio_text": "Wie viel Grad haben wir heute?", "correct_answer": "wir", "options": json.dumps(["wir", "sie", "ihr", "es"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit12_exercises.append({
    "id": 41024, "lesson_id": 11204, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Im Süden gibt es heute viel Sonne.", "question_en": "Listen and select the region forecast.", "question_ar": "استمع واختر طقس الجنوب.", "question_es": "Escucha y selecciona el tiempo del sur."}, ensure_ascii=False),
    "audio_text": "Im Süden gibt es heute viel Sonne.", "correct_answer": "Im Süden gibt es heute viel Sonne.", "options": json.dumps(["Im Süden gibt es heute viel Sonne.", "Im Norden schneit es stark.", "Im Westen ist es stürmisch.", "Überall regnet es."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit12_exercises.append({
    "id": 41025, "lesson_id": 11204, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Himmel", "gender": "der", "question_en": "What does 'der Himmel' mean?", "question_ar": "ما معنى \u2066'der Himmel'\u2069؟", "question_es": "¿Qué significa 'der Himmel'?"}, ensure_ascii=False),
    "audio_text": "der Himmel", "correct_answer": "sky", "options": json.dumps(["sky", "sun", "moon", "star"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit12_exercises.append({
    "id": 41026, "lesson_id": 11204, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Das Wetter ist leider sehr ___ . (schlecht)", "question_en": "Fill in 'schlecht' (bad).", "question_ar": "املأ الفراغ بكلمة سيء: \u2066'schlecht'\u2069.", "question_es": "Rellena con 'schlecht'."}, ensure_ascii=False),
    "audio_text": "Das Wetter ist leider sehr schlecht.", "correct_answer": "schlecht", "options": json.dumps(["schlecht", "schön", "warm", "sonnig"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit12_exercises.append({
    "id": 41027, "lesson_id": 11204, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Wolke", "gender": "die", "question_en": "What does 'die Wolke' mean?", "question_ar": "ما معنى \u2066'die Wolke'\u2069؟", "question_es": "¿Qué significa 'die Wolke'?"}, ensure_ascii=False),
    "audio_text": "die Wolke", "correct_answer": "cloud", "options": json.dumps(["cloud", "sun", "rain", "wind"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit12_exercises.append({
    "id": 41028, "lesson_id": 11204, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Morgen wird es wieder schön.", "question_en": "Repeat: 'Morgen wird es wieder schön.'", "question_ar": "ردد: \u2066'Morgen wird es wieder schön.'\u2069", "question_es": "Repite: 'Morgen wird es wieder schön.'"}, ensure_ascii=False),
    "audio_text": "Morgen wird es wieder schön.", "correct_answer": "Morgen wird es wieder schön.", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 11205: Urlaub & Reisewetter: Lesetext (7 exercises) ---
unit12_exercises.append({
    "id": 41029, "lesson_id": 11205, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Grad", "gender": "das", "question_en": "What does 'das Grad' mean?", "question_ar": "ما معنى \u2066'das Grad'\u2069؟", "question_es": "¿Qué significa 'das Grad'?"}, ensure_ascii=False),
    "audio_text": "das Grad", "correct_answer": "degree", "options": json.dumps(["degree", "weather", "season", "sun"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit12_exercises.append({
    "id": 41030, "lesson_id": 11205, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "In Spanien ist es im Sommer sehr heiß.", "question_en": "Listen and select the sentence.", "question_ar": "استمع واختر الجملة المسموعة.", "question_es": "Escucha y selecciona la frase."}, ensure_ascii=False),
    "audio_text": "In Spanien ist es im Sommer sehr heiß.", "correct_answer": "In Spanien ist es im Sommer sehr heiß.", "options": json.dumps(["In Spanien ist es im Sommer sehr heiß.", "In Deutschland schneit es im Sommer.", "Im Winter ist es in Spanien kalt.", "Wir fahren im Herbst nach Italien."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit12_exercises.append({
    "id": 41031, "lesson_id": 11205, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Die Temperatur liegt bei 30 ___ . (Grad)", "question_en": "Fill in 'Grad'.", "question_ar": "املأ الفراغ بكلمة درجات: \u2066'Grad'\u2069.", "question_es": "Rellena con 'Grad'."}, ensure_ascii=False),
    "audio_text": "Die Temperatur liegt bei 30 Grad.", "correct_answer": "Grad", "options": json.dumps(["Grad", "Uhr", "Euro", "Meter"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit12_exercises.append({
    "id": 41032, "lesson_id": 11205, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Jahreszeit", "gender": "die", "question_en": "What does 'die Jahreszeit' mean?", "question_ar": "ما معنى \u2066'die Jahreszeit'\u2069؟", "question_es": "¿Qué significa 'die Jahreszeit'?"}, ensure_ascii=False),
    "audio_text": "die Jahreszeit", "correct_answer": "season of the year", "options": json.dumps(["season of the year", "weather forecast", "holiday", "month"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit12_exercises.append({
    "id": 41033, "lesson_id": 11205, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Wir machen am Wochenende einen Ausflug in die Berge.", "question_en": "Listen and select the weekend plan.", "question_ar": "استمع واختر خطة عطلة نهاية الأسبوع.", "question_es": "Escucha y selecciona el plan para el fin de semana."}, ensure_ascii=False),
    "audio_text": "Wir machen am Wochenende einen Ausflug in die Berge.", "correct_answer": "Wir machen am Wochenende einen Ausflug in die Berge.", "options": json.dumps(["Wir machen am Wochenende einen Ausflug in die Berge.", "Wir bleiben wegen des Regens zu Hause.", "Wir gehen ins Kino.", "Wir arbeiten am Samstag im Büro."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit12_exercises.append({
    "id": 41034, "lesson_id": 11205, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Im Herbst wird es kühler und es ___ oft. (regnet)", "question_en": "Fill in 'regnet'.", "question_ar": "املأ الفراغ بكلمة تمطر: \u2066'regnet'\u2069.", "question_es": "Rellena con 'regnet'."}, ensure_ascii=False),
    "audio_text": "Im Herbst wird es kühler und es regnet oft.", "correct_answer": "regnet", "options": json.dumps(["regnet", "scheint", "schneit", "wärmt"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit12_exercises.append({
    "id": 41035, "lesson_id": 11205, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Ich liebe sonniges Wetter.", "question_en": "Repeat: 'Ich liebe sonniges Wetter.'", "question_ar": "ردد: \u2066'Ich liebe sonniges Wetter.'\u2069", "question_es": "Repite: 'Ich liebe sonniges Wetter.'"}, ensure_ascii=False),
    "audio_text": "Ich liebe sonniges Wetter.", "correct_answer": "Ich liebe sonniges Wetter.", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 11206: Einheitstest: Wetter & Jahreszeiten (10 exercises) ---
test_pool_12 = [
    ("die Sonne", ["sun", "rain", "snow", "cloud"], "sun", "match_pairs", "What does 'die Sonne' mean?", "ما معنى \u2066'die Sonne'\u2069؟", "¿Qué significa 'die Sonne'?"),
    ("der Regen", ["rain", "sun", "wind", "sky"], "rain", "match_pairs", "What does 'der Regen' mean?", "ما معنى \u2066'der Regen'\u2069؟", "¿Qué significa 'der Regen'?"),
    ("Heute scheint die Sonne.", ["Heute scheint die Sonne.", "Heute regnet es.", "Heute schneit es.", "Es ist sehr kalt."], "Heute scheint die Sonne.", "listen_choose", "Listen to the weather.", "استمع لحالة الطقس.", "Escucha el tiempo."),
    ("Es regnet heute sehr stark.", ["regnet", "schneit", "scheint", "weht"], "regnet", "type_fill_blank", "Fill in 'regnet'.", "صرف فعل تمطر: \u2066'regnet'\u2069.", "Elige 'regnet'."),
    ("Im Sommer ist es in Deutschland warm.", ["Im", "Am", "Um", "An"], "Im", "type_fill_blank", "Choose preposition 'Im'.", "اختر حرف الجر مع فصول السنة: \u2066'Im'\u2069.", "Elige 'Im'."),
    ("Heute ist es sehr kalt draußen.", ["es", "er", "sie", "man"], "es", "type_fill_blank", "Fill in impersonal 'es'.", "املأ الفراغ بالضمير: \u2066'es'\u2069.", "Elige 'es'."),
    ("der Sommer", ["summer", "winter", "spring", "autumn"], "summer", "match_pairs", "What does 'der Sommer' mean?", "ما معنى \u2066'der Sommer'\u2069؟", "¿Qué significa 'der Sommer'?"),
    ("Morgen wird es windig und regnerisch.", ["Morgen wird es windig und regnerisch.", "Morgen wird es sonnig und heiß.", "Es schneit stark.", "Es bleibt trocken."], "Morgen wird es windig und regnerisch.", "listen_choose", "Listen to the forecast.", "استمع لنشرة الطقس.", "Escucha el pronóstico."),
    ("Das Wetter ist heute wunderschön.", None, "Das Wetter ist heute wunderschön.", "repeat_prompt", "Repeat: 'Das Wetter ist heute wunderschön.'", "ردد: \u2066'Das Wetter ist heute wunderschön.'\u2069", "Repite: 'Das Wetter ist heute wunderschön.'"),
    ("Nimm deinen Regenschirm mit, es regnet!", ["Regenschirm", "Koffer", "Mantel", "Schuh"], "Regenschirm", "type_fill_blank", "Fill in 'Regenschirm'.", "املأ الفراغ بكلمة مظلة المطر: \u2066'Regenschirm'\u2069.", "Rellena con 'Regenschirm'.")
]

for idx, (audio, opts, ans, extype, q_en, q_ar, q_es) in enumerate(test_pool_12, start=1):
    unit12_exercises.append({
        "id": 41035 + idx,
        "lesson_id": 11206,
        "passage_id": None,
        "skill": "listening" if extype == "listen_choose" else ("speaking" if extype == "repeat_prompt" else "reading"),
        "exercise_type": extype,
        "prompt": json.dumps({
            "de": audio,
            "question_en": f"Unit 12 Test ({idx}/10): {q_en}",
            "question_ar": f"اختبار الوحدة 12 ({idx}/10): {q_ar}",
            "question_es": f"Test Unidad 12 ({idx}/10): {q_es}"
        }, ensure_ascii=False),
        "audio_text": audio,
        "correct_answer": ans,
        "options": json.dumps(opts, ensure_ascii=False) if opts else None,
        "is_graded": 1,
        "is_test_pool": 1,
        "sort_order": idx
    })

for ex in unit12_exercises:
    if ex["id"] not in existing_ex_ids:
        data["exercises"].append(ex)
        existing_ex_ids.add(ex["id"])

with open(CONTENT_PATH, "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print(f"Successfully built Unit 12 (Wetter & Jahreszeiten)! Total exercises added: {len(unit12_exercises)}")
