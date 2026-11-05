import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../data/local/app_database.dart';

import '../../../core/i18n/strings.dart';

import '../../../core/i18n/translations.dart';

class ScenariosScreen extends ConsumerWidget {
  const ScenariosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scenariosAsync = ref.watch(_scenariosProvider);
    return Scaffold(
      appBar: AppBar(title: Text(t(context, Str.navSpeaking))),
      body: scenariosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cloud_off_rounded, size: 48,
                    color: Theme.of(context).colorScheme.error),
                const SizedBox(height: 12),
                Text('Szenarien konnten nicht geladen werden.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 16),
                FilledButton.tonalIcon(
                  onPressed: () => ref.invalidate(_scenariosProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Erneut versuchen'),
                ),
              ],
            ),
          ),
        ),
        data: (rows) => rows.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.chat_bubble_outline_rounded, size: 48,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4)),
                    const SizedBox(height: 12),
                    Text('Noch keine Szenarien verfügbar.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        )),
                  ],
                ),
              )
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: rows.length,
          itemBuilder: (context, i) {
            final s = rows[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(s.level),
                ),
                title: Text(s.title,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(s.description),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go('/speaking/chat/${s.id}'),
              ),
            );
          },
        ),
      ),
    );
  }
}

final _scenariosProvider = StreamProvider<List<SpeakingScenario>>((ref) {
  return ref.watch(appDatabaseProvider).watchAllScenarios();
});
