import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Native on-device speech recognition.  We delegate to Apple's
/// `SFSpeechRecognizer` on iOS and Android's built-in recognizer — both
/// run locally *and* support German (de-DE) out of the box.  No network,
/// no cost, no API key.
class SttService {
  SttService();

  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _initialized = false;
  bool get availableOnDevice => _initialized && _speech.isAvailable;

  /// Last partial/final transcription the user produced on the current
  /// listen session.  Always emits the latest recognized text so the UI
  /// can stream it into a chat bubble.
  Future<String> listenOnce({
    required ValueChanged<String> onPartial,
    Duration listenFor = const Duration(seconds: 12),
  }) async {
    if (!_initialized) {
      _initialized = await _speech.initialize(
        onError: (e) {
          debugPrint('STT error: ${e.errorMsg}');
        },
        onStatus: (s) {
          debugPrint('STT status: $s');
        },
      );
    }
    if (!_initialized) {
      throw const SttUnavailableException(
          'Speech recognition is not available on this device. '
          'On Android install Google app or enable dictation; on iOS '
          'ensure Siri dictation is enabled.');
    }

    final completer = Completer<String>();
    String lastRecognized = '';

    await _speech.listen(
      onResult: (SpeechRecognitionResult r) {
        lastRecognized = r.recognizedWords;
        onPartial(lastRecognized);
        if (r.finalResult) {
          completer.complete(lastRecognized);
        }
      },
      // listenOptions build avoids both the deprecated localeId top-level
      // arg and the localeId *named* arg.
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
        localeId: 'de_DE',
        // listenMode omitted intentionally — default is dictation which
        // suits language practice better than transcription mode.
      ),
    );

    // Hard cap: stop listening if the caller hangs longer than listenFor.
    Future.delayed(listenFor, () {
      try {
        _speech.stop();
      } catch (_) {}
      if (!completer.isCompleted) {
        completer.complete(lastRecognized);
      }
    });

    return completer.future;
  }

  Future<void> cancel() async {
    if (_initialized) {
      await _speech.cancel();
    }
  }
}

class SttUnavailableException implements Exception {
  const SttUnavailableException(this.message);
  final String message;
  @override
  String toString() => message;
}
