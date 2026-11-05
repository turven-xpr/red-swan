import 'dart:math';

import '../../../data/local/app_database.dart';

/// Reference implementation of the SuperMemo-2 (SM-2) scheduling algorithm.
///
/// The math lives in pure Dart so it's trivially unit-testable without
/// bringing up a database.  Persistence is handled separately by the
/// repository that calls this service.
class SrsScheduler {
  /// Defaults per SuperMemo-2 spec.
  static const double _minEaseFactor = 1.3;
  static const double _easeFactorInit = 2.5;
  static const int _repetitionsFresh = 0;
  static const int _intervalFirst = 1; // 1 day
  static const int _intervalSecond = 6; // 6 days

  /// Pure function: given the previous SRS state and a user grade in the
  /// range `0..5` (Anki-flavored scale: 0 = forgot, 3 = remembered with
  /// effort, 5 = perfect) it returns the next state.
  ///
  /// This deliberately does not break entity immutability — the caller is
  /// expected to persist a new [Flashcard] row with these values.
  Flashcard nextState(Flashcard card, int grade, {DateTime? now}) {
    if (grade < 0 || grade > 5) {
      throw ArgumentError.value(
          grade, 'grade', 'must be an integer in [0, 5] (SM-2 scale)');
    }

    final today = now ?? DateTime.now();

    int repetitions = card.repetitions;
    double easeFactor = card.easeFactor <= 0 ? _easeFactorInit : card.easeFactor;
    int intervalDays;

    if (grade < 3) {
      // Recall failed — reset repetitions and schedule again tomorrow.
      repetitions = _repetitionsFresh;
      intervalDays = _intervalFirst;
    } else {
      // Recall succeeded — graduated interval.
      if (repetitions == 0) {
        intervalDays = _intervalFirst;
      } else if (repetitions == 1) {
        intervalDays = _intervalSecond;
      } else {
        // Use ceil() because intervals are whole days.
        intervalDays = (card.intervalDays * easeFactor).ceil();
      }
      repetitions += 1;
    }

    // Standard SuperMemo-2 ease-factor update.
    final delta = 0.1 - (5 - grade) * (0.08 + (5 - grade) * 0.02);
    easeFactor = max(_minEaseFactor, easeFactor + delta);

    return card.copyWith(
      repetitions: repetitions,
      easeFactor: easeFactor,
      intervalDays: intervalDays,
      nextReviewDate: today.add(Duration(days: intervalDays)),
    );
  }
}
