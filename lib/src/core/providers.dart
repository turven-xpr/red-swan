import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../data/local/app_database.dart';
import '../data/remote/gemini_client.dart';
import '../data/seed/starter_decks.dart';
import '../data/seed/a2_deck.dart';
import '../data/seed/b1_deck.dart';
import '../data/seed/in_memory_deck.dart';
import 'audio/tts_service.dart';
import 'audio/audio_playback_service.dart';
import 'audio/stt_service.dart';
import 'config/app_config.dart';
import '../features/auth/application/auth_service.dart';
import '../features/vocabulary/application/srs_scheduler.dart';

/// Provider for the singleton AppDatabase.  Kept alive for the lifetime
/// of the app - Drift holds an SQLite handle.
///
/// NOTE: the database is *lazily* opened only when the first screen
/// actually needs it (see `driftInitProvider`).  Mounting the router
/// no longer awaits this - that's what buys us ~300ms of cold-start.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// One-shot async init.  Replaces the old blocking path that ran
/// synchronously before the router mounted.  Touches the Drift handle
/// so the SQLite open happens off the critical path.  Callers kick it
/// via `WidgetsBinding.instance.addPostFrameCallback` in `main.dart`.
final driftInitProvider = FutureProvider<void>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  // Force the lazy open by consuming one event from each stream.
  await db.watchAllScenarios().first
      .timeout(const Duration(seconds: 5), onTimeout: () => <SpeakingScenario>[]);
  await db.watchAllFlashcards().first
      .timeout(const Duration(seconds: 5), onTimeout: () => <Flashcard>[]);
});

/// Synchronous, in-memory mirror of the A1 starter deck.
///
/// The point: the very first frame of the app can already render
/// vocabulary without waiting for Drift to open.  This provider is the
/// data source during that brief window - `cachedFlashcardsProvider`
/// below merges it with Drift once Drift is live.
final inMemoryDeckProvider = Provider<List<InMemorySeedCard>>(
  (ref) => kInMemoryA1Deck,
);

/// Reactive merge of the in-memory deck + live Drift rows.
///
/// Behaviour:
///   * First load: emits the in-memory deck synchronously as a stub
///     (`repetitions=0`, `nextReviewDate=now`) so screens can render
///     before Drift finishes opening.
///   * Once Drift is open, switches to the live Drift-backed stream.
///
/// Uses a single subscription to the database stream to avoid rebuild storms.
final cachedFlashcardsProvider = StreamProvider<List<Flashcard>>((ref) async* {
  // 1. Emit the synchronous stub list immediately - no Drift await.
  final stub = <Flashcard>[
    for (final s in kInMemoryA1Deck)
      Flashcard(
        id: s.stableId.hashCode & 0x7fffffff,
        german: s.german,
        english: s.english,
        partOfSpeech: s.partOfSpeech,
        exampleGerman: s.exampleGerman,
        exampleEnglish: s.exampleEnglish,
        level: s.level,
        repetitions: 0,
        easeFactor: 2.5,
        intervalDays: 0,
        nextReviewDate: DateTime.now(),
        createdAt: DateTime(2024, 1, 1),
      ),
  ];
  yield stub;

  // 2. Await Drift readiness, then switch to the live stream.
  //    Use ref.read to avoid re-watching on rebuilds.
  await ref.read(driftInitProvider.future);
  yield* ref.read(appDatabaseProvider).watchAllFlashcards();
});

/// Reactive count of flashcards due for review RIGHT NOW.  Reads from
/// the cached flashcards so the dashboard can render even before Drift
/// loads.
final cachedDueCountProvider = Provider<int>((ref) {
  final cards = ref.watch(cachedFlashcardsProvider).value ?? const <Flashcard>[];
  return cards.where((c) => c.nextReviewDate.isBefore(DateTime.now())).length;
});

