from pathlib import Path

localizer_path = Path(r"c:\Users\HP\3D Objects\Deutschy-main\Deutschy-main\lib\src\features\study\domain\exercise_localizer.dart")
feedback_path = Path(r"c:\Users\HP\3D Objects\Deutschy-main\Deutschy-main\lib\src\features\study\domain\feedback_translations_data.dart")

unit14_options = {
    'exam / test': ('exam / test', 'امتحان / اختبار', 'examen / prueba'),
    'task / exercise': ('task / exercise', 'مهمة / تمرين', 'tarea / ejercicio'),
    'place of residence': ('place of residence', 'مكان الإقامة / السكن', 'lugar de residencia'),
    'place of birth': ('place of birth', 'مكان الميلاد', 'lugar de nacimiento'),
    'date of birth': ('date of birth', 'تاريخ الميلاد', 'fecha de nacimiento'),
    "today's date": ("today's date", 'تاريخ اليوم', 'fecha de hoy'),
    'first name': ('first name', 'الاسم الأول', 'nombre de pila'),
    'surname / last name': ('surname / last name', 'اسم العائلة / اللقب', 'apellido'),
    'to pass the exam': ('to pass the exam', 'ينجح في الامتحان', 'aprobar el examen'),
    'to fail the exam': ('to fail the exam', 'يرسب في الامتحان', 'suspender el examen'),
    'to register for exam': ('to register for exam', 'يسجل للامتحان', 'inscribirse al examen'),
    'to delay the exam': ('to delay the exam', 'يؤجل الامتحان', 'aplazar el examen'),
}

# Update exercise_localizer.dart
content = localizer_path.read_text(encoding='utf-8')
target = '  static const Map<String, ({String en, String ar, String es})> kExerciseOptions = {'
entries = []
for k, (en, ar, es) in sorted(unit14_options.items()):
    clean_k = k.lower().replace("'", "\\'")
    if f"'{clean_k}':" not in content:
        entries.append(f"    '{clean_k}': (en: '{en}', ar: '{ar}', es: '{es}'),")

if entries:
    replacement = target + "\n" + "\n".join(entries)
    content = content.replace(target, replacement, 1)
    localizer_path.write_text(content, encoding='utf-8')
    print(f"Added {len(entries)} options to exercise_localizer.dart")
else:
    print("No new options to add to exercise_localizer.dart")

