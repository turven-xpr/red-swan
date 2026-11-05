import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/onboarding_pref.dart';
import '../../../core/i18n/strings.dart';
import '../../../core/i18n/translations.dart';
import '../../../core/widgets/animations/premium_animations.dart';

/// Full-screen onboarding shown exactly once on first launch.
/// The user picks a CEFR start level; the choice is persisted
/// and the app routes to the dashboard thereafter.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  StartLevel? _selected;
  bool _committing = false;

  void _commit() async {
    if (_selected == null || _committing) return;
    setState(() => _committing = true);
    await ref
        .read(onboardingPrefsProvider.notifier)
        .setShown(_selected!);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 1),
                  StaggerCascade(
                    children: [
                      // Logo area
                      Icon(Icons.school_rounded, size: 72, color: cs.primary),
                      const SizedBox(height: 16),
                      Text(
                        t(context, Str.onboardingTitle),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        t(context, Str.onboardingBody),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.72),
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Level picker tiles
                      Text(
                        t(context, Str.onboardingPickLevel),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: cs.onSurfaceVariant,
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 12),
                      for (final lvl in StartLevel.values)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: PressScaleEffect(
                            onTap: () => setState(() => _selected = lvl),
                            child: _LevelTile(
                              level: lvl,
                              selected: _selected == lvl,
                              onTap: () => setState(() => _selected = lvl),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const Spacer(flex: 1),
                  // Commit button
                  FilledButton(
                    onPressed: _selected != null && !_committing ? _commit : null,
                    child: _committing
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              color: cs.onPrimary,
                            ),
                          )
                        : Text(
                            t(context, Str.onboardingCta),
                            style: const TextStyle(fontSize: 16),
                          ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LevelTile extends StatelessWidget {
  const _LevelTile({
    required this.level,
    required this.selected,
    required this.onTap,
  });
  final StartLevel level;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final bg = selected ? cs.primaryContainer : cs.surfaceContainerHigh;
    final fg = selected ? cs.onPrimaryContainer : cs.onSurface.withValues(alpha: 0.8);

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Material(
        color: bg,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: selected
                        ? cs.primary
                        : cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    startLevelCEFR(level),
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      color: selected ? cs.onPrimary : cs.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    startLevelLabel(level),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: fg,
                    ),
                  ),
                ),
                if (selected)
                  Icon(Icons.check_circle_rounded, color: cs.primary, size: 22)
                else
                  const SizedBox(width: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}