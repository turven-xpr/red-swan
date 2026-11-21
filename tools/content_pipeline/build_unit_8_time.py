import json
from pathlib import Path

CONTENT_PATH = Path(r"c:\Users\HP\3D Objects\Deutschy-main\Deutschy-main\assets\deutschy_content.json")

with open(CONTENT_PATH, "r", encoding="utf-8") as f:
    data = json.load(f)

# 1. Register Unit 8
if not any(u["id"] == 50004 for u in data["units"]):
    data["units"].append({
        "id": 50004,
        "level": "A1",
        "unit_number": 8,
        "title_de": "Tagesablauf & Zeit",
        "title_en": "Daily Routine & Time",
        "title_ar": "الروتين اليومي والوقت",
        "title_es": "Rutina diaria y la hora",
        "topic_key": "daily_routine"
    })

# 2. Add Vocabulary for Unit 8 (IDs 1170-1194)
unit8_words = [
    {"id": 1170, "lemma": "Uhr", "level": "A1", "topic": "daily_routine", "pos": "noun", "gender": "die", "plural": "Uhren", "conjugation": None, "translation_en": "clock / o'clock", "translation_ar": "ساعة (وقت أو حائط)", "translation_es": "reloj / hora", "frequency_rank": 170},
    {"id": 1171, "lemma": "Stunde", "level": "A1", "topic": "daily_routine", "pos": "noun", "gender": "die", "plural": "Stunden", "conjugation": None, "translation_en": "hour", "translation_ar": "ساعة (مدة زمنية)", "translation_es": "hora (duración)", "frequency_rank": 171},
    {"id": 1172, "lemma": "Tag", "level": "A1", "topic": "daily_routine", "pos": "noun", "gender": "der", "plural": "Tage", "conjugation": None, "translation_en": "day", "translation_ar": "يوم", "translation_es": "día", "frequency_rank": 172},
    {"id": 1173, "lemma": "Woche", "level": "A1", "topic": "daily_routine", "pos": "noun", "gender": "die", "plural": "Wochen", "conjugation": None, "translation_en": "week", "translation_ar": "أسبوع", "translation_es": "semana", "frequency_rank": 173},
    {"id": 1174, "lemma": "Monat", "level": "A1", "topic": "daily_routine", "pos": "noun", "gender": "der", "plural": "Monate", "conjugation": None, "translation_en": "month", "translation_ar": "شهر", "translation_es": "mes", "frequency_rank": 174},
    {"id": 1175, "lemma": "Jahr", "level": "A1", "topic": "daily_routine", "pos": "noun", "gender": "das", "plural": "Jahre", "conjugation": None, "translation_en": "year", "translation_ar": "سنة", "translation_es": "año", "frequency_rank": 175},
    {"id": 1176, "lemma": "Termin", "level": "A1", "topic": "daily_routine", "pos": "noun", "gender": "der", "plural": "Termine", "conjugation": None, "translation_en": "appointment", "translation_ar": "موعد", "translation_es": "cita", "frequency_rank": 176},
    {"id": 1177, "lemma": "Zeit", "level": "A1", "topic": "daily_routine", "pos": "noun", "gender": "die", "plural": None, "conjugation": None, "translation_en": "time", "translation_ar": "وقت", "translation_es": "tiempo", "frequency_rank": 177},
    {"id": 1178, "lemma": "Morgen", "level": "A1", "topic": "daily_routine", "pos": "noun", "gender": "der", "plural": None, "conjugation": None, "translation_en": "morning", "translation_ar": "صباح", "translation_es": "mañana (parte del día)", "frequency_rank": 178},
    {"id": 1179, "lemma": "Abend", "level": "A1", "topic": "daily_routine", "pos": "noun", "gender": "der", "plural": "Abende", "conjugation": None, "translation_en": "evening", "translation_ar": "مساء", "translation_es": "tarde / noche", "frequency_rank": 179},
    {"id": 1180, "lemma": "Nacht", "level": "A1", "topic": "daily_routine", "pos": "noun", "gender": "die", "plural": "Nächte", "conjugation": None, "translation_en": "night", "translation_ar": "ليل", "translation_es": "noche", "frequency_rank": 180},
    {"id": 1181, "lemma": "Brief", "level": "A1", "topic": "daily_routine", "pos": "noun", "gender": "der", "plural": "Briefe", "conjugation": None, "translation_en": "letter", "translation_ar": "رسالة بريدية", "translation_es": "carta", "frequency_rank": 181},
    {"id": 1182, "lemma": "Einladung", "level": "A1", "topic": "daily_routine", "pos": "noun", "gender": "die", "plural": "Einladungen", "conjugation": None, "translation_en": "invitation", "translation_ar": "دعوة", "translation_es": "invitación", "frequency_rank": 182},
    {"id": 1183, "lemma": "aufstehen", "level": "A1", "topic": "daily_routine", "pos": "verb", "gender": None, "plural": None, "conjugation": "steht auf", "translation_en": "to get up", "translation_ar": "يستيقظ / ينهض", "translation_es": "levantarse", "frequency_rank": 183},
    {"id": 1184, "lemma": "anfangen", "level": "A1", "topic": "daily_routine", "pos": "verb", "gender": None, "plural": None, "conjugation": "fängt an", "translation_en": "to begin / start", "translation_ar": "يبدأ", "translation_es": "empezar", "frequency_rank": 184},
    {"id": 1185, "lemma": "aufhören", "level": "A1", "topic": "daily_routine", "pos": "verb", "gender": None, "plural": None, "conjugation": "hört auf", "translation_en": "to stop / end", "translation_ar": "ينتهي / يتوقف", "translation_es": "terminar", "frequency_rank": 185},
    {"id": 1186, "lemma": "schlafen", "level": "A1", "topic": "daily_routine", "pos": "verb", "gender": None, "plural": None, "conjugation": "du schläfst, er schläft", "translation_en": "to sleep", "translation_ar": "ينام", "translation_es": "dormir", "frequency_rank": 186},
    {"id": 1187, "lemma": "können", "level": "A1", "topic": "daily_routine", "pos": "verb", "gender": None, "plural": None, "conjugation": "kann, kannst, kann, können", "translation_en": "can / to be able to", "translation_ar": "يستطيع", "translation_es": "poder", "frequency_rank": 187},
    {"id": 1188, "lemma": "müssen", "level": "A1", "topic": "daily_routine", "pos": "verb", "gender": None, "plural": None, "conjugation": "muss, musst, muss, müssen", "translation_en": "must / to have to", "translation_ar": "يجب / يضطر", "translation_es": "deber / tener que", "frequency_rank": 188},
    {"id": 1189, "lemma": "wollen", "level": "A1", "topic": "daily_routine", "pos": "verb", "gender": None, "plural": None, "conjugation": "will, willst, will, wollen", "translation_en": "to want", "translation_ar": "يريد", "translation_es": "querer", "frequency_rank": 189},
    {"id": 1190, "lemma": "einladen", "level": "A1", "topic": "daily_routine", "pos": "verb", "gender": None, "plural": None, "conjugation": "lädt ein", "translation_en": "to invite", "translation_ar": "يدعو", "translation_es": "invitar", "frequency_rank": 190},
    {"id": 1191, "lemma": "heute", "level": "A1", "topic": "daily_routine", "pos": "adverb", "gender": None, "plural": None, "conjugation": None, "translation_en": "today", "translation_ar": "اليوم", "translation_es": "hoy", "frequency_rank": 191},
    {"id": 1192, "lemma": "morgen", "level": "A1", "topic": "daily_routine", "pos": "adverb", "gender": None, "plural": None, "conjugation": None, "translation_en": "tomorrow", "translation_ar": "غداً", "translation_es": "mañana", "frequency_rank": 192},
    {"id": 1193, "lemma": "gestern", "level": "A1", "topic": "daily_routine", "pos": "adverb", "gender": None, "plural": None, "conjugation": None, "translation_en": "yesterday", "translation_ar": "أمس", "translation_es": "ayer", "frequency_rank": 193},
    {"id": 1194, "lemma": "spät", "level": "A1", "topic": "daily_routine", "pos": "adjective", "gender": None, "plural": None, "conjugation": None, "translation_en": "late", "translation_ar": "متأخر", "translation_es": "tarde", "frequency_rank": 194},
]

