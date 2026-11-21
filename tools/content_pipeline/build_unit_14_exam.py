import json
from pathlib import Path

CONTENT_PATH = Path(r"c:\Users\HP\3D Objects\Deutschy-main\Deutschy-main\assets\deutschy_content.json")

with open(CONTENT_PATH, "r", encoding="utf-8") as f:
    data = json.load(f)

# 1. Register Unit 14
if not any(u["id"] == 50010 for u in data["units"]):
    data["units"].append({
        "id": 50010,
        "level": "A1",
        "unit_number": 14,
        "title_de": "Goethe A1 Prüfungstraining",
        "title_en": "Goethe A1 Exam Training",
        "title_ar": "التدريب على امتحان جوته A1",
        "title_es": "Entrenamiento para el examen Goethe A1",
        "topic_key": "exam_practice"
    })

# 2. Add Vocabulary for Unit 14 (IDs 1350-1374)
unit14_words = [
    {"id": 1350, "lemma": "Prüfung", "level": "A1", "topic": "exam_practice", "pos": "noun", "gender": "die", "plural": "Prüfungen", "conjugation": None, "translation_en": "exam / test", "translation_ar": "امتحان / اختبار", "translation_es": "examen / prueba", "frequency_rank": 350},
    {"id": 1351, "lemma": "Aufgabe", "level": "A1", "topic": "exam_practice", "pos": "noun", "gender": "die", "plural": "Aufgaben", "conjugation": None, "translation_en": "exercise / task", "translation_ar": "مهمة / تمرين", "translation_es": "tarea / ejercicio", "frequency_rank": 351},
    {"id": 1352, "lemma": "Frage", "level": "A1", "topic": "exam_practice", "pos": "noun", "gender": "die", "plural": "Fragen", "conjugation": None, "translation_en": "question", "translation_ar": "سؤال", "translation_es": "pregunta", "frequency_rank": 352},
    {"id": 1353, "lemma": "Antwort", "level": "A1", "topic": "exam_practice", "pos": "noun", "gender": "die", "plural": "Antworten", "conjugation": None, "translation_en": "answer", "translation_ar": "إجابة / جواب", "translation_es": "respuesta", "frequency_rank": 353},
    {"id": 1354, "lemma": "Formular", "level": "A1", "topic": "exam_practice", "pos": "noun", "gender": "das", "plural": "Formulare", "conjugation": None, "translation_en": "form", "translation_ar": "استمارة / نموذج", "translation_es": "formulario", "frequency_rank": 354},
    {"id": 1355, "lemma": "Vorname", "level": "A1", "topic": "exam_practice", "pos": "noun", "gender": "der", "plural": "Vornamen", "conjugation": None, "translation_en": "first name", "translation_ar": "الاسم الأول", "translation_es": "nombre de pila", "frequency_rank": 355},
    {"id": 1356, "lemma": "Familienname", "level": "A1", "topic": "exam_practice", "pos": "noun", "gender": "der", "plural": "Familiennamen", "conjugation": None, "translation_en": "surname / last name", "translation_ar": "اسم العائلة / اللقب", "translation_es": "apellido", "frequency_rank": 356},
    {"id": 1357, "lemma": "Geburtsdatum", "level": "A1", "topic": "exam_practice", "pos": "noun", "gender": "das", "plural": "Geburtsdaten", "conjugation": None, "translation_en": "date of birth", "translation_ar": "تاريخ الميلاد", "translation_es": "fecha de nacimiento", "frequency_rank": 357},
    {"id": 1358, "lemma": "Geburtsort", "level": "A1", "topic": "exam_practice", "pos": "noun", "gender": "der", "plural": "Geburtsorte", "conjugation": None, "translation_en": "place of birth", "translation_ar": "مكان الميلاد", "translation_es": "lugar de nacimiento", "frequency_rank": 358},
    {"id": 1359, "lemma": "Wohnort", "level": "A1", "topic": "exam_practice", "pos": "noun", "gender": "der", "plural": "Wohnorte", "conjugation": None, "translation_en": "place of residence", "translation_ar": "مكان الإقامة / السكن", "translation_es": "lugar de residencia", "frequency_rank": 359},
    {"id": 1360, "lemma": "Postleitzahl", "level": "A1", "topic": "exam_practice", "pos": "noun", "gender": "die", "plural": "Postleitzahlen", "conjugation": None, "translation_en": "postal code / ZIP", "translation_ar": "الرمز البريدي", "translation_es": "código postal", "frequency_rank": 360},
    {"id": 1361, "lemma": "Unterschrift", "level": "A1", "topic": "exam_practice", "pos": "noun", "gender": "die", "plural": "Unterschriften", "conjugation": None, "translation_en": "signature", "translation_ar": "توقيع", "translation_es": "firma", "frequency_rank": 361},
    {"id": 1362, "lemma": "Datum", "level": "A1", "topic": "exam_practice", "pos": "noun", "gender": "das", "plural": "Daten", "conjugation": None, "translation_en": "date", "translation_ar": "تاريخ", "translation_es": "fecha", "frequency_rank": 362},
    {"id": 1363, "lemma": "Anrede", "level": "A1", "topic": "exam_practice", "pos": "noun", "gender": "die", "plural": "Anreden", "conjugation": None, "translation_en": "salutation / greeting", "translation_ar": "صيغة الخطاب / التحية", "translation_es": "fórmula de saludo", "frequency_rank": 363},
    {"id": 1364, "lemma": "Gruß", "level": "A1", "topic": "exam_practice", "pos": "noun", "gender": "der", "plural": "Grüße", "conjugation": None, "translation_en": "greeting / regards", "translation_ar": "تحية", "translation_es": "saludo / recuerdos", "frequency_rank": 364},
    {"id": 1365, "lemma": "Absender", "level": "A1", "topic": "exam_practice", "pos": "noun", "gender": "der", "plural": "Absender", "conjugation": None, "translation_en": "sender", "translation_ar": "المرسل", "translation_es": "remitente", "frequency_rank": 365},
    {"id": 1366, "lemma": "Empfänger", "level": "A1", "topic": "exam_practice", "pos": "noun", "gender": "der", "plural": "Empfänger", "conjugation": None, "translation_en": "recipient", "translation_ar": "المستلم / المرسل إليه", "translation_es": "destinatario", "frequency_rank": 366},
    {"id": 1367, "lemma": "Thema", "level": "A1", "topic": "exam_practice", "pos": "noun", "gender": "das", "plural": "Themen", "conjugation": None, "translation_en": "topic / theme", "translation_ar": "موضوع", "translation_es": "tema", "frequency_rank": 367},
    {"id": 1368, "lemma": "Karte", "level": "A1", "topic": "exam_practice", "pos": "noun", "gender": "die", "plural": "Karten", "conjugation": None, "translation_en": "card", "translation_ar": "بطاقة", "translation_es": "tarjeta", "frequency_rank": 368},
    {"id": 1369, "lemma": "Buchstabe", "level": "A1", "topic": "exam_practice", "pos": "noun", "gender": "der", "plural": "Buchstaben", "conjugation": None, "translation_en": "letter (alphabet)", "translation_ar": "حرف هجائي", "translation_es": "letra", "frequency_rank": 369},
    {"id": 1370, "lemma": "Zahl", "level": "A1", "topic": "exam_practice", "pos": "noun", "gender": "die", "plural": "Zahlen", "conjugation": None, "translation_en": "number / numeral", "translation_ar": "عدد / رقم", "translation_es": "número", "frequency_rank": 370},
    {"id": 1371, "lemma": "Ergebnis", "level": "A1", "topic": "exam_practice", "pos": "noun", "gender": "das", "plural": "Ergebnisse", "conjugation": None, "translation_en": "result / score", "translation_ar": "نتيجة", "translation_es": "resultado", "frequency_rank": 371},
    {"id": 1372, "lemma": "bestehen", "level": "A1", "topic": "exam_practice", "pos": "verb", "gender": None, "plural": None, "conjugation": "besteht", "translation_en": "to pass (an exam)", "translation_ar": "ينجح في الامتحان / يجتاز", "translation_es": "aprobar (un examen)", "frequency_rank": 372},
    {"id": 1373, "lemma": "bitten", "level": "A1", "topic": "exam_practice", "pos": "verb", "gender": None, "plural": None, "conjugation": "bittet", "translation_en": "to ask for / request", "translation_ar": "يطلب / يرجو", "translation_es": "pedir / rogar", "frequency_rank": 373},
    {"id": 1374, "lemma": "bedanken", "level": "A1", "topic": "exam_practice", "pos": "verb", "gender": None, "plural": None, "conjugation": "bedankt sich", "translation_en": "to thank", "translation_ar": "يشكر", "translation_es": "agradecer / dar las gracias", "frequency_rank": 374},
]