/// Bootstraps the database with the curated A1 deck on first launch.
/// Safe to call after Drift is open (kicks off `insertMany` once per
/// install).  Triggered by `driftInitProvider`'s success callback now.
final seedBootstrapProvider = FutureProvider<void>((ref) async {
  await ref.read(driftInitProvider.future);
  final db = ref.read(appDatabaseProvider);
  final existing = await db.watchAllFlashcards().first;
  
  final hasA1 = existing.any((c) => c.level == 'A1');
  final hasA2 = existing.any((c) => c.level == 'A2');
  final hasB1 = existing.any((c) => c.level == 'B1');

  final List<FlashcardsCompanion> toInsert = [];
  if (!hasA1) {
    toInsert.addAll(StarterFlashcards.a1Deck());
  }
  if (!hasA2) {
    toInsert.addAll(A2Deck.entries(now: DateTime.now()));
  }
  if (!hasB1) {
    toInsert.addAll(B1Deck.entries(now: DateTime.now()));
  }
  
  if (toInsert.isNotEmpty) {
    await db.insertMany(toInsert);
  }

  final scenarios = await db.watchAllScenarios().first;
  final hasB1Scenario = scenarios.any((s) => s.level == 'B1');
  if (scenarios.isEmpty) {
    await db.insertScenarios(StarterScenarios.presets());
  } else if (!hasB1Scenario) {
    await db.deleteAllScenarios();
    await db.insertScenarios(StarterScenarios.presets());
  }
});

final srsSchedulerProvider = Provider<SrsScheduler>((ref) => SrsScheduler());

final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 3),
      sendTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );
});

/// Gemini client pointed at our secure proxy endpoint.  Source of truth
/// is `kGeminiProxyUrl` in `lib/src/core/config/app_config.dart`.  Override
/// at compile-time via `--dart-define=DEUTSCHY_PROXY_URL=https://your-deploy`.
final geminiProxyUrlProvider = Provider<Uri>(
  (ref) => Uri.parse(kGeminiProxyUrl),
);

final geminiClientProvider = Provider<GeminiClient>((ref) {
  final primaryProxy = ref.watch(geminiProxyUrlProvider).toString();

  const envKey1 = String.fromEnvironment('NVIDIA_API_KEY_1');
  const envKey2 = String.fromEnvironment('NVIDIA_API_KEY_2');
  const envKey3 = String.fromEnvironment('NVIDIA_API_KEY_3');

  final endpoints = [
    AiEndpoint(url: primaryProxy),
    AiEndpoint(
      url: 'https://integrate.api.nvidia.com/v1/chat/completions',
      apiKey: envKey1,
      modelName: 'meta/llama-3.1-70b-instruct',
    ),
    AiEndpoint(
      url: 'https://integrate.api.nvidia.com/v1/chat/completions',
      apiKey: envKey2,
      modelName: 'meta/llama-3.1-70b-instruct',
    ),
    AiEndpoint(
      url: 'https://integrate.api.nvidia.com/v1/chat/completions',
      apiKey: envKey3,
      modelName: 'meta/llama-3.1-70b-instruct',
    ),
  ];

  return GeminiClient(
    dio: ref.watch(dioProvider),
    endpoints: endpoints.where((e) => e.url.isNotEmpty).toList(),
  );
});

/// Internal fallback TTS service provider.
final internalTtsServiceProvider = Provider<TtsService>((ref) {
  final svc = TtsService();
  ref.onDispose(svc.dispose);
  return svc;
});

/// Primary audio playback service with pre-baked MP3 support and TTS fallback.
final audioPlaybackServiceProvider = Provider<AudioPlaybackService>((ref) {
  final tts = ref.watch(internalTtsServiceProvider);
  final svc = AudioPlaybackService(ttsService: tts);
  ref.onDispose(svc.dispose);
  return svc;
});

/// Backwards-compatible provider proxy for callers expecting [TtsService].
/// Delegates all playback seamlessly to [AudioPlaybackService].
final ttsServiceProvider = Provider<TtsService>((ref) {
  final audioPlayback = ref.watch(audioPlaybackServiceProvider);
  return AudioPlaybackTtsProxy(audioPlayback);
});

final sttServiceProvider = Provider<SttService>((ref) => SttService());

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

/// Reactive auth state - the rest of the app listens to this via
/// ref.watch to drive router guards and dashboard personalisation.
///
/// Backed by Firebase Auth streams so `/home` reactively updates as
/// sign-in / sign-out transitions happen elsewhere in the app.
final currentUserProvider = StreamProvider<AuthUser?>((ref) async* {
  final svc = ref.watch(authServiceProvider);
  yield svc.currentUser();
  yield* svc.watch();
});
