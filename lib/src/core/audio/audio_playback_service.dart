import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show AssetBundle, rootBundle;
import 'package:rxdart/rxdart.dart';

import 'tts_service.dart';
export 'tts_service.dart' show TtsState;

enum _ActivePlaybackSource { none, audioClip, tts }

/// Audio playback service that acts as the primary audio player for Deutschy.
///
/// Pre-baked studio/neural MP3 clips from `assets/audio/` (mapped via
/// `assets/audio/manifest.json`) are the primary source of truth.
/// If an audio asset is missing or unplayable, the service seamlessly
/// falls back to [TtsService].
///
/// Emits unified [TtsState] events on [state] regardless of whether playback
/// was performed via pre-baked MP3 or TTS engine.
class AudioPlaybackService {
  AudioPlaybackService({
    AudioPlayer? audioPlayer,
    TtsService? ttsService,
    AssetBundle? assetBundle,
    Map<String, dynamic>? initialManifest,
  })  : _audioPlayer = audioPlayer ?? AudioPlayer(),
        _ttsService = ttsService ?? TtsService(),
        _assetBundle = assetBundle,
        _ownsPlayer = audioPlayer == null,
        _ownsTts = ttsService == null {
    if (initialManifest != null) {
      _manifest = initialManifest;
      _manifestLoaded = true;
    }
    _initSubscriptions();
  }

  final AudioPlayer _audioPlayer;
  final TtsService _ttsService;
  final AssetBundle? _assetBundle;
  final bool _ownsPlayer;
  final bool _ownsTts;

  final BehaviorSubject<TtsState> _state =
      BehaviorSubject.seeded(TtsState.idle);

  /// Unified state stream emitting [TtsState.playing] while audio or TTS
  /// is active, and [TtsState.idle] when playback finishes or stops.
  Stream<TtsState> get state => _state.stream;

  /// Current playback state snapshot.
  TtsState get currentState => _state.value;

  StreamSubscription<PlayerState>? _playerStateSub;
  StreamSubscription<void>? _playerCompleteSub;
  StreamSubscription<TtsState>? _ttsStateSub;

  Map<String, dynamic> _manifest = const {};
  bool _manifestLoaded = false;
  bool _isInitialized = false;

  _ActivePlaybackSource _activeSource = _ActivePlaybackSource.none;
  int _currentOperationId = 0;

  double _speechRate = 0.40; // Default learner rate matching TtsService

  /// Current speech rate setting.
  double get speechRate => _speechRate;

  /// Exposes the underlying [TtsService] fallback.
  TtsService get ttsService => _ttsService;

  /// Exposes the underlying [AudioPlayer].
  AudioPlayer get audioPlayer => _audioPlayer;

  void _initSubscriptions() {
    _playerStateSub = _audioPlayer.onPlayerStateChanged.listen((playerState) {
      if (_activeSource == _ActivePlaybackSource.audioClip) {
        if (playerState == PlayerState.playing) {
          if (_state.value != TtsState.playing) {
            _state.add(TtsState.playing);
          }
        } else if (playerState == PlayerState.completed ||
            playerState == PlayerState.stopped) {
          _activeSource = _ActivePlaybackSource.none;
          if (_state.value != TtsState.idle) {
            _state.add(TtsState.idle);
          }
        }
      }
    });

    _playerCompleteSub = _audioPlayer.onPlayerComplete.listen((_) {
      if (_activeSource == _ActivePlaybackSource.audioClip) {
        _activeSource = _ActivePlaybackSource.none;
        if (_state.value != TtsState.idle) {
          _state.add(TtsState.idle);
        }
      }
    });

    _ttsStateSub = _ttsService.state.listen((ttsState) {
      if (_activeSource == _ActivePlaybackSource.tts) {
        if (_state.value != ttsState) {
          _state.add(ttsState);
        }
        if (ttsState == TtsState.idle) {
          _activeSource = _ActivePlaybackSource.none;
        }
      }
    });
  }

  /// Initializes the service and preloads the audio manifest.
  Future<void> init() async {
    if (_isInitialized) return;
    await _loadManifest();
    await _ttsService.init();
    _isInitialized = true;
  }

  /// Sets in-memory manifest data directly (useful for tests and dynamic updates).
  void setManifest(Map<String, dynamic> manifest) {
    _manifest = manifest;
    _manifestLoaded = true;
  }

  /// Reloads `assets/audio/manifest.json`.
  Future<void> reloadManifest() async {
    _manifestLoaded = false;
    await _loadManifest();
  }

