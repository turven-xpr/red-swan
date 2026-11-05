# Project: Gamification & UI Enhancements (Worker phase)

## Architecture
- Gamification features in `deutschy` app.
- UI elements:
  - `MemoryMatchCompletionOverlay` and `WordChainCompletionOverlay` rendered in `Stack` overlay overlays.
  - `_CountdownRing` drawing progress for Word Chain.
  - `FlashcardView` representing flashcards in Review Screen.
  - Grade buttons in `_GradePanel`.
  - Buttons and interactive items styled with `PressScaleEffect`.

## Milestones
| # | Name | Scope | Dependencies | Status |
|---|------|-------|-------------|--------|
| 1 | Overlay Refactoring | Refactor `MemoryMatchCompletionOverlay` and `WordChainCompletionOverlay` to use custom Containers instead of `AlertDialog` | None | PLANNED |
| 2 | Animation and Motion | Support reduced motion in `FlashcardView` and `_CountdownRing` | M1 | PLANNED |
| 3 | Press-Scale Interactions | Wrap buttons/views in `PressScaleEffect` (completion overlays, flashcard, grade panel, completion screen) | M2 | PLANNED |
| 4 | M3 Color Tokens | Migrate hardcoded colors (`Colors.amber[600]`, `Colors.redAccent`, `Color(0xFFFFD700)`) to context color schemes | M3 | PLANNED |
| 5 | Accessibility & Semantics | Replace zero-sized accessibility text widget hack, add semantic labels for options buttons and flashcard | M4 | PLANNED |
| 6 | State Bugs & Verification | Fix `_bestSec` update in `memory_match_screen.dart` and `_highScore` update in `word_chain_screen.dart`, run flutter analyze and tests | M5 | PLANNED |

## Code Layout
- `lib/src/features/games/presentation/memory_match_screen.dart`
- `lib/src/features/games/presentation/word_chain_screen.dart`
- `lib/src/features/vocabulary/presentation/review_screen.dart`
- `test/memory_match_engine_test.dart`
- `test/word_chain_engine_test.dart`
- `test/games_ui_enhancements_test.dart`
