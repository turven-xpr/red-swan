import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:deutschy/src/data/local/app_database.dart';
import 'package:deutschy/src/features/games/application/word_chain_engine.dart';

void main() {
  Flashcard mk(int id, String de, String en) => Flashcard(
        id: id,
        german: de,
        english: en,
        partOfSpeech: 'noun',
        level: 'A1',
        repetitions: 0,
        easeFactor: 2.5,
        intervalDays: 0,
        nextReviewDate: DateTime(2024, 1, 1),
        createdAt: DateTime(2024, 1, 1),
      );

  final deck = [
    mk(1, 'Tisch', 'table'),
    mk(2, 'Tür', 'door'),
    mk(3, 'Fenster', 'window'),
    mk(4, 'Stuhl', 'chair'),
    mk(5, 'Lampe', 'lamp'),
    mk(6, 'Apfel', 'apple'),
    mk(7, 'Wasser', 'water'),
    mk(8, 'Kaffee', 'coffee'),
  ];

  group('WordChainEngine', () {
    test('nextQuestion returns 4 unique options with the correct one present',
        () {
      final engine = WordChainEngine(random: Random(99));
      final target = deck[0];
      final q = engine.nextQuestion(target, deck);

      expect(q.options.length, 4);
      expect(q.options.toSet().length, 4, reason: 'options must be unique');
      expect(q.options.contains(target.english), isTrue);
    });

    test('check returns true only for the correctIndex', () {
      final engine = WordChainEngine(random: Random(13));
      final q = engine.nextQuestion(deck[2], deck);
      expect(engine.check(q, q.correctIndex), isTrue);
      for (var i = 0; i < q.options.length; i++) {
        if (i == q.correctIndex) continue;
        expect(engine.check(q, i), isFalse,
            reason: 'wrong index $i should return false');
      }
    });

    test('engine exposes its configured secondsPerQuestion', () {
      final engine = WordChainEngine(secondsPerQuestion: 7);
      expect(engine.secondsPerQuestion, 7);
    });
  });
}