existing_w_ids = {w["id"] for w in data["words"]}
for w in unit14_words:
    if w["id"] not in existing_w_ids:
        data["words"].append(w)

# 3. Add Lessons for Unit 14 (11401 - 11406)
unit14_lessons = [
    {
        "id": 11401, "unit_id": 50010, "level": "A1", "title_de": "Hören Teil 1, 2 & 3: Prüfungsstrategien", "title_en": "Listening Parts 1, 2 & 3: Strategies",
        "sort_order": 1, "lesson_type": "vocabulary", "pass_threshold": 0.7, "grammar_content": None, "content_json": None
    },
    {
        "id": 11402, "unit_id": 50010, "level": "A1", "title_de": "Lesen Teil 1, 2 & 3: Texte, Anzeigen & Schilder", "title_en": "Reading Parts 1, 2 & 3: Texts & Signs",
        "sort_order": 2, "lesson_type": "vocabulary", "pass_threshold": 0.7, "grammar_content": None, "content_json": None
    },
    {
        "id": 11403, "unit_id": 50010, "level": "A1", "title_de": "Schreiben Teil 1: Formulare ausfüllen", "title_en": "Writing Part 1: Filling Out Forms",
        "sort_order": 3, "lesson_type": "grammar", "pass_threshold": 0.7,
        "grammar_content": "# مهارة الكتابة: تعبئة الاستمارات (Schreiben Teil 1)\n# Writing Part 1: Filling Out Registration Forms\n\n## 🇩🇪 Deutsch | 🇬🇧 English | 🇸🇦 عربي\n\nفي الجزء الأول من امتحان الكتابة في معهد جوته (Schreiben Teil 1)، يُطلب منك استخراج 5 معلومات من نص قصير وتعبئتها في استمارة:\nIn Goethe A1 Schreiben Teil 1, you must extract 5 pieces of personal information from a short prompt to fill in a form:\n\n### الحقول الأساسية في الاستمارة:\n1. **Familienname / Name:** اسم العائلة / اللقب\n2. **Vorname:** الاسم الشخصي الأول\n3. **Geburtsdatum / Geburtsort:** تاريخ ومكان الميلاد\n4. **Wohnort / Straße / PLZ:** مكان الإقامة والشارع والرمز البريدي\n5. **Anzahl der Personen:** عدد الأشخاص المسافرين أو الحاجزين\n6. **Zahlungsweise:** طريقة الدفع (bar / Kreditkarte)",
        "content_json": None
    },
    {
        "id": 11404, "unit_id": 50010, "level": "A1", "title_de": "Schreiben Teil 2: Brief & E-Mail schreiben", "title_en": "Writing Part 2: Letter & Email",
        "sort_order": 4, "lesson_type": "grammar", "pass_threshold": 0.7,
        "grammar_content": "# كتابة رسالة أو إيميل (Schreiben Teil 2)\n# Writing Part 2: Drafting an Email / Letter (~30 words)\n\n## 🇩🇪 Deutsch | 🇬🇧 English | 🇸🇦 عربي\n\nيُطلب منك كتابة نص قصير (حوالي 30 كلمة) يغطي **3 نقاط أساسية (Leitpunkte)**:\nYou are asked to write a short message covering **3 bullet points**:\n\n### هيكل الرسالة:\n1. **التحية (Anrede):**\n   - غير رسمية (أصدقاء): *Liebe Anna,* (للأنثى) / *Lieber Thomas,* (للذكر)\n   - رسمية (عمل / فنادق): *Sehr geehrte Damen und Herren,* / *Sehr geehrte Frau Müller,*\n\n2. **صلب الموضوع (3 Leitpunkte):**\n   - سبب الكتابة: *Ich schreibe Ihnen, weil...*\n   - الشكر أو الاعتذار: *Vielen Dank für Ihre Hilfe.* / *Es tut mir leid, aber...*\n   - الموعد أو التأكيد: *Ich komme am Montag um 14 Uhr.*\n\n3. **الخاتمة والتوقيع (Gruß & Unterschrift):**\n   - غير رسمية: *Viele Grüße / Herzliche Grüße* + اسمك الأول\n   - رسمية: *Mit freundlichen Grüßen* + اسمك الكامل",
        "content_json": None
    },
    {
        "id": 11405, "unit_id": 50010, "level": "A1", "title_de": "Sprechen Teil 1, 2 & 3: Mündliche Prüfung", "title_en": "Speaking Parts 1, 2 & 3: Oral Exam",
        "sort_order": 5, "lesson_type": "text", "pass_threshold": 0.7, "grammar_content": None, "content_json": None
    },
    {
        "id": 11406, "unit_id": 50010, "level": "A1", "title_de": "Goethe A1 Modellprüfung: Kompletttest", "title_en": "Goethe A1 Full Mock Exam",
        "sort_order": 6, "lesson_type": "unit_test", "pass_threshold": 0.75, "grammar_content": None, "content_json": None
    }
]

