from pathlib import Path

localizer_path = Path(r"c:\Users\HP\3D Objects\Deutschy-main\Deutschy-main\lib\src\features\study\domain\exercise_localizer.dart")
feedback_path = Path(r"c:\Users\HP\3D Objects\Deutschy-main\Deutschy-main\lib\src\features\study\domain\feedback_translations_data.dart")

unit9_options = {
    'male doctor': ('male doctor', 'طبيب', 'médico'),
    'female doctor': ('female doctor', 'طبيبة', 'médica'),
    'male teacher': ('male teacher', 'معلم', 'profesor'),
    'female teacher': ('female teacher', 'معلمة', 'profesora'),
    'male colleague': ('male colleague', 'زميل عمل', 'colega (m.)'),
    'female colleague': ('female colleague', 'زميلة عمل', 'colega (f.)'),
    'company': ('company', 'شركة', 'empresa'),
    'office': ('office', 'مكتب', 'oficina'),
    'school': ('school', 'مدرسة', 'escuela'),
    'university': ('university', 'جامعة', 'universidad'),
    'internship': ('internship', 'تدريب عملي', 'prácticas'),
    'break / pause': ('break / pause', 'استراحة', 'pausa / descanso'),
    'job / position': ('job / position', 'وظيفة / منصب', 'puesto de trabajo'),
    'to earn': ('to earn', 'يكسب (مالاً)', 'ganar dinero'),
    'unemployed': ('unemployed', 'عاطل عن العمل', 'desempleado'),
    'hardworking': ('hardworking', 'مجتهد', 'trabajador'),
    'important': ('important', 'مهم', 'importante'),
    'boss': ('boss', 'رئيس العمل / مدير', 'jefe'),
}

# Update exercise_localizer.dart
content = localizer_path.read_text(encoding='utf-8')
target = '  static const Map<String, ({String en, String ar, String es})> kExerciseOptions = {'
entries = []
for k, (en, ar, es) in sorted(unit9_options.items()):
    clean_k = k.lower().replace("'", "\\'")
    if f"'{clean_k}':" not in content:
        entries.append(f"    '{clean_k}': (en: '{en}', ar: '{ar}', es: '{es}'),")

if entries:
    replacement = target + "\n" + "\n".join(entries)
    content = content.replace(target, replacement, 1)
    localizer_path.write_text(content, encoding='utf-8')
    print(f"Added {len(entries)} options to exercise_localizer.dart")

