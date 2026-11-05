# MemoryMatchScreen Analysis & Test Design Handoff Report

## 1. Observation

### File & Paths
* **MemoryMatchScreen Component**: `c:/Users/sbaih/german_learning_app/lib/src/features/games/presentation/memory_match_screen.dart`
* **MemoryMatchEngine & Seed**: 
  * `c:/Users/sbaih/german_learning_app/lib/src/features/games/application/memory_match_engine.dart`
  * `c:/Users/sbaih/german_learning_app/lib/src/features/games/application/memory_match_seed.dart`
* **Core Providers & TtsService**: 
  * `c:/Users/sbaih/german_learning_app/lib/src/core/providers.dart`
  * `c:/Users/sbaih/german_learning_app/lib/src/core/audio/tts_service.dart`

### Code Observations

1. **State Initialization & SharedPreferences Load**
   * Key for SharedPreferences (line 35):
     ```dart
     static const String _bestKey = 'best_memory_match_seconds';
     ```
   * Best time loaded asynchronously during `initState()` (lines 46, 49-53):
     ```dart
     @override
     void initState() {
       ...
       _loadBest();
     }

     Future<void> _loadBest() async {
       final prefs = await SharedPreferences.getInstance();
       if (!mounted) return;
       setState(() => _bestSec = prefs.getInt(_bestKey));
     }
     ```
   * Best time updated on win (lines 98-101):
     ```dart
     final secs = _elapsedSec;
     if (_bestSec == null || secs < _bestSec!) {
       await _saveBest(secs);
     }
     ```

2. **TTS Usage**
   * TTS read from Riverpod provider `ttsServiceProvider` (line 70) and called on German card reveal (lines 75-78):
     ```dart
     final tts = ref.read(ttsServiceProvider);
     ...
     // Speak the German card the moment it's revealed.
     if (card.face == CardFace.german) {
       unawaited(tts.speak(card.text));
     }
     ```

3. **MemoryMatchEngine Generation & Shuffling**
   * Engine created inside `initState()` and reset inside the "Nächstes Spiel" button without dependency injection or provider integration (lines 40-41, 145):
     ```dart
     _engine = MemoryMatchEngine();
     _deck = _engine.buildDeck();
     ```

4. **Card Tile Properties**
   * Each card is rendered via `MemoryCardTile` displaying the associated `MemoryCard` card model (lines 211-216):
     ```dart
     return MemoryCardTile(
       key: ValueKey('card-${card.id}'),
       card: card,
       faceUp: isFaceUp,
       onTap: () => _onTap(card),
     );
     ```

5. **Navigation**
   * Navigating back to home screen from the win dialog (line 158):
     ```dart
     context.go('/home');
     ```

---

## 2. Logic Chain

1. **State Flow & Lifecycle**:
   * **Initialization**: The screen constructs `MemoryMatchEngine`, generates a 16-card deck (randomly shuffled via `Random()`), starts a `Timer.periodic` ticker to track elapsed time (`_elapsedSec`), and fetches the best time (`_bestSec`) from `SharedPreferences`.
   * **First Tap**: The tapped card is added to `_revealed`. If it is a German card, its text is spoken via `tts.speak`. It is stored as `_first`.
   * **Second Tap**: The card is added to `_revealed`, stored as `_second`, and `_moves` is incremented. `_busy` is set to `true`.
   * **Match Determination**:
     * **Match**: If card pair IDs match, they are added to `_matched`. If 8 pairs are matched, the timer is stopped, the new best score is saved to `SharedPreferences` if applicable, and `_showWin` is displayed.
     * **Mismatch**: After a 600ms delay (`Future.delayed`), both cards are removed from `_revealed` (flipping them face down), and `_busy` is set to `false`.
   * **Reset**: The win dialog's "Nächstes Spiel" button resets all counters, clears card sets, creates a fresh deck, and restarts the timer.

2. **SharedPreferences Best Time Mocking**:
   * Since `SharedPreferences.getInstance()` is called directly, the standard Flutter testing mechanism `SharedPreferences.setMockInitialValues` can prepopulate key-value pairs before pumping the widget.

3. **TTS Mocking**:
   * `TtsService` is retrieved from `ttsServiceProvider`. By overriding this Riverpod provider inside the widget test using a `ProviderScope` override, we can bypass the platform channel dependencies of `FlutterTts`.
   * Extending `TtsService` allows overriding public methods (`init`, `speak`, `stop`, `dispose`, and getter `state`) without compilation errors concerning private members (`_tts`, `_state`, `_initialized`).

