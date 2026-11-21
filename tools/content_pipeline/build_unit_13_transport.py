import json
from pathlib import Path

CONTENT_PATH = Path(r"c:\Users\HP\3D Objects\Deutschy-main\Deutschy-main\assets\deutschy_content.json")

with open(CONTENT_PATH, "r", encoding="utf-8") as f:
    data = json.load(f)

# 1. Register Unit 13
if not any(u["id"] == 50009 for u in data["units"]):
    data["units"].append({
        "id": 50009,
        "level": "A1",
        "unit_number": 13,
        "title_de": "Weg & Verkehr",
        "title_en": "Directions & Transport",
        "title_ar": "الاتجاهات والمواصلات",
        "title_es": "Direcciones y transporte",
        "topic_key": "travel"
    })

# 2. Add Vocabulary for Unit 13 (IDs 1320-1344)
unit13_words = [
    {"id": 1320, "lemma": "Bahnhof", "level": "A1", "topic": "travel", "pos": "noun", "gender": "der", "plural": "Bahnhöfe", "conjugation": None, "translation_en": "train station", "translation_ar": "محطة قطار", "translation_es": "estación de tren", "frequency_rank": 320},
    {"id": 1321, "lemma": "Zug", "level": "A1", "topic": "travel", "pos": "noun", "gender": "der", "plural": "Züge", "conjugation": None, "translation_en": "train", "translation_ar": "قطار", "translation_es": "tren", "frequency_rank": 321},
    {"id": 1322, "lemma": "Bus", "level": "A1", "topic": "travel", "pos": "noun", "gender": "der", "plural": "Busse", "conjugation": None, "translation_en": "bus", "translation_ar": "حافلة / باص", "translation_es": "autobús", "frequency_rank": 322},
    {"id": 1323, "lemma": "Flughafen", "level": "A1", "topic": "travel", "pos": "noun", "gender": "der", "plural": "Flughäfen", "conjugation": None, "translation_en": "airport", "translation_ar": "مطار", "translation_es": "aeropuerto", "frequency_rank": 323},
    {"id": 1324, "lemma": "Flugzeug", "level": "A1", "topic": "travel", "pos": "noun", "gender": "das", "plural": "Flugzeuge", "conjugation": None, "translation_en": "airplane", "translation_ar": "طائرة", "translation_es": "avión", "frequency_rank": 324},
    {"id": 1325, "lemma": "Fahrkarte", "level": "A1", "topic": "travel", "pos": "noun", "gender": "die", "plural": "Fahrkarten", "conjugation": None, "translation_en": "ticket", "translation_ar": "تذكرة سفر", "translation_es": "billete / pasaje", "frequency_rank": 325},
    {"id": 1326, "lemma": "Gleis", "level": "A1", "topic": "travel", "pos": "noun", "gender": "das", "plural": "Gleise", "conjugation": None, "translation_en": "platform / track", "translation_ar": "رصيف القطار / خط السكة", "translation_es": "vía / andén", "frequency_rank": 326},
    {"id": 1327, "lemma": "Haltestelle", "level": "A1", "topic": "travel", "pos": "noun", "gender": "die", "plural": "Haltestellen", "conjugation": None, "translation_en": "stop (bus/tram)", "translation_ar": "موقف (باص / ترام)", "translation_es": "parada", "frequency_rank": 327},
    {"id": 1328, "lemma": "Ampel", "level": "A1", "topic": "travel", "pos": "noun", "gender": "die", "plural": "Ampeln", "conjugation": None, "translation_en": "traffic light", "translation_ar": "إشارة مرور", "translation_es": "semáforo", "frequency_rank": 328},
    {"id": 1329, "lemma": "Straße", "level": "A1", "topic": "travel", "pos": "noun", "gender": "die", "plural": "Straßen", "conjugation": None, "translation_en": "street", "translation_ar": "شارع", "translation_es": "calle", "frequency_rank": 329},
    {"id": 1330, "lemma": "Ecke", "level": "A1", "topic": "travel", "pos": "noun", "gender": "die", "plural": "Ecken", "conjugation": None, "translation_en": "corner", "translation_ar": "زاوية / ركن", "translation_es": "esquina", "frequency_rank": 330},
    {"id": 1331, "lemma": "links", "level": "A1", "topic": "travel", "pos": "adverb", "gender": None, "plural": None, "conjugation": None, "translation_en": "left / to the left", "translation_ar": "يساراً / إلى اليسار", "translation_es": "a la izquierda", "frequency_rank": 331},
    {"id": 1332, "lemma": "rechts", "level": "A1", "topic": "travel", "pos": "adverb", "gender": None, "plural": None, "conjugation": None, "translation_en": "right / to the right", "translation_ar": "يميناً / إلى اليمين", "translation_es": "a la derecha", "frequency_rank": 332},
    {"id": 1333, "lemma": "geradeaus", "level": "A1", "topic": "travel", "pos": "adverb", "gender": None, "plural": None, "conjugation": None, "translation_en": "straight ahead", "translation_ar": "إلى الأمام مباشرة", "translation_es": "todo recto", "frequency_rank": 333},
    {"id": 1334, "lemma": "abfahren", "level": "A1", "topic": "travel", "pos": "verb", "gender": None, "plural": None, "conjugation": "fährt ab", "translation_en": "to depart", "translation_ar": "ينطلق / يغادر", "translation_es": "partir / salir", "frequency_rank": 334},
    {"id": 1335, "lemma": "ankommen", "level": "A1", "topic": "travel", "pos": "verb", "gender": None, "plural": None, "conjugation": "kommt an", "translation_en": "to arrive", "translation_ar": "يصل", "translation_es": "llegar", "frequency_rank": 335},
    {"id": 1336, "lemma": "umsteigen", "level": "A1", "topic": "travel", "pos": "verb", "gender": None, "plural": None, "conjugation": "steigt um", "translation_en": "to change (trains/buses)", "translation_ar": "يبدل (قطار / باص)", "translation_es": "hacer transbordo", "frequency_rank": 336},
    {"id": 1337, "lemma": "einsteigen", "level": "A1", "topic": "travel", "pos": "verb", "gender": None, "plural": None, "conjugation": "steigt ein", "translation_en": "to get on / board", "translation_ar": "يركب / يصعد", "translation_es": "subir a", "frequency_rank": 337},
    {"id": 1338, "lemma": "aussteigen", "level": "A1", "topic": "travel", "pos": "verb", "gender": None, "plural": None, "conjugation": "steigt aus", "translation_en": "to get off", "translation_ar": "ينزل من وسيلة النقل", "translation_es": "bajar de", "frequency_rank": 338},
    {"id": 1339, "lemma": "Nähe", "level": "A1", "topic": "travel", "pos": "noun", "gender": "die", "plural": None, "conjugation": None, "translation_en": "vicinity / near", "translation_ar": "قرب / جوار", "translation_es": "cercanía", "frequency_rank": 339},
    {"id": 1340, "lemma": "weit", "level": "A1", "topic": "travel", "pos": "adjective", "gender": None, "plural": None, "conjugation": None, "translation_en": "far", "translation_ar": "بعيد", "translation_es": "lejos", "frequency_rank": 340},
    {"id": 1341, "lemma": "nah", "level": "A1", "topic": "travel", "pos": "adjective", "gender": None, "plural": None, "conjugation": None, "translation_en": "near / close", "translation_ar": "قريب", "translation_es": "cerca", "frequency_rank": 341},
    {"id": 1342, "lemma": "reisen", "level": "A1", "topic": "travel", "pos": "verb", "gender": None, "plural": None, "conjugation": "reist", "translation_en": "to travel", "translation_ar": "يسافر", "translation_es": "viajar", "frequency_rank": 342},
    {"id": 1343, "lemma": "Auto", "level": "A1", "topic": "travel", "pos": "noun", "gender": "das", "plural": "Autos", "conjugation": None, "translation_en": "car", "translation_ar": "سيارة", "translation_es": "coche / auto", "frequency_rank": 343},
    {"id": 1344, "lemma": "Fahrrad", "level": "A1", "topic": "travel", "pos": "noun", "gender": "das", "plural": "Fahrräder", "conjugation": None, "translation_en": "bicycle", "translation_ar": "دراجة هوائية", "translation_es": "bicicleta", "frequency_rank": 344},
]

