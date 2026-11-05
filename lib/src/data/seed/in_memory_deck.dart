/// Synchronous, in-memory mirror of the A1 starter deck.
///
/// This is intentionally a separate constant from `StarterFlashcards.a1Deck()`
/// in `starter_decks.dart`.  We expose the data here so the very first
/// frame of the app can show real vocabulary without waiting for Drift
/// to open the SQLite database.
///
/// Cold-start rationale: mounting the UI before the database is open
/// saves ~150–400 ms on first launch.  Drift-backed progress rows
/// (`WatchedFlashcardProgress`) are merged on top of this list lazily by
/// the cache layer — see `cardCacheProvider` in providers.dart.
class InMemorySeedCard {
  const InMemorySeedCard({
    required this.stableId,
    required this.german,
    required this.english,
    required this.partOfSpeech,
    required this.exampleGerman,
    required this.exampleEnglish,
    required this.level,
  });

  /// Stable identifier derived from `"$level:-:$german"`.  Used as a join
  /// key with the Drift `UserFlashcardProgress` table once persistence
  /// is up.
  final String stableId;
  final String german;
  final String english;
  final String partOfSpeech;
  final String? exampleGerman;
  final String? exampleEnglish;
  final String level;
}

/// Pure-Dart list of A1 starter cards.  Mirrors
/// `StarterFlashcards.a1Deck()` so the in-memory cache and the persistent
/// Drift deck stay aligned on first launch.
const List<InMemorySeedCard> kInMemoryA1Deck = <InMemorySeedCard>[
  InMemorySeedCard(
      stableId: 'A1:-:der Tisch',
      german: 'der Tisch',
      english: 'the table',
      partOfSpeech: 'noun',
      exampleGerman: 'Der Tisch ist groß.',
      exampleEnglish: 'The table is big.',
      level: 'A1'),
  InMemorySeedCard(
      stableId: 'A1:-:die Tür',
      german: 'die Tür',
      english: 'the door',
      partOfSpeech: 'noun',
      exampleGerman: 'Die Tür ist offen.',
      exampleEnglish: 'The door is open.',
      level: 'A1'),
  InMemorySeedCard(
      stableId: 'A1:-:das Fenster',
      german: 'das Fenster',
      english: 'the window',
      partOfSpeech: 'noun',
      exampleGerman: 'Das Fenster ist zu.',
      exampleEnglish: 'The window is closed.',
      level: 'A1'),
  InMemorySeedCard(
      stableId: 'A1:-:der Stuhl',
      german: 'der Stuhl',
      english: 'the chair',
      partOfSpeech: 'noun',
      exampleGerman: 'Der Stuhl ist neu.',
      exampleEnglish: 'The chair is new.',
      level: 'A1'),
  InMemorySeedCard(
      stableId: 'A1:-:die Lampe',
      german: 'die Lampe',
      english: 'the lamp',
      partOfSpeech: 'noun',
      exampleGerman: 'Die Lampe ist hell.',
      exampleEnglish: 'The lamp is bright.',
      level: 'A1'),
  InMemorySeedCard(
      stableId: 'A1:-:der Apfel',
      german: 'der Apfel',
      english: 'the apple',
      partOfSpeech: 'noun',
      exampleGerman: 'Ich esse einen Apfel.',
      exampleEnglish: 'I eat an apple.',
      level: 'A1'),
  InMemorySeedCard(
      stableId: 'A1:-:das Wasser',
      german: 'das Wasser',
      english: 'the water',
      partOfSpeech: 'noun',
      exampleGerman: 'Das Wasser ist kalt.',
      exampleEnglish: 'The water is cold.',
      level: 'A1'),
  InMemorySeedCard(
      stableId: 'A1:-:der Kaffee',
      german: 'der Kaffee',
      english: 'the coffee',
      partOfSpeech: 'noun',
      exampleGerman: 'Der Kaffee ist heiß.',
      exampleEnglish: 'The coffee is hot.',
      level: 'A1'),
  InMemorySeedCard(
      stableId: 'A1:-:gehen',
      german: 'gehen',
      english: 'to go / to walk',
      partOfSpeech: 'verb',
      exampleGerman: 'Ich gehe zur Schule.',
      exampleEnglish: 'I go to school.',
      level: 'A1'),
  InMemorySeedCard(
      stableId: 'A1:-:kommen',
      german: 'kommen',
      english: 'to come',
      partOfSpeech: 'verb',
      exampleGerman: 'Er kommt aus Berlin.',
      exampleEnglish: 'He comes from Berlin.',
      level: 'A1'),
  InMemorySeedCard(
      stableId: 'A1:-:sprechen',
      german: 'sprechen',
      english: 'to speak',
      partOfSpeech: 'verb',
      exampleGerman: 'Ich spreche Deutsch.',
      exampleEnglish: 'I speak German.',
      level: 'A1'),
  InMemorySeedCard(
      stableId: 'A1:-:lernen',
      german: 'lernen',
      english: 'to learn',
      partOfSpeech: 'verb',
      exampleGerman: 'Wir lernen Deutsch.',
      exampleEnglish: 'We are learning German.',
      level: 'A1'),
  InMemorySeedCard(
      stableId: 'A1:-:essen',
      german: 'essen',
      english: 'to eat',
      partOfSpeech: 'verb',
      exampleGerman: 'Ich esse Brot.',
      exampleEnglish: 'I eat bread.',
      level: 'A1'),
  InMemorySeedCard(
      stableId: 'A1:-:trinken',
      german: 'trinken',
      english: 'to drink',
      partOfSpeech: 'verb',
      exampleGerman: 'Sie trinkt Tee.',
      exampleEnglish: 'She drinks tea.',
      level: 'A1'),
  InMemorySeedCard(
      stableId: 'A1:-:sein',
      german: 'sein',
      english: 'to be',
      partOfSpeech: 'verb',
      exampleGerman: 'Ich bin Student.',
      exampleEnglish: 'I am a student.',
      level: 'A1'),
  InMemorySeedCard(
      stableId: 'A1:-:haben',
      german: 'haben',
      english: 'to have',
      partOfSpeech: 'verb',
      exampleGerman: 'Ich habe Zeit.',
      exampleEnglish: 'I have time.',
      level: 'A1'),
  InMemorySeedCard(
      stableId: 'A1:-:groß',
      german: 'groß',
      english: 'big',
      partOfSpeech: 'adjective',
      exampleGerman: 'Das Haus ist groß.',
      exampleEnglish: 'The house is big.',
      level: 'A1'),
  InMemorySeedCard(
      stableId: 'A1:-:klein',
      german: 'klein',
      english: 'small',
      partOfSpeech: 'adjective',
      exampleGerman: 'Der Hund ist klein.',
      exampleEnglish: 'The dog is small.',
      level: 'A1'),
  InMemorySeedCard(
      stableId: 'A1:-:gut',
      german: 'gut',
      english: 'good',
      partOfSpeech: 'adjective',
      exampleGerman: 'Das Essen ist gut.',
      exampleEnglish: 'The food is good.',
      level: 'A1'),
  InMemorySeedCard(
      stableId: 'A1:-:schön',
      german: 'schön',
      english: 'beautiful / nice',
      partOfSpeech: 'adjective',
      exampleGerman: 'Heute ist es schön.',
      exampleEnglish: 'Today is nice.',
      level: 'A1'),
  InMemorySeedCard(
      stableId: 'A1:-:auf Wiedersehen',
      german: 'auf Wiedersehen',
      english: 'goodbye',
      partOfSpeech: 'phrase',
      exampleGerman: 'Auf Wiedersehen!',
      exampleEnglish: 'Goodbye!',
      level: 'A1'),
  InMemorySeedCard(
      stableId: 'A1:-:Guten Morgen',
      german: 'Guten Morgen',
      english: 'Good morning',
      partOfSpeech: 'phrase',
      exampleGerman: 'Guten Morgen, Anna!',
      exampleEnglish: 'Good morning, Anna!',
      level: 'A1'),
  InMemorySeedCard(
      stableId: 'A1:-:Danke',
      german: 'Danke',
      english: 'Thank you',
      partOfSpeech: 'phrase',
      exampleGerman: 'Danke, sehr freundlich.',
      exampleEnglish: 'Thanks, very kind.',
      level: 'A1'),
  InMemorySeedCard(
      stableId: 'A1:-:Bitte',
      german: 'Bitte',
      english: 'Please / You are welcome',
      partOfSpeech: 'phrase',
      exampleGerman: 'Bitte, setzen Sie sich.',
      exampleEnglish: 'Please, sit down.',
      level: 'A1'),
  InMemorySeedCard(
      stableId: 'A1:-:Ja / Nein',
      german: 'Ja / Nein',
      english: 'Yes / No',
      partOfSpeech: 'phrase',
      exampleGerman: 'Ja, das stimmt.',
      exampleEnglish: 'Yes, that is right.',
      level: 'A1'),
];
