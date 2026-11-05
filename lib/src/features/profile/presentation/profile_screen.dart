import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/profile_photo.dart';
import '../../../core/i18n/strings.dart';
import '../../../core/i18n/translations.dart';
import '../../../core/providers.dart';
import '../../../core/widgets/animations/deutschy_animations.dart';
import '../../../core/widgets/animations/premium_animations.dart';

import '../../../shared/widgets/audio_speed_picker.dart';
import 'settings_widgets.dart';

/// Profile + Settings hub.
///
/// Combines:
///   * Profile avatar & display name (top)
///   * Theme picker  (light / dark / system)
///   * Display language picker (de / en / fr / ar)
///   * Notifications master switch + daily reminder
///   * Sign-out
///   * About dialog
///
/// All controls read from providers in `lib/src/core/config/*` and
/// rebuild when the user changes them.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t(context, Str.navProfile)),
      ),
      body: userAsync.when(
        data: (user) => SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 120),
          child: StaggerCascade(
            delayMs: 70,
            children: [
              const _ProfileHeader(),
              const SizedBox(height: 28),
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
                Text('Profil konnte nicht geladen werden', style: theme.textTheme.bodyLarge),
                const SizedBox(height: 12),
                FilledButton.tonalIcon(
                  onPressed: () => ref.invalidate(currentUserProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Erneut versuchen'),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: theme.colorScheme.surface,
    );
  }
}

// ---------------------------------------------------------------------------
// Header (avatar + name + change-photo button).
// ---------------------------------------------------------------------------

class _ProfileHeader extends ConsumerWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final photo = ref.watch(profilePhotoProvider);
    final theme = Theme.of(context);

    final initial = userAsync.maybeWhen(
      data: (u) {
        final name = u?.displayName?.trim() ?? '';
        return name.isNotEmpty ? name.characters.first.toUpperCase() : 'G';
      },
      orElse: () => 'G',
    );

    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 52,
                backgroundColor: theme.colorScheme.primary,
                foregroundImage: photo != null
                    ? MemoryImage(photo)
                    : null,
                child: photo == null
                    ? Text(
                        initial,
                        style: TextStyle(
                          fontSize: 40,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Material(
                  color: theme.colorScheme.secondary,
                  shape: const CircleBorder(),
                  elevation: 2,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => _pickPhoto(context, ref),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.camera_alt,
                        color: theme.colorScheme.onSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            userAsync.maybeWhen(
              data: (u) {
                final name = u?.displayName?.trim() ?? '';
                return name.isNotEmpty ? name : 'Gast';
              },
              orElse: () => '…',
            ),
            style: theme.textTheme.titleLarge,
          ),
          TextButton.icon(
            icon: const Icon(Icons.edit, size: 16),
            label: Text(t(context, Str.settingsChangePhoto)),
            onPressed: () => _pickPhoto(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _pickPhoto(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(profilePhotoProvider.notifier);
    final source = await showModalBottomSheet<ImagePickerSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(t(ctx, Str.photoGallery)),
              onTap: () => Navigator.of(ctx).pop(ImagePickerSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_outlined),
              title: Text(t(ctx, Str.photoCamera)),
              onTap: () => Navigator.of(ctx).pop(ImagePickerSource.camera),
            ),
            if (ref.read(profilePhotoProvider) != null)
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: Text(t(ctx, Str.photoRemove)),
                onTap: () async {
                  Navigator.of(ctx).pop(ImagePickerSource.gallery);
                  await notifier.clear();
                },
              ),
          ],
        ),
      ),
    );
    if (source == ImagePickerSource.gallery) {
      await notifier.pickFromGallery();

    } else if (source == ImagePickerSource.camera) {
      await notifier.pickFromCamera();
    }
  }
}

enum ImagePickerSource { gallery, camera }


// ---------------------------------------------------------------------------
// Settings section classes live in `settings_widgets.dart`.  This file
// keeps only the screen scaffold + the avatar header.
// ---------------------------------------------------------------------------
