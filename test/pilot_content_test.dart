import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:deutschy/src/features/study/data/content_repository.dart';
import 'package:deutschy/src/features/study/domain/curriculum_models.dart';

void main() {
  late ContentRepository repo;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    final file = File('assets/deutschy_content.json');
    final jsonStr = file.readAsStringSync();
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;

    repo = ContentRepository();
    repo.loadFromData(data);
  });

  group('Pilot Content Integration Tests', () {
    test('content repo loaded pilot learn cards successfully', () {
      expect(repo.allLearnCards.length, equals(9));
    });

    test('Unit 1 Lesson 10101 has 2 presentation cards (concept + phonetic)', () {
      final cards = repo.getLearnCardsForLesson(10101);
      expect(cards.length, equals(2));
      expect(cards[0].type, equals(LearnCardType.concept));
      expect(cards[0].customPromptDe, contains('Hallo'));
      expect(cards[1].type, equals(LearnCardType.phonetic));
      expect(cards[1].customPromptDe, equals('ch'));
      expect(cards[1].contrastPairs.length, equals(2));
    });

    test('Unit 1 Lesson 10102 has 1 phonetic card with special German umlauts', () {
      final cards = repo.getLearnCardsForLesson(10102);
      expect(cards.length, equals(1));
      expect(cards[0].type, equals(LearnCardType.phonetic));
      expect(cards[0].customPromptDe, contains('ä'));
      expect(cards[0].sampleWords, contains('Äpfel'));
      expect(cards[0].sampleWords, contains('schön'));
    });

    test('Unit 5 Lesson 10001 has 6 presentation cards (5 nouns + 1 chunk)', () {
      final cards = repo.getLearnCardsForLesson(10001);
      expect(cards.length, equals(6));

      // 5 Nouns with word links
      for (int i = 0; i < 5; i++) {
        expect(cards[i].type, equals(LearnCardType.nounArticle));
        expect(cards[i].wordId, isNotNull);
        final word = repo.getWordById(cards[i].wordId!);
        expect(word, isNotNull);
        expect(word!.gender, isNotNull);
      }

      // Check card 0: Mutter (die)
      final mutterWord = repo.getWordById(cards[0].wordId!);
      expect(mutterWord!.lemma, equals('Mutter'));
      expect(mutterWord.gender, equals('die'));

      // Check card 1: Vater (der)
      final vaterWord = repo.getWordById(cards[1].wordId!);
      expect(vaterWord!.lemma, equals('Vater'));
      expect(vaterWord.gender, equals('der'));

      // Check card 2: Kind (das)
      final kindWord = repo.getWordById(cards[2].wordId!);
      expect(kindWord!.lemma, equals('Kind'));
      expect(kindWord.gender, equals('das'));

      // Check card 5: Phrase chunk (Ich habe einen Bruder)
      expect(cards[5].type, equals(LearnCardType.phraseChunk));
      expect(cards[5].chunkDe, equals('Ich habe einen Bruder'));
      expect(cards[5].highlightToken, equals('einen'));
      expect(cards[5].tileTokens, equals(['Ich', 'habe', 'einen', 'Bruder']));
    });

    test('all Arabic translations in pilot cards include BiDi isolates', () {
      for (final card in repo.allLearnCards) {
        if (card.sentenceAr != null) {
          expect(card.sentenceAr, contains('\u2066'));
          expect(card.sentenceAr, contains('\u2069'));
        }
        if (card.mouthTipAr != null) {
          expect(card.mouthTipAr, contains('\u2066'));
          expect(card.mouthTipAr, contains('\u2069'));
        }
      }
    });
  });
}
