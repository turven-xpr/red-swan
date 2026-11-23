// Hand-curated translation tables.  These power every visible string
// in the app.  All three non-German locales (English, French,
// Arabic) live alongside `german` so the UI displays the user's
// chosen language WITHOUT requiring any codegen step.
//
// Adding a string:
//   1.  Add an entry to AppStrings below with a unique `_("...")`
//       lookup.  Use the key once at every use site via
//       `Strings(context).yourKey`.
//   2.  Add the translation in the four `_entries` arrays below.
//
// Why a hand-authored table and not flutter gen_l10n ARB files?
//   *  The build runs without `flutter gen-l10n`, so we don't have
//      to remember to re-run codegen whenever we add a string.
//   *  Source of truth is one Dart file — easy to grep, easy to
//      review in PRs.
//   *  Arabic copy is RTL-handled by Flutter at render time when
//      `MaterialApp.locale = Locale('ar')`.
class AppStrings {
  const AppStrings._();
}

/// The keys used across the app — kept in one place so we have a
// registry of every string we ship.
class Str {
  const Str._();
  static const String appName = 'appName';
  static const String splashTagline = 'splashTagline';
  static const String dashboardToday = 'dashboardToday';
  static const String dashboardDueToday = 'dashboardDueToday';
  static const String dashboardOverdueShort = 'dashboardOverdueShort';
  static const String dashboardEmptyState = 'dashboardEmptyState';
  static const String navHome = 'navHome';
  static const String navVocab = 'navVocab';
  static const String navSpeaking = 'navSpeaking';
  static const String navWriting = 'navWriting';
  static const String navGames = 'navGames';
  static const String navGrammar = 'navGrammar';
  static const String navReading = 'navReading';
  static const String navProfile = 'navProfile';
  static const String loginTagline = 'loginTagline';
  static const String loginWithGoogle = 'loginWithGoogle';
  static const String loginWithApple = 'loginWithApple';
  static const String loginOpening = 'loginOpening';
  static const String loginAccept = 'loginAccept';
  static const String writingPromptHint = 'writingPromptHint';
  static const String writingHelperChars = 'writingHelperChars';
  static const String writingGrade = 'writingGrade';
  static const String writingChecking = 'writingChecking';
  static const String errorNetwork = 'errorNetwork';
  static const String errorMalformed = 'errorMalformed';
  static const String errorGeneric = 'errorGeneric';
  static const String errorRetry = 'errorRetry';
  static const String vocabHeaderTitle = 'vocabHeaderTitle';
  static const String vocabDue = 'vocabDue';
  static const String vocabEmptyStart = 'vocabEmptyStart';
  static const String vocabLockedSoon = 'vocabLockedSoon';
  static const String reviewActionForgot = 'reviewActionForgot';
  static const String reviewActionHard = 'reviewActionHard';
  static const String reviewActionGood = 'reviewActionGood';
  static const String reviewActionEasy = 'reviewActionEasy';
  static const String reviewActionSkip = 'reviewActionSkip';
  static const String reviewShowAnswer = 'reviewShowAnswer';
  static const String reviewListen = 'reviewListen';
  static const String reviewClose = 'reviewClose';
  static const String finishCongrats = 'finishCongrats';
  static const String streakDays = 'streakDays';
  static const String streakNone = 'streakNone';
  static const String settingsTheme = 'settingsTheme';
  static const String settingsThemeSystem = 'settingsThemeSystem';
  static const String settingsThemeLight = 'settingsThemeLight';
  static const String settingsThemeDark = 'settingsThemeDark';
  static const String settingsLanguage = 'settingsLanguage';
  static const String settingsNotifications = 'settingsNotifications';
  static const String settingsStreak = 'settingsStreak';
  static const String settingsReminderTime = 'settingsReminderTime';
  static const String settingsProfilePhoto = 'settingsProfilePhoto';
  static const String settingsChangePhoto = 'settingsChangePhoto';
  static const String settingsAccount = 'settingsAccount';
  static const String settingsSignOut = 'settingsSignOut';
  static const String settingsAbout = 'settingsAbout';
  static const String settingsAboutBody = 'settingsAboutBody';
  static const String settingsVersion = 'settingsVersion';
  static const String settingsPlannedOnboardingTitle =
      'settingsPlannedOnboardingTitle';
  static const String settingsPlannedOnboardingBody =
      'settingsPlannedOnboardingBody';
  static const String photoGallery = 'photoGallery';
  static const String photoCamera = 'photoCamera';
  static const String photoRemove = 'photoRemove';
  static const String pickReminderTime = 'pickReminderTime';
  static const String grammarTitle = 'grammarTitle';
  static const String onboardingTitle = 'onboardingTitle';
  static const String onboardingBody = 'onboardingBody';
  static const String onboardingPickLevel = 'onboardingPickLevel';
  static const String onboardingCta = 'onboardingCta';
  static const String settingsReviewNotifEnabled = 'settingsReviewNotifEnabled';
  static const String reverseAnim = 'reverseAnim';
  static const String gamesHomeMemoryMatch = 'gamesHomeMemoryMatch';
  static const String gamesHomeWordChain = 'gamesHomeWordChain';
  static const String gamesComplete = 'gamesComplete';
  static const String readingTitle = 'readingTitle';
  static const String loginGuest = 'loginGuest';
  static const String navMore = 'navMore';

