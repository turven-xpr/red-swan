import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tracks which lessons the user has completed/passed.
/// Persisted in SharedPreferences so progress survives app restarts.
class LessonProgressNotifier extends Notifier<Set<int>> {
  static const _kCompletedKey = 'deutschy_completed_lessons_v1';

  @override
  Set<int> build() {
    _load();
    return const {};
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_kCompletedKey);
      if (list != null) {
        state = list.map((e) => int.tryParse(e)).whereType<int>().toSet();
      }
    } catch (_) {
      // Tolerate storage failure in unit tests or unsupported environments
    }
  }

  bool isCompleted(int lessonId) => state.contains(lessonId);

  Future<void> markLessonCompleted(int lessonId) async {
    if (state.contains(lessonId)) return;
    final next = Set<int>.from(state)..add(lessonId);
    state = next;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        _kCompletedKey,
        next.map((id) => id.toString()).toList(),
      );
    } catch (_) {
      // Tolerate storage failure
    }
  }

  Future<void> resetProgress() async {
    state = const {};
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kCompletedKey);
    } catch (_) {
      // Tolerate
    }
  }
}

final lessonProgressProvider =
    NotifierProvider<LessonProgressNotifier, Set<int>>(LessonProgressNotifier.new);

