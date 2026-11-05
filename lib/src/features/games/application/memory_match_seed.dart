/// Seed vocabulary (german-english pairs) used by the mini-games.  Sourced
/// from the same data as the SRS A1 deck so the games reinforce what
/// learners have already touched — no random rare words.
///
/// Public so other features (teaser cards, dashboard stats) can read the
/// same list.  Deliberately small (16 pairs) and high-frequency.
class MemoryMatchSeed {
  MemoryMatchSeed._();

  static const List<({String german, String english})> pairs = [
    (german: 'der Tisch', english: 'the table'),
    (german: 'die Tür', english: 'the door'),
    (german: 'das Fenster', english: 'the window'),
    (german: 'der Stuhl', english: 'the chair'),
    (german: 'die Lampe', english: 'the lamp'),
    (german: 'der Apfel', english: 'the apple'),
    (german: 'das Wasser', english: 'the water'),
    (german: 'der Kaffee', english: 'the coffee'),
  ];
}
