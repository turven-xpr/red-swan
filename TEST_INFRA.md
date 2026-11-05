# Test Infrastructure (E2E & Integration testing)

This document details the E2E and integration test architecture, feature inventory, mock configurations, and verification methods for the premium game enhancements in Deutschy.

---

## 1. Test Architecture

The E2E testing framework uses a **dual-track setup** to test features without runtime dependencies on external APIs (Gemini, Firebase Auth, Google Mobile Ads) or platform hardware features (native Speech-to-Text and Text-to-Speech).

*   **Test Runner:** `flutter test test/games_e2e_test.dart`
*   **Testing Tool:** Flutter Widget/Integration testing (`flutter_test` package) using `WidgetTester` to pump frames, inject mock dependencies via Riverpod container overrides, and verify visual and state transitions.
*   **Target Screens:** `MemoryMatchScreen` and `WordChainScreen`.

```
                  ┌──────────────────────────────┐
                  │      flutter test Runner     │
                  └──────────────┬───────────────┘
                                 │ Injects
                                 ▼
                  ┌──────────────────────────────┐
                  │      ProviderScope (Mocks)   │
                  ├──────────────────────────────┤
                  │ • FakeTtsService             │
                  │ • FakeSttService             │
                  │ • FakeAdService              │
                  │ • InMemoryAppDatabase        │
                  │ • Mock SharedPreferences     │
                  └──────────────┬───────────────┘
                                 │ Pumps UI
                                 ▼
                  ┌──────────────────────────────┐
                  │       E2E Test Widget        │
                  └──────────────────────────────┘
```

---

## 2. Feature Inventory (F1 - F6)

The suite validates the six core features introduced in the game enhancements milestone:

| ID | Feature Name | Description | Verification Target |
|---|---|---|---|
| **F1** | Memory Match Premium Completion Overlay | Replaces basic win Dialog with a full-screen completion overlay. | Confetti trigger, stats (time, moves, best time), Play Again and Back buttons. |
| **F2** | Word Chain Premium Completion Overlay | Replaces basic game-over Dialog with a full-screen completion overlay. | Confetti trigger, final score, high score comparison, Play Again and Back buttons. |
| **F3** | Memory Match 3D Flip Card Animation | Cards use a 3D Y-axis flip rotation on tap to reveal their face. | Rotation angle transforms, visibility states, transition duration. |
| **F4** | Word Chain Countdown Ring Animation | The 5-second countdown timer ring animates progress smoothly between ticks. | Progress bar values, `TweenAnimationBuilder` ticks, color transitions on low time. |
| **F5** | Press-Scale Micro-Interactions | Scale down / bounce up gesture effects on all cards and option buttons. | Tap gesture triggers, transform matrix scaling down on press. |
| **F6** | M3 Color Migration & Theme Adaptation | Layouts use theme-aware Material 3 color tokens. | Light/Dark theme configuration, accessibility labels, semantic nodes. |

---

## 3. Mock Setup & Dependency Overrides

To ensure tests are opaque-box, deterministic, and isolated, the suite overrides five global services using Riverpod's `ProviderScope.overrides`.

### A. Stub/Fake Implementation Contracts

#### 1. Text-to-Speech Stub (`FakeTtsService`)
Bypasses AVFoundation/Google TTS engine to avoid platform channel timeouts.
```dart
import 'package:deutschy/src/core/audio/tts_service.dart';

class FakeTtsService implements TtsService {
  final List<String> spokenTexts = [];

  @override
  Future<void> speak(String text) async {
    spokenTexts.add(text);
  }

  @override
  Future<void> stop() async {}

  @override
  void dispose() {}
}
```

#### 2. Speech-to-Text Stub (`FakeSttService`)
Bypasses microphone permissions and real audio transcription.
```dart
import 'package:deutschy/src/core/audio/stt_service.dart';

class FakeSttService implements SttService {
  String transcriptionStub = 'Guten Tag';

  @override
  Future<bool> initialize() async => true;

  @override
  Future<void> startListening({required Function(String) onResult}) async {
    onResult(transcriptionStub);
  }

  @override
  Future<void> stopListening() async {}
}
```

#### 3. Monetization Stub (`FakeAdService`)
Bypasses Google Mobile Ads initialization and network request requirements.
```dart
import 'package:deutschy/src/features/monetization/ad_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class FakeAdService implements AdService {
  bool interstitialShown = false;

  @override
  String get bannerUnitId => 'test_banner_id';

  @override
  String get interstitialUnitId => 'test_interstitial_id';

  @override
  Future<void> init() async {}

  @override
  BannerAd buildBanner({AdSize size = AdSize.banner}) {
    // Return dummy banner configuration
    return BannerAd(
      adUnitId: bannerUnitId,
      size: size,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    );
  }

  @override
  Future<void> showInterstitial() async {
    interstitialShown = true;
  }
}
```

