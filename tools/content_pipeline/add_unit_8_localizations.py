from pathlib import Path

localizer_path = Path(r"c:\Users\HP\3D Objects\Deutschy-main\Deutschy-main\lib\src\features\study\domain\exercise_localizer.dart")
feedback_path = Path(r"c:\Users\HP\3D Objects\Deutschy-main\Deutschy-main\lib\src\features\study\domain\feedback_translations_data.dart")

unit8_options = {
    'clock / o\'clock': ('clock / o\'clock', 'ساعة (وقت أو حائط)', 'reloj / hora'),
    'hour': ('hour', 'ساعة (مدة زمنية)', 'hora (duración)'),
    'appointment': ('appointment', 'موعد', 'cita'),
    'invitation': ('invitation', 'دعوة', 'invitación'),
    'to get up': ('to get up', 'يستيقظ / ينهض', 'levantarse'),
    'to sleep': ('to sleep', 'ينام', 'dormir'),
    'must / to have to': ('must / to have to', 'يجب / يضطر', 'deber / tener que'),
    'can / to be able to': ('can / to be able to', 'يستطيع', 'poder'),
    'best regards / many greetings': ('Best regards / Many greetings', 'أطيب التحيات', 'saludos cordiales'),
    'yesterday': ('yesterday', 'أمس', 'ayer'),
}

# Update exercise_localizer.dart
content = localizer_path.read_text(encoding='utf-8')
target = '  static const Map<String, ({String en, String ar, String es})> kExerciseOptions = {'
entries = []
for k, (en, ar, es) in sorted(unit8_options.items()):
    clean_k = k.lower().replace("'", "\\'")
    if f"'{clean_k}':" not in content:
        entries.append(f"    '{clean_k}': (en: '{en}', ar: '{ar}', es: '{es}'),")

if entries:
    replacement = target + "\n" + "\n".join(entries)
    content = content.replace(target, replacement, 1)
    localizer_path.write_text(content, encoding='utf-8')
    print(f"Added {len(entries)} options to exercise_localizer.dart")

