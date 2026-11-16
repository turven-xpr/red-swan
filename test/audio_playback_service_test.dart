import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:deutschy/src/core/audio/audio_playback_service.dart';
import 'package:deutschy/src/core/audio/tts_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAudioPlayer extends Fake implements AudioPlayer {
  final StreamController<PlayerState> _stateController =
      StreamController<PlayerState>.broadcast();
  final StreamController<void> _completeController =
      StreamController<void>.broadcast();

  Source? lastSource;
  double? lastPlaybackRate;
  bool stopCalled = false;
  bool disposeCalled = false;
  bool shouldFailPlay = false;

  @override
  Stream<PlayerState> get onPlayerStateChanged => _stateController.stream;

  @override
  Stream<void> get onPlayerComplete => _completeController.stream;

  @override
  Future<void> play(Source source,
      {double? volume,
      double? balance,
      AudioContext? ctx,
      Duration? position,
      PlayerMode? mode}) async {
    if (shouldFailPlay) {
      throw Exception('Audio player failed to play source');
    }
    lastSource = source;
    _stateController.add(PlayerState.playing);
  }

  @override
  Future<void> stop() async {
    stopCalled = true;
    _stateController.add(PlayerState.stopped);
  }

  @override
  Future<void> setPlaybackRate(double playbackRate) async {
    lastPlaybackRate = playbackRate;
  }

  @override
  Future<void> dispose() async {
    disposeCalled = true;
    await _stateController.close();
    await _completeController.close();
  }

  void simulateComplete() {
    _completeController.add(null);
    _stateController.add(PlayerState.completed);
  }
}

class FakeTtsService extends Fake implements TtsService {
  final StreamController<TtsState> _stateController =
      StreamController<TtsState>.broadcast();

  final List<String> spokenTexts = [];
  bool stopCalled = false;
  bool initCalled = false;
  bool disposeCalled = false;
  double _speechRate = 0.40;

  @override
  Stream<TtsState> get state => _stateController.stream;

  @override
  double get speechRate => _speechRate;

  @override
  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate;
  }

  @override
  Future<void> init() async {
    initCalled = true;
  }

  @override
  Future<void> speak(String text) async {
    spokenTexts.add(text);
    _stateController.add(TtsState.playing);
  }

  @override
  Future<void> stop() async {
    stopCalled = true;
    _stateController.add(TtsState.idle);
  }

  @override
  Future<void> dispose() async {
    disposeCalled = true;
    await _stateController.close();
  }

  void simulateComplete() {
    _stateController.add(TtsState.idle);
  }
}

