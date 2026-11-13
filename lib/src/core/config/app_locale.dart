import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds the user's choice of display language.  Persisted to
/// `SharedPreferences` and exposed as a Riverpod provider so every
/// screen rebuilds when the user changes language in Settings.
///
/// Supported locales: `de`, `en`, `fr`, `ar`.
class AppLocaleNotifier extends Notifier<Locale> {
  static const _key = 'app_locale_v1';

  @override
  Locale build() {
    _load();
    return const Locale('en');
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw != null) {
        state = Locale(raw);
      }
    } catch (_) {
      // SharedPreferences unavailable (e.g. in tests) — keep default
      // English so layouts still render.
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, locale.languageCode);
    } catch (_) {
      // Persisting failed; the in-memory update still applies for this
      // session.
    }
  }
}

final appLocaleProvider =
    NotifierProvider<AppLocaleNotifier, Locale>(AppLocaleNotifier.new);

/// Read the active [Locale] from inside a `BuildContext`.  Falls back
/// to the locale the MaterialApp requested when ProviderScope is not
/// available (e.g. inside the translation table itself).
class AppLocale {
  const AppLocale._();
  static Locale localeOf(BuildContext context) {
    try {
      final container =
          ProviderScope.containerOf(context, listen: false);
      return container.read(appLocaleProvider);
    } catch (_) {
      // ProviderScope missing — fall back to the MaterialApp locale.
      return Localizations.localeOf(context);
    }
  }

  /// Locale code → display name in the locale's own script for the
  /// language picker UI.
  static String label(Locale locale) {
    switch (locale.languageCode) {
      case LocaleCode.arabic:
        return 'العربية';
      case LocaleCode.spanish:
        return 'Español';
      case LocaleCode.german:
        return 'Deutsch';
      case LocaleCode.french:
        return 'Français';
      default:
        return 'English';
    }
  }
}

class LocaleCode {
  const LocaleCode._();
  static const String english = 'en';
  static const String arabic = 'ar';
  static const String spanish = 'es';

  // Legacy fallback support
  static const String german = 'de';
  static const String french = 'fr';
}
