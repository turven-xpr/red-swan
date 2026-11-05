import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';

/// Reusable control for adjusting audio / TTS playback speed.
/// Rates:
///   * 0.35 = 0.75x (slow learner mode)
///   * 0.45 = 1.0x (normal speed)
///   * 0.55 = 1.25x (fast speed)
class AudioSpeedPicker extends ConsumerWidget {
  const AudioSpeedPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tts = ref.watch(ttsServiceProvider);
    final rate = tts.speechRate;

    return SegmentedButton<double>(
      segments: const [
        ButtonSegment<double>(
          value: 0.35,
          label: Text('0.75x'),
          icon: Icon(Icons.slow_motion_video),
        ),
        ButtonSegment<double>(
          value: 0.45,
          label: Text('1.0x'),
          icon: Icon(Icons.play_arrow),
        ),
        ButtonSegment<double>(
          value: 0.55,
          label: Text('1.25x'),
          icon: Icon(Icons.fast_forward),
        ),
      ],
      selected: {
        if (rate <= 0.38) 0.35 else if (rate >= 0.50) 0.55 else 0.45,
      },
      onSelectionChanged: (selection) {
        tts.setSpeechRate(selection.first);
      },
    );
  }
}
