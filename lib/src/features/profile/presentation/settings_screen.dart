import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/strings.dart';
import '../../../core/i18n/translations.dart';
import '../../../core/providers.dart';
import '../../../core/widgets/animations/deutschy_animations.dart';
import '../../../core/widgets/animations/premium_animations.dart';
import '../../../shared/widgets/audio_speed_picker.dart';
import 'settings_widgets.dart';

/// Preserved settings screen (Theme, Language, Notifications, Account, About).
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: userAsync.when(
        data: (user) => SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 120),
          child: StaggerCascade(
            delayMs: 70,
            children: [
              SettingsSection(
                title: t(context, Str.settingsTheme),
                child: const ThemeControl(),
              ),
              const SizedBox(height: 16),
              SettingsSection(
                title: t(context, Str.settingsLanguage),
                child: const LanguageControl(),
              ),
              const SizedBox(height: 16),
              SettingsSection(
                title: 'Audio-Geschwindigkeit',
                child: const AudioSpeedPicker(),
              ),
              const SizedBox(height: 16),
              SettingsSection(
                title: t(context, Str.settingsNotifications),
                child: const NotificationsControl(),
              ),
              const SizedBox(height: 16),
              SettingsSection(
                title: t(context, Str.settingsAccount),
                child: const AccountControl(),
              ),
              const SizedBox(height: 24),
              const AboutControl(),
            ],
          ),
        ),
        loading: () => const Center(child: FadingRing(size: 32)),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline_rounded, size: 48, color: theme.colorScheme.error),
                const SizedBox(height: 12),
                Text('Settings could not be loaded', style: theme.textTheme.bodyLarge),
                const SizedBox(height: 12),
                FilledButton.tonalIcon(
                  onPressed: () => ref.invalidate(currentUserProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

