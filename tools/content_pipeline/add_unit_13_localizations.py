from pathlib import Path

localizer_path = Path(r"c:\Users\HP\3D Objects\Deutschy-main\Deutschy-main\lib\src\features\study\domain\exercise_localizer.dart")
feedback_path = Path(r"c:\Users\HP\3D Objects\Deutschy-main\Deutschy-main\lib\src\features\study\domain\feedback_translations_data.dart")

unit13_options = {
    'train station': ('train station', 'محطة قطار', 'estación de tren'),
    'train': ('train', 'قطار', 'tren'),
    'bus': ('bus', 'حافلة / باص', 'autobús'),
    'airport': ('airport', 'مطار', 'aeropuerto'),
    'airplane': ('airplane', 'طائرة', 'avión'),
    'ticket': ('ticket', 'تذكرة سفر', 'billete'),
    'platform / track': ('platform / track', 'رصيف المحطة', 'vía / andén'),
    'bus stop': ('bus stop', 'موقف حافلة', 'parada de autobús'),
    'traffic light': ('traffic light', 'إشارة مرور', 'semáforo'),
    'street': ('street', 'شارع', 'calle'),
    'corner': ('corner', 'زاوية / ركن', 'esquina'),
    'to the left': ('to the left', 'إلى اليسار', 'a la izquierda'),
    'to the right': ('to the right', 'إلى اليمين', 'a la derecha'),
    'straight ahead': ('straight ahead', 'إلى الأمام مباشرة', 'todo recto'),
    'to depart': ('to depart', 'ينطلق / يغادر', 'partir / salir'),
    'to arrive': ('to arrive', 'يصل', 'llegar'),
    'to change trains / buses': ('to change trains / buses', 'يبدل وسيلة المواصلات', 'hacer transbordo'),
    'close / near': ('close / near', 'قريب', 'cerca'),
    'far': ('far', 'بعيد', 'lejos'),
    'far away': ('far away', 'بعيد', 'lejos'),
    'bicycle': ('bicycle', 'دراجة هوائية', 'bicicleta'),
    'railway station': ('railway station', 'محطة قطار', 'estación de tren'),
    'crossroad': ('crossroad', 'تقاطع طرق', 'cruce'),
    'street sign': ('street sign', 'لافتة شارع', 'señal de tráfico'),
    'bridge': ('bridge', 'جسر', 'puente'),
    'motorcycle': ('motorcycle', 'دراجة نارية', 'motocicleta'),
}

