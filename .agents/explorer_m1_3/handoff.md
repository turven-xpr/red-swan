# Handoff Report: E2E Test Infrastructure Design (Milestone 1.3)

## 1. Observation
We have inspected the following workspace files and definitions:

*   **`c:/Users/sbaih/german_learning_app/.agents/sub_orch_e2e_tests/SCOPE.md`**:
    *   Lines 3–6:
        ```markdown
        ## Architecture
        - Dual track E2E testing runner and layout in `test/`.
        - Flutter Widget/Integration testing framework mapping to MemoryMatchScreen and WordChainScreen.
        - Drift database seeds and Riverpod provider overrides to mock dependencies without hitting active Firebase/STT/TTS.
        ```
    *   Lines 15–18:
        ```markdown
        ## Interface Contracts
        - No runtime dependencies on real audio (TTS/STT), Firebase, or Ad service; all overridden with stubs.
        - Test runner command: `flutter test test/games_e2e_test.dart`.
        ```

*   **`c:/Users/sbaih/german_learning_app/.agents/sub_orch_e2e_tests/BRIEFING.md`**:
    *   Line 38:
        ```markdown
        - Minimum thresholds: Tier 1: 5*N, Tier 2: 5*N, Tier 3: N, Tier 4: max(5, N/2).
        ```

*   **`c:/Users/sbaih/german_learning_app/ORIGINAL_REQUEST.md`**:
    *   Requirements `R1` (Full-Screen Game Completion Overlay) and `R2` (Core Gameplay Animations & Micro-Interactions) require a full-screen completion overlay, 3D flip card, smooth countdown ring animation, press-scale micro-animations, and theme-aware Material 3 color migration.

*   **`c:/Users/sbaih/german_learning_app/.agents/sub_orch_implementation/SCOPE.md`**:
    *   Milestones `MM-1`, `WC-1`, `MM-2`, `WC-2`, `MI-1`, and `M3-1` map to the game enhancement features.

---

## 2. Logic Chain
Based on these observations, the test design relies on the following logic steps:

1.  **Feature Count ($N = 6$):** Six core features were identified from the requirement logs:
    *   **F1:** Memory Match Premium Completion Overlay
    *   **F2:** Word Chain Premium Completion Overlay
    *   **F3:** Memory Match 3D Flip Card Animation
    *   **F4:** Word Chain Countdown Ring Smooth Animation
    *   **F5:** Press-Scale Micro-Interactions (gesture scaling on cards/buttons)
    *   **F6:** Material 3 Color Migration & Theme Adaptation (Light/Dark themes, accessibility, and semantic labels)

2.  **Test Count Thresholds:** Since $N = 6$, we calculate the minimum test cases required for each tier under the sub-orchestrator's rules:
    *   **Tier 1 (Feature Coverage):** $5 \times N = 30$ tests.
    *   **Tier 2 (Boundary & Corner Cases):** $5 \times N = 30$ tests.
    *   **Tier 3 (Cross-Feature Combinations):** $N = 6$ tests (pairwise interactions).
    *   **Tier 4 (Real-World Application Scenarios):** $\max(5, N/2) = \max(5, 3) = 5$ tests.
    *   **Total expected E2E tests:** $30 + 30 + 6 + 5 = 71$ tests.

3.  **Mocking Strategy:** Platform hardware features must be mocked in the widget test environment to avoid test suite crashes or timeouts. The services to override are:
    *   `ttsServiceProvider` with a fake TTS stub recorder.
    *   `sttServiceProvider` with a fake STT stub transcriber.
    *   `adServiceProvider` with a fake AdService to bypass the AdMob SDK initialization.
    *   `appDatabaseProvider` with a Drift native in-memory database to execute deterministic seeding.
    *   `SharedPreferences` values pre-seeded with mock initial values.

---

## 3. Caveats
*   **Accessibility Elements:** Tier 1 and 2 tests assume that semantic labels are properly attached to countdown progress controls and card layouts. If not properly implemented, testing accessibility and screen reader nodes will fail.
*   **Reduced Motion Constraints:** Under system accessibility settings where `prefersReducedMotion` is true, 3D card flips and smooth timer animations are bypassed. The test runner must mock this condition to verify graceful fallbacks.
*   **Drift/Native Bindings:** Native SQLite database handles require appropriate native binary bindings in testing environments. Overriding the executor to `NativeDatabase.memory()` works in standard Flutter testing.

---

## 4. Conclusion
We have compiled and written the comprehensive test design architecture into **`c:/Users/sbaih/german_learning_app/TEST_INFRA.md`**. It includes the architecture, the 6 core features, concrete code structures for all necessary stubs (TTS, STT, Ads, Database, SharedPreferences), and the 71 test targets mapped across Tiers 1-4.

---

## 5. Verification Method
To verify this analysis and the test infrastructure design:
1. Inspect the content of **`c:/Users/sbaih/german_learning_app/TEST_INFRA.md`**.
2. Run the planned integration suite template locally via:
   ```bash
   flutter test test/games_e2e_test.dart
   ```
3. *Invalidation Conditions:* If any test dependencies (like the AdMob SDK initialization or TTS native channels) are not overridden in `games_e2e_test.dart` at runtime, the tests will fail on platform channel exceptions.
