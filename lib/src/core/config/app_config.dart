// Runtime configuration constants for Deutschy.
//
// All values that vary per-environment (real AdMob IDs, proxy URL, log
// level, etc.) live here as `const` so we can sweep them from a single
// file when shipping to production.  At release time:
//
//   1. Replace `kGeminiProxyUrl` with the deployed proxy URL
//      (e.g. https://deutschy-proxy.fly.dev/ai)
//   2. Replace `kAdMobAndroidAppId` + `kAdMobIosAppId` with the real
//      AdMob units from your AdMob console
//   3. Bump `kMinSupportedLevel` once you add A2 / B1 content
//
// Until then the values below are **safe defaults**:
//   * Proxy URL points at the Android emulator loopback for local dev
//   * AdMob IDs are the official **test units** — no revenue, but
//     Apple / Play Store don't reject builds that ship test IDs,
//     while real-but-unverified IDs may fail to fill.

/// Base URL of the deployed Gemini proxy.  Replace with your hosted
/// endpoint before shipping to production.
const String kGeminiProxyUrl = String.fromEnvironment(
  'DEUTSCHY_PROXY_URL',
  defaultValue: 'http://10.0.2.2:3000/ai',
);

/// AdMob Android app ID (matches `meta-data` in AndroidManifest.xml).
/// This is the **real** App ID and is required even for debug builds.
/// Override per-build via `--dart-define=ADMOB_ANDROID_APP_ID=…`.
const String kAdMobAndroidAppId = String.fromEnvironment(
  'ADMOB_ANDROID_APP_ID',
  defaultValue: 'ca-app-pub-8428663405548569~4897063446',
);

/// AdMob iOS app ID (matches `GADApplicationIdentifier` in Info.plist).
const String kAdMobIosAppId = String.fromEnvironment(
  'ADMOB_IOS_APP_ID',
  defaultValue: 'ca-app-pub-8428663405548569~4897063446',
);

/// Lowest CEFR level shipped in the deck.  Used by the dashboard to
/// guard the level-picker against accidental empty states.
const String kMinSupportedLevel = 'A1';

/// Support contact shown on error dialogs and the Privacy placeholder.
const String kSupportEmail = 'support@deutschy.app';

/// Google OAuth Web client id (NOT the same as the Android OAuth
/// client id used by the native Firebase flow).  Override per build
/// via:
///   `flutter build apk --dart-define=GOOGLE_SERVER_CLIENT_ID=…`
///
/// Read by [AuthService.init] which forwards it to
/// `GoogleSignIn.initialize(serverClientId: …)` so the v7 plugin can
/// build the correct Google OAuth code-exchange flow on Android.
const String kGoogleServerClientId = String.fromEnvironment(
  'GOOGLE_SERVER_CLIENT_ID',
  defaultValue:
      '139495496763-p2vatm4ci6bqad00n72bdmlvkjj539ii.apps.googleusercontent.com',
);

/// App version (kept in Dart so we can show it in the Profile screen
/// without bundling the platform constants).  Updated by hand on each
/// release; the platform sources of truth remain pubspec.yaml and the
/// Xcode project.
const String kAppVersion = '1.1.0+2';
