import 'package:flutter/widgets.dart';

import '../config/app_locale.dart';
import 'strings.dart';

/// Lookup table for every shipped string, indexed by [AppLocale] and
/// by [Str.*] key.  Adding a new locale requires only adding a column
/// here — no Flutter codegen step.
typedef _Group = ({String de, String en, String fr, String ar});

const Map<String, _Group> _table = {
  Str.appName: (de: 'Deutschy', en: 'Deutschy', fr: 'Deutschy', ar: 'دويتش'),
  Str.splashTagline: (
    de: 'Deutschy wird vorbereitet …',
    en: 'Deutschy is starting up …',
    fr: 'Deutschy démarre …',
    ar: 'يتم تجهيز Deutschy …',
  ),
  Str.dashboardToday: (
    de: 'Heute',
    en: 'Today',
    fr: "Aujourd'hui",
    ar: 'اليوم',
  ),
  Str.dashboardDueToday: (
    de: 'Heute fällig',
    en: 'Due today',
    fr: "À réviser aujourd'hui",
    ar: 'مستحق اليوم',
  ),
  Str.dashboardOverdueShort: (
    de: 'Karten überfällig',
    en: 'cards overdue',
    fr: 'cartes en retard',
    ar: 'بطاقات متأخرة',
  ),
  Str.dashboardEmptyState: (
    de: 'Du bist heute fertig — gut gemacht!',
    en: 'You\'re done for today — well done!',
    fr: "Tu as terminé pour aujourd'hui — bien joué !",
    ar: 'انتهيت لليوم — أحسنت!',
  ),
  Str.navHome: (
    de: 'Start',
    en: 'Home',
    fr: 'Accueil',
    ar: 'الرئيسية',
  ),
  Str.navVocab: (
    de: 'Wörter',
    en: 'Vocab',
    fr: 'Vocabulaire',
    ar: 'مفردات',
  ),
  Str.navSpeaking: (
    de: 'Sprechen',
    en: 'Speaking',
    fr: 'Parler',
    ar: 'محادثة',
  ),
  Str.navWriting: (
    de: 'Schreiben',
    en: 'Writing',
    fr: 'Écriture',
    ar: 'كتابة',
  ),
  Str.navGames: (
    de: 'Spiele',
    en: 'Games',
    fr: 'Jeux',
    ar: 'ألعاب',
  ),
  Str.navGrammar: (
    de: 'Grammatik',
    en: 'Grammar',
    fr: 'Grammaire',
    ar: 'القواعد',
  ),
  Str.navReading: (
    de: 'Lesen',
    en: 'Reading',
    fr: 'Lecture',
    ar: 'قراءة',
  ),
  Str.navProfile: (
    de: 'Profil',
    en: 'Profile',
    fr: 'Profil',
    ar: 'الملف',
  ),
  Str.loginTagline: (
    de: 'Deutsch lernen — einfach und schnell.',
    en: 'Learn German — easy and fast.',
    fr: 'Apprends l\'allemand — simple et rapide.',
    ar: 'تعلم الألمانية — بسهولة وسرعة.',
  ),
  Str.loginWithGoogle: (
    de: 'Mit Google anmelden',
    en: 'Continue with Google',
    fr: 'Continuer avec Google',
    ar: 'متابعة عبر Google',
  ),
  Str.loginWithApple: (
    de: 'Mit Apple anmelden',
    en: 'Continue with Apple',
    fr: 'Continuer avec Apple',
    ar: 'متابعة عبر Apple',
  ),
  Str.loginOpening: (
    de: 'Wird geöffnet …',
    en: 'Opening …',
    fr: 'Ouverture …',
    ar: 'جاري الفتح …',
  ),
  Str.loginAccept: (
    de: 'Mit dem Anmelden akzeptierst du unsere Bedingungen und die AdMob-Datenschutzhinweise.',
    en: 'By continuing you agree to our Terms and the AdMob Privacy Notice.',
    fr: 'En continuant, tu acceptes nos conditions et notre politique de confidentialité AdMob.',
    ar: 'بالمتابعة، فأنت توافق على شروطنا وإشعار خصوصية AdMob.',
  ),
  Str.writingPromptHint: (
    de: 'Schreibe einen deutschen Absatz …',
    en: 'Write a German paragraph …',
    fr: 'Écris un paragraphe en allemand …',
    ar: 'اكتب فقرة بالألمانية …',
  ),
  Str.writingHelperChars: (
    de: 'Mindestens 12, höchstens 1200 Zeichen.',
    en: 'Between 12 and 1200 characters.',
    fr: 'Entre 12 et 1200 caractères.',
    ar: 'بين ١٢ و ١٢٠٠ حرفًا.',
  ),
  Str.writingGrade: (
    de: 'Korrigieren',
    en: 'Get feedback',
    fr: 'Corriger',
    ar: 'صحّح لي',
  ),
  Str.writingChecking: (
    de: 'Prüfe …',
    en: 'Checking …',
    fr: 'Vérification …',
    ar: 'جاري التحقق …',
  ),
  Str.errorNetwork: (
    de: 'Coach nicht erreichbar — bitte Internet prüfen.',
    en: 'Coach offline — please check your connection.',
    fr: 'Coach hors ligne — vérifie ta connexion.',
    ar: 'المعلم غير متصل — تحقّق من الإنترنت.',
  ),
  Str.errorMalformed: (
    de: 'Antwort nicht lesbar — bitte erneut versuchen.',
    en: 'Response was unreadable — please retry.',
    fr: 'Réponse illisible — réessaie.',
    ar: 'الرد غير قابل للقراءة — حاول مجددًا.',
  ),
  Str.errorGeneric: (
    de: 'Etwas ist schiefgelaufen — bitte erneut versuchen.',
    en: 'Something went wrong — please retry.',
    fr: 'Une erreur est survenue — réessaie.',
    ar: 'حدث خطأ — حاول مجددًا.',
  ),
  Str.errorRetry: (
    de: 'Erneut versuchen',
    en: 'Retry',
    fr: 'Réessayer',
    ar: 'إعادة المحاولة',
  ),
  Str.vocabHeaderTitle: (
    de: 'Wortschatz',
    en: 'Vocabulary',
    fr: 'Vocabulaire',
    ar: 'المفردات',
  ),
  Str.vocabDue: (
    de: '%d fällig',
    en: '%d due',
    fr: '%d à réviser',
    ar: '%d مستحق',
  ),
  Str.vocabEmptyStart: (
    de: 'Level %s startet bald',
    en: 'Level %s is coming soon',
    fr: 'Le niveau %s arrive bientôt',
    ar: 'مستوى %s قادم قريبًا',
  ),
  Str.vocabLockedSoon: (
    de: 'Bald verfügbar',
    en: 'Coming soon',
    fr: 'Bientôt disponible',
    ar: 'قريبًا',
  ),
  Str.reviewActionForgot: (
    de: 'Vergessen',
    en: 'Forgot',
    fr: 'Oublié',
    ar: 'نسيت',
  ),
  Str.reviewActionHard: (
    de: 'Schwer',
    en: 'Hard',
    fr: 'Difficile',
    ar: 'صعب',
  ),
  Str.reviewActionGood: (
    de: 'Gut',
    en: 'Good',
    fr: 'Bien',
    ar: 'جيد',
  ),
  Str.reviewActionEasy: (
    de: 'Einfach',
    en: 'Easy',
    fr: 'Facile',
    ar: 'سهل',
  ),
  Str.reviewActionSkip: (
    de: 'Überspringen',
    en: 'Skip',
    fr: 'Passer',
    ar: 'تخطّي',
  ),
  Str.reviewShowAnswer: (
    de: 'Tippe um die Antwort zu sehen',
    en: 'Tap to reveal the answer',
    fr: 'Touche pour voir la réponse',
    ar: 'اضغط لرؤية الإجابة',
  ),
  Str.reviewListen: (
    de: 'Anhören',
    en: 'Listen',
    fr: 'Écouter',
    ar: 'استمع',
  ),
  Str.reviewClose: (
    de: 'Schließen',
    en: 'Close',
    fr: 'Fermer',
    ar: 'إغلاق',
  ),
  Str.finishCongrats: (
    de: 'Starke Arbeit!',
    en: 'Great job!',
    fr: 'Bravo !',
    ar: 'أحسنت!',
  ),
  Str.streakDays: (
    de: '%d Tage in Folge',
    en: '%d day streak',
    fr: '%d jours d\'affilée',
    ar: '%d يوم متتالي',
  ),
  Str.streakNone: (
    de: 'Heute anfangen',
    en: 'Start your streak today',
    fr: 'Commence ta série aujourd\'hui',
    ar: 'ابدأ سلسلتك اليوم',
  ),
  Str.settingsTheme: (
    de: 'Erscheinungsbild',
    en: 'Appearance',
    fr: 'Apparence',
    ar: 'المظهر',
  ),
  Str.settingsThemeSystem: (
    de: 'Systemvorgabe',
    en: 'System default',
    fr: 'Choix du système',
    ar: 'إعداد النظام',
  ),
  Str.settingsThemeLight: (
    de: 'Hell',
    en: 'Light',
    fr: 'Clair',
    ar: 'فاتح',
  ),
  Str.settingsThemeDark: (
    de: 'Dunkel',
    en: 'Dark',
    fr: 'Sombre',
    ar: 'داكن',
  ),
  Str.settingsLanguage: (
    de: 'Sprache',
    en: 'Language',
    fr: 'Langue',
    ar: 'اللغة',
  ),
  Str.settingsNotifications: (
    de: 'Benachrichtigungen',
    en: 'Notifications',
    fr: 'Notifications',
    ar: 'الإشعارات',
  ),
  Str.settingsStreak: (
    de: 'Erinnerung an tägliche Übung',
    en: 'Daily reminder',
    fr: 'Rappel quotidien',
    ar: 'تذكير يومي',
  ),
  Str.settingsReminderTime: (
    de: 'Wann möchtest du erinnert werden?',
    en: 'When should we remind you?',
    fr: 'À quel moment te rappeler ?',
    ar: 'متى تريد التذكير؟',
  ),
  Str.settingsProfilePhoto: (
    de: 'Profilbild',
    en: 'Profile photo',
    fr: 'Photo de profil',
    ar: 'صورة الملف',
  ),
  Str.settingsChangePhoto: (
    de: 'Foto ändern',
    en: 'Change photo',
    fr: 'Modifier la photo',
    ar: 'تغيير الصورة',
  ),
  Str.settingsAccount: (
    de: 'Konto',
    en: 'Account',
    fr: 'Compte',
    ar: 'الحساب',
  ),
  Str.settingsSignOut: (
    de: 'Abmelden',
    en: 'Sign out',
    fr: 'Se déconnecter',
    ar: 'تسجيل الخروج',
  ),
  Str.settingsAbout: (
    de: 'Über Deutschy',
    en: 'About Deutschy',
    fr: 'À propos de Deutschy',
    ar: 'حول Deutschy',
  ),
  Str.settingsAboutBody: (
    de:
        'Deutschy hilft dir, Deutsch mit Spaced Repetition und KI-Coaching zu lernen — kostenlos, offline, ohne Werbe-Tracking.',
    en:
        'Deutschy helps you learn German with spaced repetition and AI coaching — free, offline, no ad tracking.',
    fr:
        "Deutschy t'aide à apprendre l'allemand avec la répétition espacée et un coach IA — gratuit, hors-ligne, sans traçage publicitaire.",
    ar:
        'Deutschy يساعدك على تعلم الألمانية مع تكرار متباعد ومعلم ذكاء اصطناعي — مجانًا ودون اتصال وبدون تتبع إعلاني.',
  ),
  Str.settingsVersion: (
    de: 'Version',
    en: 'Version',
    fr: 'Version',
    ar: 'الإصدار',
  ),
  Str.settingsPlannedOnboardingTitle: (
    de: 'Personalisierte Begrüßung kommt',
    en: 'Personalised welcome coming soon',
    fr: 'Bientôt : accueil personnalisé',
    ar: 'الترحيب المخصص قادم قريبًا',
  ),
  Str.settingsPlannedOnboardingBody: (
    de:
        'Demnächst wirst du dein Startlevel (A0, A1, A2, B1) wählen und einen Lernplan erhalten.',
    en:
        'Soon you’ll pick your starting level (A0, A1, A2, B1) and get a study plan.',
    fr:
        'Bientôt, tu choisiras ton niveau de départ (A0, A1, A2, B1) et recevras un plan d\'apprentissage.',
    ar:
        'قريبًا ستختار مستوى البداية (A0, A1, A2, B1) وتحصل على خطة تعلّم.',
  ),
  Str.photoGallery: (
    de: 'Galerie',
    en: 'Gallery',
    fr: 'Galerie',
    ar: 'المعرض',
  ),
  Str.photoCamera: (
    de: 'Kamera',
    en: 'Camera',
    fr: 'Appareil photo',
    ar: 'الكاميرا',
  ),
  Str.photoRemove: (
    de: 'Foto entfernen',
    en: 'Remove photo',
    fr: 'Supprimer la photo',
    ar: 'إزالة الصورة',
  ),
  Str.pickReminderTime: (
    de: 'Uhrzeit wählen',
    en: 'Pick a time',
    fr: 'Choisir l\'heure',
    ar: 'اختر الوقت',
  ),
  Str.grammarTitle: (
    de: 'Grammatik',
    en: 'Grammar',
    fr: 'Grammaire',
    ar: 'القواعد',
  ),
  Str.onboardingTitle: (
    de: 'Willkommen bei Deutschy!',
    en: 'Welcome to Deutschy!',
    fr: 'Bienvenue chez Deutschy !',
    ar: 'مرحبًا بك في Deutschy!',
  ),
  Str.onboardingBody: (
    de:
        'Wähle dein Startlevel (Intro, A1, A2, B1, B2). Wir passen deinen Lernplan an — kostenlos und offline-fähig.',
    en:
        'Pick your starting level (Intro, A1, A2, B1, B2). We will tailor a study plan to it — free, ready offline.',
    fr:
        'Choisis ton niveau (Intro, A1, A2, B1, B2). Nous adapterons ton plan d\'apprentissage — gratuit, prêt hors-ligne.',
    ar:
        'اختر مستوى البداية (المقدمة، A1, A2, B1, B2). سنخصص خطة تعلمك — مجانًا وجاهزة بدون اتصال.',
  ),
  Str.onboardingPickLevel: (
    de: 'Startlevel',
    en: 'Starting Level',
    fr: 'Niveau de départ',
    ar: 'مستوى البداية',
  ),
  Str.onboardingCta: (
    de: 'Los geht\'s',
    en: 'Let\'s go',
    fr: 'On y va',
    ar: '!هيّا بنا',
  ),
  Str.settingsReviewNotifEnabled: (
    de: 'Erinnerungen sind eingeschaltet',
    en: 'Reminders are enabled',
    fr: 'Les rappels sont activés',
    ar: 'التذكيرات مُفعّلة',
  ),
  Str.reverseAnim: (
    de: 'Animationen reduzieren',
    en: 'Reduce animations',
    fr: 'Réduire les animations',
    ar: 'تقليل الحركات',
  ),
  Str.gamesHomeMemoryMatch: (
    de: 'Memory — karten-paare finden',
    en: 'Memory · Match the pairs',
    fr: 'Memory · Trouver les pairs',
    ar: 'لعبة الذاكرة · طابق الأزواج',
  ),
  Str.gamesHomeWordChain: (
    de: 'Wortkette — schnell entscheiden',
    en: 'Word Chain · Race the clock',
    fr: 'Chaîne de mots · Course contre la montre',
    ar: 'سلسلة الكلمات · سباق ضد الساعة',
  ),
  Str.gamesComplete: (
    de: 'Geschafft!',
    en: 'Round complete',
    fr: 'Bravo !',
    ar: '!أحسنت',
  ),
  Str.readingTitle: (
    de: 'Lesen',
    en: 'Reading',
    fr: 'Lecture',
    ar: 'قراءة',
  ),
  Str.loginGuest: (
    de: 'Ohne Konto fortfahren',
    en: 'Continue without an account',
    fr: 'Continuer sans compte',
    ar: 'المتابعة بدون حساب',
  ),
  Str.navMore: (
    de: 'Mehr',
    en: 'More',
    fr: 'Plus',
    ar: 'المزيد',
  ),
};

/// One string lookup.  Returns the entry for the active locale, or
/// the German copy if the key is missing.
String t(BuildContext context, String key,
    {List<String> args = const <String>[]}) {
  final code = AppLocale.localeOf(context).languageCode;
  final group = _table[key] ?? _table[Str.appName]!;
  String raw;
  switch (code) {
    case LocaleCode.french:
      raw = group.fr;
      break;
    case LocaleCode.arabic:
      raw = group.ar;
      break;
    case LocaleCode.english:
      raw = group.en;
      break;
    default:
      raw = group.de;
  }
  // Lightweight %s/%d positional fill — not as fancy as intl but
  // covers every key in the table without bringing in a dependency.
  for (var i = 0; i < args.length; i++) {
    raw = raw.replaceFirst(RegExp(r'%[sd]'), args[i]);
  }
  return raw;
}
