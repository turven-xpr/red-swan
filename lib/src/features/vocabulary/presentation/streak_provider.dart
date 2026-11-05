// Tracks the user's consecutive review streak.
//   * persisted as YYYY-MM-DD → SharedPreferences
//   * derived value: `currentStreak` providers the integer
//   * the review screen taps `markReviewed()` after completing
//     a batch — if the user already reviewed today, no double‑count
//
// Tips:
//   - The streak resets if yesterday's entry is missing (gap > 1 day).
//   - On first‑ever review: streak = 1.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StreakPrefs {
  const StreakPrefs({required this.consecutiveDays, required this.lastReviewDate});
  final int consecutiveDays;
  final DateTime? lastReviewDate;
}

class StreakNotifier extends Notifier<StreakPrefs> {
  static const _kKey = 'deutschy_streak_v1';

  @override
  StreakPrefs build() {
    _load();
    return const StreakPrefs(consecutiveDays: 0, lastReviewDate: null);
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_kKey);
      if (raw == null) return;
      final parts = raw.split(':');
      if (parts.length != 2) return;
      final days = int.tryParse(parts[0]) ?? 0;
      final date = DateTime.tryParse(parts[1]);
      state = StreakPrefs(consecutiveDays: days, lastReviewDate: date);
    } catch (_) {/* tolerate */}
  }

  Future<void> markReviewed() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final prev = state.lastReviewDate;
    int next = state.consecutiveDays;

    if (prev == null) {
      next = 1;
    } else {
      final prevDay = DateTime(prev.year, prev.month, prev.day);
      final diff = today.difference(prevDay).inDays;
      if (diff == 0) {
        // already reviewed today — no change
        return;
      } else if (diff == 1) {
        next += 1;
      } else {
        // gap — reset to 1
        next = 1;
      }
    }

    state = StreakPrefs(consecutiveDays: next, lastReviewDate: today);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _kKey,
        '$next:${today.toIso8601String().split('T').first}',
      );
    } catch (_) {/* tolerate */}
  }
}

final streakProvider = NotifierProvider<StreakNotifier, StreakPrefs>(StreakNotifier.new);