# Update feedback_translations_data.dart
unit9_feedback = {
    'arbeit': ('Arbeit', 'work / job', 'عمل', 'trabajo'),
    'die arbeit': ('die Arbeit', 'the work / job', 'العمل', 'el trabajo'),
    'beruf': ('Beruf', 'profession', 'مهنة', 'profesión'),
    'der beruf': ('der Beruf', 'the profession', 'المهنة', 'la profesión'),
    'arzt': ('Arzt', 'doctor (m.)', 'طبيب', 'médico'),
    'der arzt': ('der Arzt', 'the doctor (m.)', 'الطبيب', 'el médico'),
    'ärztin': ('Ärztin', 'doctor (f.)', 'طبيبة', 'médica'),
    'die ärztin': ('die Ärztin', 'the doctor (f.)', 'الطبيبة', 'la médica'),
    'lehrer': ('Lehrer', 'teacher (m.)', 'معلم', 'profesor'),
    'der lehrer': ('der Lehrer', 'the teacher (m.)', 'المعلم', 'el profesor'),
    'lehrerin': ('Lehrerin', 'teacher (f.)', 'معلمة', 'profesora'),
    'die lehrerin': ('die Lehrerin', 'the teacher (f.)', 'المعلمة', 'la profesora'),
    'kollege': ('Kollege', 'colleague (m.)', 'زميل عمل', 'colega (m.)'),
    'der kollege': ('der Kollege', 'the colleague (m.)', 'زميل العمل', 'el colega'),
    'kollegin': ('Kollegin', 'colleague (f.)', 'زميلة عمل', 'colega (f.)'),
    'die kollegin': ('die Kollegin', 'the colleague (f.)', 'زميلة العمل', 'la colega'),
    'büro': ('Büro', 'office', 'مكتب', 'oficina'),
    'das büro': ('das Büro', 'the office', 'المكتب', 'la oficina'),
    'firma': ('Firma', 'company', 'شركة', 'empresa'),
    'die firma': ('die Firma', 'the company', 'الشركة', 'la empresa'),
    'chef': ('Chef', 'boss', 'رئيس العمل', 'jefe'),
    'der chef': ('der Chef', 'the boss', 'رئيس العمل', 'el jefe'),
    'pause': ('Pause', 'break', 'استراحة', 'pausa'),
    'die pause': ('die Pause', 'the break', 'الاستراحة', 'la pausa'),
    'schule': ('Schule', 'school', 'مدرسة', 'escuela'),
    'die schule': ('die Schule', 'the school', 'المدرسة', 'la escuela'),
    'universität': ('Universität', 'university', 'جامعة', 'universidad'),
    'die universität': ('die Universität', 'the university', 'الجامعة', 'la universidad'),
    'stelle': ('Stelle', 'position / job', 'وظيفة / منصب', 'puesto de trabajo'),
    'die stelle': ('die Stelle', 'the position / job', 'الوظيفة', 'el puesto'),
    'praktikum': ('Praktikum', 'internship', 'تدريب عملي', 'prácticas'),
    'das praktikum': ('das Praktikum', 'the internship', 'التدريب العملي', 'las prácticas'),
    'arbeiten': ('arbeiten', 'to work', 'يعمل', 'trabajar'),
    'studieren': ('studieren', 'to study', 'يدرس بالجامعة', 'estudiar'),
    'suchen': ('suchen', 'to search', 'يبحث', 'buscar'),
    'finden': ('finden', 'to find', 'يجد', 'encontrar'),
    'verdienen': ('verdienen', 'to earn', 'يكسب', 'ganar dinero'),
    'arbeitslos': ('arbeitslos', 'unemployed', 'عاطل عن العمل', 'desempleado'),
    'fleißig': ('fleißig', 'hardworking', 'مجتهد', 'trabajador'),
    'wichtig': ('wichtig', 'important', 'مهم', 'importante'),
    'ich arbeite in einem büro.': ('Ich arbeite in einem Büro.', 'I work in an office.', 'أعمل في مكتب.', 'Trabajo en una oficina.'),
    'mein kollege ist sehr fleißig.': ('Mein Kollege ist sehr fleißig.', 'My colleague is very hardworking.', 'زميلي مجتهد جداً.', 'Mi colega es muy trabajador.'),
    'was sind sie von beruf?': ('Was sind Sie von Beruf?', 'What is your profession?', 'ما مهنة حضرتك؟', '¿A qué se dedica usted?'),
    'ich studiere an der universität informatik.': ('Ich studiere an der Universität Informatik.', 'I study computer science at university.', 'أدرس علوم الحاسوب في الجامعة.', 'Estudio informática en la universidad.'),
    'die kinder gehen in die schule.': ('Die Kinder gehen in die Schule.', 'The children go to school.', 'الأطفال يذهبون إلى المدرسة.', 'Los niños van a la escuela.'),
    'wir machen eine pause.': ('Wir machen eine Pause.', 'We are taking a break.', 'نحن نأخذ استراحة.', 'Hacemos una pausa.'),
    'ich mache ein praktikum in deutschland.': ('Ich mache ein Praktikum in Deutschland.', 'I do an internship in Germany.', 'أقوم بتدريب عملي في ألمانيا.', 'Hago unas prácticas en Alemania.'),
    'ich war gestern nicht im büro.': ('Ich war gestern nicht im Büro.', 'I was not in the office yesterday.', 'لم أكن في المكتب بالأمس.', 'Ayer no estuve en la oficina.'),
    'wo warst du gestern abend?': ('Wo warst du gestern Abend?', 'Where were you yesterday evening?', 'أين كنت مساء الأمس؟', '¿Dónde estuviste ayer por la tarde?'),
    'ich hatte gestern keine zeit.': ('Ich hatte gestern keine Zeit.', 'I had no time yesterday.', 'لم يكن لدي وقت بالأمس.', 'Ayer no tuve tiempo.'),
    'wir waren gestern in berlin.': ('Wir waren gestern in Berlin.', 'We were in Berlin yesterday.', 'كنا في برلين بالأمس.', 'Ayer estuvimos en Berlín.'),
    'er hatte gestern viel arbeit.': ('Er hatte gestern viel Arbeit.', 'He had a lot of work yesterday.', 'كان لديه الكثير من العمل بالأمس.', 'Él tuvo mucho trabajo ayer.'),
    'gestern hatte ich frei.': ('Gestern hatte ich frei.', 'Yesterday I had the day off.', 'بالأمس كنت في عطلة.', 'Ayer tuve el día libre.'),
    'ich arbeite als arzt.': ('Ich arbeite als Arzt.', 'I work as a doctor.', 'أعمل كطبيب.', 'Trabajo como médico.'),
    'er arbeitet bei siemens.': ('Er arbeitet bei Siemens.', 'He works at Siemens.', 'هو يعمل لدى شركة سيمنز.', 'Él trabaja en Siemens.'),
    'sie arbeitet als lehrerin in köln.': ('Sie arbeitet als Lehrerin in Köln.', 'She works as a teacher in Cologne.', 'تعمل كمعلمة في كولونيا.', 'Trabaja como profesora en Colonia.'),
    'was machst du beruflich?': ('Was machst du beruflich?', 'What do you do for a living?', 'ماذا تعمل في مهنتك؟', '¿A qué te dedicas?'),
    'ich suche eine neue stelle.': ('Ich suche eine neue Stelle.', 'I am looking for a new job.', 'أبحث عن وظيفة جديدة.', 'Busco un nuevo puesto de trabajo.'),
    'wir suchen ab sofort einen verkäufer.': ('Wir suchen ab sofort einen Verkäufer.', 'We are looking for a salesperson starting immediately.', 'نبحث عن بائع فوراً.', 'Buscamos un vendedor de inmediato.'),
    'ich habe die stelle gefunden.': ('Ich habe die Stelle gefunden.', 'I found the position.', 'لقد وجدت الوظيفة.', 'Encontré el puesto.'),
    'die arbeitszeit ist von 8 bis 17 uhr.': ('Die Arbeitszeit ist von 8 bis 17 Uhr.', 'The working hours are from 8 to 17.', 'ساعات العمل من 8 إلى 17.', 'El horario de trabajo es de 8 a 17.'),
    'die arbeit beginnt um 8 uhr.': ('Die Arbeit beginnt um 8 Uhr.', 'Work starts at 8 o\'clock.', 'يبدأ العمل في الساعة الثامنة.', 'El trabajo empieza a las 8.'),
    'meine kollegen sind sehr nett.': ('Meine Kollegen sind sehr nett.', 'My colleagues are very nice.', 'زملائي لطفاء جداً.', 'Mis colegas son muy amables.'),
}

fb_content = feedback_path.read_text(encoding='utf-8')
fb_target = 'const Map<String, ({String de, String en, String ar, String es})> kGermanTranslations = {'
fb_entries = []
for k, (de, en, ar, es) in sorted(unit9_feedback.items()):
    clean_k = k.lower().replace("'", "\\'")
    if f"'{clean_k}':" not in fb_content:
        fb_entries.append(f"  '{clean_k}': (de: '{de}', en: '{en}', ar: '{ar}', es: '{es}'),")

if fb_entries:
    fb_replacement = fb_target + "\n" + "\n".join(fb_entries)
    fb_content = fb_content.replace(fb_target, fb_replacement, 1)
    feedback_path.write_text(fb_content, encoding='utf-8')
    print(f"Added {len(fb_entries)} entries to feedback_translations_data.dart")
