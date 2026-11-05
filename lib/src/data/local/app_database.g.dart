// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $FlashcardsTable extends Flashcards
    with TableInfo<$FlashcardsTable, Flashcard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FlashcardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _germanMeta = const VerificationMeta('german');
  @override
  late final GeneratedColumn<String> german = GeneratedColumn<String>(
    'german',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _englishMeta = const VerificationMeta(
    'english',
  );
  @override
  late final GeneratedColumn<String> english = GeneratedColumn<String>(
    'english',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frenchMeta = const VerificationMeta('french');
  @override
  late final GeneratedColumn<String> french = GeneratedColumn<String>(
    'french',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _arabicMeta = const VerificationMeta('arabic');
  @override
  late final GeneratedColumn<String> arabic = GeneratedColumn<String>(
    'arabic',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _partOfSpeechMeta = const VerificationMeta(
    'partOfSpeech',
  );
  @override
  late final GeneratedColumn<String> partOfSpeech = GeneratedColumn<String>(
    'part_of_speech',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exampleGermanMeta = const VerificationMeta(
    'exampleGerman',
  );
  @override
  late final GeneratedColumn<String> exampleGerman = GeneratedColumn<String>(
    'example_german',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exampleEnglishMeta = const VerificationMeta(
    'exampleEnglish',
  );
  @override
  late final GeneratedColumn<String> exampleEnglish = GeneratedColumn<String>(
    'example_english',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exampleFrenchMeta = const VerificationMeta(
    'exampleFrench',
  );
  @override
  late final GeneratedColumn<String> exampleFrench = GeneratedColumn<String>(
    'example_french',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _themeMeta = const VerificationMeta('theme');
  @override
  late final GeneratedColumn<String> theme = GeneratedColumn<String>(
    'theme',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('A1'),
  );
  static const VerificationMeta _repetitionsMeta = const VerificationMeta(
    'repetitions',
  );
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
    'repetitions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _easeFactorMeta = const VerificationMeta(
    'easeFactor',
  );
  @override
  late final GeneratedColumn<double> easeFactor = GeneratedColumn<double>(
    'ease_factor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(2.5),
  );
  static const VerificationMeta _intervalDaysMeta = const VerificationMeta(
    'intervalDays',
  );
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
    'interval_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nextReviewDateMeta = const VerificationMeta(
    'nextReviewDate',
  );
  @override
  late final GeneratedColumn<DateTime> nextReviewDate =
      GeneratedColumn<DateTime>(
        'next_review_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    german,
    english,
    french,
    arabic,
    partOfSpeech,
    exampleGerman,
    exampleEnglish,
    exampleFrench,
    theme,
    level,
    repetitions,
    easeFactor,
    intervalDays,
    nextReviewDate,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'flashcards';
  @override
  VerificationContext validateIntegrity(
    Insertable<Flashcard> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('german')) {
      context.handle(
        _germanMeta,
        german.isAcceptableOrUnknown(data['german']!, _germanMeta),
      );
    } else if (isInserting) {
      context.missing(_germanMeta);
    }
    if (data.containsKey('english')) {
      context.handle(
        _englishMeta,
        english.isAcceptableOrUnknown(data['english']!, _englishMeta),
      );
    } else if (isInserting) {
      context.missing(_englishMeta);
    }
    if (data.containsKey('french')) {
      context.handle(
        _frenchMeta,
        french.isAcceptableOrUnknown(data['french']!, _frenchMeta),
      );
    }
    if (data.containsKey('arabic')) {
      context.handle(
        _arabicMeta,
        arabic.isAcceptableOrUnknown(data['arabic']!, _arabicMeta),
      );
    }
    if (data.containsKey('part_of_speech')) {
      context.handle(
        _partOfSpeechMeta,
        partOfSpeech.isAcceptableOrUnknown(
          data['part_of_speech']!,
          _partOfSpeechMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_partOfSpeechMeta);
    }
    if (data.containsKey('example_german')) {
      context.handle(
        _exampleGermanMeta,
        exampleGerman.isAcceptableOrUnknown(
          data['example_german']!,
          _exampleGermanMeta,
        ),
      );
    }
    if (data.containsKey('example_english')) {
      context.handle(
        _exampleEnglishMeta,
        exampleEnglish.isAcceptableOrUnknown(
          data['example_english']!,
          _exampleEnglishMeta,
        ),
      );
    }
    if (data.containsKey('example_french')) {
      context.handle(
        _exampleFrenchMeta,
        exampleFrench.isAcceptableOrUnknown(
          data['example_french']!,
          _exampleFrenchMeta,
        ),
      );
    }
    if (data.containsKey('theme')) {
      context.handle(
        _themeMeta,
        theme.isAcceptableOrUnknown(data['theme']!, _themeMeta),
      );
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    if (data.containsKey('repetitions')) {
      context.handle(
        _repetitionsMeta,
        repetitions.isAcceptableOrUnknown(
          data['repetitions']!,
          _repetitionsMeta,
        ),
      );
    }
    if (data.containsKey('ease_factor')) {
      context.handle(
        _easeFactorMeta,
        easeFactor.isAcceptableOrUnknown(data['ease_factor']!, _easeFactorMeta),
      );
    }
    if (data.containsKey('interval_days')) {
      context.handle(
        _intervalDaysMeta,
        intervalDays.isAcceptableOrUnknown(
          data['interval_days']!,
          _intervalDaysMeta,
        ),
      );
    }
    if (data.containsKey('next_review_date')) {
      context.handle(
        _nextReviewDateMeta,
        nextReviewDate.isAcceptableOrUnknown(
          data['next_review_date']!,
          _nextReviewDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextReviewDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Flashcard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Flashcard(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      german: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}german'],
      )!,
      english: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}english'],
      )!,
      french: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}french'],
      ),
      arabic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}arabic'],
      ),
      partOfSpeech: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}part_of_speech'],
      )!,
      exampleGerman: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}example_german'],
      ),
      exampleEnglish: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}example_english'],
      ),
      exampleFrench: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}example_french'],
      ),
      theme: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme'],
      ),
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level'],
      )!,
      repetitions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repetitions'],
      )!,
      easeFactor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ease_factor'],
      )!,
      intervalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_days'],
      )!,
      nextReviewDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_review_date'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FlashcardsTable createAlias(String alias) {
    return $FlashcardsTable(attachedDatabase, alias);
  }
}

