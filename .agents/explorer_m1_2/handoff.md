# Handoff Report: WordChainScreen E2E Test Design & Mocking Analysis

## 1. Observation

Direct observations from the codebase of `german_learning_app`:

### Countdown Timer and `remainingSec`
- **File**: `lib/src/features/games/presentation/word_chain_screen.dart`
- **Instance Variables**:
  - `Timer? _timer;` (line 35)
  - `int _remainingSec = 5;` (line 36)
- **Engine Instantiation**:
  - `_engine` is hardcoded as an instance of `WordChainEngine` (line 41):
    ```dart
    _engine = WordChainEngine();
    ```
- **Timer Start and Loop**:
  - Starts in `_nextQuestion` (lines 77-87):
    ```dart
    _remainingSec = _engine.secondsPerQuestion;
    _questionIdx++;
    ...
    _startTimer();
    ```
  - Increments and checks timeout in `_startTimer` (lines 89-102):
    ```dart
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() => _remainingSec--);
      if (_remainingSec <= 0) {
        t.cancel();
        if (!_answered) _onTimeout();
      }
    });
    ```
  - Disposes in `dispose()` (line 181) and cancels on user picks in `_onPick` (line 116).
- **Hardcoded Delays**:
  - Delay between questions is hardcoded to `900ms` (lines 130-135):
    ```dart
    void _scheduleAdvance() {
      Future<void>.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        _nextQuestion();
      });
    }
    ```

### Lives System
- **Maximum Lives**: `static const int _maxLives = 3;` (line 23).
- **Decrements**:
  - On timeout (line 108): `_lives--;`
  - On incorrect answer (line 124): `_lives--;`
- **Game End Evaluation**:
  - Check in `_nextQuestion` (lines 58-61):
    ```dart
    if (_lives <= 0 || _questionIdx >= _totalQuestions) {
      _finishGame();
      return;
    }
    ```

### Scoring System
- **Variables**: `int _score = 0;` (line 30) and `int? _highScore;` (line 34).
- **Points Formula**:
  - Correct answer adds points based on remaining time (line 122):
    ```dart
    _score += 5 + (_remainingSec.clamp(0, 5));
    ```
- **High Score persistence**:
  - Directly calls `SharedPreferences.getInstance()` in the screen state (lines 46-55):
    ```dart
    Future<void> _loadHighScore() async {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      setState(() => _highScore = prefs.getInt(_highScoreKey));
    }
    ```

### Database Loading
- **Provider Read**:
  - Reads `appDatabaseProvider` to load flashcards (lines 62-63):
    ```dart
    final cards = await ref.read(appDatabaseProvider).watchAllFlashcards().first;
    _pool = cards.where((c) => c.english.trim().isNotEmpty).toList();
    ```
- **Bail-out Criteria**:
  - Exits if the card pool has less than 4 items (lines 64-74):
    ```dart
    if (_pool.length < 4) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mindestens 4 Karten nötig — bitte Vokabeln üben.')),
      );
      context.go('/games');
      return;
    }
    ```
- **Drift Database Connection**:
  - Production DB class definition lacks constructor injection (`lib/src/data/local/app_database.dart` lines 60-61):
    ```dart
    class AppDatabase extends _$AppDatabase {
      AppDatabase() : super(_openConnection());
    ```

### TTS Service
- **Access and Playback**:
  - Accesses TTS via Riverpod (lines 84-85):
    ```dart
    final tts = ref.read(ttsServiceProvider);
    unawaited(tts.speak(q.german));
    ```
- **Definition**:
  - Contains private fields `_tts`, `_state`, `_initialized` in `lib/src/core/audio/tts_service.dart` (lines 16-24).

---

## 2. Logic Chain

