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
}