4. **E2E / Widget Test Design**:
   * The randomness of `MemoryMatchEngine.buildDeck` makes hardcoding tap locations impossible.
   * However, `MemoryCardTile` exposes its `MemoryCard` object as a public property. In a widget/integration test, the tester can query all rendered `MemoryCardTile` widgets via `tester.widgetList<MemoryCardTile>(find.byType(MemoryCardTile))` to discover the randomized deck layout, group them by `pairId`, and programmatically tap the matching pairs to execute a perfect game.
   * `GoRouter` can be mocked/tested by wrapping the widget inside `MaterialApp.router` with a test configuration containing a dummy `/home` route.

---

## 3. Caveats

* **No direct control over Randomness**: We cannot inject a custom seed or fake engine into the screen directly because `MemoryMatchEngine()` is hardcoded in `initState` and the win dialog reset button.
* **Black-Box E2E Limitations**: If E2E testing is conducted using a pure black-box framework (e.g. Appium or Patrol without widget tree access), the test cannot easily inspect the public `card` property of `MemoryCardTile`. In that case, the application would require code modifications (e.g., exposing the deck seed through a provider, or adding test-only semantic labels with the pair IDs). However, for Flutter's built-in `widget_test` and `integration_test` tools, the tree inspection works natively.

---

## 4. Conclusion

The state flow of `MemoryMatchScreen` is self-contained but depends on `SharedPreferences`, `TtsService`, and `GoRouter`.
* **State flow**: Tracked via local sets (`_revealed`, `_matched`) and a ticker timer, transitioning to a win dialog and a reset.
* **SharedPreferences best time**: Read via `SharedPreferences.getInstance()` using key `'best_memory_match_seconds'`. Mockable via `SharedPreferences.setMockInitialValues`.
* **TTS**: Triggered asynchronously via `tts.speak` when tapping German cards. Mockable by overriding `ttsServiceProvider` with a fake subclass.
* **Navigation**: Handled via `GoRouter.of(context).go('/home')`, mockable by injecting a custom `GoRouterConfig` in the test.

---

## 5. Verification Method

### Test Run Commands
Run all unit and widget tests inside the workspace:
```pwsh
flutter test
```

### Reference Test Structure
A proposed widget test using the verified mock strategies:
```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:deutschy/src/core/providers.dart';
import 'package:deutschy/src/core/audio/tts_service.dart';
import 'package:deutschy/src/features/games/presentation/memory_match_screen.dart';

class FakeTtsService extends TtsService {
  final List<String> spokenTexts = [];
  final _stateController = StreamController<TtsState>.broadcast();

  @override
  Stream<TtsState> get state => _stateController.stream;

  @override
  Future<void> init() async {}

  @override
  Future<void> speak(String text) async {
    spokenTexts.add(text);
  }

  @override
  Future<void> stop() async {}

  @override
  Future<void> dispose() async {
    await _stateController.close();
  }
}

void main() {
  testWidgets('MemoryMatchScreen Full Game Flow Test', (tester) async {
    // 1. Mock SharedPreferences initial values
    SharedPreferences.setMockInitialValues({
      'best_memory_match_seconds': 120, // 2:00 best time
    });

    final fakeTts = FakeTtsService();

    // 2. Set up test Router
    final router = GoRouter(
      initialLocation: '/game',
      routes: [
        GoRoute(
          path: '/game',
          builder: (context, state) => const MemoryMatchScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const Scaffold(body: Text('Home Screen')),
        ),
      ],
    );

    // 3. Pump Widget
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ttsServiceProvider.overrideWithValue(fakeTts),
        ],
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify initial layout
    expect(find.text('Memory Match'), findsOneWidget);
    expect(find.text('00:00'), findsOneWidget); // initial timer
    expect(find.text('02:00'), findsOneWidget); // best time from shared prefs

    // 4. Resolve randomized card layout
    final tiles = tester.widgetList<MemoryCardTile>(find.byType(MemoryCardTile)).toList();
    expect(tiles.length, 16);

    // Group cards by their pairId
    final pairs = <int, List<MemoryCard>>{};
    for (final tile in tiles) {
      pairs.putIfAbsent(tile.card.pairId, () => []).add(tile.card);
    }

    // 5. Play and Match all 8 pairs
    for (final entry in pairs.entries) {
      final cardA = entry.value[0];
      final cardB = entry.value[1];

      // Tap first card
      await tester.tap(find.byKey(ValueKey('card-${cardA.id}')));
      await tester.pump();

      // Verify TTS was triggered if it's German
      if (cardA.face == CardFace.german) {
        expect(fakeTts.spokenTexts.last, cardA.text);
      }

      // Tap second card
      await tester.tap(find.byKey(ValueKey('card-${cardB.id}')));
      await tester.pumpAndSettle();
    }

    // 6. Verify Win Dialog is shown
    expect(find.text('Sehr gut! 🎉'), findsOneWidget);

    // 7. Verify navigation back to home
    await tester.tap(find.text('Zurück'));
    await tester.pumpAndSettle();

    expect(find.text('Home Screen'), findsOneWidget);
  });
}
```
