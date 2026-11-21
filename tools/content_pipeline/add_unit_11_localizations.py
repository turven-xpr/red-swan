from pathlib import Path

localizer_path = Path(r"c:\Users\HP\3D Objects\Deutschy-main\Deutschy-main\lib\src\features\study\domain\exercise_localizer.dart")
feedback_path = Path(r"c:\Users\HP\3D Objects\Deutschy-main\Deutschy-main\lib\src\features\study\domain\feedback_translations_data.dart")

unit11_options = {
    'head': ('head', 'رأس', 'cabeza'),
    'eye': ('eye', 'عين', 'ojo'),
    'ear': ('ear', 'أذن', 'oreja'),
    'mouth': ('mouth', 'فم', 'boca'),
    'stomach / belly': ('stomach / belly', 'بطن', 'barriga / estómago'),
    'hand': ('hand', 'يد', 'mano'),
    'foot': ('foot', 'قدم', 'pie'),
    'leg': ('leg', 'ساق', 'pierna'),
    'arm': ('arm', 'ذراع', 'brazo'),
    'pharmacy': ('pharmacy', 'صيدلية', 'farmacia'),
    'hospital': ('hospital', 'مستشفى', 'hospital'),
    'medication / medicine': ('medication / medicine', 'دواء', 'medicamento'),
    'prescription': ('prescription', 'وصفة طبية / روشتة', 'receta médica'),
    'tablet / pill': ('tablet / pill', 'حبة دواء', 'pastilla'),
    'fever': ('fever', 'حمى / حرارة مرتفعة', 'fiebre'),
    'pain': ('pain', 'ألم', 'dolor'),
    'sick': ('sick', 'مريض', 'enfermo'),
    'healthy': ('healthy', 'صحي / معافى', 'sano'),
    'tired': ('tired', 'متعب', 'cansado'),
}

# Update exercise_localizer.dart
content = localizer_path.read_text(encoding='utf-8')
target = '  static const Map<String, ({String en, String ar, String es})> kExerciseOptions = {'
entries = []
for k, (en, ar, es) in sorted(unit11_options.items()):
    clean_k = k.lower().replace("'", "\\'")
    if f"'{clean_k}':" not in content:
        entries.append(f"    '{clean_k}': (en: '{en}', ar: '{ar}', es: '{es}'),")

if entries:
    replacement = target + "\n" + "\n".join(entries)
    content = content.replace(target, replacement, 1)
    localizer_path.write_text(content, encoding='utf-8')
    print(f"Added {len(entries)} options to exercise_localizer.dart")