class Flashcard extends DataClass implements Insertable<Flashcard> {
  final int id;
  final String german;
  final String english;
  final String? french;
  final String? arabic;
  final String partOfSpeech;
  final String? exampleGerman;
  final String? exampleEnglish;
  final String? exampleFrench;
  final String? theme;
  final String level;
  final int repetitions;
  final double easeFactor;
  final int intervalDays;
  final DateTime nextReviewDate;
  final DateTime createdAt;
  const Flashcard({
    required this.id,
    required this.german,
    required this.english,
    this.french,
    this.arabic,
    required this.partOfSpeech,
    this.exampleGerman,
    this.exampleEnglish,
    this.exampleFrench,
    this.theme,
    required this.level,
    required this.repetitions,
    required this.easeFactor,
    required this.intervalDays,
    required this.nextReviewDate,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['german'] = Variable<String>(german);
    map['english'] = Variable<String>(english);
    if (!nullToAbsent || french != null) {
      map['french'] = Variable<String>(french);
    }
    if (!nullToAbsent || arabic != null) {
      map['arabic'] = Variable<String>(arabic);
    }
    map['part_of_speech'] = Variable<String>(partOfSpeech);
    if (!nullToAbsent || exampleGerman != null) {
      map['example_german'] = Variable<String>(exampleGerman);
    }
    if (!nullToAbsent || exampleEnglish != null) {
      map['example_english'] = Variable<String>(exampleEnglish);
    }
    if (!nullToAbsent || exampleFrench != null) {
      map['example_french'] = Variable<String>(exampleFrench);
    }
    if (!nullToAbsent || theme != null) {
      map['theme'] = Variable<String>(theme);
    }
    map['level'] = Variable<String>(level);
    map['repetitions'] = Variable<int>(repetitions);
    map['ease_factor'] = Variable<double>(easeFactor);
    map['interval_days'] = Variable<int>(intervalDays);
    map['next_review_date'] = Variable<DateTime>(nextReviewDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FlashcardsCompanion toCompanion(bool nullToAbsent) {
    return FlashcardsCompanion(
      id: Value(id),
      german: Value(german),
      english: Value(english),
      french: french == null && nullToAbsent
          ? const Value.absent()
          : Value(french),
      arabic: arabic == null && nullToAbsent
          ? const Value.absent()
          : Value(arabic),
      partOfSpeech: Value(partOfSpeech),
      exampleGerman: exampleGerman == null && nullToAbsent
          ? const Value.absent()
          : Value(exampleGerman),
      exampleEnglish: exampleEnglish == null && nullToAbsent
          ? const Value.absent()
          : Value(exampleEnglish),
      exampleFrench: exampleFrench == null && nullToAbsent
          ? const Value.absent()
          : Value(exampleFrench),
      theme: theme == null && nullToAbsent
          ? const Value.absent()
          : Value(theme),
      level: Value(level),
      repetitions: Value(repetitions),
      easeFactor: Value(easeFactor),
      intervalDays: Value(intervalDays),
      nextReviewDate: Value(nextReviewDate),
      createdAt: Value(createdAt),
    );
  }

  factory Flashcard.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Flashcard(
      id: serializer.fromJson<int>(json['id']),
      german: serializer.fromJson<String>(json['german']),
      english: serializer.fromJson<String>(json['english']),
      french: serializer.fromJson<String?>(json['french']),
      arabic: serializer.fromJson<String?>(json['arabic']),
      partOfSpeech: serializer.fromJson<String>(json['partOfSpeech']),
      exampleGerman: serializer.fromJson<String?>(json['exampleGerman']),
      exampleEnglish: serializer.fromJson<String?>(json['exampleEnglish']),
      exampleFrench: serializer.fromJson<String?>(json['exampleFrench']),
      theme: serializer.fromJson<String?>(json['theme']),
      level: serializer.fromJson<String>(json['level']),
      repetitions: serializer.fromJson<int>(json['repetitions']),
      easeFactor: serializer.fromJson<double>(json['easeFactor']),
      intervalDays: serializer.fromJson<int>(json['intervalDays']),
      nextReviewDate: serializer.fromJson<DateTime>(json['nextReviewDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'german': serializer.toJson<String>(german),
      'english': serializer.toJson<String>(english),
      'french': serializer.toJson<String?>(french),
      'arabic': serializer.toJson<String?>(arabic),
      'partOfSpeech': serializer.toJson<String>(partOfSpeech),
      'exampleGerman': serializer.toJson<String?>(exampleGerman),
      'exampleEnglish': serializer.toJson<String?>(exampleEnglish),
      'exampleFrench': serializer.toJson<String?>(exampleFrench),
      'theme': serializer.toJson<String?>(theme),
      'level': serializer.toJson<String>(level),
      'repetitions': serializer.toJson<int>(repetitions),
      'easeFactor': serializer.toJson<double>(easeFactor),
      'intervalDays': serializer.toJson<int>(intervalDays),
      'nextReviewDate': serializer.toJson<DateTime>(nextReviewDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Flashcard copyWith({
    int? id,
    String? german,
    String? english,
    Value<String?> french = const Value.absent(),
    Value<String?> arabic = const Value.absent(),
    String? partOfSpeech,
    Value<String?> exampleGerman = const Value.absent(),
    Value<String?> exampleEnglish = const Value.absent(),
    Value<String?> exampleFrench = const Value.absent(),
    Value<String?> theme = const Value.absent(),
    String? level,
    int? repetitions,
    double? easeFactor,
    int? intervalDays,
    DateTime? nextReviewDate,
    DateTime? createdAt,
  }) => Flashcard(
    id: id ?? this.id,
    german: german ?? this.german,
    english: english ?? this.english,
    french: french.present ? french.value : this.french,
    arabic: arabic.present ? arabic.value : this.arabic,
    partOfSpeech: partOfSpeech ?? this.partOfSpeech,
    exampleGerman: exampleGerman.present
        ? exampleGerman.value
        : this.exampleGerman,
    exampleEnglish: exampleEnglish.present
        ? exampleEnglish.value
        : this.exampleEnglish,
    exampleFrench: exampleFrench.present
        ? exampleFrench.value
        : this.exampleFrench,
    theme: theme.present ? theme.value : this.theme,
    level: level ?? this.level,
    repetitions: repetitions ?? this.repetitions,
    easeFactor: easeFactor ?? this.easeFactor,
    intervalDays: intervalDays ?? this.intervalDays,
    nextReviewDate: nextReviewDate ?? this.nextReviewDate,
    createdAt: createdAt ?? this.createdAt,
  );
  Flashcard copyWithCompanion(FlashcardsCompanion data) {
    return Flashcard(
      id: data.id.present ? data.id.value : this.id,
      german: data.german.present ? data.german.value : this.german,
      english: data.english.present ? data.english.value : this.english,
      french: data.french.present ? data.french.value : this.french,
      arabic: data.arabic.present ? data.arabic.value : this.arabic,
      partOfSpeech: data.partOfSpeech.present
          ? data.partOfSpeech.value
          : this.partOfSpeech,
      exampleGerman: data.exampleGerman.present
          ? data.exampleGerman.value
          : this.exampleGerman,
      exampleEnglish: data.exampleEnglish.present
          ? data.exampleEnglish.value
          : this.exampleEnglish,
      exampleFrench: data.exampleFrench.present
          ? data.exampleFrench.value
          : this.exampleFrench,
      theme: data.theme.present ? data.theme.value : this.theme,
      level: data.level.present ? data.level.value : this.level,
      repetitions: data.repetitions.present
          ? data.repetitions.value
          : this.repetitions,
      easeFactor: data.easeFactor.present
          ? data.easeFactor.value
          : this.easeFactor,
      intervalDays: data.intervalDays.present
          ? data.intervalDays.value
          : this.intervalDays,
      nextReviewDate: data.nextReviewDate.present
          ? data.nextReviewDate.value
          : this.nextReviewDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Flashcard(')
          ..write('id: $id, ')
          ..write('german: $german, ')
          ..write('english: $english, ')
          ..write('french: $french, ')
          ..write('arabic: $arabic, ')
          ..write('partOfSpeech: $partOfSpeech, ')
          ..write('exampleGerman: $exampleGerman, ')
          ..write('exampleEnglish: $exampleEnglish, ')
          ..write('exampleFrench: $exampleFrench, ')
          ..write('theme: $theme, ')
          ..write('level: $level, ')
          ..write('repetitions: $repetitions, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('nextReviewDate: $nextReviewDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    german,
    english,
    french,
    arabic,
    partOfSpeech,
    exampleGerman,
    exampleEnglish,
    exampleFrench,
    theme,
    level,
    repetitions,
    easeFactor,
    intervalDays,
    nextReviewDate,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Flashcard &&
          other.id == this.id &&
          other.german == this.german &&
          other.english == this.english &&
          other.french == this.french &&
          other.arabic == this.arabic &&
          other.partOfSpeech == this.partOfSpeech &&
          other.exampleGerman == this.exampleGerman &&
          other.exampleEnglish == this.exampleEnglish &&
          other.exampleFrench == this.exampleFrench &&
          other.theme == this.theme &&
          other.level == this.level &&
          other.repetitions == this.repetitions &&
          other.easeFactor == this.easeFactor &&
          other.intervalDays == this.intervalDays &&
          other.nextReviewDate == this.nextReviewDate &&
          other.createdAt == this.createdAt);
}

class FlashcardsCompanion extends UpdateCompanion<Flashcard> {
  final Value<int> id;
  final Value<String> german;
  final Value<String> english;
  final Value<String?> french;
  final Value<String?> arabic;
  final Value<String> partOfSpeech;
  final Value<String?> exampleGerman;
  final Value<String?> exampleEnglish;
  final Value<String?> exampleFrench;
  final Value<String?> theme;
  final Value<String> level;
  final Value<int> repetitions;
  final Value<double> easeFactor;
  final Value<int> intervalDays;
  final Value<DateTime> nextReviewDate;
  final Value<DateTime> createdAt;
  const FlashcardsCompanion({
    this.id = const Value.absent(),
    this.german = const Value.absent(),
    this.english = const Value.absent(),
    this.french = const Value.absent(),
    this.arabic = const Value.absent(),
    this.partOfSpeech = const Value.absent(),
    this.exampleGerman = const Value.absent(),
    this.exampleEnglish = const Value.absent(),
    this.exampleFrench = const Value.absent(),
    this.theme = const Value.absent(),
    this.level = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.easeFactor = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.nextReviewDate = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  FlashcardsCompanion.insert({
    this.id = const Value.absent(),
    required String german,
    required String english,
    this.french = const Value.absent(),
    this.arabic = const Value.absent(),
    required String partOfSpeech,
    this.exampleGerman = const Value.absent(),
    this.exampleEnglish = const Value.absent(),
    this.exampleFrench = const Value.absent(),
    this.theme = const Value.absent(),
    this.level = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.easeFactor = const Value.absent(),
    this.intervalDays = const Value.absent(),
    required DateTime nextReviewDate,
    this.createdAt = const Value.absent(),
  }) : german = Value(german),
       english = Value(english),
       partOfSpeech = Value(partOfSpeech),
       nextReviewDate = Value(nextReviewDate);
  static Insertable<Flashcard> custom({
    Expression<int>? id,
    Expression<String>? german,
    Expression<String>? english,
    Expression<String>? french,
    Expression<String>? arabic,
    Expression<String>? partOfSpeech,
    Expression<String>? exampleGerman,
    Expression<String>? exampleEnglish,
    Expression<String>? exampleFrench,
    Expression<String>? theme,
    Expression<String>? level,
    Expression<int>? repetitions,
    Expression<double>? easeFactor,
    Expression<int>? intervalDays,
    Expression<DateTime>? nextReviewDate,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (german != null) 'german': german,
      if (english != null) 'english': english,
      if (french != null) 'french': french,
      if (arabic != null) 'arabic': arabic,
      if (partOfSpeech != null) 'part_of_speech': partOfSpeech,
      if (exampleGerman != null) 'example_german': exampleGerman,
      if (exampleEnglish != null) 'example_english': exampleEnglish,
      if (exampleFrench != null) 'example_french': exampleFrench,
      if (theme != null) 'theme': theme,
      if (level != null) 'level': level,
      if (repetitions != null) 'repetitions': repetitions,
      if (easeFactor != null) 'ease_factor': easeFactor,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (nextReviewDate != null) 'next_review_date': nextReviewDate,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  FlashcardsCompanion copyWith({
    Value<int>? id,
    Value<String>? german,
    Value<String>? english,
    Value<String?>? french,
    Value<String?>? arabic,
    Value<String>? partOfSpeech,
    Value<String?>? exampleGerman,
    Value<String?>? exampleEnglish,
    Value<String?>? exampleFrench,
    Value<String?>? theme,
    Value<String>? level,
    Value<int>? repetitions,
    Value<double>? easeFactor,
    Value<int>? intervalDays,
    Value<DateTime>? nextReviewDate,
    Value<DateTime>? createdAt,
  }) {
    return FlashcardsCompanion(
      id: id ?? this.id,
      german: german ?? this.german,
      english: english ?? this.english,
      french: french ?? this.french,
      arabic: arabic ?? this.arabic,
      partOfSpeech: partOfSpeech ?? this.partOfSpeech,
      exampleGerman: exampleGerman ?? this.exampleGerman,
      exampleEnglish: exampleEnglish ?? this.exampleEnglish,
      exampleFrench: exampleFrench ?? this.exampleFrench,
      theme: theme ?? this.theme,
      level: level ?? this.level,
      repetitions: repetitions ?? this.repetitions,
      easeFactor: easeFactor ?? this.easeFactor,
      intervalDays: intervalDays ?? this.intervalDays,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (german.present) {
      map['german'] = Variable<String>(german.value);
    }
    if (english.present) {
      map['english'] = Variable<String>(english.value);
    }
    if (french.present) {
      map['french'] = Variable<String>(french.value);
    }
    if (arabic.present) {
      map['arabic'] = Variable<String>(arabic.value);
    }
    if (partOfSpeech.present) {
      map['part_of_speech'] = Variable<String>(partOfSpeech.value);
    }
    if (exampleGerman.present) {
      map['example_german'] = Variable<String>(exampleGerman.value);
    }
    if (exampleEnglish.present) {
      map['example_english'] = Variable<String>(exampleEnglish.value);
    }
    if (exampleFrench.present) {
      map['example_french'] = Variable<String>(exampleFrench.value);
    }
    if (theme.present) {
      map['theme'] = Variable<String>(theme.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    if (easeFactor.present) {
      map['ease_factor'] = Variable<double>(easeFactor.value);
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (nextReviewDate.present) {
      map['next_review_date'] = Variable<DateTime>(nextReviewDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FlashcardsCompanion(')
          ..write('id: $id, ')
          ..write('german: $german, ')
          ..write('english: $english, ')
          ..write('french: $french, ')
          ..write('arabic: $arabic, ')
          ..write('partOfSpeech: $partOfSpeech, ')
          ..write('exampleGerman: $exampleGerman, ')
          ..write('exampleEnglish: $exampleEnglish, ')
          ..write('exampleFrench: $exampleFrench, ')
          ..write('theme: $theme, ')
          ..write('level: $level, ')
          ..write('repetitions: $repetitions, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('nextReviewDate: $nextReviewDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $WritingSubmissionsTable extends WritingSubmissions
    with TableInfo<$WritingSubmissionsTable, WritingSubmission> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WritingSubmissionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userTextMeta = const VerificationMeta(
    'userText',
  );
  @override
  late final GeneratedColumn<String> userText = GeneratedColumn<String>(
    'user_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aiFeedbackJsonMeta = const VerificationMeta(
    'aiFeedbackJson',
  );
  @override
  late final GeneratedColumn<String> aiFeedbackJson = GeneratedColumn<String>(
    'ai_feedback_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userText,
    aiFeedbackJson,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'writing_submissions';
  @override
  VerificationContext validateIntegrity(
    Insertable<WritingSubmission> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_text')) {
      context.handle(
        _userTextMeta,
        userText.isAcceptableOrUnknown(data['user_text']!, _userTextMeta),
      );
    } else if (isInserting) {
      context.missing(_userTextMeta);
    }
    if (data.containsKey('ai_feedback_json')) {
      context.handle(
        _aiFeedbackJsonMeta,
        aiFeedbackJson.isAcceptableOrUnknown(
          data['ai_feedback_json']!,
          _aiFeedbackJsonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WritingSubmission map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WritingSubmission(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_text'],
      )!,
      aiFeedbackJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ai_feedback_json'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WritingSubmissionsTable createAlias(String alias) {
    return $WritingSubmissionsTable(attachedDatabase, alias);
  }
}

class WritingSubmission extends DataClass
    implements Insertable<WritingSubmission> {
  final int id;
  final String userText;
  final String? aiFeedbackJson;
  final DateTime createdAt;
  const WritingSubmission({
    required this.id,
    required this.userText,
    this.aiFeedbackJson,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_text'] = Variable<String>(userText);
    if (!nullToAbsent || aiFeedbackJson != null) {
      map['ai_feedback_json'] = Variable<String>(aiFeedbackJson);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WritingSubmissionsCompanion toCompanion(bool nullToAbsent) {
    return WritingSubmissionsCompanion(
      id: Value(id),
      userText: Value(userText),
      aiFeedbackJson: aiFeedbackJson == null && nullToAbsent
          ? const Value.absent()
          : Value(aiFeedbackJson),
      createdAt: Value(createdAt),
    );
  }

  factory WritingSubmission.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WritingSubmission(
      id: serializer.fromJson<int>(json['id']),
      userText: serializer.fromJson<String>(json['userText']),
      aiFeedbackJson: serializer.fromJson<String?>(json['aiFeedbackJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userText': serializer.toJson<String>(userText),
      'aiFeedbackJson': serializer.toJson<String?>(aiFeedbackJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WritingSubmission copyWith({
    int? id,
    String? userText,
    Value<String?> aiFeedbackJson = const Value.absent(),
    DateTime? createdAt,
  }) => WritingSubmission(
    id: id ?? this.id,
    userText: userText ?? this.userText,
    aiFeedbackJson: aiFeedbackJson.present
        ? aiFeedbackJson.value
        : this.aiFeedbackJson,
    createdAt: createdAt ?? this.createdAt,
  );
  WritingSubmission copyWithCompanion(WritingSubmissionsCompanion data) {
    return WritingSubmission(
      id: data.id.present ? data.id.value : this.id,
      userText: data.userText.present ? data.userText.value : this.userText,
      aiFeedbackJson: data.aiFeedbackJson.present
          ? data.aiFeedbackJson.value
          : this.aiFeedbackJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WritingSubmission(')
          ..write('id: $id, ')
          ..write('userText: $userText, ')
          ..write('aiFeedbackJson: $aiFeedbackJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userText, aiFeedbackJson, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WritingSubmission &&
          other.id == this.id &&
          other.userText == this.userText &&
          other.aiFeedbackJson == this.aiFeedbackJson &&
          other.createdAt == this.createdAt);
}

class WritingSubmissionsCompanion extends UpdateCompanion<WritingSubmission> {
  final Value<int> id;
  final Value<String> userText;
  final Value<String?> aiFeedbackJson;
  final Value<DateTime> createdAt;
  const WritingSubmissionsCompanion({
    this.id = const Value.absent(),
    this.userText = const Value.absent(),
    this.aiFeedbackJson = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  WritingSubmissionsCompanion.insert({
    this.id = const Value.absent(),
    required String userText,
    this.aiFeedbackJson = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : userText = Value(userText);
  static Insertable<WritingSubmission> custom({
    Expression<int>? id,
    Expression<String>? userText,
    Expression<String>? aiFeedbackJson,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userText != null) 'user_text': userText,
      if (aiFeedbackJson != null) 'ai_feedback_json': aiFeedbackJson,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  WritingSubmissionsCompanion copyWith({
    Value<int>? id,
    Value<String>? userText,
    Value<String?>? aiFeedbackJson,
    Value<DateTime>? createdAt,
  }) {
    return WritingSubmissionsCompanion(
      id: id ?? this.id,
      userText: userText ?? this.userText,
      aiFeedbackJson: aiFeedbackJson ?? this.aiFeedbackJson,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userText.present) {
      map['user_text'] = Variable<String>(userText.value);
    }
    if (aiFeedbackJson.present) {
      map['ai_feedback_json'] = Variable<String>(aiFeedbackJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WritingSubmissionsCompanion(')
          ..write('id: $id, ')
          ..write('userText: $userText, ')
          ..write('aiFeedbackJson: $aiFeedbackJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SpeakingScenariosTable extends SpeakingScenarios
    with TableInfo<$SpeakingScenariosTable, SpeakingScenario> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpeakingScenariosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('A1'),
  );
  static const VerificationMeta _systemPromptMeta = const VerificationMeta(
    'systemPrompt',
  );
  @override
  late final GeneratedColumn<String> systemPrompt = GeneratedColumn<String>(
    'system_prompt',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _openingMessageMeta = const VerificationMeta(
    'openingMessage',
  );
  @override
  late final GeneratedColumn<String> openingMessage = GeneratedColumn<String>(
    'opening_message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    level,
    systemPrompt,
    openingMessage,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'speaking_scenarios';
  @override
  VerificationContext validateIntegrity(
    Insertable<SpeakingScenario> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    if (data.containsKey('system_prompt')) {
      context.handle(
        _systemPromptMeta,
        systemPrompt.isAcceptableOrUnknown(
          data['system_prompt']!,
          _systemPromptMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_systemPromptMeta);
    }
    if (data.containsKey('opening_message')) {
      context.handle(
        _openingMessageMeta,
        openingMessage.isAcceptableOrUnknown(
          data['opening_message']!,
          _openingMessageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_openingMessageMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SpeakingScenario map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpeakingScenario(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level'],
      )!,
      systemPrompt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}system_prompt'],
      )!,
      openingMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}opening_message'],
      )!,
    );
  }

  @override
  $SpeakingScenariosTable createAlias(String alias) {
    return $SpeakingScenariosTable(attachedDatabase, alias);
  }
}

class SpeakingScenario extends DataClass
    implements Insertable<SpeakingScenario> {
  final int id;
  final String title;
  final String description;
  final String level;
  final String systemPrompt;
  final String openingMessage;
  const SpeakingScenario({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.systemPrompt,
    required this.openingMessage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['level'] = Variable<String>(level);
    map['system_prompt'] = Variable<String>(systemPrompt);
    map['opening_message'] = Variable<String>(openingMessage);
    return map;
  }

  SpeakingScenariosCompanion toCompanion(bool nullToAbsent) {
    return SpeakingScenariosCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      level: Value(level),
      systemPrompt: Value(systemPrompt),
      openingMessage: Value(openingMessage),
    );
  }

  factory SpeakingScenario.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpeakingScenario(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      level: serializer.fromJson<String>(json['level']),
      systemPrompt: serializer.fromJson<String>(json['systemPrompt']),
      openingMessage: serializer.fromJson<String>(json['openingMessage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'level': serializer.toJson<String>(level),
      'systemPrompt': serializer.toJson<String>(systemPrompt),
      'openingMessage': serializer.toJson<String>(openingMessage),
    };
  }

  SpeakingScenario copyWith({
    int? id,
    String? title,
    String? description,
    String? level,
    String? systemPrompt,
    String? openingMessage,
  }) => SpeakingScenario(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    level: level ?? this.level,
    systemPrompt: systemPrompt ?? this.systemPrompt,
    openingMessage: openingMessage ?? this.openingMessage,
  );
  SpeakingScenario copyWithCompanion(SpeakingScenariosCompanion data) {
    return SpeakingScenario(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      level: data.level.present ? data.level.value : this.level,
      systemPrompt: data.systemPrompt.present
          ? data.systemPrompt.value
          : this.systemPrompt,
      openingMessage: data.openingMessage.present
          ? data.openingMessage.value
          : this.openingMessage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SpeakingScenario(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('level: $level, ')
          ..write('systemPrompt: $systemPrompt, ')
          ..write('openingMessage: $openingMessage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, description, level, systemPrompt, openingMessage);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpeakingScenario &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.level == this.level &&
          other.systemPrompt == this.systemPrompt &&
          other.openingMessage == this.openingMessage);
}

class SpeakingScenariosCompanion extends UpdateCompanion<SpeakingScenario> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> description;
  final Value<String> level;
  final Value<String> systemPrompt;
  final Value<String> openingMessage;
  const SpeakingScenariosCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.level = const Value.absent(),
    this.systemPrompt = const Value.absent(),
    this.openingMessage = const Value.absent(),
  });
  SpeakingScenariosCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String description,
    this.level = const Value.absent(),
    required String systemPrompt,
    required String openingMessage,
  }) : title = Value(title),
       description = Value(description),
       systemPrompt = Value(systemPrompt),
       openingMessage = Value(openingMessage);
  static Insertable<SpeakingScenario> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? level,
    Expression<String>? systemPrompt,
    Expression<String>? openingMessage,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (level != null) 'level': level,
      if (systemPrompt != null) 'system_prompt': systemPrompt,
      if (openingMessage != null) 'opening_message': openingMessage,
    });
  }

  SpeakingScenariosCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? description,
    Value<String>? level,
    Value<String>? systemPrompt,
    Value<String>? openingMessage,
  }) {
    return SpeakingScenariosCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      level: level ?? this.level,
      systemPrompt: systemPrompt ?? this.systemPrompt,
      openingMessage: openingMessage ?? this.openingMessage,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (systemPrompt.present) {
      map['system_prompt'] = Variable<String>(systemPrompt.value);
    }
    if (openingMessage.present) {
      map['opening_message'] = Variable<String>(openingMessage.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpeakingScenariosCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('level: $level, ')
          ..write('systemPrompt: $systemPrompt, ')
          ..write('openingMessage: $openingMessage')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FlashcardsTable flashcards = $FlashcardsTable(this);
  late final $WritingSubmissionsTable writingSubmissions =
      $WritingSubmissionsTable(this);
  late final $SpeakingScenariosTable speakingScenarios =
      $SpeakingScenariosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    flashcards,
    writingSubmissions,
    speakingScenarios,
  ];
}

typedef $$FlashcardsTableCreateCompanionBuilder =
    FlashcardsCompanion Function({
      Value<int> id,
      required String german,
      required String english,
      Value<String?> french,
      Value<String?> arabic,
      required String partOfSpeech,
      Value<String?> exampleGerman,
      Value<String?> exampleEnglish,
      Value<String?> exampleFrench,
      Value<String?> theme,
      Value<String> level,
      Value<int> repetitions,
      Value<double> easeFactor,
      Value<int> intervalDays,
      required DateTime nextReviewDate,
      Value<DateTime> createdAt,
    });
typedef $$FlashcardsTableUpdateCompanionBuilder =
    FlashcardsCompanion Function({
      Value<int> id,
      Value<String> german,
      Value<String> english,
      Value<String?> french,
      Value<String?> arabic,
      Value<String> partOfSpeech,
      Value<String?> exampleGerman,
      Value<String?> exampleEnglish,
      Value<String?> exampleFrench,
      Value<String?> theme,
      Value<String> level,
      Value<int> repetitions,
      Value<double> easeFactor,
      Value<int> intervalDays,
      Value<DateTime> nextReviewDate,
      Value<DateTime> createdAt,
    });

class $$FlashcardsTableFilterComposer
    extends Composer<_$AppDatabase, $FlashcardsTable> {
  $$FlashcardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get german => $composableBuilder(
    column: $table.german,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get english => $composableBuilder(
    column: $table.english,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get french => $composableBuilder(
    column: $table.french,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get arabic => $composableBuilder(
    column: $table.arabic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partOfSpeech => $composableBuilder(
    column: $table.partOfSpeech,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exampleGerman => $composableBuilder(
    column: $table.exampleGerman,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exampleEnglish => $composableBuilder(
    column: $table.exampleEnglish,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exampleFrench => $composableBuilder(
    column: $table.exampleFrench,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get easeFactor => $composableBuilder(
    column: $table.easeFactor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextReviewDate => $composableBuilder(
    column: $table.nextReviewDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FlashcardsTableOrderingComposer
    extends Composer<_$AppDatabase, $FlashcardsTable> {
  $$FlashcardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get german => $composableBuilder(
    column: $table.german,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get english => $composableBuilder(
    column: $table.english,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get french => $composableBuilder(
    column: $table.french,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get arabic => $composableBuilder(
    column: $table.arabic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partOfSpeech => $composableBuilder(
    column: $table.partOfSpeech,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exampleGerman => $composableBuilder(
    column: $table.exampleGerman,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exampleEnglish => $composableBuilder(
    column: $table.exampleEnglish,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exampleFrench => $composableBuilder(
    column: $table.exampleFrench,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get easeFactor => $composableBuilder(
    column: $table.easeFactor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextReviewDate => $composableBuilder(
    column: $table.nextReviewDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FlashcardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FlashcardsTable> {
  $$FlashcardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get german =>
      $composableBuilder(column: $table.german, builder: (column) => column);

  GeneratedColumn<String> get english =>
      $composableBuilder(column: $table.english, builder: (column) => column);

  GeneratedColumn<String> get french =>
      $composableBuilder(column: $table.french, builder: (column) => column);

  GeneratedColumn<String> get arabic =>
      $composableBuilder(column: $table.arabic, builder: (column) => column);

  GeneratedColumn<String> get partOfSpeech => $composableBuilder(
    column: $table.partOfSpeech,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exampleGerman => $composableBuilder(
    column: $table.exampleGerman,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exampleEnglish => $composableBuilder(
    column: $table.exampleEnglish,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exampleFrench => $composableBuilder(
    column: $table.exampleFrench,
    builder: (column) => column,
  );

  GeneratedColumn<String> get theme =>
      $composableBuilder(column: $table.theme, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => column,
  );

  GeneratedColumn<double> get easeFactor => $composableBuilder(
    column: $table.easeFactor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextReviewDate => $composableBuilder(
    column: $table.nextReviewDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$FlashcardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FlashcardsTable,
          Flashcard,
          $$FlashcardsTableFilterComposer,
          $$FlashcardsTableOrderingComposer,
          $$FlashcardsTableAnnotationComposer,
          $$FlashcardsTableCreateCompanionBuilder,
          $$FlashcardsTableUpdateCompanionBuilder,
          (
            Flashcard,
            BaseReferences<_$AppDatabase, $FlashcardsTable, Flashcard>,
          ),
          Flashcard,
          PrefetchHooks Function()
        > {
  $$FlashcardsTableTableManager(_$AppDatabase db, $FlashcardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FlashcardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FlashcardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FlashcardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> german = const Value.absent(),
                Value<String> english = const Value.absent(),
                Value<String?> french = const Value.absent(),
                Value<String?> arabic = const Value.absent(),
                Value<String> partOfSpeech = const Value.absent(),
                Value<String?> exampleGerman = const Value.absent(),
                Value<String?> exampleEnglish = const Value.absent(),
                Value<String?> exampleFrench = const Value.absent(),
                Value<String?> theme = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                Value<double> easeFactor = const Value.absent(),
                Value<int> intervalDays = const Value.absent(),
                Value<DateTime> nextReviewDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => FlashcardsCompanion(
                id: id,
                german: german,
                english: english,
                french: french,
                arabic: arabic,
                partOfSpeech: partOfSpeech,
                exampleGerman: exampleGerman,
                exampleEnglish: exampleEnglish,
                exampleFrench: exampleFrench,
                theme: theme,
                level: level,
                repetitions: repetitions,
                easeFactor: easeFactor,
                intervalDays: intervalDays,
                nextReviewDate: nextReviewDate,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String german,
                required String english,
                Value<String?> french = const Value.absent(),
                Value<String?> arabic = const Value.absent(),
                required String partOfSpeech,
                Value<String?> exampleGerman = const Value.absent(),
                Value<String?> exampleEnglish = const Value.absent(),
                Value<String?> exampleFrench = const Value.absent(),
                Value<String?> theme = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                Value<double> easeFactor = const Value.absent(),
                Value<int> intervalDays = const Value.absent(),
                required DateTime nextReviewDate,
                Value<DateTime> createdAt = const Value.absent(),
              }) => FlashcardsCompanion.insert(
                id: id,
                german: german,
                english: english,
                french: french,
                arabic: arabic,
                partOfSpeech: partOfSpeech,
                exampleGerman: exampleGerman,
                exampleEnglish: exampleEnglish,
                exampleFrench: exampleFrench,
                theme: theme,
                level: level,
                repetitions: repetitions,
                easeFactor: easeFactor,
                intervalDays: intervalDays,
                nextReviewDate: nextReviewDate,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FlashcardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FlashcardsTable,
      Flashcard,
      $$FlashcardsTableFilterComposer,
      $$FlashcardsTableOrderingComposer,
      $$FlashcardsTableAnnotationComposer,
      $$FlashcardsTableCreateCompanionBuilder,
      $$FlashcardsTableUpdateCompanionBuilder,
      (Flashcard, BaseReferences<_$AppDatabase, $FlashcardsTable, Flashcard>),
      Flashcard,
      PrefetchHooks Function()
    >;
typedef $$WritingSubmissionsTableCreateCompanionBuilder =
    WritingSubmissionsCompanion Function({
      Value<int> id,
      required String userText,
      Value<String?> aiFeedbackJson,
      Value<DateTime> createdAt,
    });
typedef $$WritingSubmissionsTableUpdateCompanionBuilder =
    WritingSubmissionsCompanion Function({
      Value<int> id,
      Value<String> userText,
      Value<String?> aiFeedbackJson,
      Value<DateTime> createdAt,
    });

class $$WritingSubmissionsTableFilterComposer
    extends Composer<_$AppDatabase, $WritingSubmissionsTable> {
  $$WritingSubmissionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userText => $composableBuilder(
    column: $table.userText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aiFeedbackJson => $composableBuilder(
    column: $table.aiFeedbackJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WritingSubmissionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WritingSubmissionsTable> {
  $$WritingSubmissionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userText => $composableBuilder(
    column: $table.userText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aiFeedbackJson => $composableBuilder(
    column: $table.aiFeedbackJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WritingSubmissionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WritingSubmissionsTable> {
  $$WritingSubmissionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userText =>
      $composableBuilder(column: $table.userText, builder: (column) => column);

  GeneratedColumn<String> get aiFeedbackJson => $composableBuilder(
    column: $table.aiFeedbackJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$WritingSubmissionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WritingSubmissionsTable,
          WritingSubmission,
          $$WritingSubmissionsTableFilterComposer,
          $$WritingSubmissionsTableOrderingComposer,
          $$WritingSubmissionsTableAnnotationComposer,
          $$WritingSubmissionsTableCreateCompanionBuilder,
          $$WritingSubmissionsTableUpdateCompanionBuilder,
          (
            WritingSubmission,
            BaseReferences<
              _$AppDatabase,
              $WritingSubmissionsTable,
              WritingSubmission
            >,
          ),
          WritingSubmission,
          PrefetchHooks Function()
        > {
  $$WritingSubmissionsTableTableManager(
    _$AppDatabase db,
    $WritingSubmissionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WritingSubmissionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WritingSubmissionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WritingSubmissionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userText = const Value.absent(),
                Value<String?> aiFeedbackJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => WritingSubmissionsCompanion(
                id: id,
                userText: userText,
                aiFeedbackJson: aiFeedbackJson,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userText,
                Value<String?> aiFeedbackJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => WritingSubmissionsCompanion.insert(
                id: id,
                userText: userText,
                aiFeedbackJson: aiFeedbackJson,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WritingSubmissionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WritingSubmissionsTable,
      WritingSubmission,
      $$WritingSubmissionsTableFilterComposer,
      $$WritingSubmissionsTableOrderingComposer,
      $$WritingSubmissionsTableAnnotationComposer,
      $$WritingSubmissionsTableCreateCompanionBuilder,
      $$WritingSubmissionsTableUpdateCompanionBuilder,
      (
        WritingSubmission,
        BaseReferences<
          _$AppDatabase,
          $WritingSubmissionsTable,
          WritingSubmission
        >,
      ),
      WritingSubmission,
      PrefetchHooks Function()
    >;
typedef $$SpeakingScenariosTableCreateCompanionBuilder =
    SpeakingScenariosCompanion Function({
      Value<int> id,
      required String title,
      required String description,
      Value<String> level,
      required String systemPrompt,
      required String openingMessage,
    });
typedef $$SpeakingScenariosTableUpdateCompanionBuilder =
    SpeakingScenariosCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> description,
      Value<String> level,
      Value<String> systemPrompt,
      Value<String> openingMessage,
    });

class $$SpeakingScenariosTableFilterComposer
    extends Composer<_$AppDatabase, $SpeakingScenariosTable> {
  $$SpeakingScenariosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get systemPrompt => $composableBuilder(
    column: $table.systemPrompt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get openingMessage => $composableBuilder(
    column: $table.openingMessage,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SpeakingScenariosTableOrderingComposer
    extends Composer<_$AppDatabase, $SpeakingScenariosTable> {
  $$SpeakingScenariosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get systemPrompt => $composableBuilder(
    column: $table.systemPrompt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get openingMessage => $composableBuilder(
    column: $table.openingMessage,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SpeakingScenariosTableAnnotationComposer
    extends Composer<_$AppDatabase, $SpeakingScenariosTable> {
  $$SpeakingScenariosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get systemPrompt => $composableBuilder(
    column: $table.systemPrompt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get openingMessage => $composableBuilder(
    column: $table.openingMessage,
    builder: (column) => column,
  );
}

class $$SpeakingScenariosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SpeakingScenariosTable,
          SpeakingScenario,
          $$SpeakingScenariosTableFilterComposer,
          $$SpeakingScenariosTableOrderingComposer,
          $$SpeakingScenariosTableAnnotationComposer,
          $$SpeakingScenariosTableCreateCompanionBuilder,
          $$SpeakingScenariosTableUpdateCompanionBuilder,
          (
            SpeakingScenario,
            BaseReferences<
              _$AppDatabase,
              $SpeakingScenariosTable,
              SpeakingScenario
            >,
          ),
          SpeakingScenario,
          PrefetchHooks Function()
        > {
  $$SpeakingScenariosTableTableManager(
    _$AppDatabase db,
    $SpeakingScenariosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpeakingScenariosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpeakingScenariosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpeakingScenariosTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<String> systemPrompt = const Value.absent(),
                Value<String> openingMessage = const Value.absent(),
              }) => SpeakingScenariosCompanion(
                id: id,
                title: title,
                description: description,
                level: level,
                systemPrompt: systemPrompt,
                openingMessage: openingMessage,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String description,
                Value<String> level = const Value.absent(),
                required String systemPrompt,
                required String openingMessage,
              }) => SpeakingScenariosCompanion.insert(
                id: id,
                title: title,
                description: description,
                level: level,
                systemPrompt: systemPrompt,
                openingMessage: openingMessage,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SpeakingScenariosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SpeakingScenariosTable,
      SpeakingScenario,
      $$SpeakingScenariosTableFilterComposer,
      $$SpeakingScenariosTableOrderingComposer,
      $$SpeakingScenariosTableAnnotationComposer,
      $$SpeakingScenariosTableCreateCompanionBuilder,
      $$SpeakingScenariosTableUpdateCompanionBuilder,
      (
        SpeakingScenario,
        BaseReferences<
          _$AppDatabase,
          $SpeakingScenariosTable,
          SpeakingScenario
        >,
      ),
      SpeakingScenario,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FlashcardsTableTableManager get flashcards =>
      $$FlashcardsTableTableManager(_db, _db.flashcards);
  $$WritingSubmissionsTableTableManager get writingSubmissions =>
      $$WritingSubmissionsTableTableManager(_db, _db.writingSubmissions);
  $$SpeakingScenariosTableTableManager get speakingScenarios =>
      $$SpeakingScenariosTableTableManager(_db, _db.speakingScenarios);
}
