from pathlib import Path

localizer_path = Path(r"c:\Users\HP\3D Objects\Deutschy-main\Deutschy-main\lib\src\features\study\domain\exercise_localizer.dart")
feedback_path = Path(r"c:\Users\HP\3D Objects\Deutschy-main\Deutschy-main\lib\src\features\study\domain\feedback_translations_data.dart")

unit12_options = {
    'sun': ('sun', 'شمس', 'sol'),
    'rain': ('rain', 'مطر', 'lluvia'),
    'snow': ('snow', 'ثلج', 'nieve'),
    'wind': ('wind', 'رياح / هواء', 'viento'),
    'cloud': ('cloud', 'سحابة / غيمة', 'nube'),
    'degree': ('degree', 'درجة', 'grado'),
    'spring': ('spring', 'الربيع', 'primavera'),
    'summer': ('summer', 'الصيف', 'verano'),
    'autumn': ('autumn', 'الخريف', 'otoño'),
    'autumn / fall': ('autumn / fall', 'الخريف', 'otoño'),
    'winter': ('winter', 'الشتاء', 'invierno'),
    'sky': ('sky', 'سماء', 'cielo'),
    'sunny': ('sunny', 'مشمس', 'soleado'),
    'cloudy': ('cloudy', 'غائم', 'nublado'),
    'windy': ('windy', 'عاصف / ذو رياح', 'ventoso'),
    'cold': ('cold', 'بارد', 'frío'),
    'warm': ('warm', 'دافئ', 'cálido'),
    'clear': ('clear', 'صافٍ', 'despejado'),
    'season of the year': ('season of the year', 'فصل من فصول السنة', 'estación del año'),
    'weather forecast': ('weather forecast', 'نشرة جوية', 'pronóstico del tiempo'),
    'holiday': ('holiday', 'عطلة', 'vacaciones'),
    'month': ('month', 'شهر', 'mes'),
    'star': ('star', 'نجم', 'estrella'),
    'moon': ('moon', 'قمر', 'luna'),
}

