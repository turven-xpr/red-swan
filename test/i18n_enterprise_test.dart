import 'package:flutter_test/flutter_test.dart';
import 'package:deutschy/src/core/i18n/bidi_utils.dart';

void main() {
  group('BidiUtils Pluralization Tests', () {
    test('Arabic plural ranges cover all 6 grammatical forms correctly', () {
      // 0: zero
      expect(BidiUtils.formatStreakDays(0, true), '0 يوم');
      // 1: one
      expect(BidiUtils.formatStreakDays(1, true), 'يوم واحد');
      // 2: two (dual)
      expect(BidiUtils.formatStreakDays(2, true), 'يومان');
      // 3-10: few (جمع قلة)
      expect(BidiUtils.formatStreakDays(3, true), '3 أيام');
      expect(BidiUtils.formatStreakDays(5, true), '5 أيام');
      expect(BidiUtils.formatStreakDays(10, true), '10 أيام');
      // 11-99: many (مفرد منصوب)
      expect(BidiUtils.formatStreakDays(11, true), '11 يومًا');
      expect(BidiUtils.formatStreakDays(25, true), '25 يومًا');
      expect(BidiUtils.formatStreakDays(99, true), '99 يومًا');
      // 100+: other
      expect(BidiUtils.formatStreakDays(100, true), '100 يوم');
      expect(BidiUtils.formatStreakDays(103, true), '103 أيام');
    });

    test('English plural handles 1 vs many correctly', () {
      expect(BidiUtils.formatStreakDays(1, false), '1 day');
      expect(BidiUtils.formatStreakDays(5, false), '5 days');
      expect(BidiUtils.formatUnitCount(1, false), '1 Unit');
      expect(BidiUtils.formatUnitCount(3, false), '3 Units');
    });

    test('Unicode BiDi isolate wraps text with U+2066 and U+2069', () {
      const germanPhrase = 'Guten Morgen!';
      final isolated = BidiUtils.isolateGerman(germanPhrase);
      expect(isolated.startsWith('\u2066'), isTrue);
      expect(isolated.endsWith('\u2069'), isTrue);
      expect(isolated.contains(germanPhrase), isTrue);
    });

    test('Safe fallback provides English if Arabic is null or blank', () {
      expect(
        BidiUtils.safeLocalized(arabic: null, fallbackEnglish: 'Letters', isArabic: true),
        'Letters',
      );
      expect(
        BidiUtils.safeLocalized(arabic: '   ', fallbackEnglish: 'Letters', isArabic: true),
        'Letters',
      );
      expect(
        BidiUtils.safeLocalized(arabic: 'الحروف والأصوات', fallbackEnglish: 'Letters', isArabic: true),
        'الحروف والأصوات',
      );
      expect(
        BidiUtils.safeLocalized(arabic: 'الحروف والأصوات', fallbackEnglish: 'Letters', isArabic: false),
        'Letters',
      );
    });
  });
}