# Update feedback_translations_data.dart
unit11_feedback = {
    'körper': ('Körper', 'body', 'جسم', 'cuerpo'),
    'der körper': ('der Körper', 'the body', 'الجسم', 'el cuerpo'),
    'kopf': ('Kopf', 'head', 'رأس', 'cabeza'),
    'der kopf': ('der Kopf', 'the head', 'الرأس', 'la cabeza'),
    'auge': ('Auge', 'eye', 'عين', 'ojo'),
    'das auge': ('das Auge', 'the eye', 'العين', 'el ojo'),
    'ohr': ('Ohr', 'ear', 'أذن', 'oreja'),
    'das ohr': ('das Ohr', 'the ear', 'الأذن', 'la oreja'),
    'mund': ('Mund', 'mouth', 'فم', 'boca'),
    'der mund': ('der Mund', 'the mouth', 'الفم', 'la boca'),
    'zahn': ('Zahn', 'tooth', 'سن', 'diente'),
    'der zahn': ('der Zahn', 'the tooth', 'السن', 'el diente'),
    'hals': ('Hals', 'throat / neck', 'حلق / عنق', 'cuello'),
    'der hals': ('der Hals', 'the throat', 'الحلق', 'la garganta'),
    'hand': ('Hand', 'hand', 'يد', 'mano'),
    'die hand': ('die Hand', 'the hand', 'اليد', 'la mano'),
    'arm': ('Arm', 'arm', 'ذراع', 'brazo'),
    'der arm': ('der Arm', 'the arm', 'الذراع', 'el brazo'),
    'bein': ('Bein', 'leg', 'ساق', 'pierna'),
    'das bein': ('das Bein', 'the leg', 'الساق', 'la pierna'),
    'fuß': ('Fuß', 'foot', 'قدم', 'pie'),
    'der fuß': ('der Fuß', 'the foot', 'القدم', 'el pie'),
    'bauch': ('Bauch', 'stomach', 'بطن', 'barriga'),
    'der bauch': ('der Bauch', 'the stomach', 'البطن', 'el estómago'),
    'rücken': ('Rücken', 'back', 'ظهر', 'espalda'),
    'der rücken': ('der Rücken', 'the back', 'الظهر', 'la espalda'),
    'fieber': ('Fieber', 'fever', 'حمى', 'fiebre'),
    'das fieber': ('das Fieber', 'the fever', 'الحمى', 'la fiebre'),
    'schmerz': ('Schmerz', 'pain', 'ألم', 'dolor'),
    'der schmerz': ('der Schmerz', 'the pain', 'الألم', 'el dolor'),
    'medikament': ('Medikament', 'medication', 'دواء', 'medicamento'),
    'das medikament': ('das Medikament', 'the medication', 'الدواء', 'el medicamento'),
    'apotheke': ('Apotheke', 'pharmacy', 'صيدلية', 'farmacia'),
    'die apotheke': ('die Apotheke', 'the pharmacy', 'الصيدلية', 'la farmacia'),
    'krankenhaus': ('Krankenhaus', 'hospital', 'مستشفى', 'hospital'),
    'das krankenhaus': ('das Krankenhaus', 'the hospital', 'المستشفى', 'el hospital'),
    'wehtun': ('wehtun', 'to hurt', 'يؤلم', 'doler'),
    'dürfen': ('dürfen', 'may / to be allowed to', 'يُسمح له', 'poder / tener permiso'),
    'krank': ('krank', 'sick', 'مريض', 'enfermo'),
    'gesund': ('gesund', 'healthy', 'سليم / معافى', 'sano'),
    'müde': ('müde', 'tired', 'متعب', 'cansado'),
    'tablette': ('Tablette', 'pill / tablet', 'حبة دواء', 'pastilla'),
    'die tablette': ('die Tablette', 'the pill', 'حبة الدواء', 'la pastilla'),
    'rezept': ('Rezept', 'prescription', 'وصفة طبية / روشتة', 'receta médica'),
    'das rezept': ('das Rezept', 'the prescription', 'الوصفة الطبية', 'la receta'),
    'mein kopf tut weh.': ('Mein Kopf tut weh.', 'My head hurts.', 'رأسي يؤلمني.', 'Me duele la cabeza.'),
    'ich habe starke kopfschmerzen.': ('Ich habe starke Kopfschmerzen.', 'I have a bad headache.', 'عندي صداع شديد.', 'Tengo un fuerte dolor de cabeza.'),
    'meine augen tun weh.': ('Meine Augen tun weh.', 'My eyes hurt.', 'عيناي تؤلماني.', 'Me duelen los ojos.'),
    'nehmen sie diese tabletten dreimal täglich.': ('Nehmen Sie diese Tabletten dreimal täglich.', 'Take these tablets three times a day.', 'تناول هذه الحبوب ثلاث مرات يومياً.', 'Tome estas pastillas tres veces al día.'),
    'der arzt gibt mir ein rezept.': ('Der Arzt gibt mir ein Rezept.', 'The doctor gives me a prescription.', 'يعطيني الطبيب وصفة طبية.', 'El médico me da una receta.'),
    'ich habe 38,5 grad fieber.': ('Ich habe 38,5 Grad Fieber.', 'I have a fever of 38.5 degrees.', 'حرارتي 38.5 درجة.', 'Tengo 38,5 grados de fiebre.'),
    'gute besserung!': ('Gute Besserung!', 'Get well soon!', 'بالشفاء العاجل!', '¡Que te mejores!'),
    'mein rücken tut weh.': ('Mein Rücken tut weh.', 'My back hurts.', 'ظهري يؤلمني.', 'Me duele la espalda.'),
    'meine beine tun weh.': ('Meine Beine tun weh.', 'My legs hurt.', 'ساقاي تؤلماني.', 'Me duelen las piernas.'),
    'ich fühle mich heute sehr krank.': ('Ich fühle mich heute sehr krank.', 'I feel very sick today.', 'أشعر بمرض شديد اليوم.', 'Me siento muy enfermo hoy.'),
    'was fehlt ihnen denn?': ('Was fehlt Ihnen denn?', 'What is bothering you?', 'ما الذي تشكو منه؟', '¿Qué le pasa?'),
    'der zahn tut weh.': ('Der Zahn tut weh.', 'The tooth hurts.', 'الضرس يؤلمني.', 'Me duele la muela.'),
    'ich habe starke halsschmerzen.': ('Ich habe starke Halsschmerzen.', 'I have a severe sore throat.', 'عندي ألم شديد في الحلق.', 'Tengo un fuerte dolor de garganta.'),
    'hier darf man nicht rauchen.': ('Hier darf man nicht rauchen.', 'Smoking is not allowed here.', 'لا يُسمح بالتدخين هنا.', 'Aquí no se permite fumar.'),
    'darf ich hier parken?': ('Darf ich hier parken?', 'May I park here?', 'هل يجوز لي ركن السيارة هنا؟', '¿Puedo aparcar aquí?'),
    'im krankenhaus darf man nicht laut sein.': ('Im Krankenhaus darf man nicht laut sein.', 'One must not be loud in the hospital.', 'لا يجوز إحداث ضوضاء في المستشفى.', 'En el hospital no se debe hacer ruido.'),
    'sie dürfen wieder sport machen.': ('Sie dürfen wieder Sport machen.', 'You may do sports again.', 'يمكنك ممارسة الرياضة مجدداً.', 'Puede volver a hacer deporte.'),
    'hier darf man keinen alkohol trinken.': ('Hier darf man keinen Alkohol trinken.', 'Drinking alcohol is not allowed here.', 'لا يُسمح بشرب الكحول هنا.', 'Aquí no se permite beber alcohol.'),
    'darf ich eine frage stellen?': ('Darf ich eine Frage stellen?', 'May I ask a question?', 'هل يسمح لي بطرح سؤال؟', '¿Puedo hacer una pregunta?'),
    'ich kann heute leider nicht zur arbeit kommen, weil ich krank bin.': ('Ich kann heute leider nicht zur Arbeit kommen, weil ich krank bin.', 'Unfortunately I cannot come to work today because I am sick.', 'للأسف لا أستطيع المجيء للعمل اليوم لأنني مريض.', 'Lamentablemente no puedo ir a trabajar hoy porque estoy enfermo.'),
    'bleiben sie drei tage im bett.': ('Bleiben Sie drei Tage im Bett.', 'Stay in bed for three days.', 'ابقَ في السرير لثلاثة أيام.', 'Quédese tres días en cama.'),
    'trinken sie viel wasser und tee.': ('Trinken Sie viel Wasser und Tee.', 'Drink lots of water and tea.', 'اشرب الكثير من الماء والشاي.', 'Beba mucha agua y té.'),
    'ich schicke ihnen die krankmeldung per e-mail.': ('Ich schicke Ihnen die Krankmeldung per E-Mail.', 'I will send you the sick certificate via email.', 'سأرسل لك الإجازة المرضية عبر البريد الإلكتروني.', 'Le enviaré el justificante médico por correo.'),
    'ich muss zum arzt gehen.': ('Ich muss zum Arzt gehen.', 'I must go to the doctor.', 'يجب أن أذهب إلى الطبيب.', 'Tengo que ir al médico.'),
}

fb_content = feedback_path.read_text(encoding='utf-8')
fb_target = 'const Map<String, ({String de, String en, String ar, String es})> kGermanTranslations = {'
fb_entries = []
for k, (de, en, ar, es) in sorted(unit11_feedback.items()):
    clean_k = k.lower().replace("'", "\\'")
    if f"'{clean_k}':" not in fb_content:
        fb_entries.append(f"  '{clean_k}': (de: '{de}', en: '{en}', ar: '{ar}', es: '{es}'),")

if fb_entries:
    fb_replacement = fb_target + "\n" + "\n".join(fb_entries)
    fb_content = fb_content.replace(fb_target, fb_replacement, 1)
    feedback_path.write_text(fb_content, encoding='utf-8')
    print(f"Added {len(fb_entries)} entries to feedback_translations_data.dart")