# Update exercise_localizer.dart
content = localizer_path.read_text(encoding='utf-8')
target = '  static const Map<String, ({String en, String ar, String es})> kExerciseOptions = {'
entries = []
for k, (en, ar, es) in sorted(unit13_options.items()):
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
unit13_feedback = {
    'bahnhof': ('Bahnhof', 'train station', 'محطة قطار', 'estación de tren'),
    'der bahnhof': ('der Bahnhof', 'the train station', 'محطة القطار', 'la estación de tren'),
    'zug': ('Zug', 'train', 'قطار', 'tren'),
    'der zug': ('der Zug', 'the train', 'القطار', 'el tren'),
    'bus': ('Bus', 'bus', 'حافلة / باص', 'autobús'),
    'der bus': ('der Bus', 'the bus', 'الحافلة', 'el autobús'),
    'flughafen': ('Flughafen', 'airport', 'مطار', 'aeropuerto'),
    'der flughafen': ('der Flughafen', 'the airport', 'المطار', 'el aeropuerto'),
    'flugzeug': ('Flugzeug', 'airplane', 'طائرة', 'avión'),
    'das flugzeug': ('das Flugzeug', 'the airplane', 'الطائرة', 'el avión'),
    'fahrkarte': ('Fahrkarte', 'ticket', 'تذكرة سفر', 'billete'),
    'die fahrkarte': ('die Fahrkarte', 'the ticket', 'تذكرة السفر', 'el billete'),
    'gleis': ('Gleis', 'platform / track', 'رصيف المحطة', 'vía / andén'),
    'das gleis': ('das Gleis', 'the platform', 'رصيف المحطة', 'la vía'),
    'haltestelle': ('Haltestelle', 'bus stop', 'موقف حافلة', 'parada'),
    'die haltestelle': ('die Haltestelle', 'the stop', 'الموقف', 'la parada'),
    'ampel': ('Ampel', 'traffic light', 'إشارة مرور', 'semáforo'),
    'die ampel': ('die Ampel', 'the traffic light', 'إشارة المرور', 'el semáforo'),
    'straße': ('Straße', 'street', 'شارع', 'calle'),
    'die straße': ('die Straße', 'the street', 'الشارع', 'la calle'),
    'ecke': ('Ecke', 'corner', 'زاوية / ركن', 'esquina'),
    'die ecke': ('die Ecke', 'the corner', 'الزاوية', 'la esquina'),
    'links': ('links', 'to the left', 'يساراً', 'a la izquierda'),
    'rechts': ('rechts', 'to the right', 'يميناً', 'a la derecha'),
    'geradeaus': ('geradeaus', 'straight ahead', 'إلى الأمام مباشرة', 'todo recto'),
    'abfahren': ('abfahren', 'to depart', 'ينطلق / يغادر', 'partir / salir'),
    'ankommen': ('ankommen', 'to arrive', 'يصل', 'llegar'),
    'umsteigen': ('umsteigen', 'to change trains', 'يبدل القطار', 'hacer transbordo'),
    'einsteigen': ('einsteigen', 'to get on / board', 'يركب', 'subir a'),
    'aussteigen': ('aussteigen', 'to get off', 'ينزل', 'bajar de'),
    'nähe': ('Nähe', 'vicinity / nearby', 'قرب / جوار', 'cercanía'),
    'die nähe': ('die Nähe', 'the vicinity', 'الجوار', 'la cercanía'),
    'weit': ('weit', 'far', 'بعيد', 'lejos'),
    'nah': ('nah', 'near / close', 'قريب', 'cerca'),
    'reisen': ('reisen', 'to travel', 'يسافر', 'viajar'),
    'auto': ('Auto', 'car', 'سيارة', 'coche'),
    'das auto': ('das Auto', 'the car', 'السيارة', 'el coche'),
    'fahrrad': ('Fahrrad', 'bicycle', 'دراجة هوائية', 'bicicleta'),
    'das fahrrad': ('das Fahrrad', 'the bicycle', 'الدراجة', 'la bicicleta'),
    'ich brauche eine fahrkarte nach frankfurt.': ('Ich brauche eine Fahrkarte nach Frankfurt.', 'I need a ticket to Frankfurt.', 'أحتاج تذكرة إلى فرانكفورت.', 'Necesito un billete a Fráncfort.'),
    'der zug fährt von gleis 4 ab.': ('Der Zug fährt von Gleis 4 ab.', 'The train departs from platform 4.', 'ينطلق القطار من الرصيف 4.', 'El tren sale de la vía 4.'),
    'wir fahren mit dem bus zur arbeit.': ('Wir fahren mit dem Bus zur Arbeit.', 'We go to work by bus.', 'نحن نذهب بالحافلة إلى العمل.', 'Vamos al trabajo en autobús.'),
    'eine fahrkarte nach hamburg, bitte.': ('Eine Fahrkarte nach Hamburg, bitte.', 'A ticket to Hamburg, please.', 'تذكرة إلى هامبورغ، من فضلك.', 'Un billete para Hamburgo, por favor.'),
    'an der ampel biegen sie nach rechts ab.': ('An der Ampel biegen Sie nach rechts ab.', 'Turn right at the traffic lights.', 'انعطف يميناً عند إشارة المرور.', 'Gire a la derecha en el semáforo.'),
    'entschuldigung, wo ist der bahnhof?': ('Entschuldigung, wo ist der Bahnhof?', 'Excuse me, where is the train station?', 'معذرة، أين محطة القطار؟', 'Disculpe, ¿dónde está la estación de tren?'),
    'das restaurant ist gleich an der ecke.': ('Das Restaurant ist gleich an der Ecke.', 'The restaurant is right at the corner.', 'المطعم موجود مباشرة عند الزاوية.', 'El restaurante está justo en la esquina.'),
    'gehen sie immer geradeaus.': ('Gehen Sie immer geradeaus.', 'Keep going straight ahead.', 'سر دائماً إلى الأمام مباشرة.', 'Siga todo recto.'),
    'geh geradeaus bis zur kreuzung!': ('Geh geradeaus bis zur Kreuzung!', 'Go straight ahead to the intersection!', 'سر إلى الأمام مباشرة حتى التقاطع!', '¡Ve todo recto hasta el cruce!'),
    'bieg nach links ab!': ('Bieg nach links ab!', 'Turn left!', 'انعطف يساراً!', '¡Gira a la izquierda!'),
    'fahr mit der u-bahn, das ist schneller.': ('Fahr mit der U-Bahn, das ist schneller.', 'Take the underground, it is faster.', 'اركب مترو الأنفاق، إنه أسرع.', 'Ve en metro, es más rápido.'),
    'ist die bank in der nähe?': ('Ist die Bank in der Nähe?', 'Is the bank nearby?', 'هل المصرف قريب من هنا؟', '¿Está cerca el banco?'),
    'fahr bitte vorsichtig!': ('Fahr bitte vorsichtig!', 'Please drive carefully!', 'قُد بحذر من فضلك!', '¡Conduce con cuidado, por favor!'),
    'ich bin gestern nach berlin gefahren.': ('Ich bin gestern nach Berlin gefahren.', 'I traveled to Berlin yesterday.', 'سافرت أمس إلى برلين.', 'Ayer viajé a Berlín.'),
    'wir haben eine fahrkarte gekauft.': ('Wir haben eine Fahrkarte gekauft.', 'We bought a ticket.', 'اشترينا تذكرة سفر.', 'Compramos un billete.'),
    'der zug ist pünktlich angekommen.': ('Der Zug ist pünktlich angekommen.', 'The train arrived on time.', 'وصل القطار في موعده تماماً.', 'El tren llegó puntual.'),
    'sie sind nach spanien gereist.': ('Sie sind nach Spanien gereist.', 'They traveled to Spain.', 'سافروا إلى إسبانيا.', 'Viajaron a España.'),
    'ich bin gut angekommen.': ('Ich bin gut angekommen.', 'I arrived safely.', 'وصلت بسلام.', 'He llegado bien.'),
    'achtung an gleis 2: der ice nach münchen fährt ein.': ('Achtung an Gleis 2: Der ICE nach München fährt ein.', 'Attention on platform 2: The ICE to Munich is arriving.', 'انتباه على الرصيف 2: قطار ICE المتجه إلى ميونخ يدخل المحطة.', 'Atención en la vía 2: llega el ICE a Múnich.'),
    'wir müssen in hannover umsteigen.': ('Wir müssen in Hannover umsteigen.', 'We have to change trains in Hanover.', 'علينا تبديل القطار في هانوفر.', 'Tenemos que hacer transbordo en Hannover.'),
    'sie müssen an der haltestelle stadtmitte aussteigen.': ('Sie müssen an der Haltestelle Stadtmitte aussteigen.', 'You have to get off at the Stadtmitte stop.', 'يجب أن تنزل في موقف وسط المدينة.', 'Debe bajarse en la parada Stadtmitte.'),
    'ich fahre gerne mit dem fahrrad.': ('Ich fahre gerne mit dem Fahrrad.', 'I like riding my bicycle.', 'أحب ركوب الدراجة الهوائية.', 'Me gusta montar en bicicleta.'),
    'wann fährt der nächste bus?': ('Wann fährt der nächste Bus?', 'When does the next bus leave?', 'متى تنطلق الحافلة القادمة؟', '¿Cuándo sale el próximo autobús?'),
}

fb_content = feedback_path.read_text(encoding='utf-8')
fb_target = '  static const Map<String, ({String de, String en, String ar, String es})> kTranslations = {'
fb_entries = []
for k, (de, en, ar, es) in sorted(unit13_feedback.items()):
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
