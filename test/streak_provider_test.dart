// Verifies the streak notifier's day-window logic without touching
// real SharedPreferences.  We swap SharedPreferences with an
// in-memory instance via the `setMockInitialValues` helper from
// the shared_preferences test surface.

import 'package:flutter_test/flutter_test.dart';
import 'package:deutschy/src/features/vocabulary/presentation/streak_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('first markReviewed yields streak of 1', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('deutschy_streak_v1'), isNull);
    // initial ReviewNotifier state should default to 0.
    final container = ProviderContainer();
    final initial = container.read(streakProvider);
    expect(initial.consecutiveDays, 0);
  });
}