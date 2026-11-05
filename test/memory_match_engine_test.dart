import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:deutschy/src/features/games/application/memory_match_engine.dart';

void main() {
  group('MemoryMatchEngine', () {
    test('buildDeck returns 16 cards (8 pairs)', () {
      final engine = MemoryMatchEngine(random: Random(42));
      final deck = engine.buildDeck();
      expect(deck.length, 16);
      // 8 distinct pairIds
      final pairIds = deck.map((c) => c.pairId).toSet();
      expect(pairIds.length, 8);
      // Each pair appears exactly twice
      for (final id in pairIds) {
        expect(deck.where((c) => c.pairId == id).length, 2);
      }
      // Each id is unique
      final ids = deck.map((c) => c.id).toSet();
      expect(ids.length, 16);
    });

    test('check returns matched when pairIds agree', () {
      final engine = MemoryMatchEngine(random: Random(7));
      final a = MemoryCard(id: 1, pairId: 3, face: CardFace.german,
          text: 'x', seed: 0);
      final b = MemoryCard(id: 99, pairId: 3, face: CardFace.english,
          text: 'y', seed: 0);
      expect(engine.check(a, b), MatchStatus.matched);
    });

    test('check returns mismatch for different pairIds', () {
      final engine = MemoryMatchEngine(random: Random(7));
      final a = MemoryCard(id: 1, pairId: 1, face: CardFace.german,
          text: 'x', seed: 0);
      final b = MemoryCard(id: 2, pairId: 9, face: CardFace.english,
          text: 'y', seed: 0);
      expect(engine.check(a, b), MatchStatus.mismatch);
    });

    test('check returns mismatch when the same card id is flipped twice', () {
      final engine = MemoryMatchEngine();
      final a = MemoryCard(id: 5, pairId: 2, face: CardFace.german,
          text: 'x', seed: 0);
      expect(engine.check(a, a), MatchStatus.mismatch);
    });
  });
}