existing_w_ids = {w["id"] for w in data["words"]}
for w in unit8_words:
    if w["id"] not in existing_w_ids:
        data["words"].append(w)

# 3. Add Lessons for Unit 8 (10801 - 10806)
unit8_lessons = [
    {
        "id": 10801, "unit_id": 50004, "level": "A1", "title_de": "Die Uhrzeit & Tageszeiten", "title_en": "Telling Time & Times of Day",
        "sort_order": 1, "lesson_type": "vocabulary", "pass_threshold": 0.7, "grammar_content": None, "content_json": None
    },
    {
        "id": 10802, "unit_id": 50004, "level": "A1", "title_de": "Mein Tagesablauf & Gewohnheiten", "title_en": "Daily Routine & Habits",
        "sort_order": 2, "lesson_type": "vocabulary", "pass_threshold": 0.7, "grammar_content": None, "content_json": None
    },
    {
        "id": 10803, "unit_id": 50004, "level": "A1", "title_de": "Grammatik: Zeitangaben mit um, am & im", "title_en": "Grammar: Time Prepositions (um, am, im)",
        "sort_order": 3, "lesson_type": "grammar", "pass_threshold": 0.7,
        "grammar_content": "# حروف الجر الزمنية — Zeitangaben: um, am, im\n# German Time Prepositions\n\n## 🇩🇪 Deutsch | 🇬🇧 English | 🇸🇦 عربي\n\nفي الألمانية نستخدم حروف جر محددة بدقة مع الأوقات والأيام والشهور:\nIn German, specific prepositions are used for exact times, days, and months:\n\n### 1. حرف الجر um (مع الساعة المحددة):\n- *Der Kurs beginnt **um 8 Uhr**.* (يبدأ الكورس في تمام الساعة الثامنة)\n- *Um wie viel Uhr?* (في أي ساعة؟)\n\n### 2. حرف الجر am (مع الأيام وأوقات اليوم):\n- *Ich habe **am Montag** frei.* (أنا في عطلة يوم الإثنين)\n- *Wir lernen **am Morgen**.* (نتعلم في الصباح)\n- *Er kommt **am Abend**.* (هو يأتي في المساء)\n*(استثناء: في الليل = in der Nacht)*\n\n### 3. حرف الجر im (مع الشهور وفصول السنة):\n- *Mein Geburtstag ist **im Mai**.* (عيد ميلادي في شهر مايو)\n- *Es ist heiß **im Sommer**.* (الجو حار في الصيف)",
        "content_json": None
    },
    {
        "id": 10804, "unit_id": 50004, "level": "A1", "title_de": "Modalverben: können, müssen & wollen", "title_en": "Modal Verbs & Sentence Bracket",
        "sort_order": 4, "lesson_type": "grammar", "pass_threshold": 0.7,
        "grammar_content": "# الأفعال الناقصة وقوس الجملة — Modalverben: können, müssen, wollen\n# German Modal Verbs & Sentence Bracket\n\n## 🇩🇪 Deutsch | 🇬🇧 English | 🇸🇦 عربي\n\nالأفعال الناقصة (Modalverben) تأتي في المركز الثاني من الجملة وتُصرَّف مع الفاعل، بينما يذهب الفعل الأساسي إلى **نهاية الجملة في صيغة المصدر (Infinitiv)**:\nModal verbs are placed in Position 2 (conjugated), and the main action verb is pushed to the **very end of the sentence in its infinitive form**:\n\n### تصريف الأفعال الثلاثة:\n| الضمير | können (يستطيع) | müssen (يجب) | wollen (يريد) |\n|---|---|---|---|\n| **ich** | **kann** | **muss** | **will** |\n| **du** | **kannst** | **musst** | **willst** |\n| **er / sie / es** | **kann** | **muss** | **will** |\n| **wir** | **können** | **müssen** | **wollen** |\n| **ihr** | **könnt** | **müsst** | **wollt** |\n| **Sie / sie** | **können** | **müssen** | **wollen** |\n\n### أمثلة على قوس الجملة (Satzklammer):\n- *Ich **kann** sehr gut Deutsch **sprechen**.*\n- *Wir **müssen** heute bis 18 Uhr **arbeiten**.*\n- *Er **will** eine neue Sprache **lernen**.*",
        "content_json": None
    },
    {
        "id": 10805, "unit_id": 50004, "level": "A1", "title_de": "Briefe & E-Mails: Goethe Schreiben Teil 2", "title_en": "Letters & Emails: Goethe Writing Task 2",
        "sort_order": 5, "lesson_type": "text", "pass_threshold": 0.7,
        "grammar_content": "# نموذج كتابة الرسالة والبريد الإلكتروني — Goethe Schreiben Teil 2\n# Formal and Informal Letter Formulas\n\n## 🇩🇪 Deutsch | 🇬🇧 English | 🇸🇦 عربي\n\nفي اختبار جوته A1، يُطلب منك كتابة رسالة قصيرة (~30 كلمة) تحتوي على 3 نقاط أساسية (سبب الكتابة، موعد/مكان، تأكيد/طلب).\nIn the Goethe A1 exam, you write a short ~30-word note addressing 3 bullet points.\n\n### 1. التحية (Anrede):\n- غير رسمي (صديق): *Lieber Thomas,* (لمذكر) / *Liebe Anna,* (لمؤنث)\n- رسمي (جهة عمل / فندق): *Sehr geehrte Damen und Herren,* / *Sehr geehrter Herr Müller,*\n\n### 2. عبارات الدعوة والرد:\n- الدعوة: *Ich lade dich herzlich zu meiner Party ein.* (أدعوك لحفلتي)\n- الشكر: *Vielen Dank für die Einladung.* (شكراً جزيلاً على الدعوة)\n- الاعتذار: *Ich kann leider nicht kommen, weil ich arbeiten muss.* (للأسف لا أستطيع المجيء)\n\n### 3. الخاتمة والتوقيع (Grußformel):\n- غير رسمي: *Viele Grüße / Herzliche Grüße*\n- رسمي: *Mit freundlichen Grüßen*",
        "content_json": None
    },
    {
        "id": 10806, "unit_id": 50004, "level": "A1", "title_de": "Einheitstest: Tagesablauf & Zeit", "title_en": "Unit Test: Daily Routine & Time",
        "sort_order": 6, "lesson_type": "unit_test", "pass_threshold": 0.75, "grammar_content": None, "content_json": None
    }
]

