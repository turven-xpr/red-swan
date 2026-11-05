# Project: Premium Game Enhancements (Memory Match & Word Chain)

## Architecture
This project enhances the existing games (`MemoryMatchScreen` and `WordChainScreen`) in the Deutschy application with high-fidelity UI celebration overlays, animations, and clean Material 3 theme colors.

- **Presentation Layer**:
  - `MemoryMatchScreen` (`lib/src/features/games/presentation/memory_match_screen.dart`): Displays 4x4 card grid, handles moves, matched cards, and elapsed time.
  - `WordChainScreen` (`lib/src/features/games/presentation/word_chain_screen.dart`): Handles translation race, remaining lives, question index, score, and countdown ring.
- **Core Widgets/Animations**:
  - `StaggerCascade`, `OrbitRing`, `GlossySurface` (`lib/src/core/widgets/animations/premium_animations.dart`).
  - Confetti Burst is adapted from `_ConfettiBurst` in `lib/src/features/vocabulary/presentation/review_screen.dart`.
- **State Management**:
  - Shared Preferences used for storing game statistics (e.g. high scores, best times).

## Code Layout
- `lib/src/features/games/presentation/memory_match_screen.dart` - Memory Match UI.
- `lib/src/features/games/presentation/word_chain_screen.dart` - Word Chain UI.
- `lib/src/core/widgets/animations/premium_animations.dart` - Reusable UI animations.
- `test/` - Unit and Widget test files.

## Milestones
| # | Name | Scope | Dependencies | Status |
|---|------|-------|-------------|--------|
| 1 | E2E Testing Suite | Set up E2E tests in `test/games_e2e_test.dart` mapping all required features (Tiers 1-4). Create `TEST_INFRA.md` and publish `TEST_READY.md`. | None | IN_PROGRESS (Conv: 1bfa1fa5-14b4-49e5-bc89-2d59a79f7b88) |
| 2 | Premium Completion Overlay | Replace basic AlertDialogs in MemoryMatch and WordChain with a premium full-screen overlay (confetti, stats, Play Again, Back). | M1 | IN_PROGRESS (Conv: b36deee4-8e2f-4b7f-bcd1-6f96145ef810) |
| 3 | Core Gameplay Animations | Implement 3D flip card transition, smooth countdown timer ring, and press-scale scale/bounce micro-interactions. | M2 | IN_PROGRESS (Conv: b36deee4-8e2f-4b7f-bcd1-6f96145ef810) |
| 4 | Material 3 Color Migration | Replace hardcoded colors with Material 3 theme color tokens; verify light/dark themes and accessibility (semantic labels). | M3 | IN_PROGRESS (Conv: b36deee4-8e2f-4b7f-bcd1-6f96145ef810) |
| 5 | Adversarial Hardening | Phase 1: Verify all tests (Tiers 1-4) pass. Phase 2: Add Tier 5 adversarial tests for coverage hardening. | M4 | IN_PROGRESS (Conv: b36deee4-8e2f-4b7f-bcd1-6f96145ef810) |

## Interface Contracts
### Overlay Integration
- Game Screens will display the overlay as a full-screen stacked widget on game completion/game over, bypassing default dialog popups.
- Interactive controls inside the overlay:
  - Play Again: Resets the state of the screen and starts a new game.
  - Back to Games: Pops the screen or navigates back using GoRouter.
