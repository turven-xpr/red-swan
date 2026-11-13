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

  // Shell & Navigation
  Str.learningPath: (
    de: 'Lernpfad:',
    en: 'Learning Path:',
    fr: 'Parcours d\'apprentissage :',
    ar: 'مسار التعلم:',
  ),
  Str.streakActiveTooltip: (
    de: 'Tägliche Serie: Übe jeden Tag, um deine Serie auszubauen!',
    en: 'Daily Streak: Practice every day to build your streak!',
    fr: 'Série quotidienne : Entraînez-vous chaque jour pour maintenir votre série !',
    ar: 'الحماسة اليومية: تدرب يوميًا لزيادة أيام حماستك المستمرة!',
  ),
  Str.streakExtendedToast: (
    de: '🔥 Serie aktiv! Lerne täglich weiter.',
    en: '🔥 Streak active! Keep learning daily to extend it.',
    fr: '🔥 Série active ! Continuez à apprendre chaque jour.',
    ar: '🔥 الحماسة نشطة! استمر في التعلم يوميًا لزيادتها.',
  ),
  Str.xpPoints: (
    de: '%s XP',
    en: '%s XP',
    fr: '%s XP',
    ar: '%s نقطة',
  ),

  // Study Screen & Checkpoints
  Str.unitLabel: (
    de: 'Einheit %s',
    en: 'Unit %s',
    fr: 'Unité %s',
    ar: 'الوحدة %s',
  ),
  Str.readyToStudy: (
    de: 'Bereit zum Lernen',
    en: 'Ready to learn',
    fr: 'Prêt à étudier',
    ar: 'جاهز للدراسة',
  ),
  Str.lessonsComingSoon: (
    de: 'Lektionen für diese Einheit werden bald freigeschaltet',
    en: 'Lessons for this unit will be unlocked soon',
    fr: 'Les leçons de cette unité seront bientôt débloquées',
    ar: 'دروس هذه الوحدة قيد الإعداد والإضافة قريبًا',
  ),
  Str.checkpointIntro: (
    de: 'Grundlagen-Checkpoint (Intro)',
    en: 'Intro Foundations Checkpoint',
    fr: 'Point de contrôle des bases',
    ar: 'نقطة تثبيت الأساسيات (Intro)',
  ),
  Str.checkpointGate: (
    de: '%s Niveau-Abschlusstest',
    en: '%s Gate Test Checkpoint',
    fr: 'Test de validation du niveau %s',
    ar: 'اختبار اجتياز المستوى %s',
  ),
  Str.checkpointIntroSub: (
    de: 'Erreiche 75%, um die Grundlagen zu meistern und A1 freizuschalten',
    en: 'Score 75% to master the basics & unlock Level A1',
    fr: 'Obtenez 75% pour maîtriser les bases et débloquer le niveau A1',
    ar: 'احصل على 75% لتثبيت الأساسيات وفتح المستوى A1',
  ),
  Str.checkpointGateSub: (
    de: 'Erreiche 75%, um das nächste Niveau freizuschalten',
    en: 'Score 75% to pass & unlock the next level',
    fr: 'Obtenez 75% pour passer et débloquer le niveau suivant',
    ar: 'احصل على 75% لاجتياز الاختبار وفتح المستوى التالي',
  ),
  Str.skillListen: (
    de: '%s Hören',
    en: '%s Listen',
    fr: '%s Écoute',
    ar: '%s استماع',
  ),
  Str.skillRead: (
    de: '%s Lesen',
    en: '%s Read',
    fr: '%s Lecture',
    ar: '%s قراءة',
  ),
  Str.skillWrite: (
    de: '%s Schreiben',
    en: '%s Write',
    fr: '%s Écriture',
    ar: '%s كتابة',
  ),
  Str.skillSpeak: (
    de: '%s Sprechen',
    en: '%s Speak',
    fr: '%s Expression',
    ar: '%s محادثة',
  ),
  Str.startIntroCheckpoint: (
    de: 'Intro-Checkpoint starten',
    en: 'Start Intro Checkpoint',
    fr: 'Commencer le point de contrôle',
    ar: 'ابدأ اختبار الأساسيات',
  ),
  Str.startGateTest: (
    de: 'Abschlusstest %s starten',
    en: 'Start %s Gate Test',
    fr: 'Commencer le test %s',
    ar: 'ابدأ اختبار المستوى %s',
  ),

  // Lesson Player
  Str.chooseCorrectAnswer: (
    de: 'Wähle die richtige Antwort',
    en: 'Choose the correct answer',
    fr: 'Choisissez la bonne réponse',
    ar: 'اختر الإجابة الصحيحة',
  ),
  Str.pronouncedCorrectly: (
    de: 'Richtig ausgesprochen',
    en: 'I pronounced it correctly',
    fr: 'Je l\'ai bien prononcé',
    ar: 'نطقتها بصوت صحيح',
  ),
  Str.checkAnswer: (
    de: 'Antwort prüfen',
    en: 'Check Answer',
    fr: 'Vérifier la réponse',
    ar: 'تحقق من الإجابة',
  ),
  Str.correctFeedback: (
    de: 'Richtig! Sehr gut 👏',
    en: 'Correct! Great job 👏',
    fr: 'Correct ! Bravo 👏',
    ar: 'إجابة صحيحة! أحسنت 👏',
  ),
  Str.incorrectFeedback: (
    de: 'Nicht ganz richtig',
    en: 'Incorrect',
    fr: 'Incorrect',
    ar: 'إجابة غير صحيحة، حاول مجددًا',
  ),
  Str.correctAnswerLabel: (
    de: 'Richtige Antwort:',
    en: 'Correct answer:',
    fr: 'Bonne réponse :',
    ar: 'الإجابة الصحيحة:',
  ),
  Str.continueButton: (
    de: 'Weiter',
    en: 'Continue',
    fr: 'Continuer',
    ar: 'المتابعة',
  ),
  Str.finishReading: (
    de: 'Lesen abgeschlossen',
    en: 'Finished Reading',
    fr: 'Lecture terminée',
    ar: 'أنهيت قراءة الدرس',
  ),
  Str.completeTextLesson: (
    de: 'Textlektion abschließen',
    en: 'Complete Reading Lesson',
    fr: 'Terminer la leçon de lecture',
    ar: 'إتمام درس النص',
  ),
  Str.completeStoryLesson: (
    de: 'Geschichte abschließen',
    en: 'Complete Story Lesson',
    fr: 'Terminer l\'histoire',
    ar: 'إتمام درس القصة',
  ),
  Str.lessonCompletedTitle: (
    de: 'Fantastisch! Lektion abgeschlossen',
    en: 'Awesome! Lesson Completed',
    fr: 'Bravo ! Leçon terminée',
    ar: 'أحسنت! أتممت الدرس بنجاح',
  ),
  Str.lessonCompletedSub: (
    de: 'Du hast wichtige Fortschritte gemacht!',
    en: 'You\'ve made great progress today!',
    fr: 'Vous avez fait de grands progrès aujourd\'hui !',
    ar: 'لقد حققت تقدمًا ممتازًا وملموسًا في تعلم الألمانية!',
  ),

  // Placeholder Screens
  Str.testsTitle: (
    de: 'Prüfungen & Zertifikate',
    en: 'Tests & Exams',
    fr: 'Tests et examens',
    ar: 'الاختبارات والشهادات الرسمية',
  ),
  Str.testsDesc: (
    de: 'Offizielle Goethe-Zertifikat-, telc- und Modellprüfungen werden hier verfügbar sein.',
    en: 'Official Goethe-Institut, telc, and level certification practice exams will be built here.',
    fr: 'Les examens blancs officiels du Goethe-Institut, telc et certifications seront disponibles ici.',
    ar: 'نماذج وتدريبات امتحانات معهد جوته، telc، واختبارات قياس الكفاءة الرسمية ستكون هنا قريبًا.',
  ),
  Str.aiTutorTitle: (
    de: 'KI-Deutschlehrer',
    en: 'AI German Teacher',
    fr: 'Professeur d\'allemand IA',
    ar: 'المعلم الذكي للألمانية (AI)',
  ),
  Str.aiTutorDesc: (
    de: 'Personalisierte KI-Chat-Gespräche mit Live-Grammatikkorrektur und Sprachpraxis werden hier bereitgestellt.',
    en: 'Personalized AI chat conversations with live grammar corrections and speech practice will be built here.',
    fr: 'Des conversations personnalisées par chat IA avec corrections en direct et pratique orale seront disponibles ici.',
    ar: 'محادثات تفاعلية ذكية مع تصحيح فوري للقواعد وتدريب النطق بالذكاء الاصطناعي قريبًا.',
  ),
  Str.profileStatsTitle: (
    de: 'Lernstatistiken & Erfolge',
    en: 'Learning Stats & Achievements',
    fr: 'Statistiques et réussites',
    ar: 'إحصائيات التعلم والإنجازات',
  ),
  Str.profileStatsDesc: (
    de: 'Tages-Serien, GER-Niveaufortschritt und Testergebnisse werden hier angezeigt.',
    en: 'Daily streak counters, CEFR level progression, and test scores will be built here.',
    fr: 'Les séries quotidiennes, la progression CECR et les scores aux tests apparaîtront ici.',
    ar: 'عدادات الحماسة اليومية، التقدم بمستويات الإطار الأوروبي، ونتائج الاختبارات ستظهر هنا.',
  ),
  Str.profileSettingsBtn: (
    de: 'App-Einstellungen & Sprache',
    en: 'App Settings & Language',
    fr: 'Paramètres et langue',
    ar: 'إعدادات التطبيق واللغة',
  ),
  Str.settingsAudioSpeed: (
    de: 'Audio-Geschwindigkeit',
    en: 'Audio Speed',
    fr: 'Vitesse audio',
    ar: 'سرعة نطق الصوت',
  ),

  // Onboarding
  Str.onboardingStep1Title: (
    de: 'Welche Sprache sprichst du?',
    en: 'What language do you speak?',
    fr: 'Quelle est votre langue maternelle ?',
    ar: 'ما هي لغتك الأم؟',
  ),
  Str.onboardingStep1Sub: (
    de: 'Wähle die Sprache, mit der du Deutsch lernen möchtest.',
    en: 'Choose the language you will use to learn German.',
    fr: 'Choisissez la langue que vous utiliserez pour apprendre l\'allemand.',
    ar: 'اختر اللغة التي تفضل استخدامها لشرح وتعلم الألمانية.',
  ),
  Str.onboardingStep2Title: (
    de: 'Warum lernst du Deutsch?',
    en: 'Why are you learning German?',
    fr: 'Pourquoi apprenez-vous l\'allemand ?',
    ar: 'ما هو هدفك الأساسي من تعلم الألمانية؟',
  ),
  Str.onboardingStep2Sub: (
    de: 'Wir passen deine Lektionen an dein persönliches Ziel an.',
    en: 'We customize your lessons to match your goal.',
    fr: 'Nous adaptons vos leçons selon votre objectif.',
    ar: 'سنخصص لك خطة الدروس والمفردات لتناسب هدفك بدقة.',
  ),
  Str.onboardingStep3Title: (
    de: 'Wie gut ist dein Deutsch?',
    en: 'How much German do you know?',
    fr: 'Quel est votre niveau actuel en allemand ?',
    ar: 'ما هو مستواك الحالي في اللغة الألمانية؟',
  ),
  Str.onboardingStep3Sub: (
    de: 'Keine Sorge, wir starten genau dort, wo du dich wohlfühlst.',
    en: 'Don\'t worry, we start exactly where you feel comfortable.',
    fr: 'Pas d\'inquiétude, nous commençons exactement à votre niveau.',
    ar: 'لا تقلق، سنبدأ معك بدقة من المستوى المناسب لمعرفتك.',
  ),
  Str.onboardingStep4Title: (
    de: 'Was ist dein tägliches Ziel?',
    en: 'What is your daily goal?',
    fr: 'Quel est votre objectif quotidien ?',
    ar: 'ما هو هدف دراستك اليومي؟',
  ),
  Str.onboardingStep4Sub: (
    de: 'Schon wenige Minuten pro Tag reichen für große Fortschritte!',
    en: 'Even a few minutes a day make a huge difference!',
    fr: 'Même quelques minutes par jour font une grande différence !',
    ar: 'بضع دقائق يوميًا كافية لصنع فارق حقيقي ومستمر!',
  ),
  Str.onboardingReasonStudy: (
    de: 'Studium an der Universität',
    en: 'University & Academic Study',
    fr: 'Études universitaires',
    ar: 'الدراسة والجامعة في ألمانيا',
  ),
  Str.onboardingReasonStudyDesc: (
    de: 'Vorbereitung auf DSH/TestDaF und akademischen Erfolg',
    en: 'Prepare for DSH/TestDaF and university success',
    fr: 'Préparation au DSH/TestDaF et études',
    ar: 'التحضير لشهادات DSH/TestDaF والالتحاق بالجامعات',
  ),
  Str.onboardingReasonAusbildung: (
    de: 'Duale Ausbildung',
    en: 'Apprenticeship (Ausbildung)',
    fr: 'Formation professionnelle (Ausbildung)',
    ar: 'التدريب المهني (Ausbildung)',
  ),
  Str.onboardingReasonAusbildungDesc: (
    de: 'Praktischer Berufsalltag und Fachsprache',
    en: 'Vocational training and workplace language',
    fr: 'Formation en alternance et vocabulaire professionnel',
    ar: 'الاستعداد للتدريب المهني ولغة العمل الحرفية والمهنية',
  ),
  Str.onboardingReasonJob: (
    de: 'Karriere & Arbeit',
    en: 'Work & Career in Germany',
    fr: 'Travail et carrière en Allemagne',
    ar: 'العمل والوظيفة في ألمانيا',
  ),
  Str.onboardingReasonJobDesc: (
    de: 'Chancen auf dem deutschen Arbeitsmarkt nutzen',
    en: 'Professional opportunities and career growth',
    fr: 'Opportunités professionnelles et carrière',
    ar: 'الحصول على وظيفة وتطوير المسار المهني مع الشركات الألمانية',
  ),
  Str.onboardingReasonTravel: (
    de: 'Reisen & Kultur',
    en: 'Travel, Tourism & Culture',
    fr: 'Voyages et tourisme',
    ar: 'السفر، السياحة، واستكشاف الثقافة',
  ),
  Str.onboardingReasonTravelDesc: (
    de: 'Souverän im Alltag und Urlaub verständigen',
    en: 'Communicate smoothly while traveling',
    fr: 'Communiquer facilement en voyage',
    ar: 'التواصل بثقة في الحياة اليومية وأثناء السفر والتنقل',
  ),
  Str.onboardingReasonFun: (
    de: 'Neugier & Gehirnjogging',
    en: 'Personal Interest & Brain Training',
    fr: 'Intérêt personnel et culture',
    ar: 'شغف باللغات وتنشيط الذاكرة',
  ),
  Str.onboardingReasonFunDesc: (
    de: 'Eine der wichtigsten Sprachen Europas lernen',
    en: 'Enjoy learning one of Europe\'s key languages',
    fr: 'Apprendre une langue européenne majeure par plaisir',
    ar: 'متعة تعلم إحدى أهم لغات أوروبا كمهارة جديدة',
  ),
  Str.onboardingBtnContinue: (
    de: 'Weiter',
    en: 'Continue',
    fr: 'Continuer',
    ar: 'متابعة',
  ),
  Str.onboardingBtnBack: (
    de: 'Zurück',
    en: 'Back',
    fr: 'Retour',
    ar: 'رجوع',
  ),
  Str.onboardingBtnStart: (
    de: 'Jetzt starten',
    en: 'Start Learning',
    fr: 'Commencer',
    ar: 'ابدأ التعلم الآن',
  ),
  Str.onboardingLevelIntroTitle: (
    de: 'Intro · Absoluter Anfänger',
    en: 'Intro · Absolute Beginner',
    fr: 'Intro · Grand Débutant',
    ar: 'مقدمة · مبتدئ تماماً',
  ),
  Str.onboardingLevelIntroDesc: (
    de: 'Ich kann kein Deutsch oder nur wenige einfache Wörter',
    en: 'I know zero German or just a few basic words',
    fr: 'Je ne connais pas l\'allemand ou juste quelques mots de base',
    ar: 'لا أعرف أي ألمانية أو فقط بضع كلمات أساسية',
  ),
  Str.onboardingLevelA1Title: (
    de: 'A1 · Anfänger',
    en: 'A1 · Beginner',
    fr: 'A1 · Débutant',
    ar: 'A1 · مبتدئ',
  ),
  Str.onboardingLevelA1Desc: (
    de: 'Ich kann mich vorstellen und einfache Alltagssätze verstehen',
    en: 'I can introduce myself and understand simple daily phrases',
    fr: 'Je peux me présenter et comprendre des phrases simples du quotidien',
    ar: 'أستطيع تقديم نفسي وفهم عبارات يومية بسيطة',
  ),
  Str.onboardingLevelA2Title: (
    de: 'A2 · Grundlegende Kenntnisse',
    en: 'A2 · Elementary',
    fr: 'A2 · Élémentaire',
    ar: 'A2 · أساسي',
  ),
  Str.onboardingLevelA2Desc: (
    de: 'Ich kann mich in einfachen Alltagssituationen verständigen',
    en: 'I can communicate in simple everyday situations & routines',
    fr: 'Je peux communiquer dans des situations simples de la vie quotidienne',
    ar: 'أستطيع التواصل في المواقف اليومية البسيطة والروتينية',
  ),
  Str.onboardingLevelB1Title: (
    de: 'B1 · Mittelstufe',
    en: 'B1 · Intermediate',
    fr: 'B1 · Intermédiaire',
    ar: 'B1 · متوسط',
  ),
  Str.onboardingLevelB1Desc: (
    de: 'Ich kann meine Meinung äußern und Hauptaussagen verstehen',
    en: 'I can express opinions, understand main ideas & speak steadily',
    fr: 'Je peux exprimer des opinions, comprendre les idées principales et parler régulièrement',
    ar: 'أستطيع التعبير عن الآراء وفهم الأفكار الرئيسية والتحدث بثبات',
  ),
  Str.onboardingLevelB2Title: (
    de: 'B2 · Gute Mittelstufe',
    en: 'B2 · Upper Intermediate',
    fr: 'B2 · Intermédiaire supérieur',
    ar: 'B2 · فوق المتوسط',
  ),
  Str.onboardingLevelB2Desc: (
    de: 'Ich beherrsche Fachgespräche und komplexe Texte',
    en: 'I can handle technical/work conversations & complex texts',
    fr: 'Je peux gérer des conversations techniques/professionnelles et des textes complexes',
    ar: 'أستطيع التعامل مع المحادثات التقنية/العمل والنصوص المعقدة',
  ),
  Str.onboardingGoal3MinTitle: (
    de: '3 Min. / Tag · Gelegentlich',
    en: '3 min / day · Casual',
    fr: '3 min / jour · Décontracté',
    ar: '3 دقائق / يوم · مريح',
  ),
  Str.onboardingGoal3MinDesc: (
    de: 'Schnelle Mikrogewohnheit für dein Gehirn',
    en: 'Quick micro-habit to keep your brain active',
    fr: 'Micro-habitude rapide pour garder l\'esprit vif',
    ar: 'عادة صغيرة وسريعة لتنشيط العقل',
  ),
  Str.onboardingGoal5MinTitle: (
    de: '5 Min. / Tag · Regelmäßig',
    en: '5 min / day · Regular',
    fr: '5 min / jour · منتظم',
    ar: '5 دقائق / يوم · منتظم',
  ),
  Str.onboardingGoal5MinDesc: (
    de: 'Stetige tägliche Übung für deine Serie',
    en: 'Steady daily practice to build your streak',
    fr: 'Pratique quotidienne régulière pour maintenir votre série',
    ar: 'تمرين يومي منتظم لبناء حماسك المتواصل',
  ),
  Str.onboardingGoal15MinTitle: (
    de: '15 Min. / Tag · Engagiert (Empfohlen)',
    en: '15 min / day · Committed (Recommended)',
    fr: '15 min / jour · Engagé (Recommandé)',
    ar: '15 دقيقة / يوم · ملتزم (موصى به)',
  ),
  Str.onboardingGoal15MinDesc: (
    de: 'Optimales Tempo für Behalten und Wortschatzaufbau',
    en: 'Optimal daily pace for solid retention and vocabulary growth',
    fr: 'Rythme quotidien optimal pour une mémorisation solide et enrichir le vocabulaire',
    ar: 'الوتيرة اليومية المثالية لتثبيت المعلومات وبناء المفردات',
  ),
  Str.onboardingGoal30MinTitle: (
    de: '30 Min. / Tag · Ernsthaft',
    en: '30 min / day · Serious',
    fr: '30 min / jour · Sérieux',
    ar: '30 دقيقة / يوم · جاد',
  ),
  Str.onboardingGoal30MinDesc: (
    de: 'Schnellere Deutsch-Flüssigkeit für Beruf oder Studium',
    en: 'Fast-track your German fluency for work or study',
    fr: 'Accélérez votre maîtrise de l\'allemand pour le travail ou les études',
    ar: 'مسار سريع لإتقان الألمانية للعمل أو الدراسة',
  ),
  Str.onboardingGoal60MinTitle: (
    de: '1 Std. / Tag · Intensiv',
    en: '1 Hour / day · Intensive',
    fr: '1 heure / jour · Intensif',
    ar: 'ساعة واحدة / يوم · مكثف',
  ),
  Str.onboardingGoal60MinDesc: (
    de: 'Umfassendes Lernen: Grammatik, Sprechen & Tests',
    en: 'Comprehensive study covering grammar, speaking & tests',
    fr: 'Étude complète : grammaire, expression orale et tests',
    ar: 'دراسة شاملة تشمل القواعد والمحادثة والاختبارات',
  ),
  Str.onboardingGoal120MinTitle: (
    de: '2 Std. / Tag · Super Intensiv',
    en: '2 Hours / day · Super Intensive',
    fr: '2 heures / jour · Super intensif',
    ar: 'ساعتان / يوم · فائق الكثافة',
  ),
  Str.onboardingGoal120MinDesc: (
    de: 'Schnellster Weg zum Bestehen von Goethe- / telc-Prüfungen',
    en: 'Fastest route to passing Goethe / telc exams',
    fr: 'La voie la plus rapide pour réussir les examens Goethe / telc',
    ar: 'أسرع طريق لاجتياز اختبارات Goethe / telc',
  ),

  // ── Lesson Player – remaining keys ────────────────────────────────
  Str.noExercisesFound: (
    de: 'Keine Übungen für diese Lektion gefunden.',
    en: 'No exercises found for this lesson.',
    fr: 'Aucun exercice trouvé pour cette leçon.',
    ar: 'لا توجد تمارين متاحة حالياً.',
  ),
  Str.tapToListen: (
    de: 'Tippe zum Anhören',
    en: 'Tap to listen',
    fr: 'Appuyez pour écouter',
    ar: 'اضغط للاستماع',
  ),
  Str.typeWordHint: (
    de: 'Wort hier eingeben…',
    en: 'Type word here...',
    fr: 'Tapez le mot ici…',
    ar: 'اكتب الكلمة هنا...',
  ),
  Str.toggleTranslations: (
    de: 'Übersetzungen ein-/ausblenden',
    en: 'Toggle Translations',
    fr: 'Afficher / masquer les traductions',
    ar: 'إظهار / إخفاء الترجمة',
  ),
  Str.readFullText: (
    de: 'Volltext vorlesen',
    en: 'Read Full Text',
    fr: 'Lire le texte complet',
    ar: 'قراءة النص كاملاً',
  ),
  Str.textLessonSubtitle: (
    de: 'Höre jeden Satz und lies die Übersetzung',
    en: 'Read & listen sentence by sentence',
    fr: 'Lire et écouter phrase par phrase',
    ar: 'استمع إلى كل جملة، واقرأ الترجمة والشروحات',
  ),
  Str.vocabGrammarNotes: (
    de: 'Vokabeln & Grammatikhinweise',
    en: 'Vocabulary & Grammar Notes',
    fr: 'Vocabulaire et notes de grammaire',
    ar: 'المفردات وقواعد النص',
  ),
  Str.comprehensionCheck: (
    de: 'Verständnisfragen',
    en: 'Comprehension Check',
    fr: 'Questions de compréhension',
    ar: 'أسئلة فهم النص',
  ),
  Str.autoReadStory: (
    de: 'Geschichte vorlesen',
    en: 'Auto Read Story',
    fr: 'Lecture automatique',
    ar: 'استماع وتتبع القصة',
  ),
  Str.storyComprehension: (
    de: 'Geschichte-Verständnis',
    en: 'Story Comprehension',
    fr: 'Compréhension de l\'histoire',
    ar: 'أسئلة فهم القصة',
  ),
  Str.yourScore: (
    de: 'Dein Ergebnis',
    en: 'Your Score',
    fr: 'Votre score',
    ar: 'نتيجتك',
  ),

  // ── Study Screen – remaining ──────────────────────────────────────
  Str.unitsCount: (
    de: '%s Einheiten',
    en: '%s Units',
    fr: '%s Unités',
    ar: '%s وحدات',
  ),

  // ── Listening Sessions ────────────────────────────────────────────
  Str.listeningSessions: (
    de: 'Hörsitzungen',
    en: 'Listening Sessions',
    fr: 'Sessions d\'écoute',
    ar: 'جلسات الاستماع',
  ),
  Str.listeningSubtitle: (
    de: 'Hintergrund-Audio zum Eintauchen',
    en: 'Background audio immersion practice',
    fr: 'Pratique d\'immersion audio en arrière-plan',
    ar: 'استماع متواصل في الخلفية لتقوية الأذن',
  ),
  Str.minutesShort: (
    de: '%s Min.',
    en: '%s Min',
    fr: '%s min',
    ar: '%s دقيقة',
  ),
  Str.comprehensionQuiz: (
    de: 'Verständnis-Quiz',
    en: 'Comprehension Quiz',
    fr: 'Quiz de compréhension',
    ar: 'اختبر فهمك',
  ),
  Str.quickComprehensionCheck: (
    de: 'Schnelle Verständnisfrage',
    en: 'Quick Comprehension Check',
    fr: 'Vérification rapide de la compréhension',
    ar: 'سؤال فهم سريع',
  ),
  Str.correctAnswer: (
    de: 'Richtige Antwort! 🎉',
    en: 'Correct answer! 🎉',
    fr: 'Bonne réponse ! 🎉',
    ar: 'إجابة صحيحة ممتاز! 🎉',
  ),
  Str.incorrectTryAgain: (
    de: 'Falsch, versuche es nochmal!',
    en: 'Incorrect, try again!',
    fr: 'Incorrect, réessayez !',
    ar: 'إجابة غير صحيحة، حاول مجدداً!',
  ),

  // ── Settings & Profile ────────────────────────────────────────────
  Str.settingsTitle: (
    de: 'Einstellungen',
    en: 'Settings',
    fr: 'Paramètres',
    ar: 'الإعدادات',
  ),
  Str.settingsLoadError: (
    de: 'Einstellungen konnten nicht geladen werden',
    en: 'Settings could not be loaded',
    fr: 'Les paramètres n\'ont pas pu être chargés',
    ar: 'تعذر تحميل الإعدادات',
  ),
  Str.retryButton: (
    de: 'Wiederholen',
    en: 'Retry',
    fr: 'Réessayer',
    ar: 'إعادة المحاولة',
  ),
  Str.learnerFallback: (
    de: 'Lernende(r)',
    en: 'Learner',
    fr: 'Apprenant(e)',
    ar: 'متعلّم',
  ),
  Str.profileStatsPlaceholder: (
    de: 'Tagessträhne, CEFR-Level und Testergebnisse werden hier erstellt.',
    en: 'Daily streak counters, CEFR level progression, and test scores will be built here.',
    fr: 'Compteurs de série, progression CEFR et scores de tests seront ajoutés ici.',
    ar: 'سيتم إنشاء عدادات الخطوط اليومية وتقدم مستويات CEFR ونتائج الاختبارات هنا.',
  ),
};

/// One string lookup. Returns the entry for the active locale, or
/// the German copy if the key is missing.
String t(
  BuildContext context,
  String key, {
  List<String> args = const <String>[],
  Map<String, String>? namedArgs,
}) {
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
  // Positional %s / %d replacement
  for (var i = 0; i < args.length; i++) {
    raw = raw.replaceFirst(RegExp(r'%[sd]'), args[i]);
  }
  // Named {key} replacement for enterprise-grade flexibility
  if (namedArgs != null && namedArgs.isNotEmpty) {
    namedArgs.forEach((k, v) {
      raw = raw.replaceAll('{$k}', v);
    });
  }
  return raw;
}