existing_w_ids = {w["id"] for w in data["words"]}
for w in unit13_words:
    if w["id"] not in existing_w_ids:
        data["words"].append(w)

# 3. Add Lessons for Unit 13 (11301 - 11306)
unit13_lessons = [
    {
        "id": 11301, "unit_id": 50009, "level": "A1", "title_de": "Öffentliche Verkehrsmittel", "title_en": "Public Transport",
        "sort_order": 1, "lesson_type": "vocabulary", "pass_threshold": 0.7, "grammar_content": None, "content_json": None
    },
    {
        "id": 11302, "unit_id": 50009, "level": "A1", "title_de": "Nach dem Weg fragen & Richtungen", "title_en": "Asking for Directions",
        "sort_order": 2, "lesson_type": "vocabulary", "pass_threshold": 0.7, "grammar_content": None, "content_json": None
    },
    {
        "id": 11303, "unit_id": 50009, "level": "A1", "title_de": "Grammatik: Imperativ (du-Form) & Richtungsangaben", "title_en": "Grammar: Imperative (du-Form) & Directions",
        "sort_order": 3, "lesson_type": "grammar", "pass_threshold": 0.7,
        "grammar_content": "# صيغة الأمر (du-Form) ووصف الطريق\n# Imperative (du-Form) and Giving Directions\n\n## 🇩🇪 Deutsch | 🇬🇧 English | 🇸🇦 عربي\n\n### 1. صيغة الأمر مع المفرد المخاطب (du):\nلتكوين صيغة الأمر مع (du)، نأخذ جذر الفعل ونحذف النهاية (en/st) والضمير (du):\n- *gehen* -> **Geh!** (اذهب!)\n- *fahren* -> **Fahr!** (قُد / سافر!)\n- *biegen* -> **Bieg ab!** (انعطف!)\n\n### 2. الاتجاهات الشائعة:\n- *Geh **geradeaus**!* (سر إلى الأمام مباشرة!)\n- *Bieg an der Ampel **nach rechts** ab!* (انعطف يميناً عند إشارة المرور!)\n- *Bieg an der nächsten Ecke **nach links** ab!* (انعطف يساراً عند الزاوية القادمة!)\n\n### 3. السؤال عن الطريق بأدب:\n- *Entschuldigung, wie komme ich zum Bahnhof?* (عذراً، كيف أصل إلى محطة القطار؟)\n- *Ist der Flughafen weit von hier?* (هل المطار بعيد من هنا؟)",
        "content_json": None
    },
    {
        "id": 11304, "unit_id": 50009, "level": "A1", "title_de": "Grammatik: Perfekt mit haben und sein", "title_en": "Grammar: Conversational Past (haben & sein)",
        "sort_order": 4, "lesson_type": "grammar", "pass_threshold": 0.7,
        "grammar_content": "# الماضي المركب (Perfekt) مع haben و sein\n# The Conversational Past with 'haben' and 'sein'\n\n## 🇩🇪 Deutsch | 🇬🇧 English | 🇸🇦 عربي\n\nفي المستوى A1 نستخدم صيغة الماضي المركب (Perfekt) للحديث عن الأحداث الماضية في الحياة اليومية:\nIn Level A1, the Perfekt tense is used for everyday spoken past conversations:\n\n### 1. مع أفعال الحركة والانتقال (sein + Partizip II):\n- *Ich **bin** mit dem Zug nach Berlin **gefahren**.* (سافرت بالقطار إلى برلين)\n- *Der Bus **ist** pünktlich **angekommen**.* (وصلت الحافلة في الموعد المحدد)\n- *Wir **sind** viel **gereist**.* (سافرنا كثيراً)\n\n### 2. مع أغلب الأفعال العادية (haben + Partizip II):\n- *Ich **habe** eine Fahrkarte **gekauft**.* (اشتريت تذكرة سفر)\n- *Er **hat** eine Reise **gemacht**.* (قام برحلة)",
        "content_json": None
    },
    {
        "id": 11305, "unit_id": 50009, "level": "A1", "title_de": "Am Bahnhof: Durchsagen & Fahrplan", "title_en": "At the Station: Announcements & Timetable",
        "sort_order": 5, "lesson_type": "text", "pass_threshold": 0.7, "grammar_content": None, "content_json": None
    },
    {
        "id": 11306, "unit_id": 50009, "level": "A1", "title_de": "Einheitstest: Weg & Verkehr", "title_en": "Unit Test: Directions & Transport",
        "sort_order": 6, "lesson_type": "unit_test", "pass_threshold": 0.75, "grammar_content": None, "content_json": None
    }
]

