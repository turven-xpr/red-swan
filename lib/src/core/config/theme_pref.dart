import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Three discrete choices the user can pick on the Settings page:
/// `system`, `light`, `dark`.  Persisted to `SharedPreferences`.
enum ThemePreference { system, light, dark }

class ThemePreferenceNotifier extends Notifier<ThemePreference> {
  static const _key = 'theme_pref_v1';

  @override
  ThemePreference build() {
    _load();
    return ThemePreference.system;
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = _decode(prefs.getString(_key));
    } catch (_) {
      state = ThemePreference.system;
    }
  }

  Future<void> set(ThemePreference pref) async {
    state = pref;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, _encode(pref));
    } catch (_) {/* tolerate write failure in tests */}
  }

  static ThemePreference _decode(String? raw) {
    switch (raw) {
      case 'light':
        return ThemePreference.light;
      case 'dark':
        return ThemePreference.dark;
      case 'system':
      default:
        return ThemePreference.system;
    }
  }

  static String _encode(ThemePreference pref) {
    switch (pref) {
      case ThemePreference.light:
        return 'light';
      case ThemePreference.dark:
        return 'dark';
      case ThemePreference.system:
        return 'system';
    }
  }
}

final themePreferenceProvider =
    NotifierProvider<ThemePreferenceNotifier, ThemePreference>(
        ThemePreferenceNotifier.new);

/// Map the preference to a `ThemeMode` that `MaterialApp.themeMode`
/// consumes.
ThemeMode themeModeOf(ThemePreference pref) {
  switch (pref) {
    case ThemePreference.light:
      return ThemeMode.light;
    case ThemePreference.dark:
      return ThemeMode.dark;
    case ThemePreference.system:
      return ThemeMode.system;
  }
}