# Update exercise_localizer.dart
content = localizer_path.read_text(encoding='utf-8')
target = '  static const Map<String, ({String en, String ar, String es})> kExerciseOptions = {'
entries = []
for k, (en, ar, es) in sorted(unit12_options.items()):
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
unit12_feedback = {
    'wetter': ('Wetter', 'weather', 'طقس / جو', 'tiempo / clima'),
    'das wetter': ('das Wetter', 'the weather', 'الطقس', 'el tiempo'),
    'sonne': ('Sonne', 'sun', 'شمس', 'sol'),
    'die sonne': ('die Sonne', 'the sun', 'الشمس', 'el sol'),
    'regen': ('Regen', 'rain', 'مطر', 'lluvia'),
    'der regen': ('der Regen', 'the rain', 'المطر', 'la lluvia'),
    'schnee': ('Schnee', 'snow', 'ثلج', 'nieve'),
    'der schnee': ('der Schnee', 'the snow', 'الثلج', 'la nieve'),
    'wind': ('Wind', 'wind', 'رياح / هواء', 'viento'),
    'der wind': ('der Wind', 'the wind', 'الرياح', 'el viento'),
    'wolke': ('Wolke', 'cloud', 'سحابة / غيمة', 'nube'),
    'die wolke': ('die Wolke', 'the cloud', 'السحابة', 'la nube'),
    'grad': ('Grad', 'degree', 'درجة', 'grado'),
    'das grad': ('das Grad', 'the degree', 'الدرجة', 'el grado'),
    'frühling': ('Frühling', 'spring', 'الربيع', 'primavera'),
    'der frühling': ('der Frühling', 'the spring', 'فصل الربيع', 'la primavera'),
    'sommer': ('Sommer', 'summer', 'الصيف', 'verano'),
    'der sommer': ('der Sommer', 'the summer', 'فصل الصيف', 'el verano'),
    'herbst': ('Herbst', 'autumn', 'الخريف', 'otoño'),
    'der herbst': ('der Herbst', 'the autumn', 'فصل الخريف', 'el otoño'),
    'winter': ('Winter', 'winter', 'الشتاء', 'invierno'),
    'der winter': ('der Winter', 'the winter', 'فصل الشتاء', 'el invierno'),
    'himmel': ('Himmel', 'sky', 'سماء', 'cielo'),
    'der himmel': ('der Himmel', 'the sky', 'السماء', 'el cielo'),
    'regenschirm': ('Regenschirm', 'umbrella', 'مظلة مطر', 'paraguas'),
    'der regenschirm': ('der Regenschirm', 'the umbrella', 'مظلة المطر', 'el paraguas'),
    'jahreszeit': ('Jahreszeit', 'season of the year', 'فصل من فصول السنة', 'estación del año'),
    'die jahreszeit': ('die Jahreszeit', 'the season', 'الفصل السنوي', 'la estación'),
    'sonnig': ('sonnig', 'sunny', 'مشمس', 'soleado'),
    'windig': ('windig', 'windy', 'عاصف', 'ventoso'),
    'bewölkt': ('bewölkt', 'cloudy', 'غائم', 'nublado'),
    'kalt': ('kalt', 'cold', 'بارد', 'frío'),
    'warm': ('warm', 'warm', 'دافئ', 'cálido'),
    'heiß': ('heiß', 'hot', 'حار / ساخن', 'caluroso'),
    'schön': ('schön', 'beautiful / nice', 'جميل / لطيف', 'bonito'),
    'schlecht': ('schlecht', 'bad', 'سيء', 'malo'),
    'regnen': ('regnen', 'to rain', 'تمطر', 'llover'),
    'schneien': ('schneien', 'to snow', 'تثلج', 'nevar'),
    'scheinen': ('scheinen', 'to shine', 'تشرق', 'brillar'),
    'heute scheint die sonne.': ('Heute scheint die Sonne.', 'The sun is shining today.', 'الشمس تشرق اليوم.', 'Hoy brilla el sol.'),
    'es regnet heute sehr stark.': ('Es regnet heute sehr stark.', 'It is raining very heavily today.', 'إنها تمطر بغزارة اليوم.', 'Hoy llueve muy fuerte.'),
    'das wetter ist heute wunderschön.': ('Das Wetter ist heute wunderschön.', 'The weather is wonderful today.', 'الطقس رائع جداً اليوم.', 'El tiempo está maravilloso hoy.'),
    'im sommer ist es in deutschland warm.': ('Im Sommer ist es in Deutschland warm.', 'In summer it is warm in Germany.', 'في الصيف يكون الجو دافئاً في ألمانيا.', 'En verano hace calor en Alemania.'),
    'im winter schneit es oft.': ('Im Winter schneit es oft.', 'In winter it often snows.', 'في الشتاء تثلج كثيراً.', 'En invierno nieva a menudo.'),
    'der herbst kommt nach dem sommer.': ('Der Herbst kommt nach dem Sommer.', 'Autumn comes after summer.', 'يأتي الخريف بعد الصيف.', 'El otoño viene después del verano.'),
    'meine lieblingsjahreszeit ist der frühling.': ('Meine Lieblingsjahreszeit ist der Frühling.', 'My favourite season is spring.', 'فصلي المفضل هو الربيع.', 'Mi estación favorita es la primavera.')    ,
    'heute ist es sehr kalt draußen.': ('Heute ist es sehr kalt draußen.', 'It is very cold outside today.', 'الجو بارد جداً بالخارج اليوم.', 'Hoy hace mucho frío afuera.'),
    'es sind 25 grad.': ('Es sind 25 Grad.', 'It is 25 degrees.', 'درجة الحرارة 25 درجة.', 'Hace 25 grados.'),
    'morgen wird es windig und regnerisch.': ('Morgen wird es windig und regnerisch.', 'Tomorrow will be windy and rainy.', 'سيكون الطقس غداً عاصفاً وممطراً.', 'Mañana estará ventoso y lluvioso.'),
    'nimm deinen regenschirm mit, es regnet!': ('Nimm deinen Regenschirm mit, es regnet!', 'Take your umbrella with you, it is raining!', 'خذ مظلتك معك، إنها تمطر!', '¡Llévate el paraguas, está lloviendo!'),
    'es ist heute sehr heiß.': ('Es ist heute sehr heiß.', 'It is very hot today.', 'الجو حار جداً اليوم.', 'Hoy hace mucho calor.'),
    'wie viel grad haben wir heute?': ('Wie viel Grad haben wir heute?', 'What temperature is it today?', 'كم درجة الحرارة اليوم؟', '¿Cuántos grados tenemos hoy?'),
    'im süden gibt es heute viel sonne.': ('Im Süden gibt es heute viel Sonne.', 'In the south there is a lot of sun today.', 'في الجنوب توجد شمس كثيرة اليوم.', 'En el sur hay mucho sol hoy.'),
    'das wetter ist leider sehr schlecht.': ('Das Wetter ist leider sehr schlecht.', 'Unfortunately the weather is very bad.', 'للأسف الطقس سيء جداً.', 'Lamentablemente el tiempo es muy malo.'),
    'morgen wird es wieder schön.': ('Morgen wird es wieder schön.', 'Tomorrow it will be nice again.', 'غداً سيصبح الطقس جميلاً من جديد.', 'Mañana volverá a hacer buen tiempo.'),
    'in spanien ist es im sommer sehr heiß.': ('In Spanien ist es im Sommer sehr heiß.', 'In Spain it is very hot in summer.', 'في إسبانيا الجو حار جداً في الصيف.', 'En España hace mucho calor en verano.'),
    'die temperatur liegt bei 30 grad.': ('Die Temperatur liegt bei 30 Grad.', 'The temperature is at 30 degrees.', 'درجة الحرارة 30 درجة.', 'La temperatura ronda los 30 grados.'),
    'wir machen am wochenende einen ausflug in die berge.': ('Wir machen am Wochenende einen Ausflug in die Berge.', 'We are taking a weekend trip to the mountains.', 'سنقوم برحلة إلى الجبال في نهاية الأسبوع.', 'Hacemos una excursión a las montañas el fin de semana.'),
    'im herbst wird es kühler und es regnet oft.': ('Im Herbst wird es kühler und es regnet oft.', 'In autumn it gets cooler and it rains often.', 'في الخريف يصبح الجو أبرد وتمطر كثيراً.', 'En otoño refresca y llueve a menudo.'),
    'ich liebe sonniges wetter.': ('Ich liebe sonniges Wetter.', 'I love sunny weather.', 'أنا أحب الطقس المشمس.', 'Me encanta el tiempo soleado.'),
}

fb_content = feedback_path.read_text(encoding='utf-8')
fb_target = '  static const Map<String, ({String de, String en, String ar, String es})> kTranslations = {'
fb_entries = []
for k, (de, en, ar, es) in sorted(unit12_feedback.items()):
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
