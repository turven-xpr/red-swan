import 'package:flutter/widgets.dart';

import '../config/app_locale.dart';
import 'strings.dart';

/// Lookup table for every shipped string, indexed by [AppLocale] and
/// by [Str.*] key.  Adding a new locale requires only adding a column
/// here — no Flutter codegen step.
typedef _Group = ({String de, String en, String es, String ar});

const Map<String, _Group> _table = {
    Str.appName: (de: 'Deutschy', en: 'Deutschy', es: 'Deutschy', ar: 'دويتش'),
  Str.splashTagline: (
    de: 'Deutschy wird vorbereitet …',
    en: 'Deutschy is starting up …',
    es: 'Iniciando Deutschy…',
    ar: 'يتم تجهيز Deutschy …',
  ),
  Str.dashboardToday: (
    de: 'Heute',
    en: 'Today',
    es: 'Hoy',
    ar: 'اليوم',
  ),
  Str.dashboardDueToday: (
    de: 'Heute fällig',
    en: 'Due today',
    es: 'Pendiente hoy',
    ar: 'مستحق اليوم',
  ),
  Str.dashboardOverdueShort: (
    de: 'Karten überfällig',
    en: 'cards overdue',
    es: 'tarjetas atrasadas',
    ar: 'بطاقات متأخرة',
  ),
  Str.dashboardEmptyState: (
    de: 'Du bist heute fertig — gut gemacht!',
    en: 'You\'re done for today — well done!',
    es: '¡Has terminado por hoy, bien hecho!',
    ar: 'انتهيت لليوم — أحسنت!',
  ),
  Str.navHome: (
    de: 'Start',
    en: 'Home',
    es: 'Inicio',
    ar: 'الرئيسية',
  ),
  Str.navVocab: (
    de: 'Wörter',
    en: 'Vocab',
    es: 'Vocabulario',
    ar: 'مفردات',
  ),
  Str.navSpeaking: (
    de: 'Sprechen',
    en: 'Speaking',
    es: 'Hablar',
    ar: 'محادثة',
  ),
  Str.navWriting: (
    de: 'Schreiben',
    en: 'Writing',
    es: 'Escribir',
    ar: 'كتابة',
  ),
  Str.navGames: (
    de: 'Spiele',
    en: 'Games',
    es: 'Juegos',
    ar: 'ألعاب',
  ),
  Str.navGrammar: (
    de: 'Grammatik',
    en: 'Grammar',
    es: 'Gramática',
    ar: 'القواعد',
  ),
  Str.navReading: (
    de: 'Lesen',
    en: 'Reading',
    es: 'Lectura',
    ar: 'قراءة',
  ),
  Str.navProfile: (
    de: 'Profil',
    en: 'Profile',
    es: 'Perfil',
    ar: 'الملف',
  ),
  Str.loginTagline: (
    de: 'Deutsch lernen — einfach und schnell.',
    en: 'Learn German — easy and fast.',
    es: 'Aprende alemán de la forma más fácil',
    ar: 'تعلم الألمانية — بسهولة وسرعة.',
  ),
  Str.loginWithGoogle: (
    de: 'Mit Google anmelden',
    en: 'Continue with Google',
    es: 'Continuar con Google',
    ar: 'متابعة عبر Google',
  ),
  Str.loginWithApple: (
    de: 'Mit Apple anmelden',
    en: 'Continue with Apple',
    es: 'Continuar con Apple',
    ar: 'متابعة عبر Apple',
  ),
  Str.loginOpening: (
    de: 'Wird geöffnet …',
    en: 'Opening …',
    es: 'Iniciando sesión…',
    ar: 'جاري الفتح …',
  ),
  Str.loginAccept: (
    de: 'Mit dem Anmelden akzeptierst du unsere Bedingungen und die AdMob-Datenschutzhinweise.',
    en: 'By continuing you agree to our Terms and the AdMob Privacy Notice.',
    es: 'Al continuar, aceptas nuestros Términos y Política de Privacidad.',
    ar: 'بالمتابعة، فأنت توافق على شروطنا وإشعار خصوصية AdMob.',
  ),
  Str.writingPromptHint: (
    de: 'Schreibe einen deutschen Absatz …',
    en: 'Write a German paragraph …',
    es: 'Escribe tu respuesta en alemán aquí…',
    ar: 'اكتب فقرة بالألمانية …',
  ),
  Str.writingHelperChars: (
    de: 'Mindestens 12, höchstens 1200 Zeichen.',
    en: 'Between 12 and 1200 characters.',
    es: 'Caracteres especiales:',
    ar: 'بين ١٢ و ١٢٠٠ حرفًا.',
  ),
  Str.writingGrade: (
    de: 'Korrigieren',
    en: 'Get feedback',
    es: 'Calificación',
    ar: 'صحّح لي',
  ),
  Str.writingChecking: (
    de: 'Prüfe …',
    en: 'Checking …',
    es: 'La IA está revisando tu texto…',
    ar: 'جاري التحقق …',
  ),
  Str.errorNetwork: (
    de: 'Coach nicht erreichbar — bitte Internet prüfen.',
    en: 'Coach offline — please check your connection.',
    es: 'Error de red. Comprueba tu conexión.',
    ar: 'المعلم غير متصل — تحقّق من الإنترنت.',
  ),
  Str.errorMalformed: (
    de: 'Antwort nicht lesbar — bitte erneut versuchen.',
    en: 'Response was unreadable — please retry.',
    es: 'Respuesta inesperada del servidor.',
    ar: 'الرد غير قابل للقراءة — حاول مجددًا.',
  ),
  Str.errorGeneric: (
    de: 'Etwas ist schiefgelaufen — bitte erneut versuchen.',
    en: 'Something went wrong — please retry.',
    es: 'Algo salió mal. Por favor, inténtalo de nuevo.',
    ar: 'حدث خطأ — حاول مجددًا.',
  ),
  Str.errorRetry: (
    de: 'Erneut versuchen',
    en: 'Retry',
    es: 'Reintentar',
    ar: 'إعادة المحاولة',
  ),
  Str.vocabHeaderTitle: (
    de: 'Wortschatz',
    en: 'Vocabulary',
    es: 'Repaso diario',
    ar: 'المفردات',
  ),
  Str.vocabDue: (
    de: '%d fällig',
    en: '%d due',
    es: 'Pendientes de repaso',
    ar: '%d مستحق',
  ),
  Str.vocabEmptyStart: (
    de: 'Level %s startet bald',
    en: 'Level %s is coming soon',
    es: '¡No hay tarjetas pendientes ahora!',
    ar: 'مستوى %s قادم قريبًا',
  ),
  Str.vocabLockedSoon: (
    de: 'Bald verfügbar',
    en: 'Coming soon',
    es: 'Más palabras próximamente.',
    ar: 'قريبًا',
  ),
  Str.reviewActionForgot: (
    de: 'Vergessen',
    en: 'Forgot',
    es: 'Olvidé',
    ar: 'نسيت',
  ),
  Str.reviewActionHard: (
    de: 'Schwer',
    en: 'Hard',
    es: 'Difícil',
    ar: 'صعب',
  ),
  Str.reviewActionGood: (
    de: 'Gut',
    en: 'Good',
    es: 'Bien',
    ar: 'جيد',
  ),
  Str.reviewActionEasy: (
    de: 'Einfach',
    en: 'Easy',
    es: 'Fácil',
    ar: 'سهل',
  ),
  Str.reviewActionSkip: (
    de: 'Überspringen',
    en: 'Skip',
    es: 'Saltar',
    ar: 'تخطّي',
  ),
  Str.reviewShowAnswer: (
    de: 'Tippe um die Antwort zu sehen',
    en: 'Tap to reveal the answer',
    es: 'Mostrar respuesta',
    ar: 'اضغط لرؤية الإجابة',
  ),
  Str.reviewListen: (
    de: 'Anhören',
    en: 'Listen',
    es: 'Escuchar',
    ar: 'استمع',
  ),
  Str.reviewClose: (
    de: 'Schließen',
    en: 'Close',
    es: 'Cerrar',
    ar: 'إغلاق',
  ),
  Str.finishCongrats: (
    de: 'Starke Arbeit!',
    en: 'Great job!',
    es: '¡Felicidades! Has completado la sesión.',
    ar: 'أحسنت!',
  ),
  Str.streakDays: (
    de: '%d Tage in Folge',
    en: '%d day streak',
    es: '%s días de racha',
    ar: '%d يوم متتالي',
  ),
  Str.streakNone: (
    de: 'Heute anfangen',
    en: 'Start your streak today',
    es: 'Sin racha aún',
    ar: 'ابدأ سلسلتك اليوم',
  ),
  Str.settingsTheme: (
    de: 'Erscheinungsbild',
    en: 'Appearance',
    es: 'Apariencia',
    ar: 'المظهر',
  ),
  Str.settingsThemeSystem: (
    de: 'Systemvorgabe',
    en: 'System default',
    es: 'Sistema',
    ar: 'إعداد النظام',
  ),
  Str.settingsThemeLight: (
    de: 'Hell',
    en: 'Light',
    es: 'Claro',
    ar: 'فاتح',
  ),
  Str.settingsThemeDark: (
    de: 'Dunkel',
    en: 'Dark',
    es: 'Oscuro',
    ar: 'داكن',
  ),
  Str.settingsLanguage: (
    de: 'Sprache',
    en: 'Language',
    es: 'Idioma',
    ar: 'اللغة',
  ),
  Str.settingsNotifications: (
    de: 'Benachrichtigungen',
    en: 'Notifications',
    es: 'Notificaciones',
    ar: 'الإشعارات',
  ),
  Str.settingsStreak: (
    de: 'Erinnerung an tägliche Übung',
    en: 'Daily reminder',
    es: 'Recordatorios de racha',
    ar: 'تذكير يومي',
  ),
  Str.settingsReminderTime: (
    de: 'Wann möchtest du erinnert werden?',
    en: 'When should we remind you?',
    es: 'Hora del recordatorio',
    ar: 'متى تريد التذكير؟',
  ),
  Str.settingsProfilePhoto: (
    de: 'Profilbild',
    en: 'Profile photo',
    es: 'Foto de perfil',
    ar: 'صورة الملف',
  ),
  Str.settingsChangePhoto: (
    de: 'Foto ändern',
    en: 'Change photo',
    es: 'Cambiar foto',
    ar: 'تغيير الصورة',
  ),
  Str.settingsAccount: (
    de: 'Konto',
    en: 'Account',
    es: 'Cuenta',
    ar: 'الحساب',
  ),
  Str.settingsSignOut: (
    de: 'Abmelden',
    en: 'Sign out',
    es: 'Cerrar sesión',
    ar: 'تسجيل الخروج',
  ),
  Str.settingsAbout: (
    de: 'Über Deutschy',
    en: 'About Deutschy',
    es: 'Acerca de Deutschy',
    ar: 'حول Deutschy',
  ),
  Str.settingsAboutBody: (
    de:
        'Deutschy hilft dir, Deutsch mit Spaced Repetition und KI-Coaching zu lernen — kostenlos, offline, ohne Werbe-Tracking.',
    en:
        'Deutschy helps you learn German with spaced repetition and AI coaching — free, offline, no ad tracking.',
    es: 'Deutschy es tu compañero inteligente para aprender alemán.',
    ar:
        'Deutschy يساعدك على تعلم الألمانية مع تكرار متباعد ومعلم ذكاء اصطناعي — مجانًا ودون اتصال وبدون تتبع إعلاني.',
  ),
  Str.settingsVersion: (
    de: 'Version',
    en: 'Version',
    es: 'Versión',
    ar: 'الإصدار',
  ),
  Str.settingsPlannedOnboardingTitle: (
    de: 'Personalisierte Begrüßung kommt',
    en: 'Personalised welcome coming soon',
    es: 'Guía de inicio',
    ar: 'الترحيب المخصص قادم قريبًا',
  ),
  Str.settingsPlannedOnboardingBody: (
    de:
        'Demnächst wirst du dein Startlevel (A0, A1, A2, B1) wählen und einen Lernplan erhalten.',
    en:
        'Soon you’ll pick your starting level (A0, A1, A2, B1) and get a study plan.',
    es: 'Ajusta tu configuración de aprendizaje en cualquier momento.',
    ar:
        'قريبًا ستختار مستوى البداية (A0, A1, A2, B1) وتحصل على خطة تعلّم.',
  ),
  Str.photoGallery: (
    de: 'Galerie',
    en: 'Gallery',
    es: 'Elegir de la galería',
    ar: 'المعرض',
  ),
  Str.photoCamera: (
    de: 'Kamera',
    en: 'Camera',
    es: 'Tomar una foto',
    ar: 'الكاميرا',
  ),
  Str.photoRemove: (
    de: 'Foto entfernen',
    en: 'Remove photo',
    es: 'Eliminar foto',
    ar: 'إزالة الصورة',
  ),
  Str.pickReminderTime: (
    de: 'Uhrzeit wählen',
    en: 'Pick a time',
    es: 'Seleccionar hora',
    ar: 'اختر الوقت',
  ),
  Str.grammarTitle: (
    de: 'Grammatik',
    en: 'Grammar',
    es: 'Gramática alemana',
    ar: 'القواعد',
  ),
  Str.onboardingTitle: (
    de: 'Willkommen bei Deutschy!',
    en: 'Welcome to Deutschy!',
    es: 'Bienvenido a Deutschy',
    ar: 'مرحبًا بك في Deutschy!',
  ),
  Str.onboardingBody: (
    de:
        'Wähle dein Startlevel (Intro, A1, A2, B1, B2). Wir passen deinen Lernplan an — kostenlos und offline-fähig.',
    en:
        'Pick your starting level (Intro, A1, A2, B1, B2). We will tailor a study plan to it — free, ready offline.',
    es: 'Domina el alemán paso a paso con práctica diaria.',
    ar:
        'اختر مستوى البداية (المقدمة، A1, A2, B1, B2). سنخصص خطة تعلمك — مجانًا وجاهزة بدون اتصال.',
  ),
  Str.onboardingPickLevel: (
    de: 'Startlevel',
    en: 'Starting Level',
    es: 'Elige tu nivel de inicio',
    ar: 'مستوى البداية',
  ),
  Str.onboardingCta: (
    de: 'Los geht\'s',
    en: 'Let\'s go',
    es: 'Comenzar',
    ar: '!هيّا بنا',
  ),
  Str.settingsReviewNotifEnabled: (
    de: 'Erinnerungen sind eingeschaltet',
    en: 'Reminders are enabled',
    es: 'Recordatorios diarios activados',
    ar: 'التذكيرات مُفعّلة',
  ),
  Str.reverseAnim: (
    de: 'Animationen reduzieren',
    en: 'Reduce animations',
    es: 'Invertir animación',
    ar: 'تقليل الحركات',
  ),
  Str.gamesHomeMemoryMatch: (
    de: 'Memory — karten-paare finden',
    en: 'Memory · Match the pairs',
    es: 'Juego de memoria',
    ar: 'لعبة الذاكرة · طابق الأزواج',
  ),
  Str.gamesHomeWordChain: (
    de: 'Wortkette — schnell entscheiden',
    en: 'Word Chain · Race the clock',
    es: 'Cadena de palabras',
    ar: 'سلسلة الكلمات · سباق ضد الساعة',
  ),
  Str.gamesComplete: (
    de: 'Geschafft!',
    en: 'Round complete',
    es: '¡Juego completado!',
    ar: '!أحسنت',
  ),
  Str.readingTitle: (
    de: 'Lesen',
    en: 'Reading',
    es: 'Lecturas e historias',
    ar: 'قراءة',
  ),
  Str.loginGuest: (
    de: 'Ohne Konto fortfahren',
    en: 'Continue without an account',
    es: 'Continuar como invitado',
    ar: 'المتابعة بدون حساب',
  ),
  Str.navMore: (
    de: 'Mehr',
    en: 'More',
    es: 'Más',
    ar: 'المزيد',
  ),

  // Shell & Navigation
  Str.learningPath: (
    de: 'Lernpfad:',
    en: 'Learning Path:',
    es: 'Ruta de aprendizaje:',
    ar: 'مسار التعلم:',
  ),
  Str.streakActiveTooltip: (
    de: 'Tägliche Serie: Übe jeden Tag, um deine Serie auszubauen!',
    en: 'Daily Streak: Practice every day to build your streak!',
    es: '¡Racha activa! Practica hoy para mantenerla.',
    ar: 'الحماسة اليومية: تدرب يوميًا لزيادة أيام حماستك المستمرة!',
  ),
  Str.streakExtendedToast: (
    de: '🔥 Serie aktiv! Lerne täglich weiter.',
    en: '🔥 Streak active! Keep learning daily to extend it.',
    es: '¡Racha extendida! ¡Sigue así!',
    ar: '🔥 الحماسة نشطة! استمر في التعلم يوميًا لزيادتها.',
  ),
  Str.xpPoints: (
    de: '%s XP',
    en: '%s XP',
    es: '%s XP',
    ar: '%s نقطة',
  ),

  // Study Screen & Checkpoints
  Str.unitLabel: (
    de: 'Einheit %s',
    en: 'Unit %s',
    es: 'Unidad %s',
    ar: 'الوحدة %s',
  ),
  Str.readyToStudy: (
    de: 'Bereit zum Lernen',
    en: 'Ready to learn',
    es: 'Listo para estudiar',
    ar: 'جاهز للدراسة',
  ),
  Str.lessonsComingSoon: (
    de: 'Lektionen für diese Einheit werden bald freigeschaltet',
    en: 'Lessons for this unit will be unlocked soon',
    es: 'Lecciones próximamente',
    ar: 'دروس هذه الوحدة قيد الإعداد والإضافة قريبًا',
  ),
  Str.checkpointIntro: (
    de: 'Grundlagen-Checkpoint (Intro)',
    en: 'Intro Foundations Checkpoint',
    es: 'Punto de control inicial',
    ar: 'نقطة تثبيت الأساسيات (Intro)',
  ),
  Str.checkpointGate: (
    de: '%s Niveau-Abschlusstest',
    en: '%s Gate Test Checkpoint',
    es: 'Examen de nivel %s',
    ar: 'اختبار اجتياز المستوى %s',
  ),
  Str.checkpointIntroSub: (
    de: 'Erreiche 75%, um die Grundlagen zu meistern und A1 freizuschalten',
    en: 'Score 75% to master the basics & unlock Level A1',
    es: 'Obtén 75% para dominar lo básico y desbloquear A1',
    ar: 'احصل على 75% لتثبيت الأساسيات وفتح المستوى A1',
  ),
  Str.checkpointGateSub: (
    de: 'Erreiche 75%, um das nächste Niveau freizuschalten',
    en: 'Score 75% to pass & unlock the next level',
    es: 'Aprueba el examen para desbloquear el siguiente nivel',
    ar: 'احصل على 75% لاجتياز الاختبار وفتح المستوى التالي',
  ),
  Str.skillListen: (
    de: '%s Hören',
    en: '%s Listen',
    es: '%s Escucha',
    ar: '%s استماع',
  ),
  Str.skillRead: (
    de: '%s Lesen',
    en: '%s Read',
    es: '%s Lectura',
    ar: '%s قراءة',
  ),
  Str.skillWrite: (
    de: '%s Schreiben',
    en: '%s Write',
    es: '%s Escritura',
    ar: '%s كتابة',
  ),
  Str.skillSpeak: (
    de: '%s Sprechen',
    en: '%s Speak',
    es: '%s Habla',
    ar: '%s محادثة',
  ),
  Str.startIntroCheckpoint: (
    de: 'Intro-Checkpoint starten',
    en: 'Start Intro Checkpoint',
    es: 'Iniciar punto de control',
    ar: 'ابدأ اختبار الأساسيات',
  ),
  Str.startGateTest: (
    de: 'Abschlusstest %s starten',
    en: 'Start %s Gate Test',
    es: 'Iniciar examen de nivel %s',
    ar: 'ابدأ اختبار المستوى %s',
  ),

  // Lesson Player
  Str.chooseCorrectAnswer: (
    de: 'Wähle die richtige Antwort',
    en: 'Choose the correct answer',
    es: 'Elige la respuesta correcta',
    ar: 'اختر الإجابة الصحيحة',
  ),
  Str.pronouncedCorrectly: (
    de: 'Richtig ausgesprochen',
    en: 'I pronounced it correctly',
    es: 'Lo pronuncié correctamente',
    ar: 'نطقتها بصوت صحيح',
  ),
  Str.checkAnswer: (
    de: 'Antwort prüfen',
    en: 'Check Answer',
    es: 'Comprobar',
    ar: 'تحقق من الإجابة',
  ),
  Str.correctFeedback: (
    de: 'Richtig! Sehr gut 👏',
    en: 'Correct! Great job 👏',
    es: '¡Correcto!',
    ar: 'إجابة صحيحة! أحسنت 👏',
  ),
  Str.incorrectFeedback: (
    de: 'Nicht ganz richtig',
    en: 'Incorrect',
    es: 'Incorrecto',
    ar: 'إجابة غير صحيحة، حاول مجددًا',
  ),
  Str.correctAnswerLabel: (
    de: 'Richtige Antwort:',
    en: 'Correct answer:',
    es: 'Respuesta correcta:',
    ar: 'الإجابة الصحيحة:',
  ),
  Str.translationLabel: (
    de: 'Übersetzung:',
    en: 'Translation:',
    es: 'Traducción:',
    ar: 'الترجمة:',
  ),
  Str.continueButton: (
    de: 'Weiter',
    en: 'Continue',
    es: 'Continuar',
    ar: 'المتابعة',
  ),
  Str.finishReading: (
    de: 'Lesen abgeschlossen',
    en: 'Finished Reading',
    es: 'Terminar lectura',
    ar: 'أنهيت قراءة الدرس',
  ),
  Str.completeTextLesson: (
    de: 'Textlektion abschließen',
    en: 'Complete Reading Lesson',
    es: 'Completar lección de texto',
    ar: 'إتمام درس النص',
  ),
  Str.completeStoryLesson: (
    de: 'Geschichte abschließen',
    en: 'Complete Story Lesson',
    es: 'Completar historia',
    ar: 'إتمام درس القصة',
  ),
  Str.lessonCompletedTitle: (
    de: 'Fantastisch! Lektion abgeschlossen',
    en: 'Awesome! Lesson Completed',
    es: '¡Lección completada!',
    ar: 'أحسنت! أتممت الدرس بنجاح',
  ),
  Str.lessonCompletedSub: (
    de: 'Du hast wichtige Fortschritte gemacht!',
    en: 'You\'ve made great progress today!',
    es: '¡Buen esfuerzo! Revisa los errores y sigue practicando.',
    ar: 'لقد حققت تقدمًا ممتازًا وملموسًا في تعلم الألمانية!',
  ),
  Str.nextStepBadge: (
    de: 'Weiter',
    en: 'Next',
    es: 'Siguiente',
    ar: 'التالي',
  ),
  Str.completedBadge: (
    de: 'Abgeschlossen',
    en: 'Completed',
    es: 'Completado',
    ar: 'مكتمل',
  ),
  Str.startButton: (
    de: 'Start',
    en: 'Start',
    es: 'Empezar',
    ar: 'ابدأ',
  ),

  // Placeholder Screens
  Str.testsTitle: (
    de: 'Prüfungen & Zertifikate',
    en: 'Tests & Exams',
    es: 'Exámenes de nivel y certificados',
    ar: 'الاختبارات والشهادات الرسمية',
  ),
  Str.testsDesc: (
    de: 'Offizielle Goethe-Zertifikat-, telc- und Modellprüfungen werden hier verfügbar sein.',
    en: 'Official Goethe-Institut, telc, and level certification practice exams will be built here.',
    es: 'Las pruebas de preparación para Goethe y telc se crearán aquí.',
    ar: 'نماذج وتدريبات امتحانات معهد جوته، telc، واختبارات قياس الكفاءة الرسمية ستكون هنا قريبًا.',
  ),
  Str.aiTutorTitle: (
    de: 'KI-Deutschlehrer',
    en: 'AI German Teacher',
    es: 'Profesor de alemán con IA',
    ar: 'المعلم الذكي للألمانية (AI)',
  ),
  Str.aiTutorDesc: (
    de: 'Personalisierte KI-Chat-Gespräche mit Live-Grammatikkorrektur und Sprachpraxis werden hier bereitgestellt.',
    en: 'Personalized AI chat conversations with live grammar corrections and speech practice will be built here.',
    es: 'Conversaciones con IA personalizadas con correcciones de gramática en vivo.',
    ar: 'محادثات تفاعلية ذكية مع تصحيح فوري للقواعد وتدريب النطق بالذكاء الاصطناعي قريبًا.',
  ),
  Str.profileStatsTitle: (
    de: 'Lernstatistiken & Erfolge',
    en: 'Learning Stats & Achievements',
    es: 'Estadísticas y logros de aprendizaje',
    ar: 'إحصائيات التعلم والإنجازات',
  ),
  Str.profileStatsDesc: (
    de: 'Tages-Serien, GER-Niveaufortschritt und Testergebnisse werden hier angezeigt.',
    en: 'Daily streak counters, CEFR level progression, and test scores will be built here.',
    es: 'Contadores de racha diaria, progresión de nivel MCER y puntuaciones.',
    ar: 'عدادات الحماسة اليومية، التقدم بمستويات الإطار الأوروبي، ونتائج الاختبارات ستظهر هنا.',
  ),
  Str.profileSettingsBtn: (
    de: 'App-Einstellungen & Sprache',
    en: 'App Settings & Language',
    es: 'Ajustes del sistema e idioma',
    ar: 'إعدادات التطبيق واللغة',
  ),
  Str.settingsAudioSpeed: (
    de: 'Audio-Geschwindigkeit',
    en: 'Audio Speed',
    es: 'Velocidad del audio',
    ar: 'سرعة نطق الصوت',
  ),

  // Onboarding
  Str.onboardingStep1Title: (
    de: 'Welche Sprache sprichst du?',
    en: 'What language do you speak?',
    es: 'Elige tu idioma',
    ar: 'ما هي لغتك الأم؟',
  ),
  Str.onboardingStep1Sub: (
    de: 'Wähle die Sprache, mit der du Deutsch lernen möchtest.',
    en: 'Choose the language you will use to learn German.',
    es: 'Selecciona el idioma en el que deseas aprender alemán',
    ar: 'اختر اللغة التي تفضل استخدامها لشرح وتعلم الألمانية.',
  ),
  Str.onboardingStep2Title: (
    de: 'Warum lernst du Deutsch?',
    en: 'Why are you learning German?',
    es: '¿Por qué aprendes alemán?',
    ar: 'ما هو هدفك الأساسي من تعلم الألمانية؟',
  ),
  Str.onboardingStep2Sub: (
    de: 'Wir passen deine Lektionen an dein persönliches Ziel an.',
    en: 'We customize your lessons to match your goal.',
    es: 'Personalizaremos tu vocabulario según tu objetivo',
    ar: 'سنخصص لك خطة الدروس والمفردات لتناسب هدفك بدقة.',
  ),
  Str.onboardingStep3Title: (
    de: 'Wie gut ist dein Deutsch?',
    en: 'How much German do you know?',
    es: '¿Cuál es tu nivel actual?',
    ar: 'ما هو مستواك الحالي في اللغة الألمانية؟',
  ),
  Str.onboardingStep3Sub: (
    de: 'Keine Sorge, wir starten genau dort, wo du dich wohlfühlst.',
    en: 'Don\'t worry, we start exactly where you feel comfortable.',
    es: 'Te colocaremos en el punto de inicio adecuado',
    ar: 'لا تقلق، سنبدأ معك بدقة من المستوى المناسب لمعرفتك.',
  ),
  Str.onboardingStep4Title: (
    de: 'Was ist dein tägliches Ziel?',
    en: 'What is your daily goal?',
    es: 'Elige tu meta diaria',
    ar: 'ما هو هدف دراستك اليومي؟',
  ),
  Str.onboardingStep4Sub: (
    de: 'Schon wenige Minuten pro Tag reichen für große Fortschritte!',
    en: 'Even a few minutes a day make a huge difference!',
    es: 'Establece un hábito diario realista que puedas mantener',
    ar: 'بضع دقائق يوميًا كافية لصنع فارق حقيقي ومستمر!',
  ),
  Str.onboardingReasonStudy: (
    de: 'Studium an der Universität',
    en: 'University & Academic Study',
    es: 'Estudios universitarios',
    ar: 'الدراسة والجامعة في ألمانيا',
  ),
  Str.onboardingReasonStudyDesc: (
    de: 'Vorbereitung auf DSH/TestDaF und akademischen Erfolg',
    en: 'Prepare for DSH/TestDaF and university success',
    es: 'Preparación para estudiar en universidades de Alemania',
    ar: 'التحضير لشهادات DSH/TestDaF والالتحاق بالجامعات',
  ),
  Str.onboardingReasonAusbildung: (
    de: 'Duale Ausbildung',
    en: 'Apprenticeship (Ausbildung)',
    es: 'Formación profesional (Ausbildung)',
    ar: 'التدريب المهني (Ausbildung)',
  ),
  Str.onboardingReasonAusbildungDesc: (
    de: 'Praktischer Berufsalltag und Fachsprache',
    en: 'Vocational training and workplace language',
    es: 'Aprende vocabulario práctico para trabajar y formarte en Alemania',
    ar: 'الاستعداد للتدريب المهني ولغة العمل الحرفية والمهنية',
  ),
  Str.onboardingReasonJob: (
    de: 'Karriere & Arbeit',
    en: 'Work & Career in Germany',
    es: 'Trabajo y carrera',
    ar: 'العمل والوظيفة في ألمانيا',
  ),
  Str.onboardingReasonJobDesc: (
    de: 'Chancen auf dem deutschen Arbeitsmarkt nutzen',
    en: 'Professional opportunities and career growth',
    es: 'Mejores oportunidades laborales y comunicación con colegas',
    ar: 'الحصول على وظيفة وتطوير المسار المهني مع الشركات الألمانية',
  ),
  Str.onboardingReasonTravel: (
    de: 'Reisen & Kultur',
    en: 'Travel, Tourism & Culture',
    es: 'Viajes y cultura',
    ar: 'السفر، السياحة، واستكشاف الثقافة',
  ),
  Str.onboardingReasonTravelDesc: (
    de: 'Souverän im Alltag und Urlaub verständigen',
    en: 'Communicate smoothly while traveling',
    es: 'Viaja con confianza por Alemania, Austria y Suiza',
    ar: 'التواصل بثقة في الحياة اليومية وأثناء السفر والتنقل',
  ),
  Str.onboardingReasonFun: (
    de: 'Neugier & Gehirnjogging',
    en: 'Personal Interest & Brain Training',
    es: 'Desarrollo personal y afición',
    ar: 'شغف باللغات وتنشيط الذاكرة',
  ),
  Str.onboardingReasonFunDesc: (
    de: 'Eine der wichtigsten Sprachen Europas lernen',
    en: 'Enjoy learning one of Europe\'s key languages',
    es: 'Disfruta aprendiendo un nuevo idioma a tu propio ritmo',
    ar: 'متعة تعلم إحدى أهم لغات أوروبا كمهارة جديدة',
  ),
  Str.onboardingBtnContinue: (
    de: 'Weiter',
    en: 'Continue',
    es: 'Continuar',
    ar: 'متابعة',
  ),
  Str.onboardingBtnBack: (
    de: 'Zurück',
    en: 'Back',
    es: 'Atrás',
    ar: 'رجوع',
  ),
  Str.onboardingBtnStart: (
    de: 'Jetzt starten',
    en: 'Start Learning',
    es: 'Empezar a aprender',
    ar: 'ابدأ التعلم الآن',
  ),
  Str.onboardingLevelIntroTitle: (
    de: 'Intro · Absoluter Anfänger',
    en: 'Intro · Absolute Beginner',
    es: 'Intro · Principiante absoluto',
    ar: 'مقدمة · مبتدئ تماماً',
  ),
  Str.onboardingLevelIntroDesc: (
    de: 'Ich kann kein Deutsch oder nur wenige einfache Wörter',
    en: 'I know zero German or just a few basic words',
    es: 'No sé nada de alemán o solo algunas palabras básicas',
    ar: 'لا أعرف أي ألمانية أو فقط بضع كلمات أساسية',
  ),
  Str.onboardingLevelA1Title: (
    de: 'A1 · Anfänger',
    en: 'A1 · Beginner',
    es: 'A1 · Principiante',
    ar: 'A1 · مبتدئ',
  ),
  Str.onboardingLevelA1Desc: (
    de: 'Ich kann mich vorstellen und einfache Alltagssätze verstehen',
    en: 'I can introduce myself and understand simple daily phrases',
    es: 'Puedo presentarme y entender frases sencillas de uso diario',
    ar: 'أستطيع تقديم نفسي وفهم عبارات يومية بسيطة',
  ),
  Str.onboardingLevelA2Title: (
    de: 'A2 · Grundlegende Kenntnisse',
    en: 'A2 · Elementary',
    es: 'A2 · Elemental',
    ar: 'A2 · أساسي',
  ),
  Str.onboardingLevelA2Desc: (
    de: 'Ich kann mich in einfachen Alltagssituationen verständigen',
    en: 'I can communicate in simple everyday situations & routines',
    es: 'Puedo comunicarme en situaciones cotidianas sencillas y rutinarias',
    ar: 'أستطيع التواصل في المواقف اليومية البسيطة والروتينية',
  ),
  Str.onboardingLevelB1Title: (
    de: 'B1 · Mittelstufe',
    en: 'B1 · Intermediate',
    es: 'B1 · Intermedio',
    ar: 'B1 · متوسط',
  ),
  Str.onboardingLevelB1Desc: (
    de: 'Ich kann meine Meinung äußern und Hauptaussagen verstehen',
    en: 'I can express opinions, understand main ideas & speak steadily',
    es: 'Puedo expresar opiniones, entender ideas principales y hablar con fluidez',
    ar: 'أستطيع التعبير عن الآراء وفهم الأفكار الرئيسية والتحدث بثبات',
  ),
  Str.onboardingLevelB2Title: (
    de: 'B2 · Gute Mittelstufe',
    en: 'B2 · Upper Intermediate',
    es: 'B2 · Intermedio alto',
    ar: 'B2 · فوق المتوسط',
  ),
  Str.onboardingLevelB2Desc: (
    de: 'Ich beherrsche Fachgespräche und komplexe Texte',
    en: 'I can handle technical/work conversations & complex texts',
    es: 'Puedo mantener conversaciones técnicas/laborales y comprender textos complejos',
    ar: 'أستطيع التعامل مع المحادثات التقنية/العمل والنصوص المعقدة',
  ),
  Str.onboardingGoal3MinTitle: (
    de: '3 Min. / Tag · Gelegentlich',
    en: '3 min / day · Casual',
    es: '3 min / día · Casual',
    ar: '3 دقائق / يوم · مريح',
  ),
  Str.onboardingGoal3MinDesc: (
    de: 'Schnelle Mikrogewohnheit für dein Gehirn',
    en: 'Quick micro-habit to keep your brain active',
    es: 'Microhábito rápido para mantener tu cerebro activo',
    ar: 'عادة صغيرة وسريعة لتنشيط العقل',
  ),
  Str.onboardingGoal5MinTitle: (
    de: '5 Min. / Tag · Regelmäßig',
    en: '5 min / day · Regular',
    es: '5 min / día · Regular',
    ar: '5 دقائق / يوم · منتظم',
  ),
  Str.onboardingGoal5MinDesc: (
    de: 'Stetige tägliche Übung für deine Serie',
    en: 'Steady daily practice to build your streak',
    es: 'Práctica diaria constante para mantener tu racha',
    ar: 'تمرين يومي منتظم لبناء حماسك المتواصل',
  ),
  Str.onboardingGoal15MinTitle: (
    de: '15 Min. / Tag · Engagiert (Empfohlen)',
    en: '15 min / day · Committed (Recommended)',
    es: '15 min / día · Comprometido (Recomendado)',
    ar: '15 دقيقة / يوم · ملتزم (موصى به)',
  ),
  Str.onboardingGoal15MinDesc: (
    de: 'Optimales Tempo für Behalten und Wortschatzaufbau',
    en: 'Optimal daily pace for solid retention and vocabulary growth',
    es: 'Ritmo óptimo para retención sólida y aumento de vocabulario',
    ar: 'الوتيرة اليومية المثالية لتثبيت المعلومات وبناء المفردات',
  ),
  Str.onboardingGoal30MinTitle: (
    de: '30 Min. / Tag · Ernsthaft',
    en: '30 min / day · Serious',
    es: '30 min / día · Intensivo',
    ar: '30 دقيقة / يوم · جاد',
  ),
  Str.onboardingGoal30MinDesc: (
    de: 'Schnellere Deutsch-Flüssigkeit für Beruf oder Studium',
    en: 'Fast-track your German fluency for work or study',
    es: 'Acelera tu fluidez en alemán para trabajo o estudios',
    ar: 'مسار سريع لإتقان الألمانية للعمل أو الدراسة',
  ),
  Str.onboardingGoal60MinTitle: (
    de: '1 Std. / Tag · Intensiv',
    en: '1 Hour / day · Intensive',
    es: '1 hora / día · Muy intensivo',
    ar: 'ساعة واحدة / يوم · مكثف',
  ),
  Str.onboardingGoal60MinDesc: (
    de: 'Umfassendes Lernen: Grammatik, Sprechen & Tests',
    en: 'Comprehensive study covering grammar, speaking & tests',
    es: 'Estudio integral con gramática, conversación y exámenes',
    ar: 'دراسة شاملة تشمل القواعد والمحادثة والاختبارات',
  ),
  Str.onboardingGoal120MinTitle: (
    de: '2 Std. / Tag · Super Intensiv',
    en: '2 Hours / day · Super Intensive',
    es: '2 horas / día · Súper intensivo',
    ar: 'ساعتان / يوم · فائق الكثافة',
  ),
  Str.onboardingGoal120MinDesc: (
    de: 'Schnellster Weg zum Bestehen von Goethe- / telc-Prüfungen',
    en: 'Fastest route to passing Goethe / telc exams',
    es: 'La ruta más rápida para aprobar los exámenes Goethe / telc',
    ar: 'أسرع طريق لاجتياز اختبارات Goethe / telc',
  ),

  // ── Lesson Player – remaining keys ────────────────────────────────
  Str.noExercisesFound: (
    de: 'Keine Übungen für diese Lektion gefunden.',
    en: 'No exercises found for this lesson.',
    es: 'No se encontraron ejercicios para esta lección.',
    ar: 'لا توجد تمارين متاحة حالياً.',
  ),
  Str.tapToListen: (
    de: 'Tippe zum Anhören',
    en: 'Tap to listen',
    es: 'Toca para escuchar',
    ar: 'اضغط للاستماع',
  ),
  Str.typeWordHint: (
    de: 'Wort hier eingeben…',
    en: 'Type word here...',
    es: 'Escribe la palabra aquí…',
    ar: 'اكتب الكلمة هنا...',
  ),
  Str.toggleTranslations: (
    de: 'Übersetzungen ein-/ausblenden',
    en: 'Toggle Translations',
    es: 'Mostrar / ocultar traducción',
    ar: 'إظهار / إخفاء الترجمة',
  ),
  Str.readFullText: (
    de: 'Volltext vorlesen',
    en: 'Read Full Text',
    es: 'Leer texto completo',
    ar: 'قراءة النص كاملاً',
  ),
  Str.textLessonSubtitle: (
    de: 'Höre jeden Satz und lies die Übersetzung',
    en: 'Read & listen sentence by sentence',
    es: 'Lee y escucha frase por frase',
    ar: 'استمع إلى كل جملة، واقرأ الترجمة والشروحات',
  ),
  Str.vocabGrammarNotes: (
    de: 'Vokabeln & Grammatikhinweise',
    en: 'Vocabulary & Grammar Notes',
    es: 'Notas de vocabulario y gramática',
    ar: 'المفردات وقواعد النص',
  ),
  Str.comprehensionCheck: (
    de: 'Verständnisfragen',
    en: 'Comprehension Check',
    es: 'Preguntas de comprensión',
    ar: 'أسئلة فهم النص',
  ),
  Str.autoReadStory: (
    de: 'Geschichte vorlesen',
    en: 'Auto Read Story',
    es: 'Lectura automática',
    ar: 'استماع وتتبع القصة',
  ),
  Str.storyComprehension: (
    de: 'Geschichte-Verständnis',
    en: 'Story Comprehension',
    es: 'Comprensión de la historia',
    ar: 'أسئلة فهم القصة',
  ),
  Str.yourScore: (
    de: 'Dein Ergebnis',
    en: 'Your Score',
    es: 'Tu puntuación',
    ar: 'نتيجتك',
  ),

  // ── Study Screen – remaining ──────────────────────────────────────
  Str.unitsCount: (
    de: '%s Einheiten',
    en: '%s Units',
    es: '%s Unidades',
    ar: '%s وحدات',
  ),

  // ── Listening Sessions ────────────────────────────────────────────
  Str.listeningSessions: (
    de: 'Hörsitzungen',
    en: 'Listening Sessions',
    es: 'Sesiones de escucha',
    ar: 'جلسات الاستماع',
  ),
  Str.listeningSubtitle: (
    de: 'Hintergrund-Audio zum Eintauchen',
    en: 'Background audio immersion practice',
    es: 'Práctica de inmersión en audio en segundo plano',
    ar: 'استماع متواصل في الخلفية لتقوية الأذن',
  ),
  Str.minutesShort: (
    de: '%s Min.',
    en: '%s Min',
    es: '%s min',
    ar: '%s دقيقة',
  ),
  Str.comprehensionQuiz: (
    de: 'Verständnis-Quiz',
    en: 'Comprehension Quiz',
    es: 'Cuestionario de comprensión',
    ar: 'اختبر فهمك',
  ),
  Str.quickComprehensionCheck: (
    de: 'Schnelle Verständnisfrage',
    en: 'Quick Comprehension Check',
    es: 'Comprobación rápida de comprensión',
    ar: 'سؤال فهم سريع',
  ),
  Str.correctAnswer: (
    de: 'Richtige Antwort! 🎉',
    en: 'Correct answer! 🎉',
    es: '¡Respuesta correcta! 🎉',
    ar: 'إجابة صحيحة ممتاز! 🎉',
  ),
  Str.incorrectTryAgain: (
    de: 'Falsch, versuche es nochmal!',
    en: 'Incorrect, try again!',
    es: '¡Incorrecto, inténtalo de nuevo!',
    ar: 'إجابة غير صحيحة، حاول مجدداً!',
  ),

  // ── Settings & Profile ────────────────────────────────────────────
  Str.settingsTitle: (
    de: 'Einstellungen',
    en: 'Settings',
    es: 'Ajustes',
    ar: 'الإعدادات',
  ),
  Str.settingsLoadError: (
    de: 'Einstellungen konnten nicht geladen werden',
    en: 'Settings could not be loaded',
    es: 'No se pudieron cargar los ajustes',
    ar: 'تعذر تحميل الإعدادات',
  ),
  Str.retryButton: (
    de: 'Wiederholen',
    en: 'Retry',
    es: 'Reintentar',
    ar: 'إعادة المحاولة',
  ),
  Str.learnerFallback: (
    de: 'Lernende(r)',
    en: 'Learner',
    es: 'Estudiante',
    ar: 'متعلّم',
  ),
  Str.profileStatsPlaceholder: (
    de: 'Tagessträhne, CEFR-Level und Testergebnisse werden hier erstellt.',
    en: 'Daily streak counters, CEFR level progression, and test scores will be built here.',
    es: 'Los contadores de racha, progresión MCER y resultados se mostrarán aquí.',
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
    case LocaleCode.arabic:
      raw = group.ar;
      break;
    case LocaleCode.german:
      raw = group.de;
      break;
    case LocaleCode.spanish:
      raw = group.es;
      break;
    case LocaleCode.english:
    default:
      raw = group.en;
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