existing_l_ids = {l["id"] for l in data["lessons"]}
for l in unit13_lessons:
    if l["id"] not in existing_l_ids:
        data["lessons"].append(l)

# 4. Add Exercises for Unit 13 (41051 - 41095)
existing_ex_ids = {e["id"] for e in data["exercises"]}
unit13_exercises = []

# --- LESSON 11301: Öffentliche Verkehrsmittel (7 exercises) ---
unit13_exercises.append({
    "id": 41051, "lesson_id": 11301, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Bahnhof", "gender": "der", "question_en": "What does 'der Bahnhof' mean?", "question_ar": "ما معنى \u2066'der Bahnhof'\u2069؟", "question_es": "¿Qué significa 'der Bahnhof'?"}, ensure_ascii=False),
    "audio_text": "der Bahnhof", "correct_answer": "train station", "options": json.dumps(["train station", "airport", "bus stop", "street"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit13_exercises.append({
    "id": 41052, "lesson_id": 11301, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Zug", "gender": "der", "question_en": "What does 'der Zug' mean?", "question_ar": "ما معنى \u2066'der Zug'\u2069؟", "question_es": "¿Qué significa 'der Zug'?"}, ensure_ascii=False),
    "audio_text": "der Zug", "correct_answer": "train", "options": json.dumps(["train", "car", "bicycle", "plane"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit13_exercises.append({
    "id": 41053, "lesson_id": 11301, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Ich brauche eine ___ nach Frankfurt. (Fahrkarte)", "question_en": "Fill in 'Fahrkarte' (ticket).", "question_ar": "املأ الفراغ بكلمة تذكرة: \u2066'Fahrkarte'\u2069.", "question_es": "Rellena con 'Fahrkarte'."}, ensure_ascii=False),
    "audio_text": "Ich brauche eine Fahrkarte nach Frankfurt.", "correct_answer": "Fahrkarte", "options": json.dumps(["Fahrkarte", "Zeitung", "Rechnung", "Postkarte"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit13_exercises.append({
    "id": 41054, "lesson_id": 11301, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Der Zug fährt von Gleis 4 ab.", "question_en": "Listen and choose the platform announcement.", "question_ar": "استمع واختر إعلان رصيف القطار.", "question_es": "Escucha y elige el anuncio de la vía."}, ensure_ascii=False),
    "audio_text": "Der Zug fährt von Gleis 4 ab.", "correct_answer": "Der Zug fährt von Gleis 4 ab.", "options": json.dumps(["Der Zug fährt von Gleis 4 ab.", "Der Bus kommt um 4 Uhr an.", "Das Flugzeug startet von Gate 4.", "Wir treffen uns an Gleis 10."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit13_exercises.append({
    "id": 41055, "lesson_id": 11301, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Haltestelle", "gender": "die", "question_en": "What does 'die Haltestelle' mean?", "question_ar": "ما معنى \u2066'die Haltestelle'\u2069؟", "question_es": "¿Qué significa 'die Haltestelle'?"}, ensure_ascii=False),
    "audio_text": "die Haltestelle", "correct_answer": "bus stop", "options": json.dumps(["bus stop", "airport", "railway station", "crossroad"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit13_exercises.append({
    "id": 41056, "lesson_id": 11301, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Wir fahren mit dem ___ zur Arbeit. (Bus)", "question_en": "Fill in 'Bus'.", "question_ar": "املأ الفراغ بكلمة الحافلة: \u2066'Bus'\u2069.", "question_es": "Rellena con 'Bus'."}, ensure_ascii=False),
    "audio_text": "Wir fahren mit dem Bus zur Arbeit.", "correct_answer": "Bus", "options": json.dumps(["Bus", "Fuß", "Boot", "Schiff"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit13_exercises.append({
    "id": 41057, "lesson_id": 11301, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Eine Fahrkarte nach Hamburg, bitte.", "question_en": "Repeat: 'Eine Fahrkarte nach Hamburg, bitte.'", "question_ar": "ردد: \u2066'Eine Fahrkarte nach Hamburg, bitte.'\u2069", "question_es": "Repite: 'Eine Fahrkarte nach Hamburg, bitte.'"}, ensure_ascii=False),
    "audio_text": "Eine Fahrkarte nach Hamburg, bitte.", "correct_answer": "Eine Fahrkarte nach Hamburg, bitte.", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 11302: Nach dem Weg fragen & Richtungen (7 exercises) ---
unit13_exercises.append({
    "id": 41058, "lesson_id": 11302, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "geradeaus", "question_en": "What does 'geradeaus' mean?", "question_ar": "ما معنى \u2066'geradeaus'\u2069؟", "question_es": "¿Qué significa 'geradeaus'?"}, ensure_ascii=False),
    "audio_text": "geradeaus", "correct_answer": "straight ahead", "options": json.dumps(["straight ahead", "to the left", "to the right", "backwards"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit13_exercises.append({
    "id": 41059, "lesson_id": 11302, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "links", "question_en": "What does 'links' mean?", "question_ar": "ما معنى \u2066'links'\u2069؟", "question_es": "¿Qué significa 'links'?"}, ensure_ascii=False),
    "audio_text": "links", "correct_answer": "to the left", "options": json.dumps(["to the left", "to the right", "straight ahead", "upstairs"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit13_exercises.append({
    "id": 41060, "lesson_id": 11302, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "An der Ampel biegen Sie nach ___ ab. (rechts)", "question_en": "Fill in 'rechts' (right).", "question_ar": "املأ الفراغ بكلمة يميناً: \u2066'rechts'\u2069.", "question_es": "Rellena con 'rechts'."}, ensure_ascii=False),
    "audio_text": "An der Ampel biegen Sie nach rechts ab.", "correct_answer": "rechts", "options": json.dumps(["rechts", "oben", "unten", "weit"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit13_exercises.append({
    "id": 41061, "lesson_id": 11302, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Entschuldigung, wo ist der Bahnhof?", "question_en": "Listen and select the question.", "question_ar": "استمع واختر السؤال المسموع.", "question_es": "Escucha y selecciona la pregunta."}, ensure_ascii=False),
    "audio_text": "Entschuldigung, wo ist der Bahnhof?", "correct_answer": "Entschuldigung, wo ist der Bahnhof?", "options": json.dumps(["Entschuldigung, wo ist der Bahnhof?", "Entschuldigung, wo ist das Hotel?", "Wann fährt der Bus ab?", "Wie viel kostet die Fahrkarte?"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit13_exercises.append({
    "id": 41062, "lesson_id": 11302, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Ampel", "gender": "die", "question_en": "What does 'die Ampel' mean?", "question_ar": "ما معنى \u2066'die Ampel'\u2069؟", "question_es": "¿Qué significa 'die Ampel'?"}, ensure_ascii=False),
    "audio_text": "die Ampel", "correct_answer": "traffic light", "options": json.dumps(["traffic light", "street sign", "corner", "bridge"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit13_exercises.append({
    "id": 41063, "lesson_id": 11302, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Das Restaurant ist gleich an der ___ . (Ecke)", "question_en": "Fill in 'Ecke' (corner).", "question_ar": "املأ الفراغ بكلمة الزاوية / الركن: \u2066'Ecke'\u2069.", "question_es": "Rellena con 'Ecke'."}, ensure_ascii=False),
    "audio_text": "Das Restaurant ist gleich an der Ecke.", "correct_answer": "Ecke", "options": json.dumps(["Ecke", "Straße", "Stadt", "Wand"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit13_exercises.append({
    "id": 41064, "lesson_id": 11302, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Gehen Sie immer geradeaus.", "question_en": "Repeat: 'Gehen Sie immer geradeaus.'", "question_ar": "ردد: \u2066'Gehen Sie immer geradeaus.'\u2069", "question_es": "Repite: 'Gehen Sie immer geradeaus.'"}, ensure_ascii=False),
    "audio_text": "Gehen Sie immer geradeaus.", "correct_answer": "Gehen Sie immer geradeaus.", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 11303: Grammatik: Imperativ (du-Form) & Richtungsangaben (7 exercises) ---
unit13_exercises.append({
    "id": 41065, "lesson_id": 11303, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "___ geradeaus bis zur Kreuzung! (Geh - Imperativ du)", "question_en": "Fill in imperative 'Geh'.", "question_ar": "صرف فعل الأمر مع du: \u2066'Geh'\u2069.", "question_es": "Rellena con imperativo 'Geh'."}, ensure_ascii=False),
    "audio_text": "Geh geradeaus bis zur Kreuzung!", "correct_answer": "Geh", "options": json.dumps(["Geh", "Gehst", "Gehen", "Geht"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit13_exercises.append({
    "id": 41066, "lesson_id": 11303, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "___ nach links ab! (Bieg - Imperativ du)", "question_en": "Fill in imperative 'Bieg'.", "question_ar": "صرف فعل الأمر مع du: \u2066'Bieg'\u2069.", "question_es": "Rellena con imperativo 'Bieg'."}, ensure_ascii=False),
    "audio_text": "Bieg nach links ab!", "correct_answer": "Bieg", "options": json.dumps(["Bieg", "Biegst", "Biegen", "Biegt"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit13_exercises.append({
    "id": 41067, "lesson_id": 11303, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "nah", "question_en": "What does 'nah' mean?", "question_ar": "ما معنى \u2066'nah'\u2069؟", "question_es": "¿Qué significa 'nah'?"}, ensure_ascii=False),
    "audio_text": "nah", "correct_answer": "close / near", "options": json.dumps(["close / near", "far away", "high", "low"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit13_exercises.append({
    "id": 41068, "lesson_id": 11303, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Fahr mit der U-Bahn, das ist schneller.", "question_en": "Listen and select the suggestion.", "question_ar": "استمع واختر النصيحة المقترحة.", "question_es": "Escucha y selecciona la sugerencia."}, ensure_ascii=False),
    "audio_text": "Fahr mit der U-Bahn, das ist schneller.", "correct_answer": "Fahr mit der U-Bahn, das ist schneller.", "options": json.dumps(["Fahr mit der U-Bahn, das ist schneller.", "Nimm ein Taxi zum Hotel.", "Geh zu Fuß zum Bahnhof.", "Warte auf den nächsten Bus."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit13_exercises.append({
    "id": 41069, "lesson_id": 11303, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "weit", "question_en": "What does 'weit' mean?", "question_ar": "ما معنى \u2066'weit'\u2069؟", "question_es": "¿Qué significa 'weit'?"}, ensure_ascii=False),
    "audio_text": "weit", "correct_answer": "far", "options": json.dumps(["far", "near", "fast", "slow"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit13_exercises.append({
    "id": 41070, "lesson_id": 11303, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Ist die Bank in der ___ ? (Nähe)", "question_en": "Fill in 'Nähe' (vicinity).", "question_ar": "املأ الفراغ بكلمة الجوار / القرب: \u2066'Nähe'\u2069.", "question_es": "Rellena con 'Nähe'."}, ensure_ascii=False),
    "audio_text": "Ist die Bank in der Nähe?", "correct_answer": "Nähe", "options": json.dumps(["Nähe", "Ferne", "Mitte", "Seite"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit13_exercises.append({
    "id": 41071, "lesson_id": 11303, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Fahr bitte vorsichtig!", "question_en": "Repeat: 'Fahr bitte vorsichtig!'", "question_ar": "ردد: \u2066'Fahr bitte vorsichtig!'\u2069", "question_es": "Repite: 'Fahr bitte vorsichtig!'"}, ensure_ascii=False),
    "audio_text": "Fahr bitte vorsichtig!", "correct_answer": "Fahr bitte vorsichtig!", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 11304: Grammatik: Perfekt mit haben und sein (7 exercises) ---
unit13_exercises.append({
    "id": 41072, "lesson_id": 11304, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Ich ___ gestern nach Berlin gefahren. (bin - Bewegung)", "question_en": "Fill in auxiliary 'bin' for movement.", "question_ar": "اختر الفعل المساعد مع فعل الحركة: \u2066'bin'\u2069.", "question_es": "Rellena con 'bin'."}, ensure_ascii=False),
    "audio_text": "Ich bin gestern nach Berlin gefahren.", "correct_answer": "bin", "options": json.dumps(["bin", "habe", "war", "hatte"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit13_exercises.append({
    "id": 41073, "lesson_id": 11304, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Wir haben eine Fahrkarte ___ . (gekauft)", "question_en": "Fill in Partizip II 'gekauft'.", "question_ar": "املأ الفراغ باسم المفعول: \u2066'gekauft'\u2069.", "question_es": "Rellena con 'gekauft'."}, ensure_ascii=False),
    "audio_text": "Wir haben eine Fahrkarte gekauft.", "correct_answer": "gekauft", "options": json.dumps(["gekauft", "kaufen", "kauft", "gekäuft"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit13_exercises.append({
    "id": 41074, "lesson_id": 11304, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "abfahren", "question_en": "What does 'abfahren' mean?", "question_ar": "ما معنى \u2066'abfahren'\u2069؟", "question_es": "¿Qué significa 'abfahren'?"}, ensure_ascii=False),
    "audio_text": "abfahren", "correct_answer": "to depart", "options": json.dumps(["to depart", "to arrive", "to stop", "to return"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit13_exercises.append({
    "id": 41075, "lesson_id": 11304, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Der Zug ist pünktlich angekommen.", "question_en": "Listen and select the sentence.", "question_ar": "استمع واختر الجملة المسموعة.", "question_es": "Escucha y selecciona la frase."}, ensure_ascii=False),
    "audio_text": "Der Zug ist pünktlich angekommen.", "correct_answer": "Der Zug ist pünktlich angekommen.", "options": json.dumps(["Der Zug ist pünktlich angekommen.", "Der Zug hat 20 Minuten Verspätung.", "Der Zug fällt heute leider aus.", "Wir sind zu spät gekommen."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit13_exercises.append({
    "id": 41076, "lesson_id": 11304, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "umsteigen", "question_en": "What does 'umsteigen' mean?", "question_ar": "ما معنى \u2066'umsteigen'\u2069؟", "question_es": "¿Qué significa 'umsteigen'?"}, ensure_ascii=False),
    "audio_text": "umsteigen", "correct_answer": "to change trains / buses", "options": json.dumps(["to change trains / buses", "to get in", "to get off", "to buy a ticket"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit13_exercises.append({
    "id": 41077, "lesson_id": 11304, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Sie sind nach Spanien ___ . (gereist)", "question_en": "Fill in 'gereist'.", "question_ar": "املأ الفراغ باسم المفعول: \u2066'gereist'\u2069.", "question_es": "Rellena con 'gereist'."}, ensure_ascii=False),
    "audio_text": "Sie sind nach Spanien gereist.", "correct_answer": "gereist", "options": json.dumps(["gereist", "reisen", "reist", "gereisen"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit13_exercises.append({
    "id": 41078, "lesson_id": 11304, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Ich bin gut angekommen.", "question_en": "Repeat: 'Ich bin gut angekommen.'", "question_ar": "ردد: \u2066'Ich bin gut angekommen.'\u2069", "question_es": "Repite: 'Ich bin gut angekommen.'"}, ensure_ascii=False),
    "audio_text": "Ich bin gut angekommen.", "correct_answer": "Ich bin gut angekommen.", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 11305: Am Bahnhof: Durchsagen & Fahrplan (7 exercises) ---
unit13_exercises.append({
    "id": 41079, "lesson_id": 11305, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Flughafen", "gender": "der", "question_en": "What does 'der Flughafen' mean?", "question_ar": "ما معنى \u2066'der Flughafen'\u2069؟", "question_es": "¿Qué significa 'der Flughafen'?"}, ensure_ascii=False),
    "audio_text": "der Flughafen", "correct_answer": "airport", "options": json.dumps(["airport", "station", "harbor", "highway"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit13_exercises.append({
    "id": 41080, "lesson_id": 11305, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Achtung an Gleis 2: Der ICE nach München fährt ein.", "question_en": "Listen and select the station announcement.", "question_ar": "استمع واختر إعلان المحطة.", "question_es": "Escucha y selecciona el anuncio de la estación."}, ensure_ascii=False),
    "audio_text": "Achtung an Gleis 2: Der ICE nach München fährt ein.", "correct_answer": "Achtung an Gleis 2: Der ICE nach München fährt ein.", "options": json.dumps(["Achtung an Gleis 2: Der ICE nach München fährt ein.", "Der Zug nach Köln hat Verspätung.", "Bitte alle Fahrgäste aussteigen.", "Der Zug nach Hamburg fällt heute aus."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit13_exercises.append({
    "id": 41081, "lesson_id": 11305, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Wir müssen in Hannover ___ . (umsteigen)", "question_en": "Fill in 'umsteigen' (change trains).", "question_ar": "املأ الفراغ بفعل تبديل القطار: \u2066'umsteigen'\u2069.", "question_es": "Rellena con 'umsteigen'."}, ensure_ascii=False),
    "audio_text": "Wir müssen in Hannover umsteigen.", "correct_answer": "umsteigen", "options": json.dumps(["umsteigen", "einsteigen", "aussteigen", "abfahren"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit13_exercises.append({
    "id": 41082, "lesson_id": 11305, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Fahrrad", "gender": "das", "question_en": "What does 'das Fahrrad' mean?", "question_ar": "ما معنى \u2066'das Fahrrad'\u2069؟", "question_es": "¿Qué significa 'das Fahrrad'?"}, ensure_ascii=False),
    "audio_text": "das Fahrrad", "correct_answer": "bicycle", "options": json.dumps(["bicycle", "car", "motorcycle", "train"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit13_exercises.append({
    "id": 41083, "lesson_id": 11305, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Sie müssen an der Haltestelle Stadtmitte aussteigen.", "question_en": "Listen and select where to get off.", "question_ar": "استمع واختر المحطة التي يجب النزول فيها.", "question_es": "Escucha y selecciona dónde bajarse."}, ensure_ascii=False),
    "audio_text": "Sie müssen an der Haltestelle Stadtmitte aussteigen.", "correct_answer": "Sie müssen an der Haltestelle Stadtmitte aussteigen.", "options": json.dumps(["Sie müssen an der Haltestelle Stadtmitte aussteigen.", "Sie müssen am Hauptbahnhof einsteigen.", "Der Bus fährt direkt zum Flughafen.", "Sie können hier sitzen bleiben."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit13_exercises.append({
    "id": 41084, "lesson_id": 11305, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Ich fahre gerne mit dem ___ . (Fahrrad)", "question_en": "Fill in 'Fahrrad'.", "question_ar": "املأ الفراغ بكلمة الدراجة: \u2066'Fahrrad'\u2069.", "question_es": "Rellena con 'Fahrrad'."}, ensure_ascii=False),
    "audio_text": "Ich fahre gerne mit dem Fahrrad.", "correct_answer": "Fahrrad", "options": json.dumps(["Fahrrad", "Flugzeug", "Schiff", "Hubschrauber"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit13_exercises.append({
    "id": 41085, "lesson_id": 11305, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Wann fährt der nächste Bus?", "question_en": "Repeat: 'Wann fährt der nächste Bus?'", "question_ar": "ردد: \u2066'Wann fährt der nächste Bus?'\u2069", "question_es": "Repite: 'Wann fährt der nächste Bus?'"}, ensure_ascii=False),
    "audio_text": "Wann fährt der nächste Bus?", "correct_answer": "Wann fährt der nächste Bus?", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 11306: Einheitstest: Weg & Verkehr (10 exercises) ---
test_pool_13 = [
    ("der Bahnhof", ["train station", "airport", "bus stop", "subway"], "train station", "match_pairs", "What does 'der Bahnhof' mean?", "ما معنى \u2066'der Bahnhof'\u2069؟", "¿Qué significa 'der Bahnhof'?"),
    ("die Fahrkarte", ["ticket", "passport", "map", "newspaper"], "ticket", "match_pairs", "What does 'die Fahrkarte' mean?", "ما معنى \u2066'die Fahrkarte'\u2069؟", "¿Qué significa 'die Fahrkarte'?"),
    ("Der Zug fährt von Gleis 4 ab.", ["Der Zug fährt von Gleis 4 ab.", "Der Bus kommt um 4 Uhr an.", "Das Flugzeug startet um 4 Uhr.", "Der Zug hat Verspätung."], "Der Zug fährt von Gleis 4 ab.", "listen_choose", "Listen to platform announcement.", "استمع لإعلان الرصيف.", "Escucha el anuncio de la vía."),
    ("Geh geradeaus bis zur Kreuzung!", ["Geh", "Gehst", "Gehen", "Geht"], "Geh", "type_fill_blank", "Fill in imperative 'Geh'.", "صرف فعل الأمر: \u2066'Geh'\u2069.", "Elige 'Geh'."),
    ("geradeaus", ["straight ahead", "to the left", "to the right", "backwards"], "straight ahead", "match_pairs", "What does 'geradeaus' mean?", "ما معنى \u2066'geradeaus'\u2069؟", "¿Qué significa 'geradeaus'?"),
    ("Ich bin gestern nach Berlin gefahren.", ["bin", "habe", "war", "hatte"], "bin", "type_fill_blank", "Fill in 'bin' for movement.", "اختر الفعل المساعد مع الحركة: \u2066'bin'\u2069.", "Elige 'bin'."),
    ("Wir haben eine Fahrkarte gekauft.", ["gekauft", "kaufen", "kauft", "gekäuft"], "gekauft", "type_fill_blank", "Fill in 'gekauft'.", "املأ الفراغ باسم المفعول: \u2066'gekauft'\u2069.", "Elige 'gekauft'."),
    ("Achtung an Gleis 2: Der ICE nach München fährt ein.", ["Achtung an Gleis 2: Der ICE nach München fährt ein.", "Der Zug nach Köln hat Verspätung.", "Alle Fahrgäste aussteigen.", "Der Zug fällt heute aus."], "Achtung an Gleis 2: Der ICE nach München fährt ein.", "listen_choose", "Listen to station announcement.", "استمع لإعلان المحطة.", "Escucha el anuncio."),
    ("Eine Fahrkarte nach Hamburg, bitte.", None, "Eine Fahrkarte nach Hamburg, bitte.", "repeat_prompt", "Repeat: 'Eine Fahrkarte nach Hamburg, bitte.'", "ردد: \u2066'Eine Fahrkarte nach Hamburg, bitte.'\u2069", "Repite: 'Eine Fahrkarte nach Hamburg, bitte.'"),
    ("An der Ampel biegen Sie nach rechts ab.", ["rechts", "oben", "unten", "weit"], "rechts", "type_fill_blank", "Fill in 'rechts'.", "املأ الفراغ بكلمة يميناً: \u2066'rechts'\u2069.", "Rellena con 'rechts'.")
]

for idx, (audio, opts, ans, extype, q_en, q_ar, q_es) in enumerate(test_pool_13, start=1):
    unit13_exercises.append({
        "id": 41085 + idx,
        "lesson_id": 11306,
        "passage_id": None,
        "skill": "listening" if extype == "listen_choose" else ("speaking" if extype == "repeat_prompt" else "reading"),
        "exercise_type": extype,
        "prompt": json.dumps({
            "de": audio,
            "question_en": f"Unit 13 Test ({idx}/10): {q_en}",
            "question_ar": f"اختبار الوحدة 13 ({idx}/10): {q_ar}",
            "question_es": f"Test Unidad 13 ({idx}/10): {q_es}"
        }, ensure_ascii=False),
        "audio_text": audio,
        "correct_answer": ans,
        "options": json.dumps(opts, ensure_ascii=False) if opts else None,
        "is_graded": 1,
        "is_test_pool": 1,
        "sort_order": idx
    })

for ex in unit13_exercises:
    if ex["id"] not in existing_ex_ids:
        data["exercises"].append(ex)
        existing_ex_ids.add(ex["id"])

with open(CONTENT_PATH, "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print(f"Successfully built Unit 13 (Weg & Verkehr)! Total exercises added: {len(unit13_exercises)}")
