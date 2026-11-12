import 'dart:convert';

/// Represents a thematic curriculum unit (e.g. Unit 3: Familie & Leute)
class CurriculumUnit {
  const CurriculumUnit({
    required this.id,
    required this.level,
    required this.unitNumber,
    required this.titleDe,
    required this.titleEn,
    this.titleAr,
    required this.topicKey,
  });

  final int id;
  final String level;
  final int unitNumber;
  final String titleDe;
  final String titleEn;
  final String? titleAr;
  final String topicKey;

  String localizedTitle(String languageCode) {
    if (languageCode == 'ar' && titleAr != null && titleAr!.isNotEmpty) {
      return titleAr!;
    }
    return titleEn;
  }

  factory CurriculumUnit.fromJson(Map<String, dynamic> json) {
    return CurriculumUnit(
      id: json['id'] as int,
      level: json['level'] as String,
      unitNumber: json['unit_number'] as int,
      titleDe: json['title_de'] as String,
      titleEn: json['title_en'] as String,
      titleAr: json['title_ar'] as String?,
      topicKey: json['topic_key'] as String,
    );
  }
}

/// Type of lesson in the curriculum
enum LessonType {
  vocabulary,
  grammar,
  review,
  unitTest,
  levelTest;

  static LessonType fromString(String val) {
    switch (val) {
      case 'grammar':
        return LessonType.grammar;
      case 'review':
        return LessonType.review;
      case 'unit_test':
        return LessonType.unitTest;
      case 'level_test':
        return LessonType.levelTest;
      case 'vocabulary':
      default:
        return LessonType.vocabulary;
    }
  }
}

/// Represents a single lesson or quiz within a unit
class CurriculumLesson {
  const CurriculumLesson({
    required this.id,
    this.unitId,
    required this.level,
    required this.titleDe,
    required this.titleEn,
    required this.sortOrder,
    required this.type,
    this.passThreshold = 0.70,
    this.grammarContent,
  });

  final int id;
  final int? unitId;
  final String level;
  final String titleDe;
  final String titleEn;
  final int sortOrder;
  final LessonType type;
  final double passThreshold;
  final String? grammarContent;

  String localizedTitle(String languageCode) {
    if (languageCode == 'ar') {
      switch (type) {
        case LessonType.vocabulary:
          return 'مفردات $sortOrder';
        case LessonType.grammar:
          return 'قواعد: $titleDe';
        case LessonType.review:
          return 'مراجعة تثبيت';
        case LessonType.unitTest:
          return 'اختبار الوحدة';
        case LessonType.levelTest:
          return 'اختبار اجتياز المستوى $level';
      }
    }
    return titleEn;
  }

  factory CurriculumLesson.fromJson(Map<String, dynamic> json) {
    return CurriculumLesson(
      id: json['id'] as int,
      unitId: json['unit_id'] as int?,
      level: json['level'] as String,
      titleDe: json['title_de'] as String,
      titleEn: json['title_en'] as String,
      sortOrder: json['sort_order'] as int,
      type: LessonType.fromString(json['lesson_type'] as String? ?? 'vocabulary'),
      passThreshold: (json['pass_threshold'] as num?)?.toDouble() ?? 0.70,
      grammarContent: json['grammar_content'] as String?,
    );
  }
}

/// A vocabulary word entry
class CurriculumWord {
  const CurriculumWord({
    required this.id,
    required this.lemma,
    required this.level,
    required this.topic,
    required this.pos,
    this.gender,
    this.plural,
    this.conjugation,
    required this.translationEn,
    required this.translationAr,
    this.frequencyRank,
  });

  final int id;
  final String lemma;
  final String level;
  final String topic;
  final String pos;
  final String? gender;
  final String? plural;
  final String? conjugation;
  final String translationEn;
  final String translationAr;
  final int? frequencyRank;

  String localizedTranslation(String languageCode) {
    if (languageCode == 'ar') return translationAr;
    return translationEn;
  }

  factory CurriculumWord.fromJson(Map<String, dynamic> json) {
    return CurriculumWord(
      id: json['id'] as int,
      lemma: json['lemma'] as String,
      level: json['level'] as String,
      topic: json['topic'] as String,
      pos: json['pos'] as String,
      gender: json['gender'] as String?,
      plural: json['plural'] as String?,
      conjugation: json['conjugation'] as String?,
      translationEn: json['translation_en'] as String,
      translationAr: json['translation_ar'] as String,
      frequencyRank: json['frequency_rank'] as int?,
    );
  }
}

/// An interactive exercise
class CurriculumExercise {
  const CurriculumExercise({
    required this.id,
    required this.lessonId,
    this.passageId,
    required this.skill,
    required this.exerciseType,
    required this.prompt,
    this.audioText,
    required this.correctAnswer,
    this.options,
    this.isGraded = true,
    this.isTestPool = false,
    required this.sortOrder,
  });

  final int id;
  final int lessonId;
  final int? passageId;
  final String skill; // listening, reading, writing, speaking
  final String exerciseType; // listen_choose, type_fill_blank, match_pairs, repeat_prompt
  final String prompt;
  final String? audioText;
  final String correctAnswer;
  final List<String>? options;
  final bool isGraded;
  final bool isTestPool;
  final int sortOrder;

  Map<String, dynamic> get promptJson {
    try {
      return jsonDecode(prompt) as Map<String, dynamic>;
    } catch (_) {
      return {'text': prompt};
    }
  }

  factory CurriculumExercise.fromJson(Map<String, dynamic> json) {
    List<String>? parsedOptions;
    if (json['options'] != null) {
      try {
        final raw = jsonDecode(json['options'] as String);
        if (raw is List) {
          parsedOptions = raw.map((e) => e.toString()).toList();
        }
      } catch (_) {}
    }

    return CurriculumExercise(
      id: json['id'] as int,
      lessonId: json['lesson_id'] as int,
      passageId: json['passage_id'] as int?,
      skill: json['skill'] as String,
      exerciseType: json['exercise_type'] as String,
      prompt: json['prompt'] as String,
      audioText: json['audio_text'] as String?,
      correctAnswer: json['correct_answer'] as String,
      options: parsedOptions,
      isGraded: (json['is_graded'] as int? ?? 1) == 1,
      isTestPool: (json['is_test_pool'] as int? ?? 0) == 1,
      sortOrder: json['sort_order'] as int,
    );
  }
}

/// Reading comprehension passage
class CurriculumReadingPassage {
  const CurriculumReadingPassage({
    required this.id,
    required this.level,
    this.unitId,
    required this.titleDe,
    required this.textDe,
    this.textAr,
  });

  final int id;
  final String level;
  final int? unitId;
  final String titleDe;
  final String textDe;
  final String? textAr;

  factory CurriculumReadingPassage.fromJson(Map<String, dynamic> json) {
    return CurriculumReadingPassage(
      id: json['id'] as int,
      level: json['level'] as String,
      unitId: json['unit_id'] as int?,
      titleDe: json['title_de'] as String,
      textDe: json['text_de'] as String,
      textAr: json['text_ar'] as String?,
    );
  }
}

