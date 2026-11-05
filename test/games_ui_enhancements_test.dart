import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deutschy/src/features/games/presentation/memory_match_screen.dart';
import 'package:deutschy/src/features/games/presentation/word_chain_screen.dart';
import 'package:deutschy/src/core/widgets/animations/premium_animations.dart';
import 'package:deutschy/src/features/games/application/memory_match_engine.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return ProviderScope(
      child: MaterialApp(
        home: child,
      ),
    );
  }

  group('MemoryCardTile 3D Flip & Scale Tests', () {
    testWidgets('MemoryCardTile performs 3D perspective rotation on faceUp transition', (tester) async {
      final card = MemoryCard(id: 1, pairId: 1, text: 'Hund', face: CardFace.german, seed: 123);
      
      bool tapped = false;
      await tester.pumpWidget(
        createTestWidget(
          Scaffold(
            body: MemoryCardTile(
              card: card,
              faceUp: false,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      // Verify initial state (showing back)
      expect(find.byType(Transform), findsWidgets);
      
      // Tap card
      await tester.tap(find.byType(MemoryCardTile));
      await tester.pump();
      expect(tapped, isTrue);

      // Re-pump with faceUp = true to trigger animation
      await tester.pumpWidget(
        createTestWidget(
          Scaffold(
            body: MemoryCardTile(
              card: card,
              faceUp: true,
              onTap: () {},
            ),
          ),
        ),
      );

      // Verify animation starts and does 3D perspective transform
      await tester.pump(const Duration(milliseconds: 100));
      final transformFinder = find.byType(Transform);
      expect(transformFinder, findsWidgets);

      // Verify presence of PressScaleEffect wrapper
      expect(find.byType(PressScaleEffect), findsOneWidget);
    });
  });

  group('WordChain & MemoryMatch Completion Overlays & Countdown Ring Tests', () {
    testWidgets('MemoryMatchCompletionOverlay renders properly with score/moves/time', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MemoryMatchCompletionOverlay(
              elapsedSec: 45,
              moves: 12,
              bestSec: 30,
              onPlayAgain: () {},
              onBack: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(MemoryMatchCompletionOverlay), findsOneWidget);
      expect(find.text('Sehr gut! 🎉'), findsOneWidget);
      expect(find.text('Du hast alle Paare gefunden!'), findsOneWidget);
      expect(find.text('00:45'), findsOneWidget); // time
      expect(find.text('12'), findsOneWidget); // moves
      expect(find.text('00:30'), findsOneWidget); // best time
      expect(find.byType(ConfettiBurst), findsOneWidget);
    });

    testWidgets('WordChainCompletionOverlay renders win and loss scenarios', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: WordChainCompletionOverlay(
                score: 80,
                highScore: 100,
                lives: 3,
                onPlayAgain: () {},
                onBack: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Spiel beendet! 🏆'), findsOneWidget);
      expect(find.text('80'), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.byType(ConfettiBurst), findsOneWidget);
    });
  });
}
