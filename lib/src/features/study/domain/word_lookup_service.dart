// ignore_for_file: text_direction_code_point_in_literal, text_direction_code_point_in_comment
import '../data/content_repository.dart';
import 'curriculum_models.dart';
import 'feedback_translations_data.dart';

/// Structured word translation result returned when learner taps a word in an example sentence.
class WordTranslationResult {
  const WordTranslationResult({
    required this.german,
    this.lemma,
    this.gender,
    this.pos,
    required this.en,
    required this.ar,
    required this.es,
  });

  final String german;
  final String? lemma;
  final String? gender;
  final String? pos;
  final String en;
  final String ar;
  final String es;

  String localized(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return ar.contains('⁦') ? ar : '⁦$ar⁩';
      case 'es':
        return es.isNotEmpty ? es : en;
      default:
        return en;
    }
  }

  String get isolatedAr => ar.contains('⁦') ? ar : '⁦$ar⁩';
}

/// Dynamic word lookup engine that provides instantaneous, isolated word-by-word
/// translations across English, Arabic (with BiDi isolates), and Spanish.
class WordLookupService {
  WordLookupService._();

  /// Looks up a word using:
  /// 1. Card-level custom `word_translations` map (if provided in card data_json)
  /// 2. Canonical Intro dictionary (`kCanonicalWordDictionary`)
  /// 3. ContentRepository curriculum words (`_words` list)
  /// 4. Global feedback translations (`kGermanTranslations`)
  static WordTranslationResult? lookup(
    String rawToken, {
    required String languageCode,
    CurriculumLearnCard? card,
    ContentRepository? repo,
  }) {
    final clean = cleanToken(rawToken);
    if (clean.isEmpty || clean == '—' || clean == '-') return null;

    // 1. Check card-level explicit word_translations
    if (card != null) {
      final cardGlossary = card.dataJson['word_translations'];
      if (cardGlossary is Map && cardGlossary[clean] is Map) {
        final m = Map<String, dynamic>.from(cardGlossary[clean] as Map);
        return WordTranslationResult(
          german: m['de'] as String? ?? clean,
          lemma: (m['lemma'] as String?)?.isNotEmpty == true ? m['lemma'] as String : null,
          gender: (m['gender'] as String?)?.isNotEmpty == true ? m['gender'] as String : null,
          pos: (m['pos'] as String?)?.isNotEmpty == true ? m['pos'] as String : null,
          en: m['en'] as String? ?? clean,
          ar: m['ar'] as String? ?? clean,
          es: m['es'] as String? ?? clean,
        );
      }
    }

    // 2. Check canonical dictionary
    final lower = clean.toLowerCase();
    // Special handling for Morgen (noun) vs morgen (adverb)
    if (lower == 'morgen') {
      if (rawToken.trim().startsWith('M')) {
        return kCanonicalWordDictionary['morgen_noun'];
      }
      return kCanonicalWordDictionary['morgen'];
    }

    final canonical = kCanonicalWordDictionary[lower];
    if (canonical != null) {
      return canonical;
    }

    // Numbers & dates fallback
    if (RegExp(r'^[0-9]+(\.[0-9]+)*$').hasMatch(clean)) {
      final isDate = clean.contains('.');
      return WordTranslationResult(
        german: clean,
        pos: 'num',
        en: isDate ? 'Date $clean' : 'Number $clean',
        ar: isDate ? 'تاريخ $clean' : 'الرقم $clean',
        es: isDate ? 'Fecha $clean' : 'Número $clean',
      );
    }

    // 3. Check ContentRepository curriculum words
    if (repo != null) {
      final match = repo.findWordByLemma(clean);
      if (match != null) {
        return WordTranslationResult(
          german: match.lemma,
          gender: match.gender,
          pos: match.pos,
          en: match.translationEn,
          ar: match.translationAr,
          es: match.translationEs ?? match.translationEn,
        );
      }
    }

    // 4. Check global kGermanTranslations
    final kEntry = kGermanTranslations[lower];
    if (kEntry != null) {
      return WordTranslationResult(
        german: kEntry.de,
        en: kEntry.en,
        ar: kEntry.ar,
        es: kEntry.es,
      );
    }

    return null;
  }

  /// Cleans punctuation around word tokens while keeping internal hyphens/accents.
  static String cleanToken(String raw) {
    var s = raw.trim();
    while (s.isNotEmpty && _isPunctuation(s.codeUnitAt(0))) {
      s = s.substring(1);
    }
    while (s.isNotEmpty && _isPunctuation(s.codeUnitAt(s.length - 1))) {
      s = s.substring(0, s.length - 1);
    }
    return s.trim();
  }

  static bool _isPunctuation(int cu) {
    return cu == 46 || cu == 44 || cu == 33 || cu == 63 || cu == 58 || cu == 59 ||
           cu == 45 || cu == 40 || cu == 41 || cu == 91 || cu == 93 ||
           cu == 34 || cu == 39 || cu == 96 || cu == 8211 || cu == 8212 ||
           cu == 171 || cu == 187 || cu == 8222 || cu == 8220;
  }
}