  // Shell & Navigation
  static const String learningPath = 'learningPath';
  static const String streakActiveTooltip = 'streakActiveTooltip';
  static const String streakExtendedToast = 'streakExtendedToast';
  static const String xpPoints = 'xpPoints';

  // Study Screen & Checkpoints
  static const String unitLabel = 'unitLabel';
  static const String readyToStudy = 'readyToStudy';
  static const String lessonsComingSoon = 'lessonsComingSoon';
  static const String checkpointIntro = 'checkpointIntro';
  static const String checkpointGate = 'checkpointGate';
  static const String checkpointIntroSub = 'checkpointIntroSub';
  static const String checkpointGateSub = 'checkpointGateSub';
  static const String skillListen = 'skillListen';
  static const String skillRead = 'skillRead';
  static const String skillWrite = 'skillWrite';
  static const String skillSpeak = 'skillSpeak';
  static const String startIntroCheckpoint = 'startIntroCheckpoint';
  static const String startGateTest = 'startGateTest';

  // Lesson Player
  static const String chooseCorrectAnswer = 'chooseCorrectAnswer';
  static const String pronouncedCorrectly = 'pronouncedCorrectly';
  static const String checkAnswer = 'checkAnswer';
  static const String correctFeedback = 'correctFeedback';
  static const String incorrectFeedback = 'incorrectFeedback';
  static const String correctAnswerLabel = 'correctAnswerLabel';
  static const String translationLabel = 'translationLabel';
  static const String continueButton = 'continueButton';
  static const String finishReading = 'finishReading';
  static const String completeTextLesson = 'completeTextLesson';
  static const String completeStoryLesson = 'completeStoryLesson';
  static const String lessonCompletedTitle = 'lessonCompletedTitle';
  static const String lessonCompletedSub = 'lessonCompletedSub';
  static const String nextStepBadge = 'nextStepBadge';
  static const String completedBadge = 'completedBadge';
  static const String startButton = 'startButton';

  // Placeholder Screens
  static const String testsTitle = 'testsTitle';
  static const String testsDesc = 'testsDesc';
  static const String aiTutorTitle = 'aiTutorTitle';
  static const String aiTutorDesc = 'aiTutorDesc';
  static const String profileStatsTitle = 'profileStatsTitle';
  static const String profileStatsDesc = 'profileStatsDesc';
  static const String profileSettingsBtn = 'profileSettingsBtn';
  static const String settingsAudioSpeed = 'settingsAudioSpeed';

