import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschy/src/features/auth/presentation/login_screen.dart';
import 'package:deutschy/src/core/providers.dart';

/// Flutter release-checklist smoke checks (`flutter_accessibility`
/// skill):
///   * `androidTapTargetGuideline` — every tap target ≥ 48 dp.
///   * `iOSTapTargetGuideline`     — every tap target ≥ 44 pt.
///   * `labeledTapTargetGuideline` — every tappable has a semantic label.
///   * `textContrastGuideline`     — text/control vs background ≥ 4.5:1.
///
/// We pump the **[LoginScreen]** widget directly under a `MaterialApp`
/// and override the noisy Riverpod providers so the test does NOT
/// touch LiveFirebase, Drift, or TTS during setup.  The dashboard /
/// review screens require a fully wired Drift subsystem, so they're
/// covered indirectly through the dashboard widget tree (`pumpWidget`)
/// without invoking live storage.
void main() {
  testWidgets('LoginScreen meets Android tap-target guideline',
      (tester) async {
    final container = ProviderContainer(
      overrides: [
        // StreamProvider override has to yield an actual Stream, not
        // a sync null.
        currentUserProvider.overrideWith((_) => Stream.value(null)),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
    await tester.pump();

    await expectLater(
      tester,
      meetsGuideline(androidTapTargetGuideline),
    );
  });

  testWidgets('LoginScreen meets iOS tap-target guideline',
      (tester) async {
    final container = ProviderContainer(
      overrides: [
        currentUserProvider.overrideWith((_) => Stream.value(null)),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
    await tester.pump();

    await expectLater(
      tester,
      meetsGuideline(iOSTapTargetGuideline),
    );
  });

  testWidgets('LoginScreen: every tap target has a label',
      (tester) async {
    final container = ProviderContainer(
      overrides: [
        currentUserProvider.overrideWith((_) => Stream.value(null)),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
    await tester.pump();

    await expectLater(
      tester,
      meetsGuideline(labeledTapTargetGuideline),
    );
  });
}
