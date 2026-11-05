import 'dart:math';

import 'memory_match_seed.dart';

/// One card face on the 4×4 grid.
///
/// Each card carries the German `word`, the English `translation` (only
/// shown when the card is one of the "English-facing" pair), the
/// `pairId` (used to detect a match), and a stable `seed` used to
/// randomise the card's starting rotation so neighbouring cards feel
/// less mechanical.
class MemoryCard {
  MemoryCard({
    required this.id,
    required this.pairId,
    required this.face,
    required this.text,
    required this.seed,
  });

  final int id;
  final int pairId;
  final CardFace face;
  final String text;
  final int seed;

  @override
  String toString() =>
      'MemoryCard(id=$id, pair=$pairId, face=${face.name}, text=$text)';
}

enum CardFace { german, english }

/// Outcome of comparing two flipped cards.
enum MatchStatus { matched, mismatch }

/// Pure-Dart game engine.  No Drift, no timers, no UI references — kept
/// side-effect-free so unit tests can run synchronously in-process.
class MemoryMatchEngine {
  MemoryMatchEngine({Random? random})
      : _rng = random ?? Random();

  final Random _rng;

  /// Build a fresh deck with [pairCount] pairs (8 by default = 16 cards).
  /// Picks the first N entries from [MemoryMatchSeed.pairs].
  List<MemoryCard> buildDeck({int pairCount = 8}) {
    final selected = MemoryMatchSeed.pairs.take(pairCount).toList();
    final cards = <MemoryCard>[
      for (var i = 0; i < selected.length; i++)
        MemoryCard(
          id: i * 2,
          pairId: i,
          face: CardFace.german,
          text: selected[i].german,
          seed: _rng.nextInt(1 << 31),
        ),
      for (var i = 0; i < selected.length; i++)
        MemoryCard(
          id: i * 2 + 1,
          pairId: i,
          face: CardFace.english,
          text: selected[i].english,
          seed: _rng.nextInt(1 << 31),
        ),
    ];
    cards.shuffle(_rng);
    return cards;
  }

  /// Compare two cards.  A match requires the same `pairId`.  We do
  /// NOT compare text/face here so the engine is robust against refactors
  /// that change the surface lookup.
  MatchStatus check(MemoryCard a, MemoryCard b) {
    if (a.id == b.id) return MatchStatus.mismatch; // double-tap on same card
    return a.pairId == b.pairId
        ? MatchStatus.matched
        : MatchStatus.mismatch;
  }
}