/// Canonical dictionary of Level Intro words mapped to trilingual translations.
const Map<String, WordTranslationResult> kCanonicalWordDictionary = {
  'abend': WordTranslationResult(german: 'Abend', lemma: 'der Abend', gender: 'der', pos: 'noun', en: 'evening', ar: 'مساء', es: 'tarde / noche'),
  'acht': WordTranslationResult(german: 'acht', lemma: null, gender: null, pos: 'num', en: 'eight (8)', ar: 'ثمانية (8)', es: 'ocho'),
  'achtzig': WordTranslationResult(german: 'achtzig', lemma: null, gender: null, pos: 'num', en: 'eighty (80)', ar: 'ثمانون (80)', es: 'ochenta'),
  'adresse': WordTranslationResult(german: 'Adresse', lemma: 'die Adresse', gender: 'die', pos: 'noun', en: 'address', ar: 'عنوان', es: 'dirección'),
  'allerseits': WordTranslationResult(german: 'allerseits', lemma: null, gender: null, pos: 'adv', en: 'everyone / all', ar: 'للجميع / كافّة', es: 'a todos'),
  'alter': WordTranslationResult(german: 'Alter', lemma: 'das Alter', gender: 'das', pos: 'noun', en: 'age', ar: 'عمر / سن', es: 'edad'),
  'an': WordTranslationResult(german: 'an', lemma: null, gender: null, pos: 'prep', en: 'at / on', ar: 'في / عند', es: 'en'),
  'anmeldeformular': WordTranslationResult(german: 'Anmeldeformular', lemma: 'das Anmeldeformular', gender: 'das', pos: 'noun', en: 'registration form', ar: 'استمارة تسجيل', es: 'formulario de inscripción'),
  'anna': WordTranslationResult(german: 'Anna', lemma: null, gender: null, pos: 'noun', en: 'Anna (personal name)', ar: 'آنّا (اسم شخصي)', es: 'Anna'),
  'apfel': WordTranslationResult(german: 'Apfel', lemma: 'der Apfel', gender: 'der', pos: 'noun', en: 'apple', ar: 'تفاحة', es: 'manzana'),
  'arabisch': WordTranslationResult(german: 'Arabisch', lemma: null, gender: 'das', pos: 'noun', en: 'Arabic (language)', ar: 'اللغة العربية', es: 'árabe'),
  'arbeitet': WordTranslationResult(german: 'arbeitet', lemma: 'arbeiten', gender: null, pos: 'verb', en: 'works', ar: 'يعمل', es: 'trabaja'),
  'arzt': WordTranslationResult(german: 'Arzt', lemma: 'der Arzt', gender: 'der', pos: 'noun', en: 'doctor / physician', ar: 'طبيب', es: 'médico'),
  'auf': WordTranslationResult(german: 'auf', lemma: null, gender: null, pos: 'prep', en: 'on / until', ar: 'إلى / على', es: 'hasta / sobre'),
  'aus': WordTranslationResult(german: 'aus', lemma: null, gender: null, pos: 'prep', en: 'from', ar: 'من', es: 'de / desde'),
  'ausfüllen': WordTranslationResult(german: 'ausfüllen', lemma: null, gender: null, pos: 'verb', en: 'to fill out', ar: 'ملء الاستمارة', es: 'rellenar'),
  'auto': WordTranslationResult(german: 'Auto', lemma: 'das Auto', gender: 'das', pos: 'noun', en: 'car', ar: 'سيارة', es: 'coche / auto'),
  'bahnhof': WordTranslationResult(german: 'Bahnhof', lemma: 'der Bahnhof', gender: 'der', pos: 'noun', en: 'train station', ar: 'محطة القطار', es: 'estación de tren'),
  'ball': WordTranslationResult(german: 'Ball', lemma: 'der Ball', gender: 'der', pos: 'noun', en: 'ball', ar: 'كرة', es: 'pelota'),
  'berlin': WordTranslationResult(german: 'Berlin', lemma: null, gender: 'das', pos: 'noun', en: 'Berlin (capital of Germany)', ar: 'برلين (عاصمة ألمانيا)', es: 'Berlín'),
  'bild': WordTranslationResult(german: 'Bild', lemma: 'das Bild', gender: 'das', pos: 'noun', en: 'picture / painting', ar: 'صورة / لوحة', es: 'imagen / cuadro'),
  'bin': WordTranslationResult(german: 'bin', lemma: 'sein', gender: null, pos: 'verb', en: 'am', ar: 'أكون / أنا', es: 'soy / estoy'),
  'bis': WordTranslationResult(german: 'bis', lemma: null, gender: null, pos: 'prep', en: 'until (Bis morgen = see you tomorrow)', ar: 'حتى / إلى (إلى الغد)', es: 'hasta (hasta mañana)'),
  'bitte': WordTranslationResult(german: 'bitte', lemma: null, gender: null, pos: 'part', en: 'please / you are welcome', ar: 'من فضلك / تفضل', es: 'por favor / de nada'),
  'blau': WordTranslationResult(german: 'blau', lemma: null, gender: null, pos: 'adj', en: 'blue', ar: 'أزرق', es: 'azul'),
  'braun': WordTranslationResult(german: 'braun', lemma: null, gender: null, pos: 'adj', en: 'brown', ar: 'بني', es: 'marrón'),
  'bruder': WordTranslationResult(german: 'Bruder', lemma: 'der Bruder', gender: 'der', pos: 'noun', en: 'brother', ar: 'أخ', es: 'hermano'),
  'bus': WordTranslationResult(german: 'Bus', lemma: 'der Bus', gender: 'der', pos: 'noun', en: 'bus', ar: 'حافلة', es: 'autobús'),
  'bücher': WordTranslationResult(german: 'Bücher', lemma: 'das Buch', gender: 'die', pos: 'noun', en: 'books', ar: 'كتب', es: 'libros'),
  'café': WordTranslationResult(german: 'Café', lemma: 'das Café', gender: 'das', pos: 'noun', en: 'café', ar: 'مقهى', es: 'cafetería'),
  'computer': WordTranslationResult(german: 'Computer', lemma: 'der Computer', gender: 'der', pos: 'noun', en: 'computer', ar: 'حاسوب', es: 'ordenador'),
  'da': WordTranslationResult(german: 'da', lemma: null, gender: null, pos: 'adv', en: 'there / here', ar: 'هنا / هناك', es: 'ahí / aquí'),
  'damaskus': WordTranslationResult(german: 'Damaskus', lemma: null, gender: 'das', pos: 'noun', en: 'Damascus', ar: 'دمشق', es: 'Damasco'),
  'dank': WordTranslationResult(german: 'Dank', lemma: null, gender: 'der', pos: 'noun', en: 'thanks', ar: 'شكر', es: 'agradecimiento'),
  'danke': WordTranslationResult(german: 'danke', lemma: 'danken', gender: null, pos: 'part', en: 'thank you', ar: 'شكراً', es: 'gracias'),
  'das': WordTranslationResult(german: 'das', lemma: null, gender: 'das', pos: 'art', en: 'the (neuter)', ar: 'الـ (للمحايد)', es: 'el / la (neutro)'),
  'der': WordTranslationResult(german: 'der', lemma: null, gender: 'der', pos: 'art', en: 'the (masculine)', ar: 'الـ (للمذكر)', es: 'el'),
  'deutsch': WordTranslationResult(german: 'Deutsch', lemma: null, gender: 'das', pos: 'noun', en: 'German (language)', ar: 'اللغة الألمانية', es: 'alemán'),
  'deutschland': WordTranslationResult(german: 'Deutschland', lemma: null, gender: 'das', pos: 'noun', en: 'Germany', ar: 'ألمانيا', es: 'Alemania'),
  'dich': WordTranslationResult(german: 'dich', lemma: 'du', gender: null, pos: 'pron', en: 'you (accusative)', ar: 'إياك / كاف المخاطب', es: 'te / a ti'),
  'die': WordTranslationResult(german: 'die', lemma: null, gender: 'die', pos: 'art', en: 'the (feminine / plural)', ar: 'الـ (للمؤنث / الجمع)', es: 'la / las'),
  'dienstag': WordTranslationResult(german: 'Dienstag', lemma: null, gender: 'der', pos: 'noun', en: 'Tuesday', ar: 'الثلاثاء', es: 'martes'),
  'donnerstag': WordTranslationResult(german: 'Donnerstag', lemma: null, gender: 'der', pos: 'noun', en: 'Thursday', ar: 'الخميس', es: 'jueves'),
  'drei': WordTranslationResult(german: 'drei', lemma: null, gender: null, pos: 'num', en: 'three (3)', ar: 'ثلاثة (3)', es: 'tres'),
  'dreizehn': WordTranslationResult(german: 'dreizehn', lemma: null, gender: null, pos: 'num', en: 'thirteen (13)', ar: 'ثلاثة عشر (13)', es: 'trece'),
  'dreißig': WordTranslationResult(german: 'dreißig', lemma: null, gender: null, pos: 'num', en: 'thirty (30)', ar: 'ثلاثون (30)', es: 'treinta'),
  'du': WordTranslationResult(german: 'du', lemma: null, gender: null, pos: 'pron', en: 'you (informal)', ar: 'أنتَ / أنتِ', es: 'tú'),
  'e-mail-adresse': WordTranslationResult(german: 'E-Mail-Adresse', lemma: 'die E-Mail-Adresse', gender: 'die', pos: 'noun', en: 'email address', ar: 'عنوان البريد الإلكتروني', es: 'dirección de correo electrónico'),
  'ein': WordTranslationResult(german: 'ein', lemma: null, gender: null, pos: 'art', en: 'a / an (masculine / neuter)', ar: 'أداة تنكير (مذكر / محايد)', es: 'un'),
  'eine': WordTranslationResult(german: 'eine', lemma: null, gender: null, pos: 'art', en: 'a / an (feminine)', ar: 'أداة تنكير (مؤنث)', es: 'una'),
  'einen': WordTranslationResult(german: 'einen', lemma: 'ein', gender: null, pos: 'art', en: 'a / an (accusative masculine)', ar: 'أداة تنكير منصوبة (مذكر)', es: 'un'),
  'eins': WordTranslationResult(german: 'eins', lemma: null, gender: null, pos: 'num', en: 'one (1)', ar: 'واحد (1)', es: 'uno'),
  'elefant': WordTranslationResult(german: 'Elefant', lemma: 'der Elefant', gender: 'der', pos: 'noun', en: 'elephant', ar: 'فيل', es: 'elefante'),
  'elf': WordTranslationResult(german: 'elf', lemma: null, gender: null, pos: 'num', en: 'eleven (11)', ar: 'أحد عشر (11)', es: 'once'),
  'englisch': WordTranslationResult(german: 'Englisch', lemma: null, gender: 'das', pos: 'noun', en: 'English (language)', ar: 'اللغة الإنجليزية', es: 'inglés'),
  'entschuldigung': WordTranslationResult(german: 'Entschuldigung', lemma: null, gender: 'die', pos: 'noun', en: 'excuse me / sorry', ar: 'معذرة / عذراً', es: 'disculpe / perdón'),
  'er': WordTranslationResult(german: 'er', lemma: null, gender: null, pos: 'pron', en: 'he', ar: 'هو', es: 'él'),
  'es': WordTranslationResult(german: 'es', lemma: null, gender: null, pos: 'pron', en: 'it', ar: 'هو / هي (للمحايد)', es: 'ello / él / ella'),
  'euro': WordTranslationResult(german: 'Euro', lemma: 'der Euro', gender: 'der', pos: 'noun', en: 'euro', ar: 'يورو', es: 'euro'),
  'europa': WordTranslationResult(german: 'Europa', lemma: null, gender: 'das', pos: 'noun', en: 'Europe', ar: 'أوروبا', es: 'Europa'),
  'fahrrad': WordTranslationResult(german: 'Fahrrad', lemma: 'das Fahrrad', gender: 'das', pos: 'noun', en: 'bicycle', ar: 'دراجة هوائية', es: 'bicicleta'),
  'familienname': WordTranslationResult(german: 'Familienname', lemma: 'der Familienname', gender: 'der', pos: 'noun', en: 'last name / surname', ar: 'اللقب / اسم العائلة', es: 'apellido'),
  'fit': WordTranslationResult(german: 'fit', lemma: null, gender: null, pos: 'adj', en: 'fit', ar: 'رشيق', es: 'en forma'),
  'formular': WordTranslationResult(german: 'Formular', lemma: 'das Formular', gender: 'das', pos: 'noun', en: 'form', ar: 'استمارة رسمية', es: 'formulario'),
  'frau': WordTranslationResult(german: 'Frau', lemma: 'die Frau', gender: 'die', pos: 'noun', en: 'Mrs. / woman', ar: 'سيدة / امرأة', es: 'señora / mujer'),
  'freitag': WordTranslationResult(german: 'Freitag', lemma: null, gender: 'der', pos: 'noun', en: 'Friday', ar: 'الجمعة', es: 'viernes'),
  'freut': WordTranslationResult(german: 'freut', lemma: 'freuen', gender: null, pos: 'verb', en: 'pleased (nice to meet you)', ar: 'يسعدني / تشرفت', es: 'mucho gusto / encantado'),
  'frisch': WordTranslationResult(german: 'frisch', lemma: null, gender: null, pos: 'adj', en: 'fresh', ar: 'عذب / طازج', es: 'fresco'),
  'fährt': WordTranslationResult(german: 'fährt', lemma: 'fahren', gender: null, pos: 'verb', en: 'drives / travels', ar: 'يسير / يقود / يسافر', es: 'conduce / viaja'),
  'fülle': WordTranslationResult(german: 'fülle', lemma: 'ausfüllen', gender: null, pos: 'verb', en: 'fill out', ar: 'أملأ', es: 'completo / relleno'),
  'füllen': WordTranslationResult(german: 'füllen', lemma: 'ausfüllen', gender: null, pos: 'verb', en: 'fill out (formal)', ar: 'املأ / املؤوا', es: 'rellenen / complete'),
  'fünf': WordTranslationResult(german: 'fünf', lemma: null, gender: null, pos: 'num', en: 'five (5)', ar: 'خمسة (5)', es: 'cinco'),
  'fünfzehn': WordTranslationResult(german: 'fünfzehn', lemma: null, gender: null, pos: 'num', en: 'fifteen (15)', ar: 'خمسة عشر (15)', es: 'quince'),
  'fünfzig': WordTranslationResult(german: 'fünfzig', lemma: null, gender: null, pos: 'num', en: 'fifty (50)', ar: 'خمسون (50)', es: 'cincuenta'),
  'garten': WordTranslationResult(german: 'Garten', lemma: 'der Garten', gender: 'der', pos: 'noun', en: 'garden', ar: 'حديقة', es: 'jardín'),
  'geburtsdatum': WordTranslationResult(german: 'Geburtsdatum', lemma: 'das Geburtsdatum', gender: 'das', pos: 'noun', en: 'date of birth', ar: 'تاريخ الولادة', es: 'fecha de nacimiento'),
  'geburtsort': WordTranslationResult(german: 'Geburtsort', lemma: 'der Geburtsort', gender: 'der', pos: 'noun', en: 'place of birth', ar: 'مكان الولادة', es: 'lugar de nacimiento'),
  'geht': WordTranslationResult(german: 'geht', lemma: 'gehen', gender: null, pos: 'verb', en: 'goes / walks', ar: 'يسير / يمضي', es: 'va'),
  'geht\'s': WordTranslationResult(german: 'geht\'s', lemma: 'gehen', gender: null, pos: 'phrase', en: 'how is it going', ar: 'كيف الحال', es: '¿cómo va?'),
  'gehört': WordTranslationResult(german: 'gehört', lemma: 'hören', gender: null, pos: 'verb', en: 'heard', ar: 'سمعت', es: 'oído / escuchado'),
  'gelb': WordTranslationResult(german: 'gelb', lemma: null, gender: null, pos: 'adj', en: 'yellow', ar: 'أصفر', es: 'amarillo'),
  'gern': WordTranslationResult(german: 'gern', lemma: null, gender: null, pos: 'adv', en: 'gladly / likes to', ar: 'بسرور / يحب أن', es: 'con gusto'),
  'gerne': WordTranslationResult(german: 'gerne', lemma: null, gender: null, pos: 'adv', en: 'gladly', ar: 'بسرور / بكل سرور', es: 'con gusto'),
  'geschlafen': WordTranslationResult(german: 'geschlafen', lemma: 'schlafen', gender: null, pos: 'verb', en: 'slept', ar: 'نمت', es: 'dormido'),
  'geöffnet': WordTranslationResult(german: 'geöffnet', lemma: 'öffnen', gender: null, pos: 'adj', en: 'open', ar: 'مفتوح', es: 'abierto'),
  'gleich': WordTranslationResult(german: 'gleich', lemma: null, gender: null, pos: 'adv', en: 'soon / right away', ar: 'حالاً / بعد قليل', es: 'pronto / enseguida'),
  'goethestraße': WordTranslationResult(german: 'Goethestraße', lemma: 'die Goethestraße', gender: 'die', pos: 'noun', en: 'Goethe Street', ar: 'شارع غوته', es: 'calle Goethe'),
  'gras': WordTranslationResult(german: 'Gras', lemma: 'das Gras', gender: 'das', pos: 'noun', en: 'grass', ar: 'عشب', es: 'hierba / césped'),
  'grau': WordTranslationResult(german: 'grau', lemma: null, gender: null, pos: 'adj', en: 'gray', ar: 'رمادي', es: 'gris'),
  'groß': WordTranslationResult(german: 'groß', lemma: null, gender: null, pos: 'adj', en: 'big / large', ar: 'كبير / ضخم', es: 'grande'),
  'grün': WordTranslationResult(german: 'grün', lemma: null, gender: null, pos: 'adj', en: 'green', ar: 'أخضر', es: 'verde'),
  'gut': WordTranslationResult(german: 'gut', lemma: null, gender: null, pos: 'adj', en: 'good / well', ar: 'جيد / لذيذ / بخير', es: 'bueno / bien'),
  'gute': WordTranslationResult(german: 'Gute', lemma: 'gut', gender: null, pos: 'adj', en: 'good (feminine)', ar: 'طيبة (ليلة طيبة)', es: 'buena (buenas noches)'),
  'guten': WordTranslationResult(german: 'Guten', lemma: 'gut', gender: null, pos: 'adj', en: 'good (accusative)', ar: 'سعيد / طيب', es: 'buenos / buen'),
  'h': WordTranslationResult(german: 'H', lemma: null, gender: null, pos: 'noun', en: 'Letter H', ar: 'حرف H', es: 'letra H'),
  'h-o-t-e-l': WordTranslationResult(german: 'H-O-T-E-L', lemma: 'Hotel', gender: null, pos: 'noun', en: 'spelling of Hotel', ar: 'تهجئة كلمة فندق', es: 'deletreo de Hotel'),
  'habe': WordTranslationResult(german: 'habe', lemma: 'haben', gender: null, pos: 'verb', en: 'have (1st person)', ar: 'عندي / لدي', es: 'tengo'),
  'haben': WordTranslationResult(german: 'haben', lemma: null, gender: null, pos: 'verb', en: 'have', ar: 'لديك / لديكم / يملكون', es: 'tienen / tiene'),
  'hallo': WordTranslationResult(german: 'Hallo', lemma: 'hallo', gender: null, pos: 'part', en: 'hello', ar: 'مرحباً', es: 'hola'),
  'hausnummer': WordTranslationResult(german: 'Hausnummer', lemma: 'die Hausnummer', gender: 'die', pos: 'noun', en: 'house number', ar: 'رقم المنزل', es: 'número de casa'),
  'heiß': WordTranslationResult(german: 'heiß', lemma: null, gender: null, pos: 'adj', en: 'hot', ar: 'ساخن', es: 'caliente'),
  'heiße': WordTranslationResult(german: 'heiße', lemma: 'heißen', gender: null, pos: 'verb', en: 'am called / my name is', ar: 'اسمي / أُدعى', es: 'me llamo'),
  'heißen': WordTranslationResult(german: 'heißen', lemma: null, gender: null, pos: 'verb', en: 'are called', ar: 'تُدعى / يُسمى', es: 'se llama'),
  'hell': WordTranslationResult(german: 'hell', lemma: null, gender: null, pos: 'adj', en: 'bright', ar: 'ساطع / مضيء', es: 'brillante'),
  'hemd': WordTranslationResult(german: 'Hemd', lemma: 'das Hemd', gender: 'das', pos: 'noun', en: 'shirt', ar: 'قميص', es: 'camisa'),
  'herr': WordTranslationResult(german: 'Herr', lemma: 'der Herr', gender: 'der', pos: 'noun', en: 'Mr. / gentleman', ar: 'سيد', es: 'señor'),
  'heute': WordTranslationResult(german: 'heute', lemma: null, gender: null, pos: 'adv', en: 'today', ar: 'اليوم', es: 'hoy'),
  'hier': WordTranslationResult(german: 'hier', lemma: null, gender: null, pos: 'adv', en: 'here', ar: 'هنا', es: 'aquí'),
  'himmel': WordTranslationResult(german: 'Himmel', lemma: 'der Himmel', gender: 'der', pos: 'noun', en: 'sky', ar: 'سماء', es: 'cielo'),
  'hotel': WordTranslationResult(german: 'Hotel', lemma: 'das Hotel', gender: 'das', pos: 'noun', en: 'hotel', ar: 'فندق', es: 'hotel'),
  'hundert': WordTranslationResult(german: 'hundert', lemma: null, gender: null, pos: 'num', en: 'one hundred (100)', ar: 'مئة (100)', es: 'cien'),
  'hören': WordTranslationResult(german: 'hören', lemma: null, gender: null, pos: 'verb', en: 'hear / listen', ar: 'نستمع / نسمع', es: 'escuchamos'),
  'ich': WordTranslationResult(german: 'ich', lemma: null, gender: null, pos: 'pron', en: 'I', ar: 'أنا', es: 'yo'),
  'ihr': WordTranslationResult(german: 'ihr', lemma: null, gender: null, pos: 'pron', en: 'you (plural informal)', ar: 'أنتم', es: 'vosotros'),
  'ihre': WordTranslationResult(german: 'Ihre', lemma: 'ihr', gender: null, pos: 'pron', en: 'your (formal)', ar: 'خاص بحضرتك', es: 'su (de usted)'),
  'im': WordTranslationResult(german: 'im', lemma: 'in dem', gender: null, pos: 'prep', en: 'in the', ar: 'في الـ', es: 'en el'),
  'in': WordTranslationResult(german: 'in', lemma: null, gender: null, pos: 'prep', en: 'in', ar: 'في', es: 'en'),
  'insel': WordTranslationResult(german: 'Insel', lemma: 'die Insel', gender: 'die', pos: 'noun', en: 'island', ar: 'جزيرة', es: 'isla'),
  'ist': WordTranslationResult(german: 'ist', lemma: 'sein', gender: null, pos: 'verb', en: 'is', ar: 'يكون / هو', es: 'es / está'),
  'ja': WordTranslationResult(german: 'Ja', lemma: 'ja', gender: null, pos: 'part', en: 'yes', ar: 'نعم', es: 'sí'),
  'jahre': WordTranslationResult(german: 'Jahre', lemma: 'das Jahr', gender: 'die', pos: 'noun', en: 'years', ar: 'سنوات', es: 'años'),
  'jetzt': WordTranslationResult(german: 'jetzt', lemma: null, gender: null, pos: 'adv', en: 'now', ar: 'الآن', es: 'ahora'),
  'kaffee': WordTranslationResult(german: 'Kaffee', lemma: 'der Kaffee', gender: 'der', pos: 'noun', en: 'coffee', ar: 'قهوة', es: 'café'),
  'kalt': WordTranslationResult(german: 'kalt', lemma: null, gender: null, pos: 'adj', en: 'cold', ar: 'بارد', es: 'frío'),
  'karim': WordTranslationResult(german: 'Karim', lemma: null, gender: null, pos: 'noun', en: 'Karim (personal name)', ar: 'كريم (اسم شخصي)', es: 'Karim'),
  'kind': WordTranslationResult(german: 'Kind', lemma: 'das Kind', gender: 'das', pos: 'noun', en: 'child', ar: 'طفل', es: 'niño'),
  'kocht': WordTranslationResult(german: 'kocht', lemma: 'kochen', gender: null, pos: 'verb', en: 'cooks', ar: 'تطبخ / يطبخ', es: 'cocina'),
  'komme': WordTranslationResult(german: 'komme', lemma: 'kommen', gender: null, pos: 'verb', en: 'come', ar: 'آتي / أنا قادم', es: 'vengo'),
  'kommt': WordTranslationResult(german: 'kommt', lemma: 'kommen', gender: null, pos: 'verb', en: 'comes / is arriving', ar: 'يأتي / قادم', es: 'viene / llega'),
  'kostet': WordTranslationResult(german: 'kostet', lemma: 'kosten', gender: null, pos: 'verb', en: 'costs', ar: 'يكلف / سعره', es: 'cuesta'),
  'krankenhaus': WordTranslationResult(german: 'Krankenhaus', lemma: 'das Krankenhaus', gender: 'das', pos: 'noun', en: 'hospital', ar: 'مستشفى', es: 'hospital'),
  'käse': WordTranslationResult(german: 'Käse', lemma: 'der Käse', gender: 'der', pos: 'noun', en: 'cheese', ar: 'جبن', es: 'queso'),
  'können': WordTranslationResult(german: 'können', lemma: null, gender: null, pos: 'verb', en: 'can / could', ar: 'يمكنك / تستطيع', es: 'puede'),
  'l': WordTranslationResult(german: 'L', lemma: null, gender: null, pos: 'noun', en: 'Letter L', ar: 'حرف L', es: 'letra L'),
  'lampe': WordTranslationResult(german: 'Lampe', lemma: 'die Lampe', gender: 'die', pos: 'noun', en: 'lamp', ar: 'مصباح', es: 'lámpara'),
  'langsamer': WordTranslationResult(german: 'langsamer', lemma: 'langsam', gender: null, pos: 'adv', en: 'more slowly', ar: 'ببطء أكثر', es: 'más despacio'),
  'ledig': WordTranslationResult(german: 'ledig', lemma: null, gender: null, pos: 'adj', en: 'single', ar: 'أعزب / عزباء', es: 'soltero/a'),
  'lerne': WordTranslationResult(german: 'lerne', lemma: 'lernen', gender: null, pos: 'verb', en: 'learn', ar: 'أتعلم', es: 'aprendo'),
  'lernt': WordTranslationResult(german: 'lernt', lemma: 'lernen', gender: null, pos: 'verb', en: 'learns', ar: 'تتعلم / يتعلم', es: 'aprende'),
  'macht': WordTranslationResult(german: 'macht', lemma: 'machen', gender: null, pos: 'verb', en: 'makes', ar: 'يجعل / يفعل', es: 'hace'),
  'mail': WordTranslationResult(german: 'Mail', lemma: 'die Mail', gender: 'die', pos: 'noun', en: 'mail', ar: 'بريد', es: 'correo'),
  'mann': WordTranslationResult(german: 'Mann', lemma: 'der Mann', gender: 'der', pos: 'noun', en: 'man', ar: 'رجل', es: 'hombre'),
  'mansour': WordTranslationResult(german: 'Mansour', lemma: null, gender: null, pos: 'noun', en: 'Mansour (surname)', ar: 'منصور (لقب عائلي)', es: 'Mansour'),
  'marokko': WordTranslationResult(german: 'Marokko', lemma: null, gender: 'das', pos: 'noun', en: 'Morocco', ar: 'المغرب', es: 'Marruecos'),
  'meier': WordTranslationResult(german: 'Meier', lemma: null, gender: null, pos: 'noun', en: 'Meier (German surname)', ar: 'ماير (لقب ألماني)', es: 'Meier'),
  'mein': WordTranslationResult(german: 'mein', lemma: null, gender: null, pos: 'pron', en: 'my (masculine / neuter)', ar: 'ـي (ياء الملكية للمذكر/المحايد)', es: 'mi'),
  'meine': WordTranslationResult(german: 'meine', lemma: 'mein', gender: null, pos: 'pron', en: 'my (feminine / plural)', ar: 'ـي (ياء الملكية للمؤنث/الجمع)', es: 'mis / mi'),
  'mich': WordTranslationResult(german: 'mich', lemma: 'ich', gender: null, pos: 'pron', en: 'me / myself (accusative)', ar: 'نفسي / ياء المتكلم', es: 'me / a mí'),
  'milch': WordTranslationResult(german: 'Milch', lemma: 'die Milch', gender: 'die', pos: 'noun', en: 'milk', ar: 'حليب', es: 'leche'),
  'mir': WordTranslationResult(german: 'mir', lemma: 'ich', gender: null, pos: 'pron', en: 'me (dative)', ar: 'لي / معي', es: 'a mí / me'),
  'mittwoch': WordTranslationResult(german: 'Mittwoch', lemma: null, gender: 'der', pos: 'noun', en: 'Wednesday', ar: 'الأربعاء', es: 'miércoles'),
  'modern': WordTranslationResult(german: 'modern', lemma: null, gender: null, pos: 'adj', en: 'modern', ar: 'حديث / عصري', es: 'moderno'),
  'montag': WordTranslationResult(german: 'Montag', lemma: null, gender: 'der', pos: 'noun', en: 'Monday', ar: 'الإثنين', es: 'lunes'),
  'morgen': WordTranslationResult(german: 'morgen', lemma: null, gender: null, pos: 'adv', en: 'tomorrow', ar: 'غداً', es: 'mañana'),
  'morgen_noun': WordTranslationResult(german: 'Morgen', lemma: 'der Morgen', gender: 'der', pos: 'noun', en: 'morning', ar: 'صباح', es: 'mañana'),
  'musik': WordTranslationResult(german: 'Musik', lemma: 'die Musik', gender: 'die', pos: 'noun', en: 'music', ar: 'موسيقى', es: 'música'),
  'mutter': WordTranslationResult(german: 'Mutter', lemma: 'die Mutter', gender: 'die', pos: 'noun', en: 'mother', ar: 'أم', es: 'madre'),
  'muttersprache': WordTranslationResult(german: 'Muttersprache', lemma: 'die Muttersprache', gender: 'die', pos: 'noun', en: 'native language', ar: 'اللغة الأم', es: 'lengua materna'),
  'möchte': WordTranslationResult(german: 'möchte', lemma: 'möchten', gender: null, pos: 'verb', en: 'would like', ar: 'أود / أرغب', es: 'quisiera / me gustaría'),
  'müller': WordTranslationResult(german: 'Müller', lemma: null, gender: null, pos: 'noun', en: 'Müller (German surname)', ar: 'مولر (لقب ألماني)', es: 'Müller'),
  'nach': WordTranslationResult(german: 'nach', lemma: null, gender: null, pos: 'prep', en: 'to / towards', ar: 'إلى', es: 'hacia / a'),
  'nacht': WordTranslationResult(german: 'Nacht', lemma: 'die Nacht', gender: 'die', pos: 'noun', en: 'night', ar: 'ليلة', es: 'noche'),
  'name': WordTranslationResult(german: 'Name', lemma: 'der Name', gender: 'der', pos: 'noun', en: 'name', ar: 'اسم', es: 'nombre'),
  'nehme': WordTranslationResult(german: 'nehme', lemma: 'nehmen', gender: null, pos: 'verb', en: 'take', ar: 'آخذ', es: 'tomo'),
  'nein': WordTranslationResult(german: 'Nein', lemma: 'nein', gender: null, pos: 'part', en: 'no', ar: 'لا', es: 'no'),
  'neu': WordTranslationResult(german: 'neu', lemma: null, gender: null, pos: 'adj', en: 'new', ar: 'جديد', es: 'nuevo'),
  'neun': WordTranslationResult(german: 'neun', lemma: null, gender: null, pos: 'num', en: 'nine (9)', ar: 'تسعة (9)', es: 'nueve'),
  'neunzig': WordTranslationResult(german: 'neunzig', lemma: null, gender: null, pos: 'num', en: 'ninety (90)', ar: 'تسعون (90)', es: 'noventa'),
  'nicht': WordTranslationResult(german: 'nicht', lemma: null, gender: null, pos: 'adv', en: 'not', ar: 'لا / ليس', es: 'no'),
  'null': WordTranslationResult(german: 'null', lemma: null, gender: null, pos: 'num', en: 'zero (0)', ar: 'صفر (0)', es: 'cero'),
  'nummer': WordTranslationResult(german: 'Nummer', lemma: 'die Nummer', gender: 'die', pos: 'noun', en: 'number', ar: 'رقم', es: 'número'),
  'o': WordTranslationResult(german: 'O', lemma: null, gender: null, pos: 'noun', en: 'Letter O', ar: 'حرف O', es: 'letra O'),
  'orange': WordTranslationResult(german: 'Orange', lemma: 'die Orange', gender: 'die', pos: 'noun', en: 'orange', ar: 'برتقالة', es: 'naranja'),
  'park': WordTranslationResult(german: 'Park', lemma: 'der Park', gender: 'der', pos: 'noun', en: 'park', ar: 'حديقة عامة', es: 'parque'),
  'post': WordTranslationResult(german: 'Post', lemma: 'die Post', gender: 'die', pos: 'noun', en: 'post office / mail', ar: 'بريد', es: 'correo'),
  'postleitzahl': WordTranslationResult(german: 'Postleitzahl', lemma: 'die Postleitzahl', gender: 'die', pos: 'noun', en: 'postal code', ar: 'الرمز البريدي', es: 'código postal'),
  'quelle': WordTranslationResult(german: 'Quelle', lemma: 'die Quelle', gender: 'die', pos: 'noun', en: 'spring / source', ar: 'ينبوع', es: 'fuente'),
  'radio': WordTranslationResult(german: 'Radio', lemma: 'das Radio', gender: 'das', pos: 'noun', en: 'radio', ar: 'مذياع', es: 'radio'),
  'rot': WordTranslationResult(german: 'rot', lemma: null, gender: null, pos: 'adj', en: 'red', ar: 'أحمر', es: 'rojo'),
  'rote': WordTranslationResult(german: 'rote', lemma: 'rot', gender: null, pos: 'adj', en: 'red (inflected)', ar: 'حمراء', es: 'rojas / rojos'),
  'ruhig': WordTranslationResult(german: 'ruhig', lemma: null, gender: null, pos: 'adj', en: 'quiet / peaceful', ar: 'هادئ', es: 'tranquilo'),
  'rund': WordTranslationResult(german: 'rund', lemma: null, gender: null, pos: 'adj', en: 'round', ar: 'مستدير', es: 'redondo'),
  'samstag': WordTranslationResult(german: 'Samstag', lemma: null, gender: 'der', pos: 'noun', en: 'Saturday', ar: 'السبت', es: 'sábado'),
  'scheint': WordTranslationResult(german: 'scheint', lemma: 'scheinen', gender: null, pos: 'verb', en: 'shines', ar: 'تشرق / يسطع', es: 'brilla'),
  'schlaf': WordTranslationResult(german: 'schlaf', lemma: 'schlafen', gender: null, pos: 'verb', en: 'sleep (imperative)', ar: 'نَمْ', es: 'duerme'),
  'schmeckt': WordTranslationResult(german: 'schmeckt', lemma: 'schmecken', gender: null, pos: 'verb', en: 'tastes (good)', ar: 'طعمه / مذاقه', es: 'sabe bien'),
  'schmidt': WordTranslationResult(german: 'Schmidt', lemma: null, gender: null, pos: 'noun', en: 'Schmidt (German surname)', ar: 'شميت (لقب ألماني)', es: 'Schmidt'),
  'schnee': WordTranslationResult(german: 'Schnee', lemma: 'der Schnee', gender: 'der', pos: 'noun', en: 'snow', ar: 'ثلج', es: 'nieve'),
  'schnell': WordTranslationResult(german: 'schnell', lemma: null, gender: null, pos: 'adj', en: 'fast / quickly', ar: 'سريع / بسرعة', es: 'rápido'),
  'schokolade': WordTranslationResult(german: 'Schokolade', lemma: 'die Schokolade', gender: 'die', pos: 'noun', en: 'chocolate', ar: 'شوكولاتة', es: 'chocolate'),
  'schule': WordTranslationResult(german: 'Schule', lemma: 'die Schule', gender: 'die', pos: 'noun', en: 'school', ar: 'مدرسة', es: 'escuela'),
  'schwarz': WordTranslationResult(german: 'schwarz', lemma: null, gender: null, pos: 'adj', en: 'black', ar: 'أسود', es: 'negro'),
  'schwester': WordTranslationResult(german: 'Schwester', lemma: 'die Schwester', gender: 'die', pos: 'noun', en: 'sister', ar: 'أخت', es: 'hermana'),
  'schön': WordTranslationResult(german: 'schön', lemma: null, gender: null, pos: 'adj', en: 'beautiful / nice', ar: 'جميل', es: 'hermoso / bonito'),
  'sechs': WordTranslationResult(german: 'sechs', lemma: null, gender: null, pos: 'num', en: 'six (6)', ar: 'ستة (6)', es: 'seis'),
  'sechzehn': WordTranslationResult(german: 'sechzehn', lemma: null, gender: null, pos: 'num', en: 'sixteen (16)', ar: 'ستة عشر (16)', es: 'dieciséis'),
  'sechzig': WordTranslationResult(german: 'sechzig', lemma: null, gender: null, pos: 'num', en: 'sixty (60)', ar: 'ستون (60)', es: 'sesenta'),
  'sehen': WordTranslationResult(german: 'sehen', lemma: null, gender: null, pos: 'verb', en: 'to see', ar: 'أرى / رؤية', es: 'ver'),
  'sehr': WordTranslationResult(german: 'sehr', lemma: null, gender: null, pos: 'adv', en: 'very', ar: 'جداً', es: 'muy'),
  'sie': WordTranslationResult(german: 'sie', lemma: null, gender: null, pos: 'pron', en: 'she / they / You (formal)', ar: 'هي / هم / حضرتك', es: 'ella / ellos / usted'),
  'sieben': WordTranslationResult(german: 'sieben', lemma: null, gender: null, pos: 'num', en: 'seven (7)', ar: 'سبعة (7)', es: 'siete'),
  'siebzehn': WordTranslationResult(german: 'siebzehn', lemma: null, gender: null, pos: 'num', en: 'seventeen (17)', ar: 'سبعة عشر (17)', es: 'diecisiete'),
  'siebzig': WordTranslationResult(german: 'siebzig', lemma: null, gender: null, pos: 'num', en: 'seventy (70)', ar: 'سبعون (70)', es: 'setenta'),
  'so': WordTranslationResult(german: 'so', lemma: null, gender: null, pos: 'adv', en: 'so / that', ar: 'هكذا / إلى هذا الحد', es: 'tan / así'),
  'sonne': WordTranslationResult(german: 'Sonne', lemma: 'die Sonne', gender: 'die', pos: 'noun', en: 'sun', ar: 'شمس', es: 'sol'),
  'sonntag': WordTranslationResult(german: 'Sonntag', lemma: null, gender: 'der', pos: 'noun', en: 'Sunday', ar: 'الأحد', es: 'domingo'),
  'spielt': WordTranslationResult(german: 'spielt', lemma: 'spielen', gender: null, pos: 'verb', en: 'plays', ar: 'يلعب / يعزف', es: 'juega / toca'),
  'sprechen': WordTranslationResult(german: 'sprechen', lemma: null, gender: null, pos: 'verb', en: 'speak', ar: 'نتحدث / يتكلم', es: 'hablamos / habla'),
  'straße': WordTranslationResult(german: 'Straße', lemma: 'die Straße', gender: 'die', pos: 'noun', en: 'street', ar: 'شارع', es: 'calle'),
  'student': WordTranslationResult(german: 'Student', lemma: 'der Student', gender: 'der', pos: 'noun', en: 'student (male)', ar: 'طالب جامعي', es: 'estudiante'),
  'syrien': WordTranslationResult(german: 'Syrien', lemma: null, gender: 'das', pos: 'noun', en: 'Syria', ar: 'سوريا', es: 'Siria'),
  't': WordTranslationResult(german: 'T', lemma: null, gender: null, pos: 'noun', en: 'Letter T', ar: 'حرف T', es: 'letra T'),
  'tag': WordTranslationResult(german: 'Tag', lemma: 'der Tag', gender: 'der', pos: 'noun', en: 'day', ar: 'يوم', es: 'día'),
  'tage': WordTranslationResult(german: 'Tage', lemma: 'der Tag', gender: 'die', pos: 'noun', en: 'days', ar: 'أيام', es: 'días'),
  'tassen': WordTranslationResult(german: 'Tassen', lemma: 'die Tasse', gender: 'die', pos: 'noun', en: 'cups', ar: 'فناجين', es: 'tazas'),
  'taxi': WordTranslationResult(german: 'Taxi', lemma: 'das Taxi', gender: 'das', pos: 'noun', en: 'taxi', ar: 'سيارة أجرة', es: 'taxi'),
  'tee': WordTranslationResult(german: 'Tee', lemma: 'der Tee', gender: 'der', pos: 'noun', en: 'tea', ar: 'شاي', es: 'té'),
  'telefonnummer': WordTranslationResult(german: 'Telefonnummer', lemma: 'die Telefonnummer', gender: 'die', pos: 'noun', en: 'phone number', ar: 'رقم الهاتف', es: 'número de teléfono'),
  'trinke': WordTranslationResult(german: 'trinke', lemma: 'trinken', gender: null, pos: 'verb', en: 'drink', ar: 'أشرب', es: 'bebo'),
  'tschüss': WordTranslationResult(german: 'Tschüss', lemma: 'tschüss', gender: null, pos: 'part', en: 'bye', ar: 'مع السلامة', es: 'adiós'),
  'uhr': WordTranslationResult(german: 'Uhr', lemma: 'die Uhr', gender: 'die', pos: 'noun', en: 'clock / o’clock', ar: 'ساعة', es: 'reloj / hora'),
  'und': WordTranslationResult(german: 'und', lemma: null, gender: null, pos: 'conj', en: 'and', ar: 'و', es: 'y'),
  'universität': WordTranslationResult(german: 'Universität', lemma: 'die Universität', gender: 'die', pos: 'noun', en: 'university', ar: 'جامعة', es: 'universidad'),
  'unten': WordTranslationResult(german: 'unten', lemma: null, gender: null, pos: 'adv', en: 'down below / at the bottom', ar: 'بالأسفل', es: 'abajo'),
  'unterschrift': WordTranslationResult(german: 'Unterschrift', lemma: 'die Unterschrift', gender: 'die', pos: 'noun', en: 'signature', ar: 'توقيع', es: 'firma'),
  'vater': WordTranslationResult(german: 'Vater', lemma: 'der Vater', gender: 'der', pos: 'noun', en: 'father', ar: 'أب', es: 'padre'),
  'verheiratet': WordTranslationResult(german: 'verheiratet', lemma: null, gender: null, pos: 'adj', en: 'married', ar: 'متزوج / متزوجة', es: 'casado/a'),
  'verstehe': WordTranslationResult(german: 'verstehe', lemma: 'verstehen', gender: null, pos: 'verb', en: 'understand', ar: 'أفهم', es: 'entiendo'),
  'viel': WordTranslationResult(german: 'viel', lemma: null, gender: null, pos: 'adj', en: 'much / how much', ar: 'كم / كثير', es: 'mucho'),
  'vielen': WordTranslationResult(german: 'vielen', lemma: 'viel', gender: null, pos: 'adj', en: 'many (vielen Dank = thank you very much)', ar: 'جزيل / كثير', es: 'muchas'),
  'vier': WordTranslationResult(german: 'vier', lemma: null, gender: null, pos: 'num', en: 'four (4)', ar: 'أربعة (4)', es: 'cuatro'),
  'vierzehn': WordTranslationResult(german: 'vierzehn', lemma: null, gender: null, pos: 'num', en: 'fourteen (14)', ar: 'أربعة عشر (14)', es: 'catorce'),
  'vierzig': WordTranslationResult(german: 'vierzig', lemma: null, gender: null, pos: 'num', en: 'forty (40)', ar: 'أربعون (40)', es: 'cuarenta'),
  'vorname': WordTranslationResult(german: 'Vorname', lemma: 'der Vorname', gender: 'der', pos: 'noun', en: 'first name', ar: 'الاسم الأول', es: 'nombre de pila'),
  'vorstellen': WordTranslationResult(german: 'vorstellen', lemma: null, gender: null, pos: 'verb', en: 'introduce', ar: 'أُعرّف / أُقدّم نفسي', es: 'presentar'),
  'warm': WordTranslationResult(german: 'warm', lemma: null, gender: null, pos: 'adj', en: 'warm', ar: 'دافئ', es: 'cálido / tibio'),
  'wasser': WordTranslationResult(german: 'Wasser', lemma: 'das Wasser', gender: 'das', pos: 'noun', en: 'water', ar: 'ماء', es: 'agua'),
  'weiß': WordTranslationResult(german: 'weiß', lemma: null, gender: null, pos: 'adj', en: 'white', ar: 'أبيض', es: 'blanco'),
  'wie': WordTranslationResult(german: 'wie', lemma: null, gender: null, pos: 'adv', en: 'how / what', ar: 'كيف / ما', es: 'cómo'),
  'wiedersehen': WordTranslationResult(german: 'Wiedersehen', lemma: null, gender: 'das', pos: 'noun', en: 'seeing again (Auf Wiedersehen = goodbye)', ar: 'لقاء (إلى اللقاء)', es: 'vista (hasta la vista)'),
  'wir': WordTranslationResult(german: 'wir', lemma: null, gender: null, pos: 'pron', en: 'we', ar: 'نحن', es: 'nosotros'),
  'wo': WordTranslationResult(german: 'wo', lemma: null, gender: null, pos: 'adv', en: 'where', ar: 'أين', es: 'dónde'),
  'wohne': WordTranslationResult(german: 'wohne', lemma: 'wohnen', gender: null, pos: 'verb', en: 'live / reside', ar: 'أسكن / أعيش', es: 'vivo'),
  'wohnort': WordTranslationResult(german: 'Wohnort', lemma: 'der Wohnort', gender: 'der', pos: 'noun', en: 'place of residence', ar: 'مكان السكن', es: 'lugar de residencia'),
  'wohnt': WordTranslationResult(german: 'wohnt', lemma: 'wohnen', gender: null, pos: 'verb', en: 'lives / resides', ar: 'يسكن / يعيش', es: 'vive'),
  'wolke': WordTranslationResult(german: 'Wolke', lemma: 'die Wolke', gender: 'die', pos: 'noun', en: 'cloud', ar: 'سحابة', es: 'nube'),
  'yoga': WordTranslationResult(german: 'Yoga', lemma: 'das Yoga', gender: 'das', pos: 'noun', en: 'yoga', ar: 'يوغا', es: 'yoga'),
  'zehn': WordTranslationResult(german: 'zehn', lemma: null, gender: null, pos: 'num', en: 'ten (10)', ar: 'عشرة (10)', es: 'diez'),
  'zimmer': WordTranslationResult(german: 'Zimmer', lemma: 'das Zimmer', gender: 'das', pos: 'noun', en: 'room', ar: 'غرفة', es: 'habitación'),
  'zu': WordTranslationResult(german: 'zu', lemma: null, gender: null, pos: 'prep', en: 'to / at', ar: 'إلى / لـ', es: 'a / para'),
  'zug': WordTranslationResult(german: 'Zug', lemma: 'der Zug', gender: 'der', pos: 'noun', en: 'train', ar: 'قطار', es: 'tren'),
  'zwanzig': WordTranslationResult(german: 'zwanzig', lemma: null, gender: null, pos: 'num', en: 'twenty (20)', ar: 'عشرون (20)', es: 'veinte'),
  'zwei': WordTranslationResult(german: 'zwei', lemma: null, gender: null, pos: 'num', en: 'two (2)', ar: 'اثنان (2)', es: 'dos'),
  'zwölf': WordTranslationResult(german: 'zwölf', lemma: null, gender: null, pos: 'num', en: 'twelve (12)', ar: 'اثنا عشر (12)', es: 'doce'),
  'zähle': WordTranslationResult(german: 'zähle', lemma: 'zählen', gender: null, pos: 'verb', en: 'count', ar: 'أعد / أحصي', es: 'cuento'),
  'zählen': WordTranslationResult(german: 'zählen', lemma: null, gender: null, pos: 'verb', en: 'to count', ar: 'يعد / يحصي', es: 'contar'),
  'äpfel': WordTranslationResult(german: 'Äpfel', lemma: 'der Apfel', gender: 'die', pos: 'noun', en: 'apples', ar: 'تفاح', es: 'manzanas'),
};
