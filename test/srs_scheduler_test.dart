import 'package:flutter_test/flutter_test.dart';
import 'package:deutschy/src/features/vocabulary/application/srs_scheduler.dart';
import 'package:deutschy/src/data/local/app_database.dart';

/// Comprehensive unit tests for the SuperMemo-2 scheduler — the heart of
/// the entire language-learning loop.  Pure Dart is testable in-process
/// without bringing up a UI.
void main() {
  late AppDatabase database;
  late SrsScheduler scheduler;

  setUp(() {
    database = AppDatabase();
    scheduler = SrsScheduler();
  });

  tearDown(() => database.close());

  test('throws on out-of-range grade', () {
    final card = _karte();
    expect(() => scheduler.nextState(card, -1), throwsArgumentError);
    expect(() => scheduler.nextState(card, 6), throwsArgumentError);
  });

  test('first-time success: reviews=1, interval=1d', () {
    final next = scheduler.nextState(_karte(), 5);
    expect(next.repetitions, 1);
    expect(next.intervalDays, 1);
    expect(next.easeFactor, greaterThan(2.5)); // perfect recall always
                                                // bumps EF above 2.5
  });

  test('grade 4 (good): ease factor remains unchanged at 2.5', () {
    // SM-2 reference check: at grade=4 the delta is exactly 0, so EF is
    // preserved at the starting 2.5.
    final next = scheduler.nextState(_karte(), 4);
    expect(next.easeFactor, 2.5);
    expect(next.repetitions, 1);
  });

  test('two consecutive successes: 1 day then 6 days', () {
    var card = scheduler.nextState(_karte(), 5);
    expect(card.intervalDays, 1);
    card = scheduler.nextState(card, 5);
    expect(card.repetitions, 2);
    expect(card.intervalDays, 6);
  });

  test('three consecutive successes, ease factor applied', () {
    var card = scheduler.nextState(_karte(), 5);
    card = scheduler.nextState(card, 5);
    card = scheduler.nextState(card, 5);
    expect(card.repetitions, 3);
    expect(card.intervalDays, (6 * card.easeFactor).ceil());
  });

  test('a fail resets repetitions and schedules for next day', () {
    var card = scheduler.nextState(_karte(), 5);
    card = scheduler.nextState(card, 5);
    card = scheduler.nextState(card, 5);
    final c1 = scheduler.nextState(card, 1); // fail
    expect(c1.repetitions, 0);
    expect(c1.intervalDays, 1);
  });

  test('ease factor floor is 1.3', () {
    var card = _karte();
    for (var i = 0; i < 20; i++) {
      card = scheduler.nextState(card, 1); // hammer it with low scores
    }
    expect(card.easeFactor, lessThanOrEqualTo(1.3));
    expect(card.easeFactor, greaterThanOrEqualTo(1.3));
  });

  test('next review date advances by interval days', () {
    final fixed = DateTime(2024, 1, 1);
    final next = scheduler.nextState(_karte(), 5,
        now: fixed);
    expect(next.nextReviewDate, fixed.add(const Duration(days: 1)));
  });
}

Flashcard _karte() => Flashcard(
      id: 1,
      german: 'Tisch',
      english: 'table',
      partOfSpeech: 'noun',
      level: 'A1',
      repetitions: 0,
      easeFactor: 2.5,
      intervalDays: 0,
      nextReviewDate: DateTime.now(),
      createdAt: DateTime(2024, 1, 1),
    );
