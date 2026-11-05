# Scope: Implementation of Premium UI Enhancements, Animations, and M3 Migration

## Architecture
- The features are built within the existing presentation layer of the `games` and `vocabulary` features.
- State management: State is managed via existing Flutter Riverpod providers and local Widget state.
- Navigation: Route switching via GoRouter, pop back to home via context.go('/home') or Navigator.pop.
- Animation: Flip animation uses `Transform` with perspective (Y-rotation). Countdown timer ring uses `TweenAnimationBuilder` to animate the progress value. Press-scale animations use a custom stateful wrapper or animated gesture detector.
- Theme: Theme-aware Material 3 color tokens retrieved via `Theme.of(context).colorScheme`.

## Milestones
| # | Name | Scope | Dependencies | Status |
|---|------|-------|-------------|--------|
| MM-1 | Memory Match Premium Completion | Replace Memory Match AlertDialog with stacked full-screen overlay (stats, confetti, Play Again/Back) | None | PLANNED |
| WC-1 | Word Chain Premium Completion | Replace Word Chain AlertDialog with stacked full-screen overlay (stats, confetti, Play Again/Back) | None | PLANNED |
| MM-2 | Memory Match 3D Flip Card Animation | Upgrade Memory Match card reveals to use 3D flip animation | None | PLANNED |
| WC-2 | Word Chain Countdown Ring Smooth Animation | Animate Word Chain countdown ring smoothly | None | PLANNED |
| MI-1 | Press-Scale Micro-Interactions | Add press-scale (scale/bounce) to all interactive cards/buttons | None | PLANNED |
| M3-1 | Material 3 Color Migration | Replace hardcoded colors with M3 tokens, verify light/dark theme adaptation & accessibility | None | PLANNED |
| VER-1 | E2E Test Suite Run & Fixes | Wait for TEST_READY.md, run E2E test suite, fix failures | All implement | PLANNED |
| VER-2 | Adversarial Hardening (Tier 5) | Challenger-initiated adversarial test generation & code fixing | VER-1 | PLANNED |

## Interface Contracts
### Premium Completion Overlay
- The overlay must accept parameters: `onPlayAgain` (VoidCallback), `onBack` (VoidCallback), and a list/map of statistics (e.g. time, score, moves, lives).
- The completion overlay should overlay the game board using a Stack widget or a Local History Route / Modal Overlay without completely destroying the current screen's widget tree so that it animates nicely.

### 3D Flip Card
- `MemoryCardTile` must manage its own rotation state or receive a transition from parent.

### Countdown Ring
- The countdown ring widget should receive double/int values and animate between ticks smoothly.
