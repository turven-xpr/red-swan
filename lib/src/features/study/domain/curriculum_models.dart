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
    this.titleEs,
    required this.topicKey,
  });

  final int id;
  final String level;
  final int unitNumber;
  final String titleDe;
  final String titleEn;
  final String? titleAr;
  final String? titleEs;
  final String topicKey;

  String localizedTitle(String languageCode) {
    if (languageCode == 'ar' && titleAr != null && titleAr!.isNotEmpty) {
      return titleAr!;
    }
    if (languageCode == 'es' && titleEs != null && titleEs!.isNotEmpty) {
      return titleEs!;
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
      titleEs: json['title_es'] as String?,
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
  levelTest,
  text,
  story;

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
      case 'text':
        return LessonType.text;
      case 'story':
        return LessonType.story;
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
    this.contentJson,
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
  final String? contentJson;

  String? get titleAr => localizedTitle('ar');

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
        case LessonType.text:
          return 'نص: $titleDe';
        case LessonType.story:
          return 'قصة: $titleDe';
      }
    }
    if (languageCode == 'es') {
      switch (type) {
        case LessonType.vocabulary:
          return 'Vocabulario $sortOrder';
        case LessonType.grammar:
          return 'Gramática: $titleDe';
        case LessonType.review:
          return 'Repaso de consolidación';
        case LessonType.unitTest:
          return 'Examen de unidad';
        case LessonType.levelTest:
          return 'Examen de nivel $level';
        case LessonType.text:
          return 'Texto: $titleDe';
        case LessonType.story:
          return 'Historia: $titleDe';
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
      contentJson: json['content_json'] as String?,
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
    this.translationEs,
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
  final String? translationEs;
  final int? frequencyRank;

  String localizedTranslation(String languageCode) {
    if (languageCode == 'ar') return translationAr;
    if (languageCode == 'es' && translationEs != null && translationEs!.isNotEmpty) {
      return translationEs!;
    }
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
      translationEs: json['translation_es'] as String?,
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

/// Supported presentation card variants in the Universal LearnCard engine
enum LearnCardType {
  phonetic,
  concept,
  nounArticle,
  phraseChunk;

  static LearnCardType fromString(String val) {
    switch (val) {
      case 'phonetic':
        return LearnCardType.phonetic;
      case 'concept':
        return LearnCardType.concept;
      case 'noun_article':
        return LearnCardType.nounArticle;
      case 'phrase_chunk':
      default:
        return LearnCardType.phraseChunk;
    }
  }

  String toDbString() {
    switch (this) {
      case LearnCardType.phonetic:
        return 'phonetic';
      case LearnCardType.concept:
        return 'concept';
      case LearnCardType.nounArticle:
        return 'noun_article';
      case LearnCardType.phraseChunk:
        return 'phrase_chunk';
    }
  }
}

/// Represents a presentation card shown before quizzes (PPP: Presentation phase)
class CurriculumLearnCard {
  const CurriculumLearnCard({
    required this.id,
    required this.lessonId,
    required this.type,
    required this.sortOrder,
    this.wordId,
    this.sentenceId,
    this.customPromptDe,
    required this.dataJson,
  });

  final String id;
  final int lessonId;
  final LearnCardType type;
  final int sortOrder;
  final int? wordId;
  final int? sentenceId;
  final String? customPromptDe;
  final Map<String, dynamic> dataJson;

  // Typed getters for polymorphic payloads
  String? get mouthTipDe => dataJson['mouth_tip_de'] as String?;
  String? get mouthTipEn => dataJson['mouth_tip_en'] as String?;
  String? get mouthTipAr => dataJson['mouth_tip_ar'] as String?;
  String? get mouthTipEs => dataJson['mouth_tip_es'] as String?;
  String? get swatchHex => dataJson['swatch_hex'] as String?;
  String? get chunkDe => dataJson['chunk_de'] as String?;
  String? get translationEn => (dataJson['translation_en'] ?? dataJson['concept_en']) as String?;
  String? get translationAr => (dataJson['translation_ar'] ?? dataJson['concept_ar']) as String?;
  String? get translationEs => (dataJson['translation_es'] ?? dataJson['concept_es']) as String?;
  String? get exampleSentenceDe => dataJson['example_sentence_de'] as String?;
  String? get exampleSentenceEn => (dataJson['example_sentence_en'] ?? dataJson['sentence_en']) as String?;
  String? get exampleSentenceAr => (dataJson['example_sentence_ar'] ?? dataJson['sentence_ar']) as String?;
  String? get exampleSentenceEs => (dataJson['example_sentence_es'] ?? dataJson['sentence_es']) as String?;
  String? get sentenceEn => dataJson['sentence_en'] as String?;
  String? get sentenceAr => dataJson['sentence_ar'] as String?;
  String? get sentenceEs => dataJson['sentence_es'] as String?;
  String? get highlightToken => dataJson['highlight_token'] as String?;
  String? get grammaticalNoteDe => dataJson['grammatical_note_de'] as String?;
  String? get grammaticalNoteEn => dataJson['grammatical_note_en'] as String?;
  String? get grammaticalNoteAr => dataJson['grammatical_note_ar'] as String?;
  String? get anchorWordDe => dataJson['anchor_word_de'] as String?;
  String? get anchorWordEn => dataJson['anchor_word_en'] as String?;
  String? get anchorWordAr => dataJson['anchor_word_ar'] as String?;
  String? get anchorWordEs => dataJson['anchor_word_es'] as String?;
  String? get phoneticNote => dataJson['phonetic_note'] as String?;

  String? localizedExampleSentence(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return exampleSentenceAr ?? sentenceAr ?? sentenceEn;
      case 'es':
        return exampleSentenceEs ?? sentenceEs ?? sentenceEn;
      default:
        return exampleSentenceEn ?? sentenceEn;
    }
  }

  String? localizedTranslation(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return translationAr ?? anchorWordAr ?? sentenceAr;
      case 'es':
        return translationEs ?? anchorWordEs ?? sentenceEs;
      default:
        return translationEn ?? anchorWordEn ?? sentenceEn;
    }
  }

  List<String> get tileTokens =>
      (dataJson['tile_tokens'] as List?)?.map((e) => e.toString()).toList() ?? const [];

  List<Map<String, dynamic>> get contrastPairs =>
      (dataJson['contrast_pairs'] as List?)
          ?.map((e) => Map<String, dynamic>.from(e as Map))
          .toList() ??
      const [];

  List<String> get sampleWords =>
      (dataJson['sample_words'] as List?)?.map((e) => e.toString()).toList() ?? const [];

  factory CurriculumLearnCard.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> parsedData = {};
    if (json['data_json'] is String) {
      try {
        parsedData = jsonDecode(json['data_json'] as String) as Map<String, dynamic>;
      } catch (_) {}
    } else if (json['data_json'] is Map) {
      parsedData = Map<String, dynamic>.from(json['data_json'] as Map);
    }

    return CurriculumLearnCard(
      id: json['id'].toString(),
      lessonId: json['lesson_id'] as int,
      type: LearnCardType.fromString((json['card_type'] ?? 'phrase_chunk') as String),
      sortOrder: json['sort_order'] as int? ?? 1,
      wordId: json['word_id'] as int?,
      sentenceId: json['sentence_id'] as int?,
      customPromptDe: json['custom_prompt_de'] as String?,
      dataJson: parsedData,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'lesson_id': lessonId,
        'card_type': type.toDbString(),
        'sort_order': sortOrder,
        'word_id': wordId,
        'sentence_id': sentenceId,
        'custom_prompt_de': customPromptDe,
        'data_json': jsonEncode(dataJson),
      };
}

