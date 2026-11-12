import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/curriculum_models.dart';

/// Repository that manages and queries the read-only curriculum content.
class ContentRepository {
  ContentRepository();

  bool _initialized = false;
  final List<CurriculumUnit> _units = [];
  final List<CurriculumLesson> _lessons = [];
  final List<CurriculumWord> _words = [];
  final List<CurriculumExercise> _exercises = [];
  final List<CurriculumReadingPassage> _passages = [];

  bool get isInitialized => _initialized;

  /// Loads the curriculum data from the bundled asset.
  Future<void> init() async {
    if (_initialized) return;

    try {
      final jsonString = await rootBundle.loadString('assets/deutschy_content.json');
      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      if (data['units'] is List) {
        _units.clear();
        for (final u in data['units'] as List) {
          _units.add(CurriculumUnit.fromJson(u as Map<String, dynamic>));
        }
      }

      if (data['lessons'] is List) {
        _lessons.clear();
        for (final l in data['lessons'] as List) {
          _lessons.add(CurriculumLesson.fromJson(l as Map<String, dynamic>));
        }
      }

      if (data['words'] is List) {
        _words.clear();
        for (final w in data['words'] as List) {
          _words.add(CurriculumWord.fromJson(w as Map<String, dynamic>));
        }
      }

      if (data['exercises'] is List) {
        _exercises.clear();
        for (final e in data['exercises'] as List) {
          _exercises.add(CurriculumExercise.fromJson(e as Map<String, dynamic>));
        }
      }

      if (data['reading_passages'] is List) {
        _passages.clear();
        for (final p in data['reading_passages'] as List) {
          _passages.add(CurriculumReadingPassage.fromJson(p as Map<String, dynamic>));
        }
      }

      _initialized = true;
      debugPrint('[ContentRepository] Loaded ${_units.length} units, ${_lessons.length} lessons, ${_words.length} words, ${_exercises.length} exercises.');
    } catch (e, st) {
      debugPrint('[ContentRepository] Error loading curriculum content: $e\n$st');
    }
  }

  /// Get all units for a given CEFR level (e.g. 'A1')
  List<CurriculumUnit> getUnitsForLevel(String level) {
    return _units.where((u) => u.level.toUpperCase() == level.toUpperCase()).toList()
      ..sort((a, b) => a.unitNumber.compareTo(b.unitNumber));
  }

  /// Get all lessons for a specific unit
  List<CurriculumLesson> getLessonsForUnit(int unitId) {
    return _lessons.where((l) => l.unitId == unitId).toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  /// Get all lessons for an entire level (including level tests)
  List<CurriculumLesson> getLessonsForLevel(String level) {
    return _lessons.where((l) => l.level.toUpperCase() == level.toUpperCase()).toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  /// Get exercises for a specific lesson
  List<CurriculumExercise> getExercisesForLesson(int lessonId) {
    return _exercises.where((e) => e.lessonId == lessonId).toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  /// Get words introduced in a specific unit
  List<CurriculumWord> getWordsForTopic(String topic) {
    return _words.where((w) => w.topic.toLowerCase() == topic.toLowerCase()).toList();
  }

  /// Get reading passage for a unit
  CurriculumReadingPassage? getPassageForUnit(int unitId) {
    try {
      return _passages.firstWhere((p) => p.unitId == unitId);
    } catch (_) {
      return null;
    }
  }
}

/// Content repository singleton provider
final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  return ContentRepository();
});

/// FutureProvider that ensures the repository is initialized
final contentInitProvider = FutureProvider<void>((ref) async {
  final repo = ref.watch(contentRepositoryProvider);
  await repo.init();
});

/// Watch units for a specific CEFR level
final unitsByLevelProvider = Provider.family<List<CurriculumUnit>, String>((ref, level) {
  final repo = ref.watch(contentRepositoryProvider);
  return repo.getUnitsForLevel(level);
});

/// Watch lessons for a specific unit
final lessonsByUnitProvider = Provider.family<List<CurriculumLesson>, int>((ref, unitId) {
  final repo = ref.watch(contentRepositoryProvider);
  return repo.getLessonsForUnit(unitId);
});

