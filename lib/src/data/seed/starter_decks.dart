import 'package:drift/drift.dart';

import '../local/app_database.dart';

/// Curated starter decks for A1 and A2 so the app has content even before
/// we plug in any cloud CMS.  These are short, high-frequency words every
/// modern beginner runs into in their first weeks.
class StarterFlashcards {
  static List<FlashcardsCompanion> a1Deck() => _wrap([
        ('der Tisch', 'the table', 'noun', 'Der Tisch ist groß.', 'The table is big.'),
        ('die Tür', 'the door', 'noun', 'Die Tür ist offen.', 'The door is open.'),
        ('das Fenster', 'the window', 'noun', 'Das Fenster ist zu.', 'The window is closed.'),
        ('der Stuhl', 'the chair', 'noun', 'Der Stuhl ist neu.', 'The chair is new.'),
        ('die Lampe', 'the lamp', 'noun', 'Die Lampe ist hell.', 'The lamp is bright.'),
        ('der Apfel', 'the apple', 'noun', 'Ich esse einen Apfel.', 'I eat an apple.'),
        ('das Wasser', 'the water', 'noun', 'Das Wasser ist kalt.', 'The water is cold.'),
        ('der Kaffee', 'the coffee', 'noun', 'Der Kaffee ist heiß.', 'The coffee is hot.'),
        ('gehen', 'to go / to walk', 'verb', 'Ich gehe zur Schule.', 'I go to school.'),
        ('kommen', 'to come', 'verb', 'Er kommt aus Berlin.', 'He comes from Berlin.'),
        ('sprechen', 'to speak', 'verb', 'Ich spreche Deutsch.', 'I speak German.'),
        ('lernen', 'to learn', 'verb', 'Wir lernen Deutsch.', 'We are learning German.'),
        ('essen', 'to eat', 'verb', 'Ich esse Brot.', 'I eat bread.'),
        ('trinken', 'to drink', 'verb', 'Sie trinkt Tee.', 'She drinks tea.'),
        ('sein', 'to be', 'verb', 'Ich bin Student.', 'I am a student.'),
        ('haben', 'to have', 'verb', 'Ich habe Zeit.', 'I have time.'),
        ('groß', 'big', 'adjective', 'Das Haus ist groß.', 'The house is big.'),
        ('klein', 'small', 'adjective', 'Der Hund ist klein.', 'The dog is small.'),
        ('gut', 'good', 'adjective', 'Das Essen ist gut.', 'The food is good.'),
        ('schön', 'beautiful / nice', 'adjective', 'Heute ist es schön.', 'Today is nice.'),
        ('auf Wiedersehen', 'goodbye', 'phrase', 'Auf Wiedersehen!', 'Goodbye!'),
        ('Guten Morgen', 'Good morning', 'phrase', 'Guten Morgen, Anna!', 'Good morning, Anna!'),
        ('Danke', 'Thank you', 'phrase', 'Danke, sehr freundlich.', 'Thanks, very kind.'),
        ('Bitte', 'Please / You are welcome', 'phrase', 'Bitte, setzen Sie sich.', 'Please, sit down.'),
        ('Ja / Nein', 'Yes / No', 'phrase', 'Ja, das stimmt.', 'Yes, that is right.'),
      ], 'A1');

  static List<FlashcardsCompanion> _wrap(
    List<(String, String, String, String, String)> rows,
    String level,
  ) {
    final now = DateTime.now();
    return [
      for (final (german, english, pos, exDe, exEn) in rows)
        FlashcardsCompanion.insert(
          german: german,
          english: english,
          partOfSpeech: pos,
          exampleGerman: Value(exDe),
          exampleEnglish: Value(exEn),
          level: Value(level),
          nextReviewDate: now,
        ),
    ];
  }
}

class StarterScenarios {
  static List<SpeakingScenariosCompanion> presets() => [
        SpeakingScenariosCompanion.insert(
          title: 'Im Café',
          description: 'Order coffee and a pastry at a Berlin café.',
          level: const Value('A1'),
          systemPrompt:
              'You are a friendly German barista in Berlin. The user is a beginner (A1). '
              'Reply only in German, using very short sentences (max 8 words). '
              'Speak naturally, ask one follow-up question, and never correct the user — your job is to keep the conversation flowing.',
          openingMessage: 'Hallo! Was darf es sein?',
        ),
        SpeakingScenariosCompanion.insert(
          title: 'Im Hotel',
          description: 'Check in at a hotel reception in Munich.',
          level: const Value('A2'),
          systemPrompt:
              'You are a German hotel receptionist. The user is at level A2. '
              'Reply in short, clear German (max 12 words). Confirm details politely, and ask for the next document politely.',
          openingMessage:
              'Guten Abend! Herzlich willkommen. Haben Sie eine Reservierung?',
        ),
        SpeakingScenariosCompanion.insert(
          title: 'Beim Arzt',
          description: 'Describe your symptoms to a German doctor.',
          level: const Value('A2'),
          systemPrompt:
              'You are a calm German general practitioner. The user is at level A2. '
              'Reply in German, ask simple yes/no questions when possible, max 10 words each.',
          openingMessage: 'Guten Tag. Was fehlt Ihnen heute?',
        ),
        SpeakingScenariosCompanion.insert(
          title: 'Auf dem Markt',
          description: 'Buy fruit and vegetables at a market stand.',
          level: const Value('A1'),
          systemPrompt:
              'You are a friendly German market vendor. The user is a beginner (A1). '
              'Speak in very short German sentences (max 6 words). Recommend fresh items.',
          openingMessage: 'Hallo! Suchen Sie etwas Bestimmtes?',
        ),
        SpeakingScenariosCompanion.insert(
          title: 'Wahlbüro (Bürgeramt)',
          description: 'Discuss voter registration and civic rights.',
          level: const Value('B1'),
          systemPrompt:
              'You are a polite German civil servant (Beamter) at the citizen registry office. The user is a B1 learner. '
              'Reply in natural German at a B1 level (max 15 words). Speak formally (use "Sie"). '
              'Discuss voter registration, polling cards, or civic rights.',
          openingMessage: 'Guten Tag. Wie kann ich Ihnen heute bei Ihrer Wahlregistrierung helfen?',
        ),
      ];
}
