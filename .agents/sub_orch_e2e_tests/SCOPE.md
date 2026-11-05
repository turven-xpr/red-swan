# Scope: E2E Testing Suite

## Architecture
- Dual track E2E testing runner and layout in `test/`.
- Flutter Widget/Integration testing framework mapping to MemoryMatchScreen and WordChainScreen.
- Drift database seeds and Riverpod provider overrides to mock dependencies without hitting active Firebase/STT/TTS.

## Milestones
| # | Name | Scope | Dependencies | Status |
|---|------|-------|-------------|--------|
| 1 | Design & Feature Inventory | Explore games screen widgets and database, inventory features, and write `TEST_INFRA.md` | None | DONE |
| 2 | Test Suite Implementation | Implement the full E2E test suite covering Tiers 1-4 in `test/games_e2e_test.dart` | M1 | DONE |
| 3 | Verification & Publication | Verify test execution, ensure coverage meets thresholds, and write `TEST_READY.md` | M2 | PLANNED |

## Interface Contracts
- No runtime dependencies on real audio (TTS/STT), Firebase, or Ad service; all overridden with stubs.
- Test runner command: `flutter test test/games_e2e_test.dart`.
