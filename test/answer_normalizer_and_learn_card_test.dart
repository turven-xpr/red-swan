import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:deutschy/src/core/utils/answer_normalizer.dart';
import 'package:deutschy/src/features/study/domain/curriculum_models.dart';

void main() {
  group('AnswerNormalizer Tests', () {
    test('cleanBiDi strips isolate marks', () {
      const input = '\u2066Der Vater\u2069';
      expect(AnswerNormalizer.cleanBiDi(input), equals('Der Vater'));
    });

    test('normalize handles case, punctuation, and German keyboard variants', () {
      // Umlauts and eszett
      expect(AnswerNormalizer.normalize('Der Apfel ist schön.'), equals('der apfel ist schoen'));
      expect(AnswerNormalizer.normalize('Ich weiß nicht!'), equals('ich weiss nicht'));
      expect(AnswerNormalizer.normalize('Über dem Tisch...'), equals('ueber dem tisch'));
      expect(AnswerNormalizer.normalize('  Groß   und   Kühl  '), equals('gross und kuehl'));
    });

    test('isMatch evaluates forgivingly across BiDi and keyboards', () {
      expect(
        AnswerNormalizer.isMatch('\u2066Der Apfel ist rot.\u2069', 'Der Apfel ist rot'),
        isTrue,
      );
      expect(
        AnswerNormalizer.isMatch('Ich habe einen Bruder', 'Ich habe einen Bruder.'),
        isTrue,
      );
      expect(
        AnswerNormalizer.isMatch('heiss', 'heiß'),
        isTrue,
      );
      expect(
        AnswerNormalizer.isMatch('Maedchen', 'Mädchen'),
        isTrue,
      );
      expect(
        AnswerNormalizer.isMatch('Falsche Antwort', 'Richtig'),
        isFalse,
      );
    });
  });

  group('CurriculumLearnCard Polymorphic Contracts', () {
    test('phonetic card deserializes with mouth tips and contrast pairs', () {
      final json = {
        'id': 'card_phonetic_ch',
        'lesson_id': 10101,
        'card_type': 'phonetic',
        'sort_order': 1,
        'custom_prompt_de': 'ch',
        'data_json': jsonEncode({
          'mouth_tip_de': 'Zunge an den Gaumen legen.',
          'mouth_tip_en': 'Place tongue against hard palate.',
          'mouth_tip_ar': '\u2066ضع اللسان على الحنك.\u2069',
          'contrast_pairs': [
            {'de': 'ich', 'vs': 'ach'}
          ],
          'sample_words': ['Milch', 'sprechen', 'Licht'],
        }),
      };

      final card = CurriculumLearnCard.fromJson(json);
      expect(card.type, equals(LearnCardType.phonetic));
      expect(card.customPromptDe, equals('ch'));
      expect(card.mouthTipEn, equals('Place tongue against hard palate.'));
      expect(card.sampleWords, contains('Milch'));
      expect(card.contrastPairs.first['de'], equals('ich'));
    });

    test('noun_article card deserializes with sentence and tile tokens', () {
      final json = {
        'id': 'card_noun_vater',
        'lesson_id': 10401,
        'card_type': 'noun_article',
        'sort_order': 1,
        'word_id': 2001,
        'sentence_id': 3001,
        'data_json': {
          'example_sentence_de': 'Der Vater kocht gern.',
          'sentence_en': 'The father likes to cook.',
          'tile_tokens': ['Der', 'Vater', 'kocht', 'gern'],
        },
      };

      final card = CurriculumLearnCard.fromJson(json);
      expect(card.type, equals(LearnCardType.nounArticle));
      expect(card.wordId, equals(2001));
      expect(card.sentenceId, equals(3001));
      expect(card.exampleSentenceDe, equals('Der Vater kocht gern.'));
      expect(card.tileTokens, equals(['Der', 'Vater', 'kocht', 'gern']));
    });

    test('phrase_chunk card deserializes with highlighted token and grammar note', () {
      final json = {
        'id': 'card_chunk_bruder',
        'lesson_id': 10401,
        'card_type': 'phrase_chunk',
        'sort_order': 2,
        'data_json': {
          'chunk_de': 'Ich habe einen Bruder',
          'highlight_token': 'einen',
          'grammatical_note_en': 'Direct object masculine: ein -> einen',
        },
      };

      final card = CurriculumLearnCard.fromJson(json);
      expect(card.type, equals(LearnCardType.phraseChunk));
      expect(card.chunkDe, equals('Ich habe einen Bruder'));
      expect(card.highlightToken, equals('einen'));
      expect(card.grammaticalNoteEn, equals('Direct object masculine: ein -> einen'));
    });
  });
}