#### 4. In-Memory Database (`InMemoryAppDatabase`)
Bypasses file system dependency by running SQLite in memory.
```dart
import 'package:deutschy/src/data/local/app_database.dart';
import 'package:drift/native.dart';

AppDatabase createInMemoryDatabase() {
  return AppDatabase.withExecutor(DatabaseConnection(NativeDatabase.memory()));
}
```

### B. Overridden Test Harness Example
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:deutschy/src/core/providers.dart';
import 'package:deutschy/src/features/monetization/ad_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeTtsService fakeTts;
  late FakeAdService fakeAds;

  setUp(() {
    fakeTts = FakeTtsService();
    fakeAds = FakeAdService();
    SharedPreferences.setMockInitialValues({
      'best_memory_match_seconds': 120,
      'high_score_word_chain': 50,
    });
  });

  Widget createTestWidget(Widget child) {
    return ProviderScope(
      overrides: [
        ttsServiceProvider.overrideWithValue(fakeTts),
        adServiceProvider.overrideWithValue(fakeAds),
        // DB and STT overrides can go here
      ],
      child: MaterialApp(home: child),
    );
  }
}
```

---

## 4. Expected Test Count Thresholds

Based on the 6 core features ($N = 6$), the testing targets require the following test thresholds across Tiers 1–4:

```
Total Test Cases Target = 71 Tests
├── Tier 1: Feature Coverage (5 * N = 30 Tests)
├── Tier 2: Boundary & Corner Cases (5 * N = 30 Tests)
├── Tier 3: Cross-Feature Combinations (N = 6 Tests)
└── Tier 4: Real-World Scenarios (max(5, N/2) = 5 Tests)
```

### Tier 1: Feature Coverage
**Target: $\ge 30$ tests** (at least 5 tests per feature)
*   **F1 (Memory Match Win Overlay):**
    1. Verify overlay appears when matches reach 8 (full board).
    2. Verify time elapsed matches actual time taken.
    3. Verify moves count reflects number of attempts.
    4. Verify Play Again button resets board and timer.
    5. Verify Back button pops the route.
*   **F2 (Word Chain Completion Overlay):**
    6. Verify overlay appears on 10th question completion.
    7. Verify overlay appears when lives reach 0 (game over).
    8. Verify score displays correct calculated points + time bonuses.
    9. Verify high score updates if current score beats it.
    10. Verify option click disables further options on overlay load.
*   **F3 (Memory Match 3D Flip Card):**
    11. Verify card flips to German text when tapped.
    12. Verify card flips to English text when tapped.
    13. Verify rotation transform is applied during the flip.
    14. Verify unmatched cards flip back face-down after delay.
    15. Verify matched cards stay face-up and do not perform flip rotation on subsequent taps.
*   **F4 (Word Chain Countdown Ring):**
    16. Verify ring progress value begins at 1.0.
    17. Verify progress animates downwards on timer ticks.
    18. Verify ring changes color to red (danger state) when remaining time $\le 2$ seconds.
    19. Verify ring handles animation resets when transitioning to a new question.
    20. Verify ring halts animation when user picks an option before timeout.
*   **F5 (Press-Scale Interactions):**
    21. Verify scale transform is applied to a memory card on tap down.
    22. Verify scale restores to 1.0 on tap up / tap cancel.
    23. Verify scale down on Word Chain option buttons.
    24. Verify Play Again button scales on press.
    25. Verify Back button scales on press.
*   **F6 (Theme & Accessibility):**
    26. Verify colors adapt correctly in light theme mode (Material 3 tokens).
    27. Verify colors adapt correctly in dark theme mode (Material 3 tokens).
    28. Verify semantic labels exist for memory card backs.
    29. Verify semantic labels exist for Word Chain countdown progress.
    30. Verify theme switcher changes color schemes on active game screens without resetting gameplay state.

### Tier 2: Boundary & Corner Cases
**Target: $\ge 30$ tests** (at least 5 tests per feature group)
*   **Overlay & Timing Boundaries (F1, F2):**
    31. Win Memory Match in record time (0 seconds) -> verify best time in SharedPreferences updates correctly.
    32. Complete Memory Match with extreme number of moves (1000+) -> check overlay typography/layout bounds.
    33. Timeout precisely at the last millisecond of Word Chain question -> verify score is not recorded, and lives reduce.
    34. Tap two matched cards simultaneously -> verify game state doesn't double-match.
    35. Fail Word Chain on question 1 (0 score) -> check game over screen handles zero state properly.
*   **Animation & Transition Interruptions (F3, F4, F5):**
    36. Tap a card while another card's flip back animation is running -> check busy state prevents visual glitch.
    37. Tap option button in Word Chain during the 900ms delay preceding the next question -> verify second tap is ignored.
    38. Timer expires exactly while a press-scale animation is mid-way -> verify correct state recovery.
    39. Quickly double-tap a single card in Memory Match -> verify it is not registered as two separate card reveals.
    40. Pause/Minimize the app while timer is running -> verify timer halts and doesn't drain lives in background.
*   **Database & Storage Gaps (F1, F2):**
    41. SharedPreferences returns null for best time -> verify overlay displays "Bestzeit: --" cleanly.
    42. Database has fewer than 4 vocabulary cards -> verify Word Chain gracefully returns to games screen with warning.
    43. Attempt to save high score when disk storage is full (I/O error) -> verify app catches exception and completes overlay render.
    44. Seed database with duplicated translation options -> verify engine resolves options uniquely.
    45. Switch languages (e.g. English -> German) mid-game -> verify UI text updates dynamically.
*   **Theme & Gesture Corner Cases (F5, F6):**
    46. Rapid theme changes (Light <-> Dark) during a card flip animation -> check visual continuity.
    47. Drag finger off card while tap is active -> verify scale restores without triggering card reveal.
    48. Verify screen reader semantic announcements during a card match event.
    49. Verify color contrast ratios for countdown ring on both primary and danger colors under high-contrast system settings.
    50. Run E2E test with `prefersReducedMotion` enabled -> verify 3D flip card and countdown ring fall back gracefully.
*   **Additional Boundary / Edge Cases:**
    51. Trigger game over via timeout on every question -> verify correct overlay display.
    52. Achieve exact high score parity -> verify "Best" is preserved and not updated.
    53. Tap third card while two mismatching cards are showing -> verify third card is ignored until mismatch animation resolves.
    54. Check memory cards layout when device changes orientation mid-game.
    55. Rapidly tap options in Word Chain to ensure no multiple score additions occur.
    56. Expose TTS volume set to 0.0 -> verify game screen doesn't crash on sound play.
    57. Set system font scale to 200% -> verify overlay buttons and text do not overflow screen boundaries.
    58. Launch Word Chain when all vocabulary is deactivated (0 cards fällig) -> verify fallback behavior.
    59. Check best time saves correctly when current time exactly equals historical best time.
    60. Win Memory Match when SharedPreferences fails to initialize -> verify no app crash.

### Tier 3: Cross-Feature Combinations
**Target: $\ge 6$ tests** (pairwise feature interactions)
1.  **F3 (Card Flip) + F6 (M3 Theme Switch):** Perform card flip animation and toggle between light and dark theme modes midway. Verify card surface adapts colors correctly without interrupting rotation angle.
2.  **F4 (Countdown Ring) + F5 (Option Scale):** Verify that clicking an option triggers a press-scale bounce on the button while the countdown ring stops and records the exact remaining time.
3.  **F1 (MM Overlay) + F5 (Scale):** Trigger Memory Match win overlay and click "Play Again". Verify press-scale registers on the overlay button and the card grid scales in.
4.  **F2 (WC Overlay) + F6 (Theme Switch):** Trigger Word Chain game over screen and toggle theme mode. Verify overlay background and typography contrast tokens adjust correctly.
5.  **F3 (Card Flip) + F5 (Card Scale):** Tap memory card rapidly -> verify it scales down/up (micro-interaction) while executing the 3D flip rotation concurrently.
6.  **F4 (Countdown Ring) + F6 (Theme Switch):** Allow timer to run to danger zone ($\le 2$s), toggle theme mode. Verify ring remains red (danger token) and resumes animation smoothly in new theme.

### Tier 4: Real-World Application Scenarios
**Target: $\ge 5$ tests** (happy paths and end-to-end flows)
1.  **Memory Match Happy Path Flow:**
    *   Start game screen -> Timer starts ticking.
    *   Perform sequential clicks -> Find matching pairs.
    *   Find all 8 matching pairs.
    *   Win overlay appears -> Shows moves count, elapsed time, and confetti.
    *   Click "Play Again" -> Game resets, timer starts at 0, cards shuffled.
2.  **Word Chain High Score Challenger Flow:**
    *   Start Word Chain screen -> First question displays, countdown begins.
    *   Select correct options for questions 1–9 quickly (earning time bonuses).
    *   Select incorrect options for question 10.
    *   Game ends on question 10 -> Game over overlay loads.
    *   Verify score exceeds original high score, and new high score is written to SharedPreferences.
3.  **Word Chain Game Over Flow:**
    *   Start Word Chain screen.
    *   Let timer expire (timeout) for 3 consecutive questions.
    *   Lives drop to 0 -> Game over overlay appears showing final score.
    *   Click "Back to Games" -> Router navigates back to games home dashboard.
4.  **Memory Match Mismatch Endurance Flow:**
    *   Start Memory Match.
    *   Intentionally tap mismatched cards repeatedly (increasing move count to 50+).
    *   Eventually resolve all pairs.
    *   Verify win overlay handles high move counts without UI overflows and displays the correct non-best time.
5.  **Interrupted Word Chain Session Flow:**
    *   Start Word Chain -> Play 3 questions correctly.
    *   Tap hardware/app back button before game completion.
    *   Confirm navigation away does not save high score, cancels active tickers/timers, and avoids memory leaks.
