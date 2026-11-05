import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import 'package:deutschy/src/data/remote/gemini_client.dart';
import 'package:deutschy/src/features/writing/presentation/writing_screen.dart';
import 'package:deutschy/src/core/providers.dart';

void main() {
  testWidgets('writing screen character counter UI is wired', (tester) async {
    final container = ProviderContainer(
      overrides: [
        currentUserProvider.overrideWith((_) => Stream.value(null)),
        driftInitProvider.overrideWith((_) async {}),
        // Stub the GeminiClient so we don't actually hit the proxy.
        geminiClientProvider.overrideWith((_) => _StubGemini()),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: WritingScreen()),
      ),
    );
    await tester.pump();

    // The "Mindestens 12, höchstens 1200 Zeichen" helper caption is one
    // of Nielsen's H6 affordances — it surfaces the input constraints
    // rather than relying on user recall.
    expect(
      find.textContaining('Mindestens 12, höchstens 1200 Zeichen'),
      findsOneWidget,
    );
    // Counter suffix: `0 / 1200`.
    expect(find.text('0 / 1200'), findsOneWidget);
  });
}

/// Lightweight stand-in for `GeminiClient`.  Allows the writing screen
/// to reach its UI without network errors during widget testing.
class _StubGemini extends GeminiClient {
  _StubGemini()
      : super(dio: Dio(), endpoints: const [AiEndpoint(url: 'http://example/ai')]);
  @override
  Future<WritingFeedback> correctWriting({
    required String userText,
    required String level,
  }) async {
    return WritingFeedback(
      overallFeedback: 'Stub',
      scoreOutOf10: 8,
      corrections: const [],
    );
  }
  @override
  Future<String> continueSpeakingScenario({
    required int scenarioId,
    required List<String> history,
    required String userMessage,
    String? systemPrompt,
  }) async {
    return 'stub reply';
  }
}
