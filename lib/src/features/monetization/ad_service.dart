import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Wrapper around AdMob that:
///
///  * Defers ad loading until the app is fully painted (no jank during
///    the first interaction).
///  * Holds a single pre-loaded interstitial lazily — we *never* want to
///    block the user mid-flow while an ad downloads.
///  * Exposes a simple two-method API (`showInterstitial()`, `buildBanner`).
///  * Defaults to the official AdMob **test** unit IDs so reviewers
///    aren't shown real ads during development.  Override per-platform
///    via `--dart-define=ADMOB_*_UNIT_ID=…` at build time, or
///    pre-bake real IDs in `app_config.dart` before shipping.
///
/// Note: AdMob's Android/iOS *app* IDs (`ca-app-pub-…~…`) are passed via
/// the platform manifests, not via Dart.  The unit IDs here are the ad
/// *unit* IDs for the actual creative to display.
class AdService {
  AdService();

  InterstitialAd? _interstitial;
  bool _initialised = false;

  // Default to the official AdMob **test** unit IDs.  Override via
  // `--dart-define=ADMOB_BANNER_UNIT_ID` / `ADMOB_INTERSTITIAL_UNIT_ID`
  // at build time on top of the env-var-driven values below.
  static const String _kDefaultTestBannerId =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _kDefaultTestInterstitialId =
      'ca-app-pub-3940256099942544/1033173712';

  /// Ad unit IDs — test IDs for debug, real IDs when built with
  /// `--dart-define=ADMOB_BANNER_UNIT_ID=…` / `ADMOB_INTERSTITIAL_UNIT_ID=…`.
  ///
  /// Usage in release:
  ///   `flutter build apk --release` \
  ///     --dart-define=ADMOB_BANNER_UNIT_ID=ca-app-pub-8428663405548569/5112488773  \
  ///     --dart-define=ADMOB_INTERSTITIAL_UNIT_ID=ca-app-pub-8428663405548569/7842593893
  late final String bannerUnitId = (() {
    const String fromEnv = String.fromEnvironment('ADMOB_BANNER_UNIT_ID');
    return fromEnv.isNotEmpty ? fromEnv : _kDefaultTestBannerId;
  })();
  late final String interstitialUnitId = (() {
    const String fromEnv = String.fromEnvironment('ADMOB_INTERSTITIAL_UNIT_ID');
    return fromEnv.isNotEmpty ? fromEnv : _kDefaultTestInterstitialId;
  })();

  Future<void> init() async {
    if (kIsWeb) return; // AdMob is mobile-only
    if (_initialised) return;
    await MobileAds.instance.initialize();
    _initialised = true;
    _preloadInterstitial();
  }

  /// Build AdMob Banner widget configured for the current screen edge.
  BannerAd buildBanner({AdSize size = AdSize.banner}) {
    return BannerAd(
      adUnitId: bannerUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner failed to load: ${error.code} ${error.message}');
          ad.dispose();
        },
      ),
    )..load();
  }

  /// Build an adaptive banner that resizes itself to the available
  /// horizontal width — preferred for bottom-nav placement on phones.
  Future<BannerAd> buildAdaptiveBanner({
    required Orientation orientation,
    required double fixWidth,
  }) async {
    final AdSize? size = await AdSize
        .getLargeAnchoredAdaptiveBannerAdSizeWithOrientation(
      orientation,
      fixWidth.toInt(),
    );
    return BannerAd(
      adUnitId: bannerUnitId,
      size: size ?? AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
          debugPrint('Adaptive banner failed: ${error.code} ${error.message}');
          ad.dispose();
        },
      ),
    )..load();
  }

  /// Pre-load an interstitial.  Pre-loading prevents "cold ad" stutter
  /// during the user's review session completion.
  void _preloadInterstitial() {
    InterstitialAd.load(
      adUnitId: interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitial = ad;
          _interstitial!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial failed: ${error.code} ${error.message}');
          _interstitial = null;
          // Try again later — exponential backoff is intentionally kept
          // simple here; production should jitter the retry.
          Future.delayed(const Duration(seconds: 30), _preloadInterstitial);
        },
      ),
    );
  }

  /// Show the pre-loaded interstitial if one is ready, otherwise just no-op
  /// so the UX never blocks on a slow ad server.
  Future<void> showInterstitial() async {
    if (kIsWeb) return; // AdMob is mobile-only
    final ad = _interstitial;
    if (ad == null) return;
    _interstitial = null; // one-shot — prepare next immediately
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        _preloadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (a, error) {
        a.dispose();
        _preloadInterstitial();
      },
    );
    await ad.show();
  }
}

final adServiceProvider = Provider<AdService>((ref) {
  return AdService();
});