  Future<void> _loadManifest() async {
    if (_manifestLoaded) return;
    _manifestLoaded = true;
    try {
      final bundle = _assetBundle ?? rootBundle;
      final jsonString =
          await bundle.loadString('assets/audio/manifest.json');
      final decoded = json.decode(jsonString);
      if (decoded is Map<String, dynamic>) {
        _manifest = decoded;
      }
    } catch (e) {
      debugPrint('[AudioPlaybackService] manifest load warning: $e');
      _manifest = const {};
    }
  }

  /// Converts TTS-scale speech rates (typically ~0.35 - 0.55) to normal audio
  /// playback rates (~0.75x - 1.25x).
  double _toAudioPlayerRate(double rate) {
    if (rate >= 0.7 && rate <= 2.0) {
      return rate;
    }
    final mapped = rate / 0.45;
    return mapped.clamp(0.5, 2.0);
  }

  /// Updates speech and audio playback rates.
  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate;
    await _ttsService.setSpeechRate(rate);
    try {
      await _audioPlayer.setPlaybackRate(_toAudioPlayerRate(rate));
    } catch (e) {
      debugPrint('[AudioPlaybackService] setPlaybackRate ignored: $e');
    }
  }

  /// Sanitizes relative asset paths to the format expected by [AssetSource].
  ///
  /// Since audioplayers defaults to `prefix = 'assets/'`, this returns paths
  /// relative to `assets/` (e.g. `audio/f1/hash.mp3`).
  String _sanitizeAssetPath(String rawPath) {
    var path = rawPath.replaceAll('\\', '/').trim();
    while (path.startsWith('/')) {
      path = path.substring(1);
    }
    if (path.startsWith('assets/')) {
      path = path.substring('assets/'.length);
    }
    while (path.startsWith('/')) {
      path = path.substring(1);
    }
    if (!path.startsWith('audio/')) {
      path = 'audio/$path';
    }
    return path;
  }

  /// Looks up the audio clip file path for [text] and optional [voice] in the manifest.
  ///
  /// Supports:
  /// - Direct text keys (`"Hallo"`)
  /// - Voice-prefixed keys (`"f1|Hallo"`)
  /// - SHA-1 hash keys (full 40-char or 16-char prefix)
  /// - Nested objects with `file`, `path`, or `text` fields
  String? findClipFile(String text, {String? voice}) {
    if (_manifest.isEmpty) return null;

    final clips = _manifest['clips'];
    final Map<dynamic, dynamic> targetMap =
        (clips is Map) ? clips : _manifest;

    final q = text.trim();
    if (q.isEmpty) return null;

    // 1. Direct compound key match `voice|text`
    if (voice != null && voice.isNotEmpty) {
      final keyWithVoice = '$voice|$q';
      if (targetMap.containsKey(keyWithVoice)) {
        return _extractFilePath(targetMap[keyWithVoice]);
      }
    }

    // 2. Direct text key match
    if (targetMap.containsKey(q)) {
      return _extractFilePath(targetMap[q]);
    }

    // 3. Hash-based matches
    final textUtf8 = utf8.encode(q);
    final fullHashText = sha1.convert(textUtf8).toString();
    final shortHashText = fullHashText.substring(0, 16);

    if (targetMap.containsKey(fullHashText)) {
      return _extractFilePath(targetMap[fullHashText]);
    }
    if (targetMap.containsKey(shortHashText)) {
      return _extractFilePath(targetMap[shortHashText]);
    }

    if (voice != null && voice.isNotEmpty) {
      final vUtf8 = utf8.encode('$voice|$q');
      final fullHashV = sha1.convert(vUtf8).toString();
      final shortHashV = fullHashV.substring(0, 16);
      if (targetMap.containsKey(fullHashV)) {
        return _extractFilePath(targetMap[fullHashV]);
      }
      if (targetMap.containsKey(shortHashV)) {
        return _extractFilePath(targetMap[shortHashV]);
      }
    }

    // 4. Search entries by text attribute and compound key ending
    for (final entry in targetMap.entries) {
      final val = entry.value;
      final key = entry.key.toString();

      if (val is Map) {
        final entryText = val['text']?.toString().trim();
        final entryVoice = val['voice']?.toString();
        if (entryText == q) {
          if (voice == null || entryVoice == voice) {
            return _extractFilePath(val);
          }
        }
      }

      if (key.contains('|')) {
        final parts = key.split('|');
        final kVoice = parts[0];
        final kText = parts.sublist(1).join('|').trim();
        if (kText == q) {
          if (voice == null || kVoice == voice) {
            return _extractFilePath(val);
          }
        }
      }
    }

    // 5. Case-insensitive fallback
    final lowerQ = q.toLowerCase();
    for (final entry in targetMap.entries) {
      final val = entry.value;
      final key = entry.key.toString().toLowerCase();

      if (val is Map) {
        final entryText = val['text']?.toString().trim().toLowerCase();
        final entryVoice = val['voice']?.toString().toLowerCase();
        if (entryText == lowerQ) {
          if (voice == null || entryVoice == voice.toLowerCase()) {
            return _extractFilePath(val);
          }
        }
      }

      if (key.endsWith('|$lowerQ') || key == lowerQ) {
        return _extractFilePath(val);
      }
    }

    return null;
  }

  String? _extractFilePath(dynamic clipVal) {
    if (clipVal == null) return null;
    if (clipVal is String) return clipVal;
    if (clipVal is Map) {
      return clipVal['file']?.toString() ??
          clipVal['path']?.toString() ??
          clipVal['asset']?.toString();
    }
    return null;
  }

  /// Plays German audio for [text], selecting [voice] if specified.
  ///
  /// Checks `manifest.json` for a matching pre-baked MP3. If found and the asset
  /// is playable, audioplayers is used. Otherwise, falls back cleanly to [TtsService].
  Future<void> speak(String text, {String? voice}) async {
    await stop();
    final opId = ++_currentOperationId;

    final query = text.trim();
    if (query.isEmpty) return;

    if (!_manifestLoaded) {
      await _loadManifest();
    }
    if (opId != _currentOperationId) return;

    final clipPath = findClipFile(query, voice: voice);
    if (clipPath != null && clipPath.isNotEmpty) {
      final cleanPath = _sanitizeAssetPath(clipPath);
      final bundle = _assetBundle ?? rootBundle;
      final fullBundlePath = 'assets/$cleanPath';

      bool assetAvailable = false;
      try {
        await bundle.load(fullBundlePath);
        assetAvailable = true;
      } catch (e) {
        debugPrint(
            '[AudioPlaybackService] clip $fullBundlePath not found in bundle, falling back to TTS');
        assetAvailable = false;
      }

      if (opId != _currentOperationId) return;

      if (assetAvailable) {
        try {
          _activeSource = _ActivePlaybackSource.audioClip;
          _state.add(TtsState.playing);
          await _audioPlayer.setPlaybackRate(_toAudioPlayerRate(_speechRate));
          await _audioPlayer.play(AssetSource(cleanPath));
          return;
        } catch (e) {
          debugPrint(
              '[AudioPlaybackService] audioplayers failed for $cleanPath ($e), falling back to TTS');
          _activeSource = _ActivePlaybackSource.none;
        }
      }
    }

    // Fallback: TTS
    if (opId != _currentOperationId) return;
    _activeSource = _ActivePlaybackSource.tts;
    try {
      await _ttsService.speak(query);
    } catch (e) {
      debugPrint('[AudioPlaybackService] TTS fallback error: $e');
      _activeSource = _ActivePlaybackSource.none;
      if (_state.value != TtsState.idle) {
        _state.add(TtsState.idle);
      }
    }
  }

  /// Stops any currently playing audio clip or TTS speech immediately.
  Future<void> stop() async {
    _currentOperationId++;
    _activeSource = _ActivePlaybackSource.none;
    try {
      await _audioPlayer.stop();
    } catch (_) {}
    try {
      await _ttsService.stop();
    } catch (_) {}
    if (_state.value != TtsState.idle) {
      _state.add(TtsState.idle);
    }
  }

  /// Disposes all subscriptions, players, and state streams.
  Future<void> dispose() async {
    await stop();
    await _playerStateSub?.cancel();
    await _playerCompleteSub?.cancel();
    await _ttsStateSub?.cancel();
    if (_ownsPlayer) {
      await _audioPlayer.dispose();
    }
    if (_ownsTts) {
      await _ttsService.dispose();
    }
    await _state.close();
  }
}

/// Backwards-compatible proxy extending [TtsService] that delegates all operations
/// to [AudioPlaybackService].
///
/// Existing callers referencing [ttsServiceProvider] continue to work seamlessly
/// while gaining pre-baked MP3 audio capabilities.
class AudioPlaybackTtsProxy extends TtsService {
  AudioPlaybackTtsProxy(this._audioPlaybackService);

  final AudioPlaybackService _audioPlaybackService;

  @override
  Stream<TtsState> get state => _audioPlaybackService.state;

  @override
  double get speechRate => _audioPlaybackService.speechRate;

  @override
  Future<void> setSpeechRate(double rate) =>
      _audioPlaybackService.setSpeechRate(rate);

  @override
  Future<void> init() => _audioPlaybackService.init();

  @override
  Future<void> speak(String text) => _audioPlaybackService.speak(text);

  @override
  Future<void> stop() => _audioPlaybackService.stop();

  @override
  Future<void> dispose() async {
    // Lifecycle is owned by audioPlaybackServiceProvider
  }
}
