// Settings widgets split out of `profile_screen.dart` to keep that
// file small.  All classes in this file are public (no leading
// underscore) so they can be reused by future surfaces (e.g. a
// dedicated Settings tab).  Visibility is at the file boundary, not
// the language boundary — privacy of these widgets is purely
// structural.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/audio/notification_service.dart';
import '../../../core/config/app_locale.dart';
import '../../../core/config/notifications_pref.dart';
import '../../../core/config/theme_pref.dart';
import '../../../core/i18n/strings.dart';
import '../../../core/i18n/translations.dart';
import '../../../core/providers.dart';

/// Card-shaped section with a small caps title.  Used everywhere on
/// the Profile screen to group controls into a "what does this
/// configure" unit.
class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key, required this.title, required this.child});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

/// Theme selector — segmented light/dark/system control.
class ThemeControl extends ConsumerWidget {
  const ThemeControl({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pref = ref.watch(themePreferenceProvider);
    return SegmentedButton<ThemePreference>(
      segments: [
        ButtonSegment(
          value: ThemePreference.system,
          icon: const Icon(Icons.settings_brightness),
          label: Text(t(context, Str.settingsThemeSystem)),
        ),
        ButtonSegment(
          value: ThemePreference.light,
          icon: const Icon(Icons.light_mode_outlined),
          label: Text(t(context, Str.settingsThemeLight)),
        ),
        ButtonSegment(
          value: ThemePreference.dark,
          icon: const Icon(Icons.dark_mode_outlined),
          label: Text(t(context, Str.settingsThemeDark)),
        ),
      ],
      selected: {pref},
      onSelectionChanged: (s) =>
          ref.read(themePreferenceProvider.notifier).set(s.first),
    );
  }
}

/// Language selector — chips for de / en / fr / ar.
class LanguageControl extends ConsumerWidget {
  const LanguageControl({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(appLocaleProvider);
    final theme = Theme.of(context);
    final locales = [
      const Locale(LocaleCode.english),
      const Locale(LocaleCode.arabic),
      const Locale(LocaleCode.spanish),
    ];
    return Wrap(
      spacing: 8,
      children: [
        for (final loc in locales)
          ChoiceChip(
            label: Text(AppLocale.label(loc)),
            selected: active.languageCode == loc.languageCode,
            onSelected: (_) =>
                ref.read(appLocaleProvider.notifier).setLocale(loc),
            selectedColor: theme.colorScheme.primary,
            labelStyle: TextStyle(
              color: active.languageCode == loc.languageCode
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface,
            ),
          ),
      ],
    );
  }
}

/// Notifications master switch + reminder time + streak nudges.
class NotificationsControl extends ConsumerWidget {
  const NotificationsControl({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notif = ref.watch(notificationsPrefsProvider);
    final notifier = ref.read(notificationsPrefsProvider.notifier);
    return Column(
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(t(context, Str.settingsNotifications)),
          value: notif.enabled,
          onChanged: (v) async {
            await notifier.setEnabled(v);
            final svc = ref.read(notificationServiceProvider);
            if (v) {
              await svc.init();
              final granted = await svc.requestPermissions();
              if (!granted) {
                await notifier.setEnabled(false);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Berechtigung verweigert. Aktiviere sie in den Systemeinstellungen.',
                      ),
                    ),
                  );
                }
                return;
              }
              final tod = notif.reminderTime ?? const TimeOfDay(hour: 19, minute: 0);
              await svc.setDailyReminder(hour: tod.hour, minute: tod.minute);
            } else {
              await svc.cancelDailyReminder();
            }
          },
        ),
        if (notif.enabled) ...[
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.schedule),
            title: Text(t(context, Str.settingsReminderTime)),
            subtitle: Text(
              notif.reminderTime == null
                  ? '—:—'
                  : '${notif.reminderTime!.hour.toString().padLeft(2, '0')}:'
                      '${notif.reminderTime!.minute.toString().padLeft(2, '0')}',
            ),
            trailing: TextButton(
              onPressed: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: notif.reminderTime ??
                      const TimeOfDay(hour: 19, minute: 0),
                );
                if (picked != null) {
                  await notifier.setReminderTime(picked);
                  await ref
                      .read(notificationServiceProvider)
                      .setDailyReminder(
                          hour: picked.hour, minute: picked.minute);
                }
              },
              child: const Text('Zeit ändern'),
            ),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(t(context, Str.settingsStreak)),
            value: notif.streakNudges,
            onChanged: notifier.setStreakNudges,
          ),
        ],
        if (!notif.enabled)
          PlannedPlaceholder(
            title: t(context, Str.settingsPlannedOnboardingTitle),
            body: t(context, Str.settingsPlannedOnboardingBody),
          ),
      ],
    );
  }
}

/// Account block — shows the current user and offers a sign-out
/// button if the user is signed in.
class AccountControl extends ConsumerWidget {
  const AccountControl({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        userAsync.maybeWhen(
          data: (u) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.account_circle_outlined),
            title: Text(u?.email ?? 'Gast'),
            subtitle: Text(u?.provider.name ?? '—'),
          ),
          orElse: () => const SizedBox.shrink(),
        ),
        if (userAsync.value != null)
          OutlinedButton.icon(
            icon: const Icon(Icons.logout),
            label: Text(t(context, Str.settingsSignOut)),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            onPressed: () async {
              await ref.read(authServiceProvider).signOut();
              if (!context.mounted) return;
              GoRouter.of(context).go('/');
            },
          ),
      ],
    );
  }
}

/// About / version card.  Tap opens the standard Material About
/// dialog.
class AboutControl extends ConsumerWidget {
  const AboutControl({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.surface,
      child: ListTile(
        leading: const Icon(Icons.info_outline),
        title: Text(t(context, Str.settingsAbout)),
        subtitle: Text(t(context, Str.settingsAboutBody)),
        trailing: const Text('v1.1.0'),
        onTap: () => showAboutDialog(
          context: context,
          applicationName: t(context, Str.appName),
          applicationVersion: '${t(context, Str.settingsVersion)} 1.1.0',
          children: [Text(t(context, Str.settingsAboutBody))],
        ),
      ),
    );
  }
}

/// Inline callout used by disabled feature areas to surface a
/// "this is shipping later" message without resorting to dead links.
class PlannedPlaceholder extends StatelessWidget {
  const PlannedPlaceholder({
    super.key,
    required this.title,
    required this.body,
  });
  final String title;
  final String body;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 4),
                Text(body, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}