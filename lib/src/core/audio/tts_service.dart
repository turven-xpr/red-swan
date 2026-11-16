import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:rxdart/rxdart.dart';

/// Thin wrapper around `flutter_tts` that preconfigures the German voice
/// once per session, exposes a stream of TTS lifecycle events, and
/// guarantees German playback is *slow* enough for learners (~0.4× speed).
///
/// Using the system TTS engine is intentional: it costs $0, works offline,
/// and the OS-bundled voices render German with correct prosody (unlike a
/// remote TTS API where each call would burn CPU + bandwidth + cash).
class TtsService {
  TtsService({FlutterTts? tts}) : _tts = tts;

  FlutterTts? _tts;
  FlutterTts get _effectiveTts => _tts ??= FlutterTts();

  /// Emits the high-level lifecycle so UI can dim controls while the
  /// device is speaking.
  final BehaviorSubject<TtsState> _state =
      BehaviorSubject.seeded(TtsState.idle);
  Stream<TtsState> get state => _state.stream;

  bool _initialized = false;
  double _speechRate = 0.40; // Default learner rate (~0.75x relative)
  double get speechRate => _speechRate;

  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate;
    await _effectiveTts.setSpeechRate(rate);
  }

  Future<void> init() async {
    if (_initialized) return;

    await _effectiveTts.setLanguage('de-DE');
    await _effectiveTts.setSpeechRate(_speechRate);
    await _effectiveTts.setVolume(1.0);
    await _effectiveTts.setPitch(1.0);

    // Wire lifecycle events from the platform plugin into our own stream.
    _effectiveTts.setStartHandler(() => _state.add(TtsState.playing));
    _effectiveTts.setCompletionHandler(() => _state.add(TtsState.idle));
    _effectiveTts.setCancelHandler(() => _state.add(TtsState.idle));
    _effectiveTts.setErrorHandler((_) => _state.add(TtsState.idle));

    _initialized = true;
  }

  Future<void> speak(String text) async {
    await init();
    await _effectiveTts.stop(); // cancel anything queued
    await _effectiveTts.speak(text);
  }

  Future<void> stop() async {
    if (_initialized || _tts != null) {
      await _effectiveTts.stop();
    }
  }

  Future<void> dispose() async {
    if (_initialized || _tts != null) {
      await _effectiveTts.stop();
    }
    await _state.close();
  }
}

enum TtsState { idle, playing }
