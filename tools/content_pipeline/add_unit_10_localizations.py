from pathlib import Path

localizer_path = Path(r"c:\Users\HP\3D Objects\Deutschy-main\Deutschy-main\lib\src\features\study\domain\exercise_localizer.dart")
feedback_path = Path(r"c:\Users\HP\3D Objects\Deutschy-main\Deutschy-main\lib\src\features\study\domain\feedback_translations_data.dart")

unit10_options = {
    'dress': ('dress', 'فستان', 'vestido'),
    'pants / trousers': ('pants / trousers', 'بنطال', 'pantalón'),
    'shirt': ('shirt', 'قميص', 'camisa'),
    'shoe': ('shoe', 'حذاء', 'zapato'),
    'size': ('size', 'مقاس', 'talla'),
    'color': ('color', 'لون', 'color'),
    'money': ('money', 'نقود / مال', 'dinero'),
    'price': ('price', 'سعر', 'precio'),
    'cash register / checkout': ('cash register / checkout', 'خزينة الدفع / كاشير', 'caja'),
    'special offer / sale': ('special offer / sale', 'عرض خاص / تخفيض', 'oferta'),
    'bag': ('bag', 'حقيبة', 'bolso'),
    'cheap': ('cheap', 'رخيص', 'barato'),
    'expensive': ('expensive', 'غالي الثمن', 'caro'),
    'favorable / affordable': ('favorable / affordable', 'مناسب السعر', 'económico'),
    'customer (m.)': ('customer (m.)', 'زبون', 'cliente'),
    'to try on': ('to try on', 'يقيس (ملابس)', 'probarse'),
}

# Update exercise_localizer.dart
content = localizer_path.read_text(encoding='utf-8')
target = '  static const Map<String, ({String en, String ar, String es})> kExerciseOptions = {'
entries = []
for k, (en, ar, es) in sorted(unit10_options.items()):
    clean_k = k.lower().replace("'", "\\'")
    if f"'{clean_k}':" not in content:
        entries.append(f"    '{clean_k}': (en: '{en}', ar: '{ar}', es: '{es}'),")

if entries:
    replacement = target + "\n" + "\n".join(entries)
    content = content.replace(target, replacement, 1)
    localizer_path.write_text(content, encoding='utf-8')
    print(f"Added {len(entries)} options to exercise_localizer.dart")

