import re
from pathlib import Path

localizer_path = Path(r"c:\Users\HP\3D Objects\Deutschy-main\Deutschy-main\lib\src\features\study\domain\exercise_localizer.dart")
feedback_path = Path(r"c:\Users\HP\3D Objects\Deutschy-main\Deutschy-main\lib\src\features\study\domain\feedback_translations_data.dart")

unit7_options = {
    'bread': ('bread', 'خبز', 'pan'),
    'milk': ('milk', 'حليب', 'leche'),
    'cheese': ('cheese', 'جبن', 'queso'),
    'meat': ('meat', 'لحم', 'carne'),
    'juice': ('juice', 'عصير', 'zumo / jugo'),
    'sugar': ('sugar', 'سكر', 'azúcar'),
    'salt': ('salt', 'ملح', 'sal'),
    'butter': ('butter', 'زبدة', 'mantequilla'),
    'supermarket': ('supermarket', 'سوبرماركت', 'supermercado'),
    'market': ('market', 'سوق', 'mercado'),
    'restaurant': ('restaurant', 'مطعم', 'restaurante'),
    'bill / check': ('bill / check', 'فاتورة / حساب', 'cuenta'),
    'to eat': ('to eat', 'يأكل', 'comer'),
    'to drink': ('to drink', 'يشرب', 'beber'),
    'to buy': ('to buy', 'يشتري', 'comprar'),
    'to cook': ('to cook', 'يطبخ', 'cocinar'),
    'to taste good': ('to taste good', 'يعجب المذاق', 'gustar'),
    'to take': ('to take', 'يأخذ', 'tomar'),
    'gladly / with pleasure': ('gladly / with pleasure', 'بسرور / بحب', 'con gusto'),
    'rather / prefer': ('rather / prefer', 'يُفضّل', 'preferiblemente'),
    'bread roll': ('bread roll', 'خبز صغير / لفة', 'panecillo'),
    'egg': ('egg', 'بيضة', 'huevo'),
    'fish': ('fish', 'سمك', 'pescado'),
}

# Update exercise_localizer.dart
content = localizer_path.read_text(encoding='utf-8')
target = '  static const Map<String, ({String en, String ar, String es})> kExerciseOptions = {'
entries = []
for k, (en, ar, es) in sorted(unit7_options.items()):
    clean_k = k.lower()
    if f"'{clean_k}':" not in content:
        entries.append(f"    '{clean_k}': (en: '{en}', ar: '{ar}', es: '{es}'),")

if entries:
    replacement = target + "\n" + "\n".join(entries)
    content = content.replace(target, replacement, 1)
    localizer_path.write_text(content, encoding='utf-8')
    print(f"Added {len(entries)} options to exercise_localizer.dart")

