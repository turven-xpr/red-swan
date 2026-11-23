import 'package:flutter/material.dart';

/// Semantic color mapping for German grammatical gender.
///
/// Used by LearnCard noun_article cards and vocabulary displays.
/// Every color has a text badge companion for color-blind accessibility.
///
/// Colors are intentionally distinct and chosen for WCAG contrast:
///   - Masculine (der): Blue
///   - Feminine (die): Red/Pink
///   - Neuter (das): Green
///   - Plural (die): Amber
class GenderColors {
  GenderColors._();

  // ── Foreground / badge text ───────────────────────────────────────
  static const Color masculine = Color(0xFF1565C0); // blue 800
  static const Color feminine = Color(0xFFC62828);   // red 800
  static const Color neuter = Color(0xFF2E7D32);     // green 800
  static const Color plural = Color(0xFFF57F17);     // amber 900

  // ── Background tints (12% opacity equivalents for light mode) ────
  static const Color masculineBg = Color(0xFFE3F2FD); // blue 50
  static const Color feminineBg = Color(0xFFFFEBEE);   // red 50
  static const Color neuterBg = Color(0xFFE8F5E9);     // green 50
  static const Color pluralBg = Color(0xFFFFF8E1);     // amber 50

  // ── Dark mode foreground ─────────────────────────────────────────
  static const Color masculineDark = Color(0xFF64B5F6); // blue 300
  static const Color feminineDark = Color(0xFFEF9A9A);  // red 200
  static const Color neuterDark = Color(0xFF81C784);    // green 300
  static const Color pluralDark = Color(0xFFFFD54F);    // amber 300

  // ── Dark mode background tints ───────────────────────────────────
  static const Color masculineBgDark = Color(0xFF0D47A1); // blue 900 @ 20%
  static const Color feminineBgDark = Color(0xFF4A1515);
  static const Color neuterBgDark = Color(0xFF1B3A1B);
  static const Color pluralBgDark = Color(0xFF4A3B00);

  /// Returns the foreground color for a given gender string.
  static Color foreground(String? gender, {bool isDark = false}) {
    switch (gender?.toLowerCase()) {
      case 'masculine':
      case 'der':
      case 'm':
        return isDark ? masculineDark : masculine;
      case 'feminine':
      case 'die':
      case 'f':
        return isDark ? feminineDark : feminine;
      case 'neuter':
      case 'das':
      case 'n':
        return isDark ? neuterDark : neuter;
      case 'plural':
      case 'pl':
        return isDark ? pluralDark : plural;
      default:
        return isDark ? Colors.white70 : Colors.black54;
    }
  }

  /// Returns the background tint color for a given gender string.
  static Color background(String? gender, {bool isDark = false}) {
    switch (gender?.toLowerCase()) {
      case 'masculine':
      case 'der':
      case 'm':
        return isDark ? masculineBgDark : masculineBg;
      case 'feminine':
      case 'die':
      case 'f':
        return isDark ? feminineBgDark : feminineBg;
      case 'neuter':
      case 'das':
      case 'n':
        return isDark ? neuterBgDark : neuterBg;
      case 'plural':
      case 'pl':
        return isDark ? pluralBgDark : pluralBg;
      default:
        return isDark ? const Color(0xFF2A2A30) : const Color(0xFFF5F5F5);
    }
  }

  /// Returns the article string for a given gender.
  static String article(String? gender) {
    switch (gender?.toLowerCase()) {
      case 'masculine':
      case 'der':
      case 'm':
        return 'der';
      case 'feminine':
      case 'die':
      case 'f':
        return 'die';
      case 'neuter':
      case 'das':
      case 'n':
        return 'das';
      case 'plural':
      case 'pl':
        return 'die';
      default:
        return '';
    }
  }

  /// Returns the accessibility label for a gender badge.
  /// Localized by language code (en, ar, es).
  static String accessibilityLabel(String? gender, String languageCode) {
    final genderKey = gender?.toLowerCase() ?? '';
    switch (languageCode) {
      case 'ar':
        switch (genderKey) {
          case 'masculine':
          case 'der':
          case 'm':
            return 'مذكر';
          case 'feminine':
          case 'die':
          case 'f':
            return 'مؤنث';
          case 'neuter':
          case 'das':
          case 'n':
            return 'محايد';
          case 'plural':
          case 'pl':
            return 'جمع';
          default:
            return '';
        }
      case 'es':
        switch (genderKey) {
          case 'masculine':
          case 'der':
          case 'm':
            return 'MASC';
          case 'feminine':
          case 'die':
          case 'f':
            return 'FEM';
          case 'neuter':
          case 'das':
          case 'n':
            return 'NEUT';
          case 'plural':
          case 'pl':
            return 'PL';
          default:
            return '';
        }
      default: // en
        switch (genderKey) {
          case 'masculine':
          case 'der':
          case 'm':
            return 'MASC';
          case 'feminine':
          case 'die':
          case 'f':
            return 'FEM';
          case 'neuter':
          case 'das':
          case 'n':
            return 'NEUT';
          case 'plural':
          case 'pl':
            return 'PL';
          default:
            return '';
        }
    }
  }
}

