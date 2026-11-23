import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:deutschy/src/core/audio/audio_playback_service.dart';
import 'package:deutschy/src/core/audio/stt_service.dart';
import 'package:deutschy/src/core/audio/tts_service.dart';
import 'package:deutschy/src/core/providers.dart';
import 'package:deutschy/src/core/utils/answer_normalizer.dart';
import 'package:deutschy/src/features/study/presentation/widgets/pronunciation_coach_widget.dart';

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

class _FakeSttService extends Fake implements SttService {
  String textToReturn = '';
  bool shouldThrowUnavailable = false;

  @override
  bool get availableOnDevice => !shouldThrowUnavailable;

  @override
  Future<String> listenOnce({
    required ValueChanged<String> onPartial,
    Duration listenFor = const Duration(seconds: 12),
  }) async {
    if (shouldThrowUnavailable) {
      throw const SttUnavailableException('Microphone unavailable in test');
    }
    onPartial(textToReturn);
    return textToReturn;
  }

  @override
  Future<void> cancel() async {}
}

void main() {
  late _FakeAudioService fakeAudio;
  late _FakeSttService fakeStt;

  setUp(() {
    fakeAudio = _FakeAudioService();
    fakeStt = _FakeSttService();
  });

  Widget buildTestableWidget(Widget child) {
    return ProviderScope(
      overrides: [
        audioPlaybackServiceProvider.overrideWithValue(fakeAudio),
        sttServiceProvider.overrideWithValue(fakeStt),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: child),
        ),
      ),
    );
  }

  group('AnswerNormalizer Similarity Tests', () {
    test('exact match produces 1.0 similarity', () {
      expect(AnswerNormalizer.similarity('Guten Tag', 'Guten Tag'), equals(1.0));
      expect(AnswerNormalizer.similarity('Guten Tag!', '\u2066guten tag\u2069'), equals(1.0));
    });

    test('minor typo produces high similarity (>= 0.70)', () {
      // 1 letter mismatch in 8-character string
      final sim = AnswerNormalizer.similarity('Guten Tag', 'Guten Tak');
      expect(sim, greaterThanOrEqualTo(0.70));
    });

    test('completely different strings produce low similarity', () {
      final sim = AnswerNormalizer.similarity('Guten Morgen', 'Auf Wiedersehen');
      expect(sim, lessThan(0.40));
    });
  });

  group('PronunciationCoachWidget Tests', () {
    testWidgets('plays native audio on tap', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          PronunciationCoachWidget(
            targetText: 'Guten Tag',
            audioText: 'Guten Tag',
            onCompleted: (_) {},
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Guten Tag'), findsOneWidget);
      expect(find.text('Listen to native'), findsOneWidget);

      await tester.tap(find.text('Listen to native'));
      await tester.pump();

      expect(fakeAudio.lastSpoken, equals('Guten Tag'));
    });

    testWidgets('high similarity speech automatically passes', (tester) async {
      fakeStt.textToReturn = 'Guten Tag';
      bool? passedResult;

      await tester.pumpWidget(
        buildTestableWidget(
          PronunciationCoachWidget(
            targetText: 'Guten Tag',
            onCompleted: (result) => passedResult = result,
          ),
        ),
      );
      await tester.pump();

      // Tap microphone
      await tester.tap(find.byIcon(Icons.mic_none_rounded));
      await tester.pump();

      expect(passedResult, isTrue);
      expect(find.text('Great pronunciation!'), findsOneWidget);
    });

    testWidgets('partial speech similarity shows coaching and allows self-assessment', (tester) async {
      fakeStt.textToReturn = 'Hallo Tag';
      bool? passedResult;

      await tester.pumpWidget(
        buildTestableWidget(
          PronunciationCoachWidget(
            targetText: 'Guten Tag zusammen',
            onCompleted: (result) => passedResult = result,
          ),
        ),
      );
      await tester.pump();

      // Tap microphone
      await tester.tap(find.byIcon(Icons.mic_none_rounded));
      await tester.pump();

      expect(find.text('Good try!'), findsOneWidget);
      expect(find.text('Mark as practiced'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);

      // Tap Mark as practiced
      await tester.tap(find.text('Mark as practiced'));
      await tester.pump();

      expect(passedResult, isTrue);
    });

    testWidgets('unavailable STT shows fallback banner and does not trap learner', (tester) async {
      fakeStt.shouldThrowUnavailable = true;
      bool? passedResult;

      await tester.pumpWidget(
        buildTestableWidget(
          PronunciationCoachWidget(
            targetText: 'Wie geht es Ihnen?',
            onCompleted: (result) => passedResult = result,
          ),
        ),
      );
      await tester.pump();

      // Tap microphone
      await tester.tap(find.byIcon(Icons.mic_none_rounded));
      await tester.pump();

      expect(find.text('Microphone not available — you can self-assess'), findsOneWidget);
      expect(find.text('Mark as practiced'), findsOneWidget);

      await tester.tap(find.text('Mark as practiced'));
      await tester.pump();

      expect(passedResult, isTrue);
    });
  });
}

