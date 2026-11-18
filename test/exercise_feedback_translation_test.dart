import 'dart:convert';
import 'dart:io';

import 'package:deutschy/src/features/study/domain/curriculum_models.dart';
import 'package:deutschy/src/features/study/domain/exercise_localizer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Exercise Feedback Translation Tests', () {
    test('Exercise 40034 (sieben) resolves correctly in Arabic, Spanish, English', () {
      const ex = CurriculumExercise(
        id: 40034,
        lessonId: 10105,
        skill: 'listening',
        exerciseType: 'listen_choose',
        prompt: '{"de": "sieben", "question_en": "Listen to the number starting with S.", "question_ar": "استمع للرقم الذي يبدأ بحرف S.", "question_es": "Escucha el número que empieza con S."}',
        audioText: 'sieben',
        correctAnswer: 'sieben',
        options: ['acht', 'zehn', 'sechs', 'sieben'],
        sortOrder: 2,
      );

      final ar = ExerciseLocalizer.resolveFeedbackTranslation(ex, 'ar');
      expect(ar, isNotNull);
      expect(ar!.german, equals('sieben'));
      expect(ar.translation, equals('سبعة'));
      expect(ar.audioText, equals('sieben'));

      final es = ExerciseLocalizer.resolveFeedbackTranslation(ex, 'es');
      expect(es, isNotNull);
      expect(es!.german, equals('sieben'));
      expect(es.translation, equals('siete'));

      final en = ExerciseLocalizer.resolveFeedbackTranslation(ex, 'en');
      expect(en, isNotNull);
      expect(en!.german, equals('sieben'));
      expect(en.translation, equals('seven'));
    });

    test('type_fill_blank resolves completed sentence with hint', () {
      const ex = CurriculumExercise(
        id: 30003,
        lessonId: 10101,
        skill: 'writing',
        exerciseType: 'type_fill_blank',
        prompt: '{"sentence_de": "Meine ___ kocht sehr gut.", "hint_en": "My mother cooks very well.", "hint_ar": "أمي تطبخ جيداً جداً.", "question_ar": "اكتب الكلمة الناقصة."}',
        audioText: 'Meine Mutter kocht sehr gut.',
        correctAnswer: 'Mutter',
        sortOrder: 3,
      );

      final ar = ExerciseLocalizer.resolveFeedbackTranslation(ex, 'ar');
      expect(ar, isNotNull);
      expect(ar!.german, equals('Meine Mutter kocht sehr gut.'));
      expect(ar.translation, equals('أمي تطبخ جيداً جداً.'));

      final en = ExerciseLocalizer.resolveFeedbackTranslation(ex, 'en');
      expect(en, isNotNull);
      expect(en!.translation, equals('My mother cooks very well.'));
    });

    test('match_pairs resolves German term and localized answer', () {
      const ex = CurriculumExercise(
        id: 30001,
        lessonId: 10101,
        skill: 'reading',
        exerciseType: 'match_pairs',
        prompt: '{"de": "Mutter", "gender": "die", "question_ar": "ما معنى هذه الكلمة؟"}',
        audioText: 'Mutter',
        correctAnswer: 'mother',
        sortOrder: 1,
      );

      final ar = ExerciseLocalizer.resolveFeedbackTranslation(ex, 'ar');
      expect(ar, isNotNull);
      expect(ar!.german, equals('Mutter'));
      expect(ar.translation, equals('أمّ'));

      final es = ExerciseLocalizer.resolveFeedbackTranslation(ex, 'es');
      expect(es, isNotNull);
      expect(es!.translation, equals('madre'));
    });

    test('All 433 shipped exercises produce a valid non-empty translation', () {
      final file = File('assets/deutschy_content.json');
      expect(file.existsSync(), isTrue);

      final data = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final exercisesList = (data['exercises'] as List)
          .map((e) => CurriculumExercise.fromJson(e as Map<String, dynamic>))
          .toList();

      expect(exercisesList.length, greaterThanOrEqualTo(400));

      for (final ex in exercisesList) {
        final ar = ExerciseLocalizer.resolveFeedbackTranslation(ex, 'ar');
        expect(ar, isNotNull, reason: 'Exercise ${ex.id} (${ex.exerciseType}) failed in Arabic');
        expect(ar!.translation.trim(), isNotEmpty, reason: 'Exercise ${ex.id} translation is empty in Arabic');

        final es = ExerciseLocalizer.resolveFeedbackTranslation(ex, 'es');
        expect(es, isNotNull, reason: 'Exercise ${ex.id} (${ex.exerciseType}) failed in Spanish');
        expect(es!.translation.trim(), isNotEmpty, reason: 'Exercise ${ex.id} translation is empty in Spanish');

        final en = ExerciseLocalizer.resolveFeedbackTranslation(ex, 'en');
        expect(en, isNotNull, reason: 'Exercise ${ex.id} (${ex.exerciseType}) failed in English');
        expect(en!.translation.trim(), isNotEmpty, reason: 'Exercise ${ex.id} translation is empty in English');
      }
    });
  });
}

