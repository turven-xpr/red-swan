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

  group('Intro & A1 Pilot Content Integration Tests', () {
    test('content repo loaded 153 learn cards successfully', () {
      expect(repo.allLearnCards.length, equals(153));
    });

    test('Unit 1 Lesson 10101 (Deutsch entdecken) has 6 cognate concept cards', () {
      final cards = repo.getLearnCardsForLesson(10101);
      expect(cards.length, equals(6));
      expect(cards[0].chunkDe, contains('Hotel'));
      expect(cards[1].chunkDe, contains('Taxi'));
      expect(cards[2].chunkDe, contains('Radio'));
      expect(cards[3].chunkDe, contains('Bus'));
      expect(cards[4].chunkDe, contains('Musik'));
      expect(cards[5].chunkDe, contains('Café'));
    });

    test('Unit 1 Lesson 10102 (Buchstaben A–F) teaches A to F with anchor words', () {
      final cards = repo.getLearnCardsForLesson(10102);
      expect(cards.length, equals(6));

      expect(cards[0].customPromptDe, equals('A a'));
      expect(cards[0].anchorWordDe, equals('der Apfel'));
      expect(cards[0].anchorWordAr, contains('تفاحة'));

      expect(cards[1].customPromptDe, equals('B b'));
      expect(cards[1].anchorWordDe, equals('der Ball'));

      expect(cards[2].customPromptDe, equals('C c'));
      expect(cards[2].anchorWordDe, equals('der Computer'));

      expect(cards[3].customPromptDe, equals('D d'));
      expect(cards[3].anchorWordDe, equals('Danke'));

      expect(cards[4].customPromptDe, equals('E e'));
      expect(cards[4].anchorWordDe, equals('der Elefant'));

      expect(cards[5].customPromptDe, equals('F f'));
      expect(cards[5].anchorWordDe, equals('das Fahrrad'));
    });

    test('Unit 1 Lesson 10107 (Umlaute & Eszett) strictly teaches ä, ö, ü, ß', () {
      final cards = repo.getLearnCardsForLesson(10107);
      expect(cards.length, equals(4));

      expect(cards[0].customPromptDe, equals('Ä ä'));
      expect(cards[0].anchorWordDe, equals('der Käse'));

      expect(cards[1].customPromptDe, equals('Ö ö'));
      expect(cards[1].anchorWordDe, equals('schön'));

      expect(cards[2].customPromptDe, equals('Ü ü'));
      expect(cards[2].anchorWordDe, equals('fünf'));

      expect(cards[3].customPromptDe, equals('ß'));
      expect(cards[3].anchorWordDe, equals('weiß'));
    });

    test('Unit 2 Lesson 10202 (Zahlen 0–6) teaches digits 0 to 6 sequentially', () {
      final cards = repo.getLearnCardsForLesson(10202);
      expect(cards.length, equals(7));
      expect(cards[0].chunkDe, equals('null'));
      expect(cards[1].chunkDe, equals('eins'));
      expect(cards[6].chunkDe, equals('sechs'));
    });

    test('Unit 3 Lesson 10301 (Begrüßung) teaches standard greetings', () {
      final cards = repo.getLearnCardsForLesson(10301);
      expect(cards.length, equals(5));
      expect(cards[0].chunkDe, equals('Guten Morgen'));
      expect(cards[1].chunkDe, equals('Guten Tag'));
      expect(cards[4].chunkDe, equals('Auf Wiedersehen'));
    });

    test('Unit 4 Lesson 10311 (Länder & Sprachen) teaches countries & languages', () {
      final cards = repo.getLearnCardsForLesson(10311);
      expect(cards.length, equals(6));
      expect(cards[0].chunkDe, equals('Deutschland'));
      expect(cards[1].chunkDe, equals('Deutsch'));
      expect(cards[2].chunkDe, equals('Syrien'));
      expect(cards[4].chunkDe, equals('Arabisch'));
    });

    test('Unit 5 Lesson 10001 (Familie Pilot) retains 6 presentation cards', () {
      final cards = repo.getLearnCardsForLesson(10001);
      expect(cards.length, equals(6));
      expect(cards[0].wordId, equals(1)); // Mutter
      expect(cards[1].wordId, equals(2)); // Vater
      expect(cards[5].chunkDe, equals('Ich habe einen Bruder'));
    });

    test('all Arabic translations across all cards include BiDi isolates', () {
      for (final card in repo.allLearnCards) {
        if (card.sentenceAr != null && card.sentenceAr!.isNotEmpty) {
          expect(card.sentenceAr, contains('\u2066'));
          expect(card.sentenceAr, contains('\u2069'));
        }
        if (card.anchorWordAr != null && card.anchorWordAr!.isNotEmpty) {
          expect(card.anchorWordAr, contains('\u2066'));
          expect(card.anchorWordAr, contains('\u2069'));
        }
      }
    });
  });
}