# Update feedback_translations_data.dart
unit14_feedback = {
    'prüfung': ('Prüfung', 'exam / test', 'امتحان / اختبار', 'examen'),
    'die prüfung': ('die Prüfung', 'the exam', 'الامتحان', 'el examen'),
    'aufgabe': ('Aufgabe', 'task / exercise', 'مهمة / تمرين', 'tarea'),
    'die aufgabe': ('die Aufgabe', 'the task', 'المهمة', 'la tarea'),
    'frage': ('Frage', 'question', 'سؤال', 'pregunta'),
    'die frage': ('die Frage', 'the question', 'السؤال', 'la pregunta'),
    'antwort': ('Antwort', 'answer', 'إجابة / جواب', 'respuesta'),
    'die antwort': ('die Antwort', 'the answer', 'الإجابة', 'la respuesta'),
    'formular': ('Formular', 'form', 'استمارة / نموذج', 'formulario'),
    'das formular': ('das Formular', 'the form', 'الاستمارة', 'el formulario'),
    'vorname': ('Vorname', 'first name', 'الاسم الأول', 'nombre de pila'),
    'der vorname': ('der Vorname', 'the first name', 'الاسم الأول', 'el nombre'),
    'familienname': ('Familienname', 'surname / last name', 'اسم العائلة', 'apellido'),
    'der familienname': ('der Familienname', 'the surname', 'اسم العائلة', 'el apellido'),
    'geburtsdatum': ('Geburtsdatum', 'date of birth', 'تاريخ الميلاد', 'fecha de nacimiento'),
    'das geburtsdatum': ('das Geburtsdatum', 'the date of birth', 'تاريخ الميلاد', 'la fecha de nacimiento'),
    'wohnort': ('Wohnort', 'place of residence', 'مكان الإقامة', 'lugar de residencia'),
    'der wohnort': ('der Wohnort', 'the residence', 'مكان السكن', 'el lugar de residencia'),
    'postleitzahl': ('Postleitzahl', 'postal code', 'الرمز البريدي', 'código postal'),
    'die postleitzahl': ('die Postleitzahl', 'the postal code', 'الرمز البريدي', 'el código postal'),
    'unterschrift': ('Unterschrift', 'signature', 'توقيع', 'firma'),
    'die unterschrift': ('die Unterschrift', 'the signature', 'التوقيع', 'la firma'),
    'datum': ('Datum', 'date', 'تاريخ', 'fecha'),
    'das datum': ('das Datum', 'the date', 'التاريخ', 'la fecha'),
    'der nächste zug nach berlin fährt um 15:30 uhr ab.': ('Der nächste Zug nach Berlin fährt um 15:30 Uhr ab.', 'The next train to Berlin departs at 15:30.', 'ينطلق القطار التالي إلى برلين الساعة 15:30.', 'El próximo tren a Berlín sale a las 15:30.'),
    'kreuzen sie die richtige antwort an.': ('Kreuzen Sie die richtige Antwort an.', 'Check the correct answer.', 'ضع علامة على الإجابة الصحيحة.', 'Marque la respuesta correcta.'),
    'frau schmidt soll bitte zur information kommen.': ('Frau Schmidt soll bitte zur Information kommen.', 'Ms. Schmidt please come to the information desk.', 'نرجو من السيدة شميت التوجه إلى مكتب الاستعلامات.', 'Se ruega a la Sra. Schmidt que acuda a información.'),
    'haben sie noch eine frage?': ('Haben Sie noch eine Frage?', 'Do you have another question?', 'هل لديك سؤال آخر؟', '¿Tiene alguna otra pregunta?')    ,
    'können sie das bitte wiederholen?': ('Können Sie das bitte wiederholen?', 'Could you please repeat that?', 'هل يمكنك إعادة ذلك من فضلك؟', '¿Puede repetir eso, por favor?'),
    'die praxis ist montags bis freitags von 8 bis 12 uhr geöffnet.': ('Die Praxis ist montags bis freitags von 8 bis 12 Uhr geöffnet.', 'The practice is open Monday to Friday from 8 am to 12 pm.', 'العيادة مفتوحة من الإثنين إلى الجمعة من الساعة 8 حتى 12 ظهراً.', 'La consulta está abierta de lunes a viernes de 8 a 12.'),
    'bitte füllen sie das formular aus.': ('Bitte füllen Sie das Formular aus.', 'Please fill out the form.', 'يرجى ملء الاستمارة.', 'Por favor, rellene el formulario.'),
    'hier fehlt noch ihre unterschrift.': ('Hier fehlt noch Ihre Unterschrift.', 'Your signature is still missing here.', 'توقيعك ينقص هنا.', 'Aquí todavía falta su firma.'),
    'ich habe alle aufgaben verstanden.': ('Ich habe alle Aufgaben verstanden.', 'I understood all tasks.', 'لقد فهمت جميع التمارين.', 'He entendido todas las tareas.'),
    'ich möchte ein einzelzimmer mit frühstück buchen.': ('Ich möchte ein Einzelzimmer mit Frühstück buchen.', 'I would like to book a single room with breakfast.', 'أود حجز غرفة مفردة مع وجبة الإفطار.', 'Me gustaría reservar una habitación individual con desayuno.'),
    'hier ist mein reisepass.': ('Hier ist mein Reisepass.', 'Here is my passport.', 'ها هو جواز سفري.', 'Aquí está mi pasaporte.'),
    'sehr geehrte frau müller, vielen dank für ihre einladung.': ('Sehr geehrte Frau Müller, vielen Dank für Ihre Einladung.', 'Dear Ms. Müller, thank you very much for your invitation.', 'سيدتي الفاضلة السيدة مولر، شكراً جزيلاً لدعوتك.', 'Estimada Sra. Müller, muchas gracias por su invitación.'),
    'lieber thomas, wie geht es dir?': ('Lieber Thomas, wie geht es dir?', 'Dear Thomas, how are you?', 'عزيزي توماس، كيف حالك؟', 'Querido Thomas, ¿cómo estás?'),
    'ich kann leider nicht kommen, weil ich einen arzttermin habe.': ('Ich kann leider nicht kommen, weil ich einen Arzttermin habe.', 'Unfortunately I cannot come because I have a doctor appointment.', 'للأسف لا أستطيع الحضور لأن لدي موعداً عند الطبيب.', 'Lamentablemente no puedo ir porque tengo cita médica.'),
    'ich lade dich herzlich zu meinem geburtstag ein.': ('Ich lade dich herzlich zu meinem Geburtstag ein.', 'I warmly invite you to my birthday.', 'أدعوك بحرارة لحضور عيد ميلادي.', 'Te invito cordialmente a mi cumpleaños.'),
    'die prüfung bestehen': ('die Prüfung bestehen', 'to pass the exam', 'النجاح في الامتحان', 'aprobar el examen'),
    'vielen dank für ihre schnelle antwort.': ('Vielen Dank für Ihre schnelle Antwort.', 'Thank you very much for your prompt reply.', 'شكراً جزيلاً لردكم السريع.', 'Muchas gracias por su pronta respuesta.'),
    'ich heiße sarah und ich komme aus marokko.': ('Ich heiße Sarah und ich komme aus Marokko.', 'My name is Sarah and I come from Morocco.', 'اسمي سارة وأنا من المغرب.', 'Me llamo Sarah y soy de Marruecos.'),
    'mein vorname buchstabiert sich: s-a-r-a-h.': ('Mein Vorname buchstabiert sich: S-A-R-A-H.', 'My first name is spelled: S-A-R-A-H.', 'الاسم الأول يُهجأ: س - ا - ر - ة.', 'Mi nombre se deletrea: S-A-R-A-H.'),
    'meine telefonnummer ist 0176 45 89 23.': ('Meine Telefonnummer ist 0176 45 89 23.', 'My telephone number is 0176 45 89 23.', 'رقم هاتفي هو 0176 45 89 23.', 'Mi número de teléfono es 0176 45 89 23.'),
    'thema essen: was frühstücken sie am liebsten?': ('Thema Essen: Was frühstücken Sie am liebsten?', 'Topic food: What do you like to eat for breakfast most?', 'موضوع الطعام: ما الذي تفضل تناوله في الإفطار؟', 'Tema comida: ¿Qué es lo que más le gusta desayunar?'),
    'geben sie mir bitte das buch!': ('Geben Sie mir bitte das Buch!', 'Please give me the book!', 'أعطني الكتاب من فضلك!', '¡Deme el libro, por favor!'),
    'darf ich hier rauchen?': ('Darf ich hier rauchen?', 'May I smoke here?', 'هل يُسمح لي بالتدخين هنا؟', '¿Puedo fumar aquí?'),
    'ja, natürlich. hier bitte!': ('Ja, natürlich. Hier bitte!', 'Yes, of course. Here you are!', 'نعم، بالطبع. تفضل!', 'Sí, por supuesto. ¡Aquí tiene!'),
}

fb_content = feedback_path.read_text(encoding='utf-8')
fb_target = '  static const Map<String, ({String de, String en, String ar, String es})> kTranslations = {'
fb_entries = []
for k, (de, en, ar, es) in sorted(unit14_feedback.items()):
    clean_k = k.lower().replace("'", "\\'")
    clean_de = de.replace("'", "\\'")
    clean_en = en.replace("'", "\\'")
    clean_ar = ar.replace("'", "\\'")
    clean_es = es.replace("'", "\\'")
    if f"'{clean_k}':" not in fb_content:
        fb_entries.append(f"    '{clean_k}': (de: '{clean_de}', en: '{clean_en}', ar: '\\u2066{clean_ar}\\u2069', es: '{clean_es}'),")

if fb_entries:
    replacement = fb_target + "\n" + "\n".join(fb_entries)
    fb_content = fb_content.replace(fb_target, replacement, 1)
    feedback_path.write_text(fb_content, encoding='utf-8')
    print(f"Added {len(fb_entries)} entries to feedback_translations_data.dart")
else:
    print("No new entries to add to feedback_translations_data.dart")