class FakeAssetBundle extends Fake implements AssetBundle {
  final Map<String, String> stringAssets = {};
  final Set<String> binaryAssets = {};

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (stringAssets.containsKey(key)) {
      return stringAssets[key]!;
    }
    throw FlutterError('Unable to load asset: $key');
  }

  @override
  Future<ByteData> load(String key) async {
    if (binaryAssets.contains(key)) {
      return ByteData(10);
    }
    throw FlutterError('Unable to load asset: $key');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AudioPlaybackService', () {
    late FakeAudioPlayer fakeAudioPlayer;
    late FakeTtsService fakeTtsService;
    late FakeAssetBundle fakeAssetBundle;
    late AudioPlaybackService audioService;

    final testManifest = {
      'clips': {
        'f1|Hallo': {
          'file': 'f1/clip_hallo.mp3',
          'text': 'Hallo',
          'voice': 'f1',
        },
        'Guten Tag': {
          'file': 'm1/clip_guten_tag.mp3',
          'text': 'Guten Tag',
          'voice': 'm1',
        },
        'Tschüss': 'audio/f2/clip_tschuess.mp3',
      }
    };

    setUp(() {
      fakeAudioPlayer = FakeAudioPlayer();
      fakeTtsService = FakeTtsService();
      fakeAssetBundle = FakeAssetBundle();

      fakeAssetBundle.stringAssets['assets/audio/manifest.json'] =
          json.encode(testManifest);
      // Mark f1/clip_hallo.mp3 as available in bundle
      fakeAssetBundle.binaryAssets.add('assets/audio/f1/clip_hallo.mp3');

      audioService = AudioPlaybackService(
        audioPlayer: fakeAudioPlayer,
        ttsService: fakeTtsService,
        assetBundle: fakeAssetBundle,
      );
    });

    tearDown(() async {
      await audioService.dispose();
    });

    test('initializes with idle state and default learner speech rate', () {
      expect(audioService.currentState, TtsState.idle);
      expect(audioService.speechRate, 0.40);
    });

    test('findClipFile resolves direct compound key and text keys', () async {
      await audioService.init();

      // Compound key match with voice
      expect(
        audioService.findClipFile('Hallo', voice: 'f1'),
        'f1/clip_hallo.mp3',
      );

      // Match by text in entry without explicit voice
      expect(
        audioService.findClipFile('Hallo'),
        'f1/clip_hallo.mp3',
      );

      // Direct text key
      expect(
        audioService.findClipFile('Guten Tag'),
        'm1/clip_guten_tag.mp3',
      );

      // String value path
      expect(
        audioService.findClipFile('Tschüss'),
        'audio/f2/clip_tschuess.mp3',
      );

      // Missing clip
      expect(
        audioService.findClipFile('Unbekannt'),
        isNull,
      );
    });

    test('plays audio clip via audioplayers when present in manifest and bundle',
        () async {
      final states = <TtsState>[];
      final sub = audioService.state.listen(states.add);

      await audioService.speak('Hallo', voice: 'f1');

      expect(fakeAudioPlayer.lastSource, isNotNull);
      final assetSource = fakeAudioPlayer.lastSource as AssetSource;
      expect(assetSource.path, 'audio/f1/clip_hallo.mp3');
      expect(audioService.currentState, TtsState.playing);
      expect(fakeTtsService.spokenTexts, isEmpty);

      // Simulate audio playback complete
      fakeAudioPlayer.simulateComplete();
      await Future<void>.delayed(Duration.zero);

      expect(audioService.currentState, TtsState.idle);
      await sub.cancel();
    });

    test('falls back cleanly to TTS when clip is missing from manifest',
        () async {
      final states = <TtsState>[];
      final sub = audioService.state.listen(states.add);

      await audioService.speak('Auf Wiedersehen');

      expect(fakeTtsService.spokenTexts, contains('Auf Wiedersehen'));
      expect(audioService.currentState, TtsState.playing);

      fakeTtsService.simulateComplete();
      await Future<void>.delayed(Duration.zero);

      expect(audioService.currentState, TtsState.idle);
      await sub.cancel();
    });

    test('falls back to TTS when clip is in manifest but asset is missing from bundle',
        () async {
      // 'Guten Tag' is in manifest but NOT in fakeAssetBundle.binaryAssets
      await audioService.speak('Guten Tag');

      expect(fakeTtsService.spokenTexts, contains('Guten Tag'));
      expect(fakeAudioPlayer.lastSource, isNull);
    });

    test('falls back to TTS when audioplayers throws an error', () async {
      fakeAudioPlayer.shouldFailPlay = true;

      await audioService.speak('Hallo', voice: 'f1');

      // Failed in AudioPlayer -> fell back to TTS
      expect(fakeTtsService.spokenTexts, contains('Hallo'));
    });

    test('stop cancels active playback and resets state to idle', () async {
      await audioService.speak('Hallo', voice: 'f1');
      expect(audioService.currentState, TtsState.playing);

      await audioService.stop();

      expect(fakeAudioPlayer.stopCalled, isTrue);
      expect(fakeTtsService.stopCalled, isTrue);
      expect(audioService.currentState, TtsState.idle);
    });

    test('setSpeechRate updates speech rate and sets playback rate on AudioPlayer',
        () async {
      await audioService.setSpeechRate(0.35);

      expect(audioService.speechRate, 0.35);
      expect(fakeTtsService.speechRate, 0.35);
      expect(fakeAudioPlayer.lastPlaybackRate, isNotNull);
      // 0.35 / 0.45 ≈ 0.777
      expect(fakeAudioPlayer.lastPlaybackRate!, closeTo(0.78, 0.05));
    });

    test('AudioPlaybackTtsProxy delegates seamlessly to AudioPlaybackService',
        () async {
      final proxy = AudioPlaybackTtsProxy(audioService);

      expect(proxy.speechRate, 0.40);
      expect(proxy.state, emits(TtsState.idle));

      await proxy.speak('Hallo');
      expect(fakeAudioPlayer.lastSource, isNotNull);

      await proxy.stop();
      expect(fakeAudioPlayer.stopCalled, isTrue);
    });
  });
}