1. **Countdown Timer Control**:
   - *Observation*: The countdown relies on `_engine.secondsPerQuestion` which is hardcoded via `_engine = WordChainEngine()`.
   - *Inference*: In E2E tests, the countdown runs in real time. Latency or slow test runner steps will lead to random timeout failures.
   - *Recommendation*: Introduce `wordChainEngineProvider` in Riverpod and inject `_engine` through `ref.read`. This allows the E2E test to override `secondsPerQuestion` to a large value (e.g. `999`), preventing timeouts.
   - *Observation*: `_scheduleAdvance` causes a hardcoded `900ms` delay between questions.
   - *Inference*: A full 10-question test case will waste at least 9 seconds in delays.
   - *Recommendation*: Inject this delay duration through a Riverpod provider (`wordChainAdvanceDelayProvider`) and override it to `Duration.zero` in tests.

2. **Lives Verification**:
   - *Observation*: `_lives` decreases on timeout or wrong picks, triggering game over when `_lives <= 0`.
   - *Inference*: Tests need a reliable way to tap incorrect and correct options.
   - *Recommendation*: Add explicit `Key` identifiers to the list of `_OptionButton` widgets in the tree (e.g., `Key('option_$i')` or `Key('option_correct')` based on `q.correctIndex`) to let E2E drivers select choices deterministically.

3. **Scoring & SharedPreferences Mocking**:
   - *Observation*: Correct answer scoring uses `5 + remainingSeconds`. High score loads/saves directly to `SharedPreferences.getInstance()`.
   - *Inference*: Accessing `SharedPreferences` statically couples the UI to global storage.
   - *Recommendation*: Wrap `SharedPreferences` in `sharedPreferencesProvider` initialized at startup. This enables overriding with a mock preferences wrapper during E2E testing to test specific high score limits and assert updates.

4. **Database Mocking**:
   - *Observation*: The screen queries Drift via `appDatabaseProvider` and bails if cards < 4. `AppDatabase` hardcodes its connection.
   - *Inference*: E2E tests will fail or exhibit flakiness if the local SQLite contains less than 4 cards or arbitrary content.
   - *Recommendation*: Modify the `AppDatabase` constructor to accept an optional `QueryExecutor`, enabling in-memory sqlite instantiation (`NativeDatabase.memory()`). In E2E tests, override `appDatabaseProvider` with an in-memory instance pre-seeded with 4+ flashcards.

5. **TTS Mocking**:
   - *Observation*: TTS uses platform-native `flutter_tts` which can fail/crash in CI/headless test environments. The `TtsService` contains private variables preventing standard Dart implementation mocks.
   - *Recommendation*: Refactor `TtsService` into an abstract interface class and implement `SystemTtsService`. E2E tests can then implement a clean `FakeTtsService` and override `ttsServiceProvider`.

---

## 3. Caveats

- **External state synchronization**: Since the E2E test runs the app in an emulator/device, Riverpod provider overrides must be compiled into the test executable (e.g. `main_test.dart`) or dynamically configured before running the driver.
- **Drift database dependencies**: When replacing `AppDatabase` with `AppDatabase.forTesting`, any database observers on other screens will also point to the in-memory database, which is desired for testing isolation.

---

## 4. Conclusion

The current `WordChainScreen` is tightly coupled to real-time delays, system TTS, direct SharedPreferences, and the production sqlite file.
To build a clean E2E test suite:
1. **Time**: Provide `WordChainEngine` and advance delays via Riverpod to allow freezing/accelerating time.
2. **Database**: Update `AppDatabase` constructor to support `NativeDatabase.memory()` and override `appDatabaseProvider` with pre-seeded flashcard mocks.
3. **TTS**: Abstract `TtsService` into an interface and override with a silent `FakeTtsService`.
4. **Preferences**: Move `SharedPreferences` to Riverpod to decouple storage assertions.
5. **UI**: Add keys (`Key('option_$i')`) to option buttons to enable deterministic E2E clicks.

---

## 5. Verification Method

- **Unit tests**: Verify that existing tests are unaffected by running:
  ```pwsh
  flutter test test/word_chain_engine_test.dart
  ```
- **Code Inspection**: Confirm provider overrides can be cleanly implemented without violating layout constraints by reviewing `lib/src/core/providers.dart`.