# Update feedback_translations_data.dart
unit7_feedback = {
    'brot': ('Brot', 'bread', 'خبز', 'pan'),
    'das brot': ('das Brot', 'the bread', 'الخبز', 'el pan'),
    'brötchen': ('Brötchen', 'bread roll', 'خبز صغير / لفة', 'panecillo'),
    'das brötchen': ('das Brötchen', 'the bread roll', 'الخبز الصغير', 'el panecillo'),
    'milch': ('Milch', 'milk', 'حليب', 'leche'),
    'die milch': ('die Milch', 'the milk', 'الحليب', 'la leche'),
    'saft': ('Saft', 'juice', 'عصير', 'zumo / jugo'),
    'der saft': ('der Saft', 'the juice', 'العصير', 'el zumo'),
    'banane': ('Banane', 'banana', 'موزة', 'plátano'),
    'käse': ('Käse', 'cheese', 'جبن', 'queso'),
    'der käse': ('der Käse', 'the cheese', 'الجبن', 'el queso'),
    'fleisch': ('Fleisch', 'meat', 'لحم', 'carne'),
    'das fleisch': ('das Fleisch', 'the meat', 'اللحم', 'la carne'),
    'ei': ('Ei', 'egg', 'بيضة', 'huevo'),
    'das ei': ('das Ei', 'the egg', 'البيضة', 'el huevo'),
    'zucker': ('Zucker', 'sugar', 'سكر', 'azúcar'),
    'der zucker': ('der Zucker', 'the sugar', 'السكر', 'el azúcar'),
    'salz': ('Salz', 'salt', 'ملح', 'sal'),
    'das salz': ('das Salz', 'the salt', 'الملح', 'la sal'),
    'butter': ('Butter', 'butter', 'زبدة', 'mantequilla'),
    'die butter': ('die Butter', 'the butter', 'الزبدة', 'la mantequilla'),
    'supermarkt': ('Supermarkt', 'supermarket', 'سوبرماركت', 'supermercado'),
    'der supermarkt': ('der Supermarkt', 'the supermarket', 'السوبرماركت', 'el supermercado'),
    'markt': ('Markt', 'market', 'سوق', 'mercado'),
    'restaurant': ('Restaurant', 'restaurant', 'مطعم', 'restaurante'),
    'das restaurant': ('das Restaurant', 'the restaurant', 'المطعم', 'el restaurante'),
    'rechnung': ('Rechnung', 'bill / check', 'فاتورة / حساب', 'cuenta'),
    'die rechnung': ('die Rechnung', 'the bill / check', 'الفاتورة / الحساب', 'la cuenta'),
    'essen': ('essen', 'to eat', 'يأكل', 'comer'),
    'trinken': ('trinken', 'to drink', 'يشرب', 'beber'),
    'kaufen': ('kaufen', 'to buy', 'يشتري', 'comprar'),
    'kochen': ('kochen', 'to cook', 'يطبخ', 'cocinar'),
    'schmecken': ('schmecken', 'to taste good', 'يعجب المذاق', 'gustar'),
    'nehmen': ('nehmen', 'to take', 'يأخذ', 'tomar'),
    'gern': ('gern', 'gladly / with pleasure', 'بسرور / بحب', 'con gusto'),
    'lieber': ('lieber', 'rather / prefer', 'يُفضّل', 'preferiblemente'),
    'das essen schmeckt sehr gut.': ('Das Essen schmeckt sehr gut.', 'The food tastes very good.', 'الطعام لذيذ جداً.', 'La comida sabe muy bien.'),
    'ich kaufe einen apfel.': ('Ich kaufe einen Apfel.', 'I buy an apple.', 'أشتري تفاحة.', 'Compro una manzana.'),
    'ich habe keinen käse mehr.': ('Ich habe keinen Käse mehr.', 'I have no cheese left.', 'لم يعد لدي أي جبن.', 'Ya no me queda queso.'),
    'wie viel kostet das brot?': ('Wie viel kostet das Brot?', 'How much does the bread cost?', 'كم سعر الخبز؟', '¿Cuánto cuesta el pan?'),
    'was isst du gern zum frühstück?': ('Was isst du gern zum Frühstück?', 'What do you like to eat for breakfast?', 'ماذا تحب أن تأكل على الفطور؟', '¿Qué te gusta comer en el desayuno?'),
    'er isst ein brötchen mit käse.': ('Er isst ein Brötchen mit Käse.', 'He eats a roll with cheese.', 'هو يأكل خبزاً صغيراً بالجبن.', 'Él come un panecillo con queso.'),
    'was nimmst du?': ('Was nimmst du?', 'What will you take / have?', 'ماذا ستأخذ؟', '¿Qué tomas?'),
    'ich nehme einen kaffee.': ('Ich nehme einen Kaffee.', 'I will take a coffee.', 'سآخذ قهوة.', 'Tomo un café.'),
    'er nimmt den salat.': ('Er nimmt den Salat.', 'He takes the salad.', 'هو يأخذ السلطة.', 'Él toma la ensalada.'),
    'ich trinke gern tee, aber ich trinke lieber kaffee.': ('Ich trinke gern Tee, aber ich trinke lieber Kaffee.', 'I like drinking tea, but I prefer coffee.', 'أحب شرب الشاي، لكني أفضل القهوة.', 'Me gusta el té, pero prefiero el café.'),
    'ich esse sehr gern fisch.': ('Ich esse sehr gern Fisch.', 'I like eating fish very much.', 'أحب أكل السمك كثيراً.', 'Me gusta mucho comer pescado.'),
    'die suppe schmeckt fantastisch!': ('Die Suppe schmeckt fantastisch!', 'The soup tastes fantastic!', 'الحساء مذاقه رائع!', '¡La sopa sabe fantástica!'),
    'wir möchten bitte bezahlen.': ('Wir möchten bitte bezahlen.', 'We would like to pay, please.', 'نود أن ندفع الحساب من فضلك.', 'Nos gustaría pagar, por favor.'),
    'zusammen oder getrennt?': ('Zusammen oder getrennt?', 'Together or separate?', 'معاً أم منفصلين؟', '¿Juntos o por separado?'),
    'wir zahlen zusammen.': ('Wir zahlen zusammen.', 'We pay together.', 'ندفع معاً.', 'Pagamos juntos.'),
    'ich möchte bitte bestellen.': ('Ich möchte bitte bestellen.', 'I would like to order, please.', 'أود أن أطلب من فضلك.', 'Me gustaría pedir, por favor.'),
}

fb_content = feedback_path.read_text(encoding='utf-8')
fb_target = 'const Map<String, ({String de, String en, String ar, String es})> kGermanTranslations = {'
fb_entries = []
for k, (de, en, ar, es) in sorted(unit7_feedback.items()):
    clean_k = k.lower().replace("'", "\\'")
    if f"'{clean_k}':" not in fb_content:
        fb_entries.append(f"  '{clean_k}': (de: '{de}', en: '{en}', ar: '{ar}', es: '{es}'),")

if fb_entries:
    fb_replacement = fb_target + "\n" + "\n".join(fb_entries)
    fb_content = fb_content.replace(fb_target, fb_replacement, 1)
    feedback_path.write_text(fb_content, encoding='utf-8')
    print(f"Added {len(fb_entries)} entries to feedback_translations_data.dart")