  // Onboarding
  static const String onboardingStep1Title = 'onboardingStep1Title';
  static const String onboardingStep1Sub = 'onboardingStep1Sub';
  static const String onboardingStep2Title = 'onboardingStep2Title';
  static const String onboardingStep2Sub = 'onboardingStep2Sub';
  static const String onboardingStep3Title = 'onboardingStep3Title';
  static const String onboardingStep3Sub = 'onboardingStep3Sub';
  static const String onboardingStep4Title = 'onboardingStep4Title';
  static const String onboardingStep4Sub = 'onboardingStep4Sub';
  static const String onboardingReasonStudy = 'onboardingReasonStudy';
  static const String onboardingReasonStudyDesc = 'onboardingReasonStudyDesc';
  static const String onboardingReasonAusbildung = 'onboardingReasonAusbildung';
  static const String onboardingReasonAusbildungDesc = 'onboardingReasonAusbildungDesc';
  static const String onboardingReasonJob = 'onboardingReasonJob';
  static const String onboardingReasonJobDesc = 'onboardingReasonJobDesc';
  static const String onboardingReasonTravel = 'onboardingReasonTravel';
  static const String onboardingReasonTravelDesc = 'onboardingReasonTravelDesc';
  static const String onboardingReasonFun = 'onboardingReasonFun';
  static const String onboardingReasonFunDesc = 'onboardingReasonFunDesc';
  static const String onboardingBtnContinue = 'onboardingBtnContinue';
  static const String onboardingBtnBack = 'onboardingBtnBack';
  static const String onboardingBtnStart = 'onboardingBtnStart';
  static const String onboardingLevelIntroTitle = 'onboardingLevelIntroTitle';
  static const String onboardingLevelIntroDesc = 'onboardingLevelIntroDesc';
  static const String onboardingLevelA1Title = 'onboardingLevelA1Title';
  static const String onboardingLevelA1Desc = 'onboardingLevelA1Desc';
  static const String onboardingLevelA2Title = 'onboardingLevelA2Title';
  static const String onboardingLevelA2Desc = 'onboardingLevelA2Desc';
  static const String onboardingLevelB1Title = 'onboardingLevelB1Title';
  static const String onboardingLevelB1Desc = 'onboardingLevelB1Desc';
  static const String onboardingLevelB2Title = 'onboardingLevelB2Title';
  static const String onboardingLevelB2Desc = 'onboardingLevelB2Desc';
  static const String onboardingGoal3MinTitle = 'onboardingGoal3MinTitle';
  static const String onboardingGoal3MinDesc = 'onboardingGoal3MinDesc';
  static const String onboardingGoal5MinTitle = 'onboardingGoal5MinTitle';
  static const String onboardingGoal5MinDesc = 'onboardingGoal5MinDesc';
  static const String onboardingGoal15MinTitle = 'onboardingGoal15MinTitle';
  static const String onboardingGoal15MinDesc = 'onboardingGoal15MinDesc';
  static const String onboardingGoal30MinTitle = 'onboardingGoal30MinTitle';
  static const String onboardingGoal30MinDesc = 'onboardingGoal30MinDesc';
  static const String onboardingGoal60MinTitle = 'onboardingGoal60MinTitle';
  static const String onboardingGoal60MinDesc = 'onboardingGoal60MinDesc';
  static const String onboardingGoal120MinTitle = 'onboardingGoal120MinTitle';
  static const String onboardingGoal120MinDesc = 'onboardingGoal120MinDesc';

  // Lesson Player – remaining keys
  static const String noExercisesFound = 'noExercisesFound';
  static const String tapToListen = 'tapToListen';
  static const String typeWordHint = 'typeWordHint';
  static const String toggleTranslations = 'toggleTranslations';
  static const String readFullText = 'readFullText';
  static const String textLessonSubtitle = 'textLessonSubtitle';
  static const String vocabGrammarNotes = 'vocabGrammarNotes';
  static const String comprehensionCheck = 'comprehensionCheck';
  static const String autoReadStory = 'autoReadStory';
  static const String storyComprehension = 'storyComprehension';
  static const String yourScore = 'yourScore';

  // Study Screen – remaining
  static const String unitsCount = 'unitsCount';

  // Listening Sessions
  static const String listeningSessions = 'listeningSessions';
  static const String listeningSubtitle = 'listeningSubtitle';
  static const String minutesShort = 'minutesShort';
  static const String comprehensionQuiz = 'comprehensionQuiz';
  static const String quickComprehensionCheck = 'quickComprehensionCheck';
  static const String correctAnswer = 'correctAnswer';
  static const String incorrectTryAgain = 'incorrectTryAgain';

  // LearnCard Presentation Phase
  static const String learnPhaseTitle = 'learnPhaseTitle';
  static const String learnPhaseSwipeHint = 'learnPhaseSwipeHint';
  static const String learnPhaseReady = 'learnPhaseReady';
  static const String learnPhaseCounter = 'learnPhaseCounter';

  // Pronunciation Coach
  static const String listenNative = 'listenNative';
  static const String tapToSpeak = 'tapToSpeak';
  static const String listeningState = 'listeningState';
  static const String speechNotAvailable = 'speechNotAvailable';
  static const String youSaid = 'youSaid';
  static const String greatPronunciation = 'greatPronunciation';
  static const String goodTry = 'goodTry';
  static const String markAsPracticed = 'markAsPracticed';
  static const String tryAgainCoach = 'tryAgainCoach';

  // Settings & Profile
  static const String settingsTitle = 'settingsTitle';
  static const String settingsLoadError = 'settingsLoadError';
  static const String retryButton = 'retryButton';
  static const String learnerFallback = 'learnerFallback';
  static const String profileStatsPlaceholder = 'profileStatsPlaceholder';
}
