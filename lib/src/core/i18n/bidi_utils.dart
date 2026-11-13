import 'package:flutter/widgets.dart';

/// Enterprise BiDi and Pluralization Utilities for Deutschy.
///
/// Ensures strict isolation between German (LTR) and Arabic (RTL) text
/// to prevent punctuation jumping and layout distortion.
class BidiUtils {
  const BidiUtils._();

  /// Unicode Left-to-Right Isolate (U+2066) and Pop Directional Isolate (U+2069).
  static const String lri = '\u2066';
  static const String pdi = '\u2069';

  /// Wraps any German word or sentence with Unicode BiDi isolates.
  /// This guarantees that when German text is embedded inside an Arabic sentence
  /// (e.g. "ترجمة: Guten Morgen!"), the exclamation mark and word order do not jump.
  static String isolateGerman(String text) {
    if (text.isEmpty) return text;
    return '$lri$text$pdi';
  }

  /// 6-category Arabic pluralization following standard Arabic grammar rules:
  /// - zero: 0 (e.g. "لا توجد أيام")
  /// - one: 1 (e.g. "يوم واحد")
  /// - two: 2 (e.g. "يومان")
  /// - few: 3-10 (e.g. "3 أيام")
  /// - many: 11-99 (e.g. "15 يومًا")
  /// - other: 100+ (e.g. "100 يوم")
  static String pluralizeArabic({
    required int count,
    required String zero,
    required String one,
    required String two,
    required String few,
    required String many,
    required String other,
  }) {
    if (count == 0) return zero;
    if (count == 1) return one;
    if (count == 2) return two;

    final mod100 = count % 100;
    if (mod100 >= 3 && mod100 <= 10) {
      return '$count $few';
    }
    if (mod100 >= 11 && mod100 <= 99) {
      return '$count $many';
    }
    return '$count $other';
  }

  /// Helper for streak days in Arabic, English, and Spanish.
  static String formatStreakDays(int days, bool isArabic, [String? languageCode]) {
    if (isArabic || languageCode == 'ar') {
      return pluralizeArabic(
        count: days,
        zero: '0 يوم',
        one: 'يوم واحد',
        two: 'يومان',
        few: 'أيام',
        many: 'يومًا',
        other: 'يوم',
      );
    }
    if (languageCode == 'es') {
      return '$days ${days == 1 ? "día" : "días"}';
    }
    return '$days ${days == 1 ? "day" : "days"}';
  }

  /// Helper for unit count badge.
  static String formatUnitCount(int units, bool isArabic, [String? languageCode]) {
    if (isArabic || languageCode == 'ar') {
      return pluralizeArabic(
        count: units,
        zero: 'بدون وحدات',
        one: 'وحدة واحدة',
        two: 'وحدتان',
        few: 'وحدات',
        many: 'وحدة',
        other: 'وحدة',
      );
    }
    if (languageCode == 'es') {
      return '$units ${units == 1 ? "Unidad" : "Unidades"}';
    }
    return '$units ${units == 1 ? "Unit" : "Units"}';
  }

  /// Safe fallback helper: if [arabic] text is null or empty, falls back to [fallbackEnglish],
  /// never leaving a blank space in the UI.
  static String safeLocalized({String? arabic, required String fallbackEnglish, required bool isArabic}) {
    if (isArabic && arabic != null && arabic.trim().isNotEmpty) {
      return arabic.trim();
    }
    return fallbackEnglish.trim();
  }
}

/// A standalone widget that forces its child to render strictly in LTR.
/// Used for standalone German sentences, grammar examples, and vocabulary cards.
class GermanText extends StatelessWidget {
  const GermanText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Text(
        text,
        style: style,
        textAlign: textAlign ?? TextAlign.left,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}