# Update feedback_translations_data.dart
unit10_feedback = {
    'geld': ('Geld', 'money', 'نقود', 'dinero'),
    'das geld': ('das Geld', 'the money', 'النقود', 'el dinero'),
    'euro': ('Euro', 'euro', 'يورو', 'euro'),
    'der euro': ('der Euro', 'the euro', 'اليورو', 'el euro'),
    'cent': ('Cent', 'cent', 'سنت', 'céntimo'),
    'der cent': ('der Cent', 'the cent', 'السنت', 'el céntimo'),
    'preis': ('Preis', 'price', 'سعر', 'precio'),
    'der preis': ('der Preis', 'the price', 'السعر', 'el precio'),
    'kasse': ('Kasse', 'checkout', 'خزينة الدفع', 'caja'),
    'die kasse': ('die Kasse', 'the checkout', 'خزينة الدفع', 'la caja'),
    'kunde': ('Kunde', 'customer', 'زبون', 'cliente'),
    'der kunde': ('der Kunde', 'the customer', 'الزبون', 'el cliente'),
    'verkäufer': ('Verkäufer', 'salesman', 'بائع', 'vendedor'),
    'der verkäufer': ('der Verkäufer', 'the salesman', 'البائع', 'el vendedor'),
    'größe': ('Größe', 'size', 'مقاس', 'talla'),
    'die größe': ('die Größe', 'the size', 'المقاس', 'la talla'),
    'farbe': ('Farbe', 'color', 'لون', 'color'),
    'die farbe': ('die Farbe', 'the color', 'اللون', 'el color'),
    'angebot': ('Angebot', 'offer', 'عرض خاص', 'oferta'),
    'das angebot': ('das Angebot', 'the offer', 'العرض الخاص', 'la oferta'),
    'tasche': ('Tasche', 'bag', 'حقيبة', 'bolso'),
    'die tasche': ('die Tasche', 'the bag', 'الحقيبة', 'el bolso'),
    'schuh': ('Schuh', 'shoe', 'حذاء', 'zapato'),
    'der schuh': ('der Schuh', 'the shoe', 'الحذاء', 'el zapato'),
    'kleid': ('Kleid', 'dress', 'فستان', 'vestido'),
    'das kleid': ('das Kleid', 'the dress', 'الفستان', 'el vestido'),
    'hose': ('Hose', 'pants / trousers', 'بنطال', 'pantalón'),
    'die hose': ('die Hose', 'the pants', 'البنطال', 'el pantalón'),
    'hemd': ('Hemd', 'shirt', 'قميص', 'camisa'),
    'das hemd': ('das Hemd', 'the shirt', 'القميص', 'la camisa'),
    'kosten': ('kosten', 'to cost', 'يكلف', 'costar'),
    'bezahlen': ('bezahlen', 'to pay', 'يدفع', 'pagar'),
    'passen': ('passen', 'to fit', 'يناسب', 'quedar bien'),
    'anprobieren': ('anprobieren', 'to try on', 'يقيس ملابس', 'probarse'),
    'billig': ('billig', 'cheap', 'رخيص', 'barato'),
    'teuer': ('teuer', 'expensive', 'غالي الثمن', 'caro'),
    'günstig': ('günstig', 'affordable', 'مناسب السعر', 'económico'),
    'ich brauche ein weißes hemd.': ('Ich brauche ein weißes Hemd.', 'I need a white shirt.', 'أحتاج قميصاً أبيض.', 'Necesito una camisa blanca.'),
    'welche größe möchten sie?': ('Welche Größe möchten Sie?', 'Which size would you like?', 'ما المقاس الذي تريده؟', '¿Qué talla desea?'),
    'haben sie diese jacke in schwarz?': ('Haben Sie diese Jacke in Schwarz?', 'Do you have this jacket in black?', 'هل لديكم هذه السترة باللون الأسود؟', '¿Tiene esta chaqueta en negro?'),
    'das kostet 29 euro und 50 cent.': ('Das kostet 29 Euro und 50 Cent.', 'That costs 29 euros and 50 cents.', 'يكلف ذلك 29 يورو و50 سنتاً.', 'Cuesta 29 euros con 50 céntimos.'),
    'ich möchte mit karte bezahlen.': ('Ich möchte mit Karte bezahlen.', 'I would like to pay by card.', 'أود الدفع بالبطاقة.', 'Me gustaría pagar con tarjeta.'),
    'kann ich bitte die quittung haben?': ('Kann ich bitte die Quittung haben?', 'Can I have the receipt, please?', 'هل يمكنني الحصول على الإيصال؟', '¿Puedo tener el recibo, por favor?'),
    'dieser pullover gefällt mir sehr gut.': ('Dieser Pullover gefällt mir sehr gut.', 'I like this sweater very much.', 'هذه السترة تعجبني كثيراً.', 'Este jersey me gusta mucho.'),
    'ich nehme diesen rock.': ('Ich nehme diesen Rock.', 'I take this skirt.', 'سآخذ هذه التنورة.', 'Me llevo esta falda.'),
    'dieses kleid steht dir ausgezeichnet!': ('Dieses Kleid steht dir ausgezeichnet!', 'This dress suits you wonderfully!', 'هذا الفستان يليق بكِ بشكل رائع!', '¡Este vestido te queda de maravilla!'),
    'welches hemd möchten sie kaufen?': ('Welches Hemd möchten Sie kaufen?', 'Which shirt would you like to buy?', 'أي قميص تريد شراءه؟', '¿Qué camisa le gustaría comprar?'),
    'diese schuhe sind sehr bequem.': ('Diese Schuhe sind sehr bequem.', 'These shoes are very comfortable.', 'هذه الأحذية مريحة جداً.', 'Estos zapatos son muy cómodos.'),
    'ich nehme dieses hemd.': ('Ich nehme dieses Hemd.', 'I will take this shirt.', 'سآخذ هذا القميص.', 'Me llevo esta camisa.'),
    'kann ich das anprobieren?': ('Kann ich das anprobieren?', 'Can I try this on?', 'هل يمكنني قياس هذا؟', '¿Puedo probármelo?'),
    'die hose passt mir perfekt!': ('Die Hose passt mir perfekt!', 'The pants fit me perfectly!', 'البنطال يناسبني تماماً!', '¡Los pantalones me quedan perfectos!'),
    'kann ich ihnen helfen?': ('Kann ich Ihnen helfen?', 'Can I help you?', 'هل يمكنني مساعدتك؟', '¿Le puedo ayudar?'),
    'haben sie das auch in einer anderen farbe?': ('Haben Sie das auch in einer anderen Farbe?', 'Do you have this in another color?', 'هل لديكم هذا بلون آخر؟', '¿Tiene esto en otro color?'),
    'wo ist die umkleidekabine?': ('Wo ist die Umkleidekabine?', 'Where is the fitting room?', 'أين غرفة تبديل الملابس والقياس؟', '¿Dónde está el probador?'),
    'heute gibt es 20 prozent rabatt.': ('Heute gibt es 20 Prozent Rabatt.', 'Today there is a 20 percent discount.', 'اليوم يوجد خصم 20 بالمئة.', 'Hoy hay un 20 por ciento de descuento.'),
    'das ist ein tolles angebot!': ('Das ist ein tolles Angebot!', 'That is a great offer!', 'هذا عرض رائع!', '¡Es una gran oferta!'),
    'ich nehme die schuhe und die tasche.': ('Ich nehme die Schuhe und die Tasche.', 'I will take the shoes and the bag.', 'سآخذ الحذاء والحقيبة.', 'Me llevo los zapatos y el bolso.'),
    'zahlen sie bar oder mit karte?': ('Zahlen Sie bar oder mit Karte?', 'Do you pay cash or by card?', 'هل تدفع نقداً أم بالبطاقة؟', '¿Paga en efectivo o con tarjeta?'),
    'das ist mir leider zu teuer.': ('Das ist mir leider zu teuer.', 'That is unfortunately too expensive for me.', 'هذا غالي جداً بالنسبة لي للأسف.', 'Lamentablemente es demasiado caro para mí.'),
}

fb_content = feedback_path.read_text(encoding='utf-8')
fb_target = 'const Map<String, ({String de, String en, String ar, String es})> kGermanTranslations = {'
fb_entries = []
for k, (de, en, ar, es) in sorted(unit10_feedback.items()):
    clean_k = k.lower().replace("'", "\\'")
    if f"'{clean_k}':" not in fb_content:
        fb_entries.append(f"  '{clean_k}': (de: '{de}', en: '{en}', ar: '{ar}', es: '{es}'),")

if fb_entries:
    fb_replacement = fb_target + "\n" + "\n".join(fb_entries)
    fb_content = fb_content.replace(fb_target, fb_replacement, 1)
    feedback_path.write_text(fb_content, encoding='utf-8')
    print(f"Added {len(fb_entries)} entries to feedback_translations_data.dart")
