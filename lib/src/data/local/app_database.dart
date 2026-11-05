import 'package:drift/drift.dart';

import 'connection/connection.dart' as impl;

part 'app_database.g.dart';

/// Vocabulary flashcards with full SRS metadata (SuperMemo-style fields).
/// Indexed so we can stream `due today` queries against thousands of rows
/// without scanning the table.
class Flashcards extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get german => text()();
  TextColumn get english => text()();
  TextColumn get french => text().nullable()();
  TextColumn get arabic => text().nullable()();
  TextColumn get partOfSpeech => text()();
  TextColumn get exampleGerman => text().nullable()();
  TextColumn get exampleEnglish => text().nullable()();
  TextColumn get exampleFrench => text().nullable()();
  TextColumn get theme => text().nullable()();
  TextColumn get level => text().withDefault(const Constant('A1'))();

  // SRS state
  IntColumn get repetitions => integer().withDefault(const Constant(0))();
  RealColumn get easeFactor => real().withDefault(const Constant(2.5))();
  IntColumn get intervalDays => integer().withDefault(const Constant(0))();
  DateTimeColumn get nextReviewDate => dateTime()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

/// A long-form piece of German writing submitted for AI correction.  We
/// always keep the original text locally so it survives offline edits.
class WritingSubmissions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userText => text()();
  TextColumn get aiFeedbackJson => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

/// One row per playground/scenario for the AI speaking coach.  Stored so
/// we never have to re-fetch from the network when the user revisits a
/// session.
class SpeakingScenarios extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get level => text().withDefault(const Constant('A1'))();
  TextColumn get systemPrompt => text()();
  TextColumn get openingMessage => text()();
}

@DriftDatabase(tables: [Flashcards, WritingSubmissions, SpeakingScenarios])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(impl.openConnection());
  AppDatabase.withExecutor(super.executor);

  @override
  int get schemaVersion => 1;

  // ---------- Flashcards ----------

  Stream<List<Flashcard>> watchAllFlashcards() =>
      (select(flashcards)..orderBy([(f) => OrderingTerm.asc(f.id)])).watch();

  Stream<List<Flashcard>> watchDueFlashcards({required DateTime now}) {
    final query = select(flashcards)
      ..where((f) => f.nextReviewDate.isSmallerOrEqualValue(now))
      ..orderBy([(f) => OrderingTerm.asc(f.nextReviewDate)]);
    return query.watch();
  }

  Future<int> insertFlashcard(FlashcardsCompanion card) =>
      into(flashcards).insert(card);

  Future<bool> updateFlashcard(Flashcard card) =>
      update(flashcards).replace(card);

  Future<int> insertMany(List<FlashcardsCompanion> cards) =>
      batch((b) => b.insertAll(flashcards, cards)).then((_) => cards.length);

  Future<int> deleteAllFlashcards() =>
      delete(flashcards).go();

  // ---------- Writing ----------

  Future<int> insertWriting(WritingSubmissionsCompanion s) =>
      into(writingSubmissions).insert(s);

  Stream<List<WritingSubmission>> watchAllWritings() =>
      (select(writingSubmissions)
            ..orderBy([(w) => OrderingTerm.desc(w.createdAt)]))
          .watch();

  // ---------- Speaking ----------

  Stream<List<SpeakingScenario>> watchAllScenarios() =>
      (select(speakingScenarios)..orderBy([(s) => OrderingTerm.asc(s.id)])).watch();

  Future<int> insertScenarios(List<SpeakingScenariosCompanion> scenarios) =>
      batch((b) => b.insertAll(speakingScenarios, scenarios))
          .then((_) => scenarios.length);

  Future<int> deleteAllScenarios() =>
      delete(speakingScenarios).go();
}
