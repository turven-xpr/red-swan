import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:deutschy/src/core/providers.dart';
import 'package:deutschy/src/core/audio/audio_playback_service.dart';
import 'package:deutschy/src/core/audio/tts_service.dart';
import 'package:deutschy/src/features/study/data/content_repository.dart';
import 'package:deutschy/src/features/study/domain/curriculum_models.dart';
import 'package:deutschy/src/features/study/presentation/widgets/learn_card_widget.dart';
import 'package:deutschy/src/features/study/presentation/widgets/sentence_scramble_widget.dart';

class _FakeAudioService extends Fake implements AudioPlaybackService {
  String? lastSpoken;

  @override
  Future<void> speak(String text, {String? voice}) async {
    lastSpoken = text;
  }

  @override
  Future<void> stop() async {}

  @override
  Stream<TtsState> get state => const Stream.empty();
}

void main() {
  late ContentRepository repo;
  late _FakeAudioService fakeAudio;

  setUp(() {
    repo = ContentRepository();
    fakeAudio = _FakeAudioService();

    repo.loadFromData({
      'words': [
        {
          'id': 101,
          'lemma': 'Apfel',
          'level': 'A1',
          'topic': 'food',
          'pos': 'noun',
          'gender': 'masculine',
          'plural': 'Äpfel',
          'translation_en': 'apple',
          'translation_ar': 'تفاحة',
          'translation_es': 'manzana',
        },
        {
          'id': 102,
          'lemma': 'Mutter',
          'level': 'A1',
          'topic': 'family',
          'pos': 'noun',
          'gender': 'feminine',
          'plural': 'Mütter',
          'translation_en': 'mother',
          'translation_ar': 'أم',
          'translation_es': 'madre',
        },
      ],
      'learn_cards': [],
    });
  });

  Widget buildTestableWidget(Widget child, {Locale locale = const Locale('en')}) {
    return ProviderScope(
      overrides: [
        contentRepositoryProvider.overrideWithValue(repo),
        audioPlaybackServiceProvider.overrideWithValue(fakeAudio),
      ],
      child: MaterialApp(
        locale: locale,
        home: Scaffold(
          body: SingleChildScrollView(child: child),
        ),
      ),
    );
  }

  group('LearnCardWidget Presentation Tests', () {
    testWidgets('renders phonetic card and plays audio', (tester) async {
      final card = CurriculumLearnCard(
        id: 'p1',
        lessonId: 1,
        type: LearnCardType.phonetic,
        sortOrder: 1,
        customPromptDe: 'ch',
        dataJson: {
          'mouth_tip_en': 'Tongue against soft palate.',
          'contrast_pairs': [
            {'word_a': 'ich', 'word_b': 'ach'},
          ],
          'sample_words': ['Milch', 'Nacht'],
        },
      );

      await tester.pumpWidget(buildTestableWidget(LearnCardWidget(card: card, languageCode: 'en')));
      await tester.pump();

      expect(find.text('ch'), findsOneWidget);
      expect(find.text('Tongue against soft palate.'), findsOneWidget);
      expect(find.text('ich'), findsOneWidget);
      expect(find.text('ach'), findsOneWidget);
      expect(find.text('Milch'), findsOneWidget);
      expect(find.text('Nacht'), findsOneWidget);

      // Tap sample word audio chip
      await tester.tap(find.text('Milch'));
      await tester.pump();
      expect(fakeAudio.lastSpoken, equals('Milch'));
    });

    testWidgets('renders phonetic card with anchor word, translation, and example sentence', (tester) async {
      final card = CurriculumLearnCard(
        id: 'p_a1',
        lessonId: 10102,
        type: LearnCardType.phonetic,
        sortOrder: 1,
        customPromptDe: 'A a',
        dataJson: {
          'chunk_de': 'A wie Apfel',
          'anchor_word_de': 'der Apfel',
          'anchor_word_en': 'apple',
          'anchor_word_ar': '\u2066تفاحة\u2069',
          'example_sentence_de': 'Der Apfel ist rot.',
          'sentence_en': 'The apple is red.',
        },
      );

      await tester.pumpWidget(buildTestableWidget(LearnCardWidget(card: card, languageCode: 'en')));
      await tester.pump();

      expect(find.text('A a'), findsOneWidget);
      expect(find.text('der Apfel'), findsOneWidget);
      expect(find.text('apple'), findsOneWidget);
      expect(find.text('Der Apfel ist rot.'), findsOneWidget);
      expect(find.text('The apple is red.'), findsOneWidget);

      // Tap anchor word audio button (second volume icon: 0=letter chip, 1=anchor word, 2=example sentence)
      await tester.tap(find.byIcon(Icons.volume_up_rounded).at(1));
      await tester.pump();
      expect(fakeAudio.lastSpoken, equals('der Apfel'));
    });

    testWidgets('renders noun_article card with gender colors and text badge', (tester) async {
      final card = CurriculumLearnCard(
        id: 'n1',
        lessonId: 10,
        type: LearnCardType.nounArticle,
        sortOrder: 1,
        wordId: 101, // Apfel (masculine)
        dataJson: {
          'example_sentence_de': 'Der Apfel ist rot.',
          'sentence_en': 'The apple is red.',
        },
      );

      await tester.pumpWidget(buildTestableWidget(LearnCardWidget(card: card, languageCode: 'en')));
      await tester.pump();

      // Check badge contains article and gender accessibility label
      expect(find.text('der · MASC'), findsOneWidget);
      expect(find.textContaining('Apfel'), findsAtLeastNWidgets(1));
      expect(find.text('apple'), findsOneWidget);
      expect(find.text('Pl: die Äpfel'), findsOneWidget);
      expect(find.text('Der Apfel ist rot.'), findsOneWidget);
      expect(find.text('The apple is red.'), findsOneWidget);
    });

    testWidgets('renders noun_article card with Arabic localization without bidi leakage', (tester) async {
      final card = CurriculumLearnCard(
        id: 'n2',
        lessonId: 10,
        type: LearnCardType.nounArticle,
        sortOrder: 2,
        wordId: 102, // Mutter (feminine)
        dataJson: {
          'example_sentence_de': 'Die Mutter liest ein Buch.',
          'sentence_ar': '\u2066الأم تقرأ كتاباً.\u2069',
        },
      );

      await tester.pumpWidget(
        buildTestableWidget(
          LearnCardWidget(card: card, languageCode: 'ar'),
          locale: const Locale('ar'),
        ),
      );
      await tester.pump();

      expect(find.text('die · مؤنث'), findsOneWidget);
      expect(find.textContaining('Mutter'), findsAtLeastNWidgets(1));
      expect(find.text('أم'), findsOneWidget);
      expect(find.text('Pl: die Mütter'), findsOneWidget);
    });

    testWidgets('renders phrase_chunk card with highlighted grammatical token', (tester) async {
      final card = CurriculumLearnCard(
        id: 'c1',
        lessonId: 20,
        type: LearnCardType.phraseChunk,
        sortOrder: 1,
        dataJson: {
          'chunk_de': 'Ich habe einen Bruder',
          'highlight_token': 'einen',
          'sentence_en': 'I have a brother',
          'grammatical_note_en': 'Accusative masculine object uses "einen".',
        },
      );

      await tester.pumpWidget(buildTestableWidget(LearnCardWidget(card: card, languageCode: 'en')));
      await tester.pump();

      expect(find.text('I have a brother'), findsOneWidget);
      expect(find.text('Accusative masculine object uses "einen".'), findsOneWidget);
    });
  });

  group('SentenceScrambleWidget Tests', () {
    testWidgets('learner places tokens and submits correct sentence', (tester) async {
      bool? completedResult;

      await tester.pumpWidget(
        buildTestableWidget(
          SentenceScrambleWidget(
            correctTokens: const ['Ich', 'wohne', 'in', 'Berlin'],
            onCompleted: (result) => completedResult = result,
            languageCode: 'en',
          ),
        ),
      );
      await tester.pump();

      // Check instruction is shown
      expect(find.text('Arrange the words to form the correct sentence'), findsOneWidget);

      // Tap available tokens in sequence to place them
      await tester.tap(find.text('Ich'));
      await tester.pump();
      await tester.tap(find.text('wohne'));
      await tester.pump();
      await tester.tap(find.text('in'));
      await tester.pump();
      await tester.tap(find.text('Berlin'));
      await tester.pump();

      // Tap Check button
      expect(find.text('Check'), findsOneWidget);
      await tester.tap(find.text('Check'));
      await tester.pump();

      expect(completedResult, isTrue);
    });

    testWidgets('learner places tokens incorrectly, sees retry and resets', (tester) async {
      bool? completedResult;

      await tester.pumpWidget(
        buildTestableWidget(
          SentenceScrambleWidget(
            correctTokens: const ['Der', 'Hund', 'bellt'],
            onCompleted: (result) => completedResult = result,
            languageCode: 'en',
          ),
        ),
      );
      await tester.pump();

      // Place in wrong order: bellt, Hund, Der
      await tester.tap(find.text('bellt'));
      await tester.pump();
      await tester.tap(find.text('Hund'));
      await tester.pump();
      await tester.tap(find.text('Der'));
      await tester.pump();

      await tester.tap(find.text('Check'));
      await tester.pump();

      expect(completedResult, isFalse);
      expect(find.text('Try Again'), findsOneWidget);

      // Tap retry
      await tester.tap(find.text('Try Again'));
      await tester.pump();

      expect(find.text('Check'), findsOneWidget);
    });
  });
}