existing_l_ids = {l["id"] for l in data["lessons"]}
for l in unit8_lessons:
    if l["id"] not in existing_l_ids:
        data["lessons"].append(l)

# 4. Add Exercises for Unit 8 (40601 - 40645)
existing_ex_ids = {e["id"] for e in data["exercises"]}
unit8_exercises = []

# --- LESSON 10801: Die Uhrzeit & Tageszeiten (7 exercises) ---
unit8_exercises.append({
    "id": 40601, "lesson_id": 10801, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Uhr", "gender": "die", "question_en": "What does 'die Uhr' mean?", "question_ar": "ما معنى \u2066'die Uhr'\u2069؟", "question_es": "¿Qué significa 'die Uhr'?"}, ensure_ascii=False),
    "audio_text": "die Uhr", "correct_answer": "clock / o'clock", "options": json.dumps(["clock / o'clock", "day", "week", "month"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit8_exercises.append({
    "id": 40602, "lesson_id": 10801, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Es ist acht Uhr.", "question_en": "Listen and select the time.", "question_ar": "استمع واختر الوقت المسموع.", "question_es": "Escucha y selecciona la hora."}, ensure_ascii=False),
    "audio_text": "Es ist acht Uhr.", "correct_answer": "Es ist acht Uhr.", "options": json.dumps(["Es ist acht Uhr.", "Es ist zehn Uhr.", "Es ist zwei Uhr.", "Es ist vier Uhr."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit8_exercises.append({
    "id": 40603, "lesson_id": 10801, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Stunde", "gender": "die", "question_en": "What does 'die Stunde' mean?", "question_ar": "ما معنى \u2066'die Stunde'\u2069؟", "question_es": "¿Qué significa 'die Stunde'?"}, ensure_ascii=False),
    "audio_text": "die Stunde", "correct_answer": "hour", "options": json.dumps(["hour", "minute", "day", "year"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit8_exercises.append({
    "id": 40604, "lesson_id": 10801, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Wie ___ ist es? (spät)", "question_en": "Fill in the question word 'spät' for asking time.", "question_ar": "املأ الفراغ بكلمة السؤال عن الوقت: \u2066'spät'\u2069.", "question_es": "Rellena con 'spät'."}, ensure_ascii=False),
    "audio_text": "Wie spät ist es?", "correct_answer": "spät", "options": json.dumps(["spät", "früh", "viel", "alt"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit8_exercises.append({
    "id": 40605, "lesson_id": 10801, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Abend", "gender": "der", "question_en": "What does 'der Abend' mean?", "question_ar": "ما معنى \u2066'der Abend'\u2069؟", "question_es": "¿Qué significa 'der Abend'?"}, ensure_ascii=False),
    "audio_text": "der Abend", "correct_answer": "evening", "options": json.dumps(["evening", "morning", "night", "noon"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit8_exercises.append({
    "id": 40606, "lesson_id": 10801, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Wir treffen uns am ___ . (Morgen)", "question_en": "Fill in 'Morgen' (morning).", "question_ar": "املأ الفراغ بكلمة الصباح: \u2066'Morgen'\u2069.", "question_es": "Rellena con 'Morgen'."}, ensure_ascii=False),
    "audio_text": "Wir treffen uns am Morgen.", "correct_answer": "Morgen", "options": json.dumps(["Morgen", "Nacht", "Uhr", "Tag"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit8_exercises.append({
    "id": 40607, "lesson_id": 10801, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Wie spät ist es, bitte?", "question_en": "Repeat politely: 'Wie spät ist es, bitte?'", "question_ar": "ردد بأدب: \u2066'Wie spät ist es, bitte?'\u2069", "question_es": "Repite: 'Wie spät ist es, bitte?'"}, ensure_ascii=False),
    "audio_text": "Wie spät ist es, bitte?", "correct_answer": "Wie spät ist es, bitte?", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 10802: Mein Tagesablauf & Gewohnheiten (7 exercises) ---
unit8_exercises.append({
    "id": 40608, "lesson_id": 10802, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "aufstehen", "question_en": "What does 'aufstehen' mean?", "question_ar": "ما معنى \u2066'aufstehen'\u2069؟", "question_es": "¿Qué significa 'aufstehen'?"}, ensure_ascii=False),
    "audio_text": "aufstehen", "correct_answer": "to get up", "options": json.dumps(["to get up", "to sleep", "to start", "to stop"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit8_exercises.append({
    "id": 40609, "lesson_id": 10802, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Ich stehe jeden Tag um 7 Uhr ___ . (auf)", "question_en": "Complete separable verb 'aufstehen' with 'auf'.", "question_ar": "أكمل الفعل المنفصل \u2066aufstehen\u2069 بكلمة: \u2066'auf'\u2069.", "question_es": "Completa el verbo separable con 'auf'."}, ensure_ascii=False),
    "audio_text": "Ich stehe jeden Tag um 7 Uhr auf.", "correct_answer": "auf", "options": json.dumps(["auf", "an", "aus", "ein"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit8_exercises.append({
    "id": 40610, "lesson_id": 10802, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Der Kurs fängt um 9 Uhr an.", "question_en": "Listen and select the course start time.", "question_ar": "استمع واختر موعد بدء الكورس.", "question_es": "Escucha y selecciona la hora de inicio."}, ensure_ascii=False),
    "audio_text": "Der Kurs fängt um 9 Uhr an.", "correct_answer": "Der Kurs fängt um 9 Uhr an.", "options": json.dumps(["Der Kurs fängt um 9 Uhr an.", "Der Kurs fängt um 8 Uhr an.", "Der Kurs hört um 9 Uhr auf.", "Ich gehe um 9 Uhr schlafen."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit8_exercises.append({
    "id": 40611, "lesson_id": 10802, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "schlafen", "question_en": "What does verb 'schlafen' mean?", "question_ar": "ما معنى الفعل \u2066'schlafen'\u2069؟", "question_es": "¿Qué significa 'schlafen'?"}, ensure_ascii=False),
    "audio_text": "schlafen", "correct_answer": "to sleep", "options": json.dumps(["to sleep", "to eat", "to work", "to drive"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit8_exercises.append({
    "id": 40612, "lesson_id": 10802, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Wann ___ die Arbeit auf? (hört - aufhören)", "question_en": "Conjugate 'aufhören' for 'die Arbeit': hört.", "question_ar": "صرف الفعل \u2066aufhören\u2069 مع العمل: \u2066'hört'\u2069.", "question_es": "Conjuga 'aufhören': hört."}, ensure_ascii=False),
    "audio_text": "Wann hört die Arbeit auf?", "correct_answer": "hört", "options": json.dumps(["hört", "fängt", "steht", "geht"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit8_exercises.append({
    "id": 40613, "lesson_id": 10802, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Termin", "gender": "der", "question_en": "What does 'der Termin' mean?", "question_ar": "ما معنى \u2066'der Termin'\u2069؟", "question_es": "¿Qué significa 'der Termin'?"}, ensure_ascii=False),
    "audio_text": "der Termin", "correct_answer": "appointment", "options": json.dumps(["appointment", "letter", "party", "test"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit8_exercises.append({
    "id": 40614, "lesson_id": 10802, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Ich habe heute einen Termin beim Arzt.", "question_en": "Repeat: 'Ich habe heute einen Termin beim Arzt.'", "question_ar": "ردد: \u2066'Ich habe heute einen Termin beim Arzt.'\u2069", "question_es": "Repite: 'Ich habe heute einen Termin beim Arzt.'"}, ensure_ascii=False),
    "audio_text": "Ich habe heute einen Termin beim Arzt.", "correct_answer": "Ich habe heute einen Termin beim Arzt.", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 10803: Grammatik: Zeitangaben mit um, am & im (7 exercises) ---
unit8_exercises.append({
    "id": 40615, "lesson_id": 10803, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Der Film beginnt ___ 20 Uhr. (um - Uhrzeit)", "question_en": "Choose preposition 'um' for exact clock time.", "question_ar": "اختر حرف الجر مع التوقيت بالساعة: \u2066'um'\u2069.", "question_es": "Elige la preposición 'um' para la hora."}, ensure_ascii=False),
    "audio_text": "Der Film beginnt um 20 Uhr.", "correct_answer": "um", "options": json.dumps(["um", "am", "im", "an"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit8_exercises.append({
    "id": 40616, "lesson_id": 10803, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Ich habe ___ Montag Deutschkurs. (am - Wochentag)", "question_en": "Choose preposition 'am' for days of the week.", "question_ar": "اختر حرف الجر مع أيام الأسبوع: \u2066'am'\u2069.", "question_es": "Elige 'am' para los días de la semana."}, ensure_ascii=False),
    "audio_text": "Ich habe am Montag Deutschkurs.", "correct_answer": "am", "options": json.dumps(["am", "um", "im", "in"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit8_exercises.append({
    "id": 40617, "lesson_id": 10803, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Mein Geburtstag ist ___ Mai. (im - Monat)", "question_en": "Choose preposition 'im' for months.", "question_ar": "اختر حرف الجر مع الشهور: \u2066'im'\u2069.", "question_es": "Elige 'im' para los meses."}, ensure_ascii=False),
    "audio_text": "Mein Geburtstag ist im Mai.", "correct_answer": "im", "options": json.dumps(["im", "am", "um", "an"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit8_exercises.append({
    "id": 40618, "lesson_id": 10803, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Wir kochen am Abend zusammen.", "question_en": "Listen and select the sentence.", "question_ar": "استمع واختر الجملة المسموعة.", "question_es": "Escucha y selecciona la frase."}, ensure_ascii=False),
    "audio_text": "Wir kochen am Abend zusammen.", "correct_answer": "Wir kochen am Abend zusammen.", "options": json.dumps(["Wir kochen am Abend zusammen.", "Wir kochen am Morgen zusammen.", "Wir essen um 8 Uhr Brot.", "Wir arbeiten am Montag."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit8_exercises.append({
    "id": 40619, "lesson_id": 10803, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "gestern", "question_en": "What does 'gestern' mean?", "question_ar": "ما معنى \u2066'gestern'\u2069؟", "question_es": "¿Qué significa 'gestern'?"}, ensure_ascii=False),
    "audio_text": "gestern", "correct_answer": "yesterday", "options": json.dumps(["yesterday", "today", "tomorrow", "now"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit8_exercises.append({
    "id": 40620, "lesson_id": 10803, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "___ wie viel Uhr beginnt der Kurs? (Um)", "question_en": "Fill in question preposition 'Um'.", "question_ar": "املأ الفراغ بحرف الجر في أول السؤال: \u2066'Um'\u2069.", "question_es": "Rellena con 'Um'."}, ensure_ascii=False),
    "audio_text": "Um wie viel Uhr beginnt der Kurs?", "correct_answer": "Um", "options": json.dumps(["Um", "Am", "Im", "Wie"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit8_exercises.append({
    "id": 40621, "lesson_id": 10803, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Ich habe am Wochenende Zeit.", "question_en": "Repeat: 'Ich habe am Wochenende Zeit.'", "question_ar": "ردد: \u2066'Ich habe am Wochenende Zeit.'\u2069", "question_es": "Repite: 'Ich habe am Wochenende Zeit.'"}, ensure_ascii=False),
    "audio_text": "Ich habe am Wochenende Zeit.", "correct_answer": "Ich habe am Wochenende Zeit.", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 10804: Modalverben: können, müssen & wollen (7 exercises) ---
unit8_exercises.append({
    "id": 40622, "lesson_id": 10804, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Ich ___ gut Deutsch sprechen. (können - ich kann)", "question_en": "Conjugate modal 'können' for 'ich': kann.", "question_ar": "صرف الفعل الناقص \u2066können\u2069 مع \u2066ich\u2069: \u2066'kann'\u2069.", "question_es": "Conjuga 'können' para 'ich': kann."}, ensure_ascii=False),
    "audio_text": "Ich kann gut Deutsch sprechen.", "correct_answer": "kann", "options": json.dumps(["kann", "kannst", "können", "könnt"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit8_exercises.append({
    "id": 40623, "lesson_id": 10804, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Du ___ heute lange arbeiten. (müssen - du musst)", "question_en": "Conjugate 'müssen' for 'du': musst.", "question_ar": "صرف الفعل الناقص \u2066müssen\u2069 مع \u2066du\u2069: \u2066'musst'\u2069.", "question_es": "Conjuga 'müssen' para 'du': musst."}, ensure_ascii=False),
    "audio_text": "Du musst heute lange arbeiten.", "correct_answer": "musst", "options": json.dumps(["musst", "muss", "müsst", "müssen"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit8_exercises.append({
    "id": 40624, "lesson_id": 10804, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Wir wollen eine Reise machen.", "question_en": "Listen and select what they want to do.", "question_ar": "استمع واختر ما يريدون فعله.", "question_es": "Escucha y selecciona lo que quieren hacer."}, ensure_ascii=False),
    "audio_text": "Wir wollen eine Reise machen.", "correct_answer": "Wir wollen eine Reise machen.", "options": json.dumps(["Wir wollen eine Reise machen.", "Wir müssen heute arbeiten.", "Wir können Deutsch lernen.", "Wir wollen zu Hause bleiben."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit8_exercises.append({
    "id": 40625, "lesson_id": 10804, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Er will ein Auto ___ . (kaufen - Infinitiv am Satzende)", "question_en": "Place infinitive 'kaufen' at the end of the sentence bracket.", "question_ar": "ضع المصدر في نهاية قوس الجملة: \u2066'kaufen'\u2069.", "question_es": "Coloca el infinitivo 'kaufen' al final."}, ensure_ascii=False),
    "audio_text": "Er will ein Auto kaufen.", "correct_answer": "kaufen", "options": json.dumps(["kaufen", "kauft", "kaufte", "gekauft"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit8_exercises.append({
    "id": 40626, "lesson_id": 10804, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "müssen", "question_en": "What does 'müssen' mean?", "question_ar": "ما معنى \u2066'müssen'\u2069؟", "question_es": "¿Qué significa 'müssen'?"}, ensure_ascii=False),
    "audio_text": "müssen", "correct_answer": "must / to have to", "options": json.dumps(["must / to have to", "can / to be able to", "to want", "to like"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit8_exercises.append({
    "id": 40627, "lesson_id": 10804, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "___ du morgen mitkommen? (Kannst - können)", "question_en": "Fill in question modal 'Kannst'.", "question_ar": "املأ الفراغ بفعل الاستطاعة في السؤال: \u2066'Kannst'\u2069.", "question_es": "Rellena con 'Kannst'."}, ensure_ascii=False),
    "audio_text": "Kannst du morgen mitkommen?", "correct_answer": "Kannst", "options": json.dumps(["Kannst", "Musst", "Willst", "Darfst"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit8_exercises.append({
    "id": 40628, "lesson_id": 10804, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Ich kann leider nicht kommen.", "question_en": "Repeat: 'Ich kann leider nicht kommen.'", "question_ar": "ردد: \u2066'Ich kann leider nicht kommen.'\u2069", "question_es": "Repite: 'Ich kann leider nicht kommen.'"}, ensure_ascii=False),
    "audio_text": "Ich kann leider nicht kommen.", "correct_answer": "Ich kann leider nicht kommen.", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 10805: Briefe & E-Mails: Goethe Schreiben Teil 2 (7 exercises) ---
unit8_exercises.append({
    "id": 40629, "lesson_id": 10805, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Einladung", "gender": "die", "question_en": "What does 'die Einladung' mean?", "question_ar": "ما معنى \u2066'die Einladung'\u2069؟", "question_es": "¿Qué significa 'die Einladung'?"}, ensure_ascii=False),
    "audio_text": "die Einladung", "correct_answer": "invitation", "options": json.dumps(["invitation", "appointment", "letter", "bill"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit8_exercises.append({
    "id": 40630, "lesson_id": 10805, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "___ Anna, wie geht es dir? (Liebe - Anrede an eine Frau)", "question_en": "Fill in informal salutation for a woman: 'Liebe'.", "question_ar": "املأ الفراغ بالتحية الودية للمؤنث: \u2066'Liebe'\u2069.", "question_es": "Rellena el saludo informal femenino con 'Liebe'."}, ensure_ascii=False),
    "audio_text": "Liebe Anna, wie geht es dir?", "correct_answer": "Liebe", "options": json.dumps(["Liebe", "Lieber", "Sehr", "Viele"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit8_exercises.append({
    "id": 40631, "lesson_id": 10805, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "___ Thomas, vielen Dank für deinen Brief! (Lieber - Anrede an einen Mann)", "question_en": "Fill in informal salutation for a man: 'Lieber'.", "question_ar": "املأ الفراغ بالتحية الودية للمذكر: \u2066'Lieber'\u2069.", "question_es": "Rellena el saludo informal masculino con 'Lieber'."}, ensure_ascii=False),
    "audio_text": "Lieber Thomas, vielen Dank für deinen Brief!", "correct_answer": "Lieber", "options": json.dumps(["Lieber", "Liebe", "Sehr", "Herzlich"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit8_exercises.append({
    "id": 40632, "lesson_id": 10805, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Ich lade dich herzlich zu meiner Geburtstagsparty ein.", "question_en": "Listen and select the invitation phrase.", "question_ar": "استمع واختر جملة الدعوة.", "question_es": "Escucha y selecciona la invitación."}, ensure_ascii=False),
    "audio_text": "Ich lade dich herzlich zu meiner Geburtstagsparty ein.", "correct_answer": "Ich lade dich herzlich zu meiner Geburtstagsparty ein.", "options": json.dumps(["Ich lade dich herzlich zu meiner Geburtstagsparty ein.", "Ich danke dir für die Einladung.", "Ich kann leider nicht zur Party kommen.", "Ich habe heute keinen Geburtstag."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit8_exercises.append({
    "id": 40633, "lesson_id": 10805, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Vielen Dank ___ die Einladung! (für)", "question_en": "Fill in preposition 'für' after Dank.", "question_ar": "املأ الفراغ بحرف الجر بعد الشكر: \u2066'für'\u2069.", "question_es": "Rellena con 'für'."}, ensure_ascii=False),
    "audio_text": "Vielen Dank für die Einladung!", "correct_answer": "für", "options": json.dumps(["für", "an", "von", "mit"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit8_exercises.append({
    "id": 40634, "lesson_id": 10805, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Viele Grüße", "question_en": "What does closing formula 'Viele Grüße' mean?", "question_ar": "ما معنى خاتمة الرسالة \u2066'Viele Grüße'\u2069؟", "question_es": "¿Qué significa 'Viele Grüße'?"}, ensure_ascii=False),
    "audio_text": "Viele Grüße", "correct_answer": "Best regards / Many greetings", "options": json.dumps(["Best regards / Many greetings", "Dear friend", "Thank you very much", "Good night"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit8_exercises.append({
    "id": 40635, "lesson_id": 10805, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Mit freundlichen Grüßen", "question_en": "Repeat formal closing: 'Mit freundlichen Grüßen'", "question_ar": "ردد الخاتمة الرسمية للخطابات: \u2066'Mit freundlichen Grüßen'\u2069", "question_es": "Repite la despedida formal: 'Mit freundlichen Grüßen'"}, ensure_ascii=False),
    "audio_text": "Mit freundlichen Grüßen", "correct_answer": "Mit freundlichen Grüßen", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 10806: Einheitstest: Tagesablauf & Zeit (10 exercises) ---
test_pool_8 = [
    ("Es ist acht Uhr.", ["Es ist acht Uhr.", "Es ist zehn Uhr.", "Es ist vier Uhr.", "Es ist zwölf Uhr."], "Es ist acht Uhr.", "listen_choose", "Listen and select the time.", "استمع واختر الوقت.", "Escucha y selecciona la hora."),
    ("die Stunde", ["hour", "day", "week", "year"], "hour", "match_pairs", "What does 'die Stunde' mean?", "ما معنى \u2066'die Stunde'\u2069؟", "¿Qué significa 'die Stunde'?"),
    ("Der Film beginnt ___ 20 Uhr.", ["um", "am", "im", "an"], "um", "type_fill_blank", "Choose preposition 'um' for time.", "اختر حرف الجر مع التوقيت بالساعة: \u2066'um'\u2069.", "Elige 'um'."),
    ("Ich habe ___ Montag Deutschkurs.", ["am", "um", "im", "in"], "am", "type_fill_blank", "Choose preposition 'am' for Monday.", "اختر حرف الجر مع الأيام: \u2066'am'\u2069.", "Elige 'am'."),
    ("Ich kann gut Deutsch sprechen.", ["kann", "kannst", "können", "könnt"], "kann", "type_fill_blank", "Conjugate modal 'kann'.", "صرف فعل الاستطاعة مع ich: \u2066'kann'\u2069.", "Conjuga 'kann'."),
    ("die Einladung", ["invitation", "letter", "clock", "appointment"], "invitation", "match_pairs", "What does 'die Einladung' mean?", "ما معنى \u2066'die Einladung'\u2069؟", "¿Qué significa 'die Einladung'?"),
    ("Ich stehe jeden Tag um 7 Uhr auf.", None, "Ich stehe jeden Tag um 7 Uhr auf.", "repeat_prompt", "Repeat: 'Ich stehe jeden Tag um 7 Uhr auf.'", "ردد: \u2066'Ich stehe jeden Tag um 7 Uhr auf.'\u2069", "Repite: 'Ich stehe jeden Tag um 7 Uhr auf.'"),
    ("Wir wollen eine Reise machen.", ["Wir wollen eine Reise machen.", "Wir müssen heute arbeiten.", "Wir können kein Deutsch.", "Wir bleiben zu Hause."], "Wir wollen eine Reise machen.", "listen_choose", "Listen to what they want.", "استمع لما يريدون.", "Escucha lo que quieren."),
    ("Viele Grüße", ["Best regards / Many greetings", "Dear friend", "Goodbye", "Excuse me"], "Best regards / Many greetings", "match_pairs", "What does 'Viele Grüße' mean?", "ما معنى \u2066'Viele Grüße'\u2069؟", "¿Qué significa 'Viele Grüße'?"),
    ("Vielen Dank für die Einladung!", ["für", "an", "von", "um"], "für", "type_fill_blank", "Fill in 'für'.", "املأ الفراغ بكلمة: \u2066'für'\u2069.", "Rellena con 'für'.")
]

for idx, (audio, opts, ans, extype, q_en, q_ar, q_es) in enumerate(test_pool_8, start=1):
    unit8_exercises.append({
        "id": 40635 + idx,
        "lesson_id": 10806,
        "passage_id": None,
        "skill": "listening" if extype == "listen_choose" else ("speaking" if extype == "repeat_prompt" else "reading"),
        "exercise_type": extype,
        "prompt": json.dumps({
            "de": audio,
            "question_en": f"Unit 8 Test ({idx}/10): {q_en}",
            "question_ar": f"اختبار الوحدة 8 ({idx}/10): {q_ar}",
            "question_es": f"Test Unidad 8 ({idx}/10): {q_es}"
        }, ensure_ascii=False),
        "audio_text": audio,
        "correct_answer": ans,
        "options": json.dumps(opts, ensure_ascii=False) if opts else None,
        "is_graded": 1,
        "is_test_pool": 1,
        "sort_order": idx
    })

for ex in unit8_exercises:
    if ex["id"] not in existing_ex_ids:
        data["exercises"].append(ex)
        existing_ex_ids.add(ex["id"])

with open(CONTENT_PATH, "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print(f"Successfully built Unit 8 (Tagesablauf & Zeit)! Total exercises added: {len(unit8_exercises)}")