# Update feedback_translations_data.dart
unit8_feedback = {
    'uhr': ('Uhr', 'clock / o\'clock', 'ساعة', 'reloj / hora'),
    'die uhr': ('die Uhr', 'the clock / o\'clock', 'الساعة', 'el reloj'),
    'stunde': ('Stunde', 'hour', 'ساعة (مدة)', 'hora'),
    'die stunde': ('die Stunde', 'the hour', 'الساعة (المدة)', 'la hora'),
    'termin': ('Termin', 'appointment', 'موعد', 'cita'),
    'der termin': ('der Termin', 'the appointment', 'الموعد', 'la cita'),
    'brief': ('Brief', 'letter', 'رسالة', 'carta'),
    'der brief': ('der Brief', 'the letter', 'الرسالة', 'la carta'),
    'einladung': ('Einladung', 'invitation', 'دعوة', 'invitación'),
    'die einladung': ('die Einladung', 'the invitation', 'الدعوة', 'la invitación'),
    'aufstehen': ('aufstehen', 'to get up', 'يستيقظ', 'levantarse'),
    'anfangen': ('anfangen', 'to begin', 'يبدأ', 'empezar'),
    'aufhören': ('aufhören', 'to end / stop', 'ينتهي', 'terminar'),
    'schlafen': ('schlafen', 'to sleep', 'ينام', 'dormir'),
    'können': ('können', 'can / to be able to', 'يستطيع', 'poder'),
    'müssen': ('müssen', 'must / to have to', 'يجب', 'deber'),
    'wollen': ('wollen', 'to want', 'يريد', 'querer'),
    'heute': ('heute', 'today', 'اليوم', 'hoy'),
    'gestern': ('gestern', 'yesterday', 'أمس', 'ayer'),
    'spät': ('spät', 'late', 'متأخر', 'tarde'),
    'es ist acht uhr.': ('Es ist acht Uhr.', 'It is eight o\'clock.', 'إنها الساعة الثامنة.', 'Son las ocho en punto.'),
    'wie spät ist es?': ('Wie spät ist es?', 'What time is it?', 'كم الساعة؟', '¿Qué hora es?'),
    'wie spät ist es, bitte?': ('Wie spät ist es, bitte?', 'What time is it, please?', 'كم الساعة، لو سمحت؟', '¿Qué hora es, por favor?'),
    'wir treffen uns am morgen.': ('Wir treffen uns am Morgen.', 'We meet in the morning.', 'نلتقي في الصباح.', 'Nos encontramos por la mañana.'),
    'ich stehe jeden tag um 7 uhr auf.': ('Ich stehe jeden Tag um 7 Uhr auf.', 'I get up at 7 o\'clock every day.', 'أستيقظ كل يوم في الساعة السابعة.', 'Me levanto todos los días a las 7.'),
    'der kurs fängt um 9 uhr an.': ('Der Kurs fängt um 9 Uhr an.', 'The course starts at 9 o\'clock.', 'يبدأ الكورس في الساعة التاسعة.', 'El curso empieza a las 9.'),
    'wann hört die arbeit auf?': ('Wann hört die Arbeit auf?', 'When does work end?', 'متى ينتهي العمل؟', '¿Cuándo termina el trabajo?'),
    'ich habe heute einen termin beim arzt.': ('Ich habe heute einen Termin beim Arzt.', 'I have an appointment at the doctor today.', 'لدي موعد عند الطبيب اليوم.', 'Tengo una cita con el médico hoy.'),
    'der film beginnt um 20 uhr.': ('Der Film beginnt um 20 Uhr.', 'The movie starts at 8 PM.', 'يبدأ الفيلم في الساعة الثامنة مساءً.', 'La película empieza a las 20:00.'),
    'ich habe am montag deutschkurs.': ('Ich habe am Montag Deutschkurs.', 'I have German class on Monday.', 'لدي كورس ألماني يوم الإثنين.', 'Tengo clase de alemán el lunes.'),
    'mein geburtstag ist im mai.': ('Mein Geburtstag ist im Mai.', 'My birthday is in May.', 'عيد ميلادي في شهر مايو.', 'Mi cumpleaños es en mayo.'),
    'wir kochen am abend zusammen.': ('Wir kochen am Abend zusammen.', 'We cook together in the evening.', 'نطبخ معاً في المساء.', 'Cocinamos juntos por la tarde.'),
    'um wie viel uhr beginnt der kurs?': ('Um wie viel Uhr beginnt der Kurs?', 'At what time does the course begin?', 'في أي ساعة يبدأ الكورس؟', '¿A qué hora empieza el curso?'),
    'ich habe am wochenende zeit.': ('Ich habe am Wochenende Zeit.', 'I have time on the weekend.', 'لدي وقت في عطلة نهاية الأسبوع.', 'Tengo tiempo el fin de semana.'),
    'ich kann gut deutsch sprechen.': ('Ich kann gut Deutsch sprechen.', 'I can speak German well.', 'أستطيع التحدث بالألمانية جيداً.', 'Sé hablar alemán bien.'),
    'du musst heute lange arbeiten.': ('Du musst heute lange arbeiten.', 'You must work long today.', 'عليك أن تعمل لوقت متأخر اليوم.', 'Tienes que trabajar hasta tarde hoy.'),
    'wir wollen eine reise machen.': ('Wir wollen eine Reise machen.', 'We want to go on a trip.', 'نريد أن نقوم برحلة.', 'Queremos hacer un viaje.'),
    'er will ein auto kaufen.': ('Er will ein Auto kaufen.', 'He wants to buy a car.', 'هو يريد شراء سيارة.', 'Él quiere comprar un coche.'),
    'kannst du morgen mitkommen?': ('Kannst du morgen mitkommen?', 'Can you come along tomorrow?', 'هل يمكنك القدوم معنا غداً؟', '¿Puedes venir mañana?'),
    'ich kann leider nicht kommen.': ('Ich kann leider nicht kommen.', 'Unfortunately I cannot come.', 'للأسف لا أستطيع المجيء.', 'Lamentablemente no puedo venir.'),
    'liebe anna, wie geht es dir?': ('Liebe Anna, wie geht es dir?', 'Dear Anna, how are you?', 'عزيزتي آنا، كيف حالك؟', 'Querida Anna, ¿cómo estás?'),
    'lieber thomas, vielen dank für deinen brief!': ('Lieber Thomas, vielen Dank für deinen Brief!', 'Dear Thomas, thank you very much for your letter!', 'عزيزي توماس، شكراً جزيلاً على رسالتك!', '¡Querido Thomas, muchas gracias por tu carta!'),
    'ich lade dich herzlich zu meiner geburtstagsparty ein.': ('Ich lade dich herzlich zu meiner Geburtstagsparty ein.', 'I warmly invite you to my birthday party.', 'أدعوك من كل قلبي لحفلة عيد ميلادي.', 'Te invito cordialmente a mi fiesta de cumpleaños.'),
    'vielen dank für die einladung!': ('Vielen Dank für die Einladung!', 'Thank you very much for the invitation!', 'شكراً جزيلاً على الدعوة!', '¡Muchas gracias por la invitación!'),
    'viele grüße': ('Viele Grüße', 'Best regards', 'أطيب التحيات', 'Saludos cordiales'),
    'mit freundlichen grüßen': ('Mit freundlichen Grüßen', 'With kind regards (formal)', 'مع خالص التحيات والتقدير', 'Atentamente'),
}

fb_content = feedback_path.read_text(encoding='utf-8')
fb_target = 'const Map<String, ({String de, String en, String ar, String es})> kGermanTranslations = {'
fb_entries = []
for k, (de, en, ar, es) in sorted(unit8_feedback.items()):
    clean_k = k.lower().replace("'", "\\'")
    if f"'{clean_k}':" not in fb_content:
        fb_entries.append(f"  '{clean_k}': (de: '{de}', en: '{en}', ar: '{ar}', es: '{es}'),")

if fb_entries:
    fb_replacement = fb_target + "\n" + "\n".join(fb_entries)
    fb_content = fb_content.replace(fb_target, fb_replacement, 1)
    feedback_path.write_text(fb_content, encoding='utf-8')
    print(f"Added {len(fb_entries)} entries to feedback_translations_data.dart")