existing_l_ids = {l["id"] for l in data["lessons"]}
for l in unit14_lessons:
    if l["id"] not in existing_l_ids:
        data["lessons"].append(l)

# 4. Add Exercises for Unit 14 (41101 - 41145)
existing_ex_ids = {e["id"] for e in data["exercises"]}
unit14_exercises = []

# --- LESSON 11401: Hören Teil 1, 2 & 3: Prüfungsstrategien (7 exercises) ---
unit14_exercises.append({
    "id": 41101, "lesson_id": 11401, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Prüfung", "gender": "die", "question_en": "What does 'die Prüfung' mean?", "question_ar": "ما معنى \u2066'die Prüfung'\u2069؟", "question_es": "¿Qué significa 'die Prüfung'?"}, ensure_ascii=False),
    "audio_text": "die Prüfung", "correct_answer": "exam / test", "options": json.dumps(["exam / test", "homework", "lesson", "certificate"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit14_exercises.append({
    "id": 41102, "lesson_id": 11401, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Aufgabe", "gender": "die", "question_en": "What does 'die Aufgabe' mean?", "question_ar": "ما معنى \u2066'die Aufgabe'\u2069؟", "question_es": "¿Qué significa 'die Aufgabe'?"}, ensure_ascii=False),
    "audio_text": "die Aufgabe", "correct_answer": "task / exercise", "options": json.dumps(["task / exercise", "question", "answer", "book"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit14_exercises.append({
    "id": 41103, "lesson_id": 11401, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Der nächste Zug nach Berlin fährt um 15:30 Uhr ab.", "question_en": "Hören Teil 1: Listen and choose the departure time.", "question_ar": "سماعي جزء 1: استمع واختر موعد انطلاق القطار.", "question_es": "Comprensión auditiva Parte 1: Escucha la hora de salida."}, ensure_ascii=False),
    "audio_text": "Der nächste Zug nach Berlin fährt um 15:30 Uhr ab.", "correct_answer": "Der nächste Zug nach Berlin fährt um 15:30 Uhr ab.", "options": json.dumps(["Der nächste Zug nach Berlin fährt um 15:30 Uhr ab.", "Der Zug nach München fährt um 14:00 Uhr ab.", "Der Bus kommt um 15:30 Uhr an.", "Der Zug fällt heute leider aus."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit14_exercises.append({
    "id": 41104, "lesson_id": 11401, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Kreuzen Sie die richtige ___ an. (Antwort)", "question_en": "Fill in 'Antwort' (answer).", "question_ar": "املأ الفراغ بكلمة الإجابة: \u2066'Antwort'\u2069.", "question_es": "Rellena con 'Antwort'."}, ensure_ascii=False),
    "audio_text": "Kreuzen Sie die richtige Antwort an.", "correct_answer": "Antwort", "options": json.dumps(["Antwort", "Frage", "Zahl", "Karte"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit14_exercises.append({
    "id": 41105, "lesson_id": 11401, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Frau Schmidt soll bitte zur Information kommen.", "question_en": "Hören Teil 2: Listen to the public announcement.", "question_ar": "سماعي جزء 2: استمع للإعلان العام.", "question_es": "Comprensión auditiva Parte 2: Escucha el anuncio público."}, ensure_ascii=False),
    "audio_text": "Frau Schmidt soll bitte zur Information kommen.", "correct_answer": "Frau Schmidt soll bitte zur Information kommen.", "options": json.dumps(["Frau Schmidt soll bitte zur Information kommen.", "Herr Schmidt ruft ein Taxi.", "Der Schalter Information ist geschlossen.", "Frau Schmidt soll sofort zum Ausgang gehen."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit14_exercises.append({
    "id": 41106, "lesson_id": 11401, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Haben Sie noch eine ___ ? (Frage)", "question_en": "Fill in 'Frage' (question).", "question_ar": "املأ الفراغ بكلمة سؤال: \u2066'Frage'\u2069.", "question_es": "Rellena con 'Frage'."}, ensure_ascii=False),
    "audio_text": "Haben Sie noch eine Frage?", "correct_answer": "Frage", "options": json.dumps(["Frage", "Antwort", "Prüfung", "Note"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit14_exercises.append({
    "id": 41107, "lesson_id": 11401, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Können Sie das bitte wiederholen?", "question_en": "Repeat: 'Können Sie das bitte wiederholen?'", "question_ar": "ردد: \u2066'Können Sie das bitte wiederholen?'\u2069", "question_es": "Repite: 'Können Sie das bitte wiederholen?'"}, ensure_ascii=False),
    "audio_text": "Können Sie das bitte wiederholen?", "correct_answer": "Können Sie das bitte wiederholen?", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 11402: Lesen Teil 1, 2 & 3: Texte, Anzeigen & Schilder (7 exercises) ---
unit14_exercises.append({
    "id": 41108, "lesson_id": 11402, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Wohnort", "gender": "der", "question_en": "What does 'der Wohnort' mean?", "question_ar": "ما معنى \u2066'der Wohnort'\u2069؟", "question_es": "¿Qué significa 'der Wohnort'?"}, ensure_ascii=False),
    "audio_text": "der Wohnort", "correct_answer": "place of residence", "options": json.dumps(["place of residence", "place of birth", "hotel", "office"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit14_exercises.append({
    "id": 41109, "lesson_id": 11402, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Geburtsdatum", "gender": "das", "question_en": "What does 'das Geburtsdatum' mean?", "question_ar": "ما معنى \u2066'das Geburtsdatum'\u2069؟", "question_es": "¿Qué significa 'das Geburtsdatum'?"}, ensure_ascii=False),
    "audio_text": "das Geburtsdatum", "correct_answer": "date of birth", "options": json.dumps(["date of birth", "today's date", "appointment", "time"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit14_exercises.append({
    "id": 41110, "lesson_id": 11402, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Die Praxis ist montags bis freitags von 8 bis 12 Uhr geöffnet.", "question_en": "Lesen/Hören: Opening hours comprehension.", "question_ar": "استمع واختر أوقات دوام العيادة.", "question_es": "Comprensión: Escucha el horario de apertura."}, ensure_ascii=False),
    "audio_text": "Die Praxis ist montags bis freitags von 8 bis 12 Uhr geöffnet.", "correct_answer": "Die Praxis ist montags bis freitags von 8 bis 12 Uhr geöffnet.", "options": json.dumps(["Die Praxis ist montags bis freitags von 8 bis 12 Uhr geöffnet.", "Die Praxis ist am Wochenende ganztägig offen.", "Die Praxis öffnet nur am Nachmittag.", "Die Praxis bleibt heute geschlossen."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit14_exercises.append({
    "id": 41111, "lesson_id": 11402, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Bitte füllen Sie das ___ aus. (Formular)", "question_en": "Fill in 'Formular' (form).", "question_ar": "املأ الفراغ بكلمة استمارة: \u2066'Formular'\u2069.", "question_es": "Rellena con 'Formular'."}, ensure_ascii=False),
    "audio_text": "Bitte füllen Sie das Formular aus.", "correct_answer": "Formular", "options": json.dumps(["Formular", "Buch", "Rezept", "Ticket"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit14_exercises.append({
    "id": 41112, "lesson_id": 11402, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Postleitzahl", "gender": "die", "question_en": "What does 'die Postleitzahl' mean?", "question_ar": "ما معنى \u2066'die Postleitzahl'\u2069؟", "question_es": "¿Qué significa 'die Postleitzahl'?"}, ensure_ascii=False),
    "audio_text": "die Postleitzahl", "correct_answer": "postal code", "options": json.dumps(["postal code", "phone number", "street number", "house number"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit14_exercises.append({
    "id": 41113, "lesson_id": 11402, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Hier fehlt noch Ihre ___ . (Unterschrift)", "question_en": "Fill in 'Unterschrift' (signature).", "question_ar": "املأ الفراغ بكلمة توقيع: \u2066'Unterschrift'\u2069.", "question_es": "Rellena con 'Unterschrift'."}, ensure_ascii=False),
    "audio_text": "Hier fehlt noch Ihre Unterschrift.", "correct_answer": "Unterschrift", "options": json.dumps(["Unterschrift", "Adresse", "Nummer", "Stadt"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit14_exercises.append({
    "id": 41114, "lesson_id": 11402, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Ich habe alle Aufgaben verstanden.", "question_en": "Repeat: 'Ich habe alle Aufgaben verstanden.'", "question_ar": "ردد: \u2066'Ich habe alle Aufgaben verstanden.'\u2069", "question_es": "Repite: 'Ich habe alle Aufgaben verstanden.'"}, ensure_ascii=False),
    "audio_text": "Ich habe alle Aufgaben verstanden.", "correct_answer": "Ich habe alle Aufgaben verstanden.", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 11403: Schreiben Teil 1: Formulare ausfüllen (7 exercises) ---
unit14_exercises.append({
    "id": 41115, "lesson_id": 11403, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Vorname", "gender": "der", "question_en": "What does 'der Vorname' mean?", "question_ar": "ما معنى \u2066'der Vorname'\u2069؟", "question_es": "¿Qué significa 'der Vorname'?"}, ensure_ascii=False),
    "audio_text": "der Vorname", "correct_answer": "first name", "options": json.dumps(["first name", "surname", "nickname", "title"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit14_exercises.append({
    "id": 41116, "lesson_id": 11403, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Familienname", "gender": "der", "question_en": "What does 'der Familienname' mean?", "question_ar": "ما معنى \u2066'der Familienname'\u2069؟", "question_es": "¿Qué significa 'der Familienname'?"}, ensure_ascii=False),
    "audio_text": "der Familienname", "correct_answer": "surname / last name", "options": json.dumps(["surname / last name", "first name", "company name", "street name"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit14_exercises.append({
    "id": 41117, "lesson_id": 11403, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Anzahl der Personen: ___ (zwei Erwachsene)", "question_en": "Fill in number '2'.", "question_ar": "املأ الفراغ بالرقم المناسب: \u2066'2'\u2069.", "question_es": "Rellena con '2'."}, ensure_ascii=False),
    "audio_text": "Anzahl der Personen: zwei.", "correct_answer": "2", "options": json.dumps(["2", "5", "10", "1"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit14_exercises.append({
    "id": 41118, "lesson_id": 11403, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Ich möchte ein Einzelzimmer mit Frühstück buchen.", "question_en": "Listen and select the booking request.", "question_ar": "استمع واختر طلب الحجز المسموع.", "question_es": "Escucha y selecciona la solicitud de reserva."}, ensure_ascii=False),
    "audio_text": "Ich möchte ein Einzelzimmer mit Frühstück buchen.", "correct_answer": "Ich möchte ein Einzelzimmer mit Frühstück buchen.", "options": json.dumps(["Ich möchte ein Einzelzimmer mit Frühstück buchen.", "Ich buche ein Doppelzimmer ohne Frühstück.", "Das Hotel hat keine freien Zimmer mehr.", "Ich storniere meine Reservierung."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit14_exercises.append({
    "id": 41119, "lesson_id": 11403, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Zahlungsweise: ___ (bar)", "question_en": "Fill in 'bar' (cash).", "question_ar": "املأ الفراغ بطريقة الدفع نقداً: \u2066'bar'\u2069.", "question_es": "Rellena con 'bar'."}, ensure_ascii=False),
    "audio_text": "Zahlungsweise: bar.", "correct_answer": "bar", "options": json.dumps(["bar", "Kredit", "Online", "Scheck"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit14_exercises.append({
    "id": 41120, "lesson_id": 11403, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "Datum", "gender": "das", "question_en": "What does 'das Datum' mean?", "question_ar": "ما معنى \u2066'das Datum'\u2069؟", "question_es": "¿Qué significa 'das Datum'?"}, ensure_ascii=False),
    "audio_text": "das Datum", "correct_answer": "date", "options": json.dumps(["date", "time", "day", "year"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit14_exercises.append({
    "id": 41121, "lesson_id": 11403, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Hier ist mein Reisepass.", "question_en": "Repeat: 'Hier ist mein Reisepass.'", "question_ar": "ردد: \u2066'Hier ist mein Reisepass.'\u2069", "question_es": "Repite: 'Hier ist mein Reisepass.'"}, ensure_ascii=False),
    "audio_text": "Hier ist mein Reisepass.", "correct_answer": "Hier ist mein Reisepass.", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 11404: Schreiben Teil 2: Brief & E-Mail schreiben (7 exercises) ---
unit14_exercises.append({
    "id": 41122, "lesson_id": 11404, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "___ Frau Müller, vielen Dank für Ihre Einladung. (Sehr geehrte)", "question_en": "Formal salutation for a woman.", "question_ar": "صيغة الخطاب الرسمي لسيدة: \u2066'Sehr geehrte'\u2069.", "question_es": "Saludo formal femenino: 'Sehr geehrte'."}, ensure_ascii=False),
    "audio_text": "Sehr geehrte Frau Müller, vielen Dank für Ihre Einladung.", "correct_answer": "Sehr geehrte", "options": json.dumps(["Sehr geehrte", "Sehr geehrter", "Liebe", "Lieber"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit14_exercises.append({
    "id": 41123, "lesson_id": 11404, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "___ Thomas, wie geht es dir? (Lieber)", "question_en": "Informal greeting for a man.", "question_ar": "تحية غير رسمية لصديق: \u2066'Lieber'\u2069.", "question_es": "Saludo informal masculino: 'Lieber'."}, ensure_ascii=False),
    "audio_text": "Lieber Thomas, wie geht es dir?", "correct_answer": "Lieber", "options": json.dumps(["Lieber", "Liebe", "Sehr geehrter", "Hallo"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit14_exercises.append({
    "id": 41124, "lesson_id": 11404, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Mit freundlichen ___ . (Grüßen)", "question_en": "Formal sign-off 'Grüßen'.", "question_ar": "خاتمة رسمية للرسائل: \u2066'Grüßen'\u2069.", "question_es": "Despedida formal: 'Grüßen'."}, ensure_ascii=False),
    "audio_text": "Mit freundlichen Grüßen", "correct_answer": "Grüßen", "options": json.dumps(["Grüßen", "Dank", "Briefen", "Wünschen"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit14_exercises.append({
    "id": 41125, "lesson_id": 11404, "passage_id": None, "skill": "listening", "exercise_type": "listen_choose",
    "prompt": json.dumps({"de": "Ich kann leider nicht kommen, weil ich einen Arzttermin habe.", "question_en": "Listen and select the cancellation reason.", "question_ar": "استمع واختر سبب الاعتذار عن الحضور.", "question_es": "Escucha y selecciona el motivo de cancelación."}, ensure_ascii=False),
    "audio_text": "Ich kann leider nicht kommen, weil ich einen Arzttermin habe.", "correct_answer": "Ich kann leider nicht kommen, weil ich einen Arzttermin habe.", "options": json.dumps(["Ich kann leider nicht kommen, weil ich einen Arzttermin habe.", "Ich komme gerne am Samstag zu Ihrer Party.", "Ich habe meine Hausaufgaben vergessen.", "Der Zug hatte keine Verspätung."], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit14_exercises.append({
    "id": 41126, "lesson_id": 11404, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Ich lade dich herzlich zu meinem Geburtstag ___ . (ein - einladen)", "question_en": "Fill in prefix 'ein' for einladen.", "question_ar": "صرف فعل الدعوة: \u2066'ein'\u2069.", "question_es": "Rellena con 'ein'."}, ensure_ascii=False),
    "audio_text": "Ich lade dich herzlich zu meinem Geburtstag ein.", "correct_answer": "ein", "options": json.dumps(["ein", "aus", "auf", "mit"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit14_exercises.append({
    "id": 41127, "lesson_id": 11404, "passage_id": None, "skill": "reading", "exercise_type": "match_pairs",
    "prompt": json.dumps({"de": "bestehen", "question_en": "What does 'die Prüfung bestehen' mean?", "question_ar": "ما معنى \u2066'die Prüfung bestehen'\u2069؟", "question_es": "¿Qué significa 'die Prüfung bestehen'?"}, ensure_ascii=False),
    "audio_text": "die Prüfung bestehen", "correct_answer": "to pass the exam", "options": json.dumps(["to pass the exam", "to fail the exam", "to register for exam", "to delay the exam"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit14_exercises.append({
    "id": 41128, "lesson_id": 11404, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Vielen Dank für Ihre schnelle Antwort.", "question_en": "Repeat: 'Vielen Dank für Ihre schnelle Antwort.'", "question_ar": "ردد: \u2066'Vielen Dank für Ihre schnelle Antwort.'\u2069", "question_es": "Repite: 'Vielen Dank für Ihre schnelle Antwort.'"}, ensure_ascii=False),
    "audio_text": "Vielen Dank für Ihre schnelle Antwort.", "correct_answer": "Vielen Dank für Ihre schnelle Antwort.", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 11405: Sprechen Teil 1, 2 & 3: Mündliche Prüfung (7 exercises) ---
unit14_exercises.append({
    "id": 41129, "lesson_id": 11405, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Ich heiße Sarah und ich komme aus Marokko.", "question_en": "Sprechen Teil 1: Self-introduction.", "question_ar": "تحدث جزء 1: التعريف بالنفس.", "question_es": "Expresión oral Parte 1: Presentación personal."}, ensure_ascii=False),
    "audio_text": "Ich heiße Sarah und ich komme aus Marokko.", "correct_answer": "Ich heiße Sarah und ich komme aus Marokko.", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 1
})
unit14_exercises.append({
    "id": 41130, "lesson_id": 11405, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Mein Vorname buchstabiert sich: S-A-R-A-H.", "question_en": "Sprechen Teil 1: Spelling your name.", "question_ar": "تحدث جزء 1: تهجئة الاسم بالأحرف الألمانية.", "question_es": "Expresión oral Parte 1: Deletrear el nombre."}, ensure_ascii=False),
    "audio_text": "Mein Vorname buchstabiert sich: S-A-R-A-H.", "correct_answer": "Mein Vorname buchstabiert sich: S-A-R-A-H.", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 2
})
unit14_exercises.append({
    "id": 41131, "lesson_id": 11405, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Meine Telefonnummer ist 0176 45 89 23.", "question_en": "Sprechen Teil 1: Stating telephone number.", "question_ar": "تحدث جزء 1: نطق رقم الهاتف بالألمانية.", "question_es": "Expresión oral Parte 1: Decir el número de teléfono."}, ensure_ascii=False),
    "audio_text": "Meine Telefonnummer ist 0176 45 89 23.", "correct_answer": "Meine Telefonnummer ist 0176 45 89 23.", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 3
})
unit14_exercises.append({
    "id": 41132, "lesson_id": 11405, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Thema Essen: Was frühstücken Sie am liebsten?", "question_en": "Sprechen Teil 2: Ask for info with flashcard.", "question_ar": "تحدث جزء 2: صياغة سؤال ببطاقة المفردات.", "question_es": "Expresión oral Parte 2: Formular una pregunta con tarjeta."}, ensure_ascii=False),
    "audio_text": "Thema Essen: Was frühstücken Sie am liebsten?", "correct_answer": "Thema Essen: Was frühstücken Sie am liebsten?", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 4
})
unit14_exercises.append({
    "id": 41133, "lesson_id": 11405, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Geben Sie mir bitte das Buch!", "question_en": "Sprechen Teil 3: Polite request with picture card.", "question_ar": "تحدث جزء 3: صياغة رجاء مؤدب ببطاقة الصور.", "question_es": "Expresión oral Parte 3: Petición cortés con tarjeta de imagen."}, ensure_ascii=False),
    "audio_text": "Geben Sie mir bitte das Buch!", "correct_answer": "Geben Sie mir bitte das Buch!", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 5
})
unit14_exercises.append({
    "id": 41134, "lesson_id": 11405, "passage_id": None, "skill": "writing", "exercise_type": "type_fill_blank",
    "prompt": json.dumps({"de": "Darf ich hier ___ ? (rauchen - Sprechen Teil 3 Bitte)", "question_en": "Fill in 'rauchen' (smoke).", "question_ar": "املأ الفراغ بفعل التدخين: \u2066'rauchen'\u2069.", "question_es": "Rellena con 'rauchen'."}, ensure_ascii=False),
    "audio_text": "Darf ich hier rauchen?", "correct_answer": "rauchen", "options": json.dumps(["rauchen", "parken", "sitzen", "essen"], ensure_ascii=False),
    "is_graded": 1, "is_test_pool": 0, "sort_order": 6
})
unit14_exercises.append({
    "id": 41135, "lesson_id": 11405, "passage_id": None, "skill": "speaking", "exercise_type": "repeat_prompt",
    "prompt": json.dumps({"de": "Ja, natürlich. Hier bitte!", "question_en": "Repeat: 'Ja, natürlich. Hier bitte!'", "question_ar": "ردد: \u2066'Ja, natürlich. Hier bitte!'\u2069", "question_es": "Repite: 'Ja, natürlich. Hier bitte!'"}, ensure_ascii=False),
    "audio_text": "Ja, natürlich. Hier bitte!", "correct_answer": "Ja, natürlich. Hier bitte!", "options": None,
    "is_graded": 1, "is_test_pool": 0, "sort_order": 7
})

# --- LESSON 11406: Goethe A1 Modellprüfung: Kompletttest (10 exercises) ---
test_pool_14 = [
    ("die Prüfung", ["exam / test", "homework", "lesson", "certificate"], "exam / test", "match_pairs", "What does 'die Prüfung' mean?", "ما معنى \u2066'die Prüfung'\u2069؟", "¿Qué significa 'die Prüfung'?"),
    ("Kreuzen Sie die richtige Antwort an.", ["Antwort", "Frage", "Zahl", "Karte"], "Antwort", "type_fill_blank", "Fill in 'Antwort'.", "املأ الفراغ بكلمة الإجابة: \u2066'Antwort'\u2069.", "Elige 'Antwort'."),
    ("Der nächste Zug nach Berlin fährt um 15:30 Uhr ab.", ["Der nächste Zug nach Berlin fährt um 15:30 Uhr ab.", "Der Zug nach München fährt um 14:00 Uhr ab.", "Der Bus kommt um 15:30 Uhr an.", "Der Zug fällt heute aus."], "Der nächste Zug nach Berlin fährt um 15:30 Uhr ab.", "listen_choose", "Hören: Listen to departure time.", "استمع لموعد مغادرة القطار.", "Escucha la hora de salida."),
    ("das Geburtsdatum", ["date of birth", "today's date", "appointment", "time"], "date of birth", "match_pairs", "What does 'das Geburtsdatum' mean?", "ما معنى \u2066'das Geburtsdatum'\u2069؟", "¿Qué significa 'das Geburtsdatum'?"),
    ("Sehr geehrte Frau Müller, vielen Dank für Ihre Einladung.", ["Sehr geehrte", "Sehr geehrter", "Liebe", "Lieber"], "Sehr geehrte", "type_fill_blank", "Choose formal female salutation.", "اختر صيغة الخطاب الرسمي لسيدة: \u2066'Sehr geehrte'\u2069.", "Elige 'Sehr geehrte'."),
    ("Mit freundlichen Grüßen", ["Grüßen", "Dank", "Briefen", "Wünschen"], "Grüßen", "type_fill_blank", "Fill in formal closing 'Grüßen'.", "خاتمة رسمية: \u2066'Grüßen'\u2069.", "Elige 'Grüßen'."),
    ("Ich kann leider nicht kommen, weil ich einen Arzttermin habe.", ["Ich kann leider nicht kommen, weil ich einen Arzttermin habe.", "Ich komme gerne zu Ihrer Party.", "Ich habe meine Hausaufgaben vergessen.", "Der Zug hatte keine Verspätung."], "Ich kann leider nicht kommen, weil ich einen Arzttermin habe.", "listen_choose", "Listen to cancellation reason.", "استمع لسبب الاعتذار.", "Escucha el motivo."),
    ("Ich lade dich herzlich zu meinem Geburtstag ein.", ["ein", "aus", "auf", "mit"], "ein", "type_fill_blank", "Fill in prefix 'ein'.", "صرف فعل الدعوة: \u2066'ein'\u2069.", "Elige 'ein'."),
    ("Können Sie das bitte wiederholen?", None, "Können Sie das bitte wiederholen?", "repeat_prompt", "Repeat: 'Können Sie das bitte wiederholen?'", "ردد: \u2066'Können Sie das bitte wiederholen?'\u2069", "Repite: 'Können Sie das bitte wiederholen?'"),
    ("Hier fehlt noch Ihre Unterschrift.", ["Unterschrift", "Adresse", "Nummer", "Stadt"], "Unterschrift", "type_fill_blank", "Fill in 'Unterschrift'.", "املأ الفراغ بكلمة التوقيع: \u2066'Unterschrift'\u2069.", "Rellena con 'Unterschrift'.")
]

for idx, (audio, opts, ans, extype, q_en, q_ar, q_es) in enumerate(test_pool_14, start=1):
    unit14_exercises.append({
        "id": 41135 + idx,
        "lesson_id": 11406,
        "passage_id": None,
        "skill": "listening" if extype == "listen_choose" else ("speaking" if extype == "repeat_prompt" else "reading"),
        "exercise_type": extype,
        "prompt": json.dumps({
            "de": audio,
            "question_en": f"Goethe A1 Mock Exam ({idx}/10): {q_en}",
            "question_ar": f"امتحان جوته التجريبي A1 ({idx}/10): {q_ar}",
            "question_es": f"Examen de prueba Goethe A1 ({idx}/10): {q_es}"
        }, ensure_ascii=False),
        "audio_text": audio,
        "correct_answer": ans,
        "options": json.dumps(opts, ensure_ascii=False) if opts else None,
        "is_graded": 1,
        "is_test_pool": 1,
        "sort_order": idx
    })

for ex in unit14_exercises:
    if ex["id"] not in existing_ex_ids:
        data["exercises"].append(ex)
        existing_ex_ids.add(ex["id"])

with open(CONTENT_PATH, "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print(f"Successfully built Unit 14 (Goethe A1 Prüfungstraining)! Total exercises added: {len(unit14_exercises)}")
