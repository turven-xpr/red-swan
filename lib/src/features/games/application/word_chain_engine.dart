import 'dart:math';

import '../../../data/local/app_database.dart';
import 'memory_match_seed.dart';

/// One step in Word Chain Race.
class WordChainQuestion {
  WordChainQuestion({
    required this.german,
    required this.options,
    required this.correctIndex,
  });

  final String german;
  final List<String> options; // 4 entries, shuffled
  final int correctIndex;
}

/// Pure-Dart engine that generates timed-translation-multi-choice questions
/// from any deck of [Flashcard]s.
class WordChainEngine {
  WordChainEngine({Random? random, this.optionsPerQuestion = 4, this.secondsPerQuestion = 5})
      : _rng = random ?? Random();

  final Random _rng;
  final int optionsPerQuestion;
  final int secondsPerQuestion;

  /// Build a [WordChainQuestion] for the [target] flashcard by picking
  /// three distinct *other* flashcards as distractors.
  WordChainQuestion nextQuestion(Flashcard target, List<Flashcard> pool) {
    // Pull distractors from anywhere in the pool — re-using the same
    // seed deck keeps the words learner-relevant.
    final others = pool.where((c) => c.id != target.id).toList();
    others.shuffle(_rng);

    // From the same MemoryMatchSeed we know which translations look
    // plausible (the 8 A1 pairs).  When the pool is too small, fall back
    // to whatever is available.
    final distractors = <String>{};
    for (final c in others) {
      if (distractors.length >= optionsPerQuestion - 1) break;
      final translation = c.english.trim();
      if (translation.isEmpty) continue;
      if (translation == target.english.trim()) continue;
      distractors.add(translation);
    }
    // Bottom of barrel: borrow from MemoryMatchSeed if pool was too thin.
    if (distractors.length < optionsPerQuestion - 1) {
      final used = distractors.toSet();
      for (final pair in MemoryMatchSeed.pairs) {
        if (used.contains(pair.english)) continue;
        if (pair.english == target.english.trim()) continue;
        distractors.add(pair.english);
        used.add(pair.english);
        if (distractors.length >= optionsPerQuestion - 1) break;
      }
    }

    final options = <String>[target.english.trim(), ...distractors.take(optionsPerQuestion - 1)];
    options.shuffle(_rng);
    final correctIndex = options.indexOf(target.english.trim());
    return WordChainQuestion(
      german: target.german,
      options: options,
      correctIndex: correctIndex,
    );
  }

  /// Returns true if [pickedIndex] matches the question's correct answer.
  bool check(WordChainQuestion q, int pickedIndex) =>
      pickedIndex == q.correctIndex;
}
