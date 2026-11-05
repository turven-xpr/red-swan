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
  TtsService();

  final FlutterTts _tts = FlutterTts();

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
    await _tts.setSpeechRate(rate);
  }

  Future<void> init() async {
    if (_initialized) return;

    await _tts.setLanguage('de-DE');
    await _tts.setSpeechRate(_speechRate);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    // Wire lifecycle events from the platform plugin into our own stream.
    _tts.setStartHandler(() => _state.add(TtsState.playing));
    _tts.setCompletionHandler(() => _state.add(TtsState.idle));
    _tts.setCancelHandler(() => _state.add(TtsState.idle));
    _tts.setErrorHandler((_) => _state.add(TtsState.idle));

    _initialized = true;
  }

  Future<void> speak(String text) async {
    await init();
    await _tts.stop(); // cancel anything queued
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }

  Future<void> dispose() async {
    await _tts.stop();
    await _state.close();
  }
}

enum TtsState { idle, playing }
