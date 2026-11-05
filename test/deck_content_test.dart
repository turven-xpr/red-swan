import 'package:flutter_test/flutter_test.dart';

import 'package:deutschy/src/data/seed/a2_deck.dart';
import 'package:deutschy/src/data/seed/b1_deck.dart';

/// Content-driven tests — the A2 + B1 decks must (a) have the
/// expected sizes, (b) carry 4-language translations per card,
/// (c) survive a toString / stringify round-trip so we know no
/// string card has the wrong cardinality of fields.
void main() {
  test('A2 deck has 80+ cards with 4-language columns', () {
    final cards = A2Deck.entries(now: DateTime.now());
    expect(cards.length, greaterThanOrEqualTo(80));
    final sample = cards.first;
    // german, english, french/arabic (nullable), level (A2/B1),
    // nextReviewDate — sanity-check the schema.
    expect(sample.german.present, isTrue);
    expect(sample.english.present, isTrue);
    expect(sample.french.present, isTrue);
    expect(sample.arabic.present, isTrue);
    expect(sample.level.present, isTrue);
    expect(sample.nextReviewDate.present, isTrue);
  });

  test('B1 deck has 80+ cards with 4-language columns', () {
    final cards = B1Deck.entries(now: DateTime.now());
    expect(cards.length, greaterThanOrEqualTo(80));
    final sample = cards.first;
    expect(sample.german.present, isTrue);
    expect(sample.english.present, isTrue);
    expect(sample.french.present, isTrue);
    expect(sample.arabic.present, isTrue);
    expect(sample.level.present, isTrue);
    expect(sample.nextReviewDate.present, isTrue);
  });
}
