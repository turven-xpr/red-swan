import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_locale.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';

/// A session audio item with German sentence, Arabic and English translations
class ListeningSentence {
  const ListeningSentence({
    required this.speaker,
    required this.de,
    required this.ar,
    required this.en,
    this.topic = 'Alltag',
  });

  final String speaker;
  final String de;
  final String ar;
  final String en;
  final String topic;
}

class ListeningSessionsScreen extends ConsumerStatefulWidget {
  const ListeningSessionsScreen({super.key});

  @override
  ConsumerState<ListeningSessionsScreen> createState() => _ListeningSessionsScreenState();
}

class _ListeningSessionsScreenState extends ConsumerState<ListeningSessionsScreen> {
  int _targetMinutes = 15;
  int _currentTrackIndex = 0;
  bool _isPlaying = false;
  bool _showTranslation = true;
  double _playbackSpeed = 1.0;
  Timer? _playbackTimer;
  int _elapsedSeconds = 0;

  final List<ListeningSentence> _playlist = const [
    ListeningSentence(
      speaker: 'Anna',
      de: 'Guten Morgen! Hast du heute gut geschlafen?',
      ar: 'صباح الخير! هل نمت جيداً اليوم؟',
      en: 'Good morning! Did you sleep well today?',
      topic: 'Begrüßung',
    ),
    ListeningSentence(
      speaker: 'Ben',
      de: 'Ja, danke! Ich habe wunderbar geschlafen. Und du?',
      ar: 'نعم شكراً لك! لقد نمت بشكل رائع. وأنت؟',
      en: 'Yes, thank you! I slept wonderfully. And you?',
      topic: 'Begrüßung',
    ),
    ListeningSentence(
      speaker: 'Anna',
      de: 'Ich auch. Möchtest du eine Tasse frischen Kaffee oder lieber Tee?',
      ar: 'أنا أيضاً. هل ترغب في فنجان قهوة طازجة أم تفضل الشاي؟',
      en: 'Me too. Would you like a cup of fresh coffee or rather tea?',
      topic: 'Frühstück',
    ),
    ListeningSentence(
      speaker: 'Ben',
      de: 'Kaffee mit etwas Milch wäre perfekt, danke dir!',
      ar: 'قهوة مع قليل من الحليب ستكون مثالية، شكراً جزيلاً!',
      en: 'Coffee with some milk would be perfect, thank you!',
      topic: 'Frühstück',
    ),
    ListeningSentence(
      speaker: 'Anna',
      de: 'Bitte sehr! Was hast du heute Nachmittag vor?',
      ar: 'تفضل على الرحب! ما هي خططك بعد ظهر اليوم؟',
      en: 'Here you go! What are your plans for this afternoon?',
      topic: 'Pläne',
    ),
    ListeningSentence(
      speaker: 'Ben',
      de: 'Ich muss zuerst zum Supermarkt gehen und Gemüse und Brot kaufen.',
      ar: 'عليّ أولاً الذهاب إلى السوبرماركت وشراء الخضار والخبز.',
      en: 'First I need to go to the supermarket and buy vegetables and bread.',
      topic: 'Einkaufen',
    ),
    ListeningSentence(
      speaker: 'Anna',
      de: 'Vergiss bitte nicht, auch Butter und Mineralwasser mitzubringen.',
      ar: 'من فضلك لا تنسَ أن تجلب معك الزبدة والمياه المعدنية أيضاً.',
      en: 'Please don\'t forget to also bring butter and mineral water.',
      topic: 'Einkaufen',
    ),
    ListeningSentence(
      speaker: 'Ben',
      de: 'Alles klar, ich schreibe es direkt auf meine Einkaufsliste.',
      ar: 'حسناً تماماً، سأكتب ذلك فوراً في قائمة مشترياتي.',
      en: 'All right, I will write it directly on my shopping list.',
      topic: 'Einkaufen',
    ),
    ListeningSentence(
      speaker: 'Anna',
      de: 'Danach können wir einen gemütlichen Spaziergang im Park machen.',
      ar: 'بعد ذلك يمكننا القيام بنزهة مشي مريحة وممتعة في الحديقة العامة.',
      en: 'Afterwards we can take a relaxing walk in the park.',
      topic: 'Freizeit',
    ),
    ListeningSentence(
      speaker: 'Ben',
      de: 'Das ist eine tolle Idee! Das Wetter heute ist sonnig und angenehm mild.',
      ar: 'إنها فكرة رائعة! الطقس اليوم مشمس ومعتدل ولطيف.',
      en: 'That is a great idea! The weather today is sunny and pleasantly mild.',
      topic: 'Wetter',
    ),
    ListeningSentence(
      speaker: 'Anna',
      de: 'Perfekt! Treffen wir uns um 16 Uhr vor der Bibliothek?',
      ar: 'ممتاز! هل نلتقي في الساعة الرابعة عصراً أمام المكتبة؟',
      en: 'Perfect! Shall we meet at 4 PM in front of the library?',
      topic: 'Verabredung',
    ),
    ListeningSentence(
      speaker: 'Ben',
      de: 'Abgemacht! Bis später, Anna.',
      ar: 'اتفقنا! إلى اللقاء لاحقاً يا آنا.',
      en: 'Deal! See you later, Anna.',
      topic: 'Verabredung',
    ),
  ];

  @override
  void dispose() {
    _playbackTimer?.cancel();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _pause();
    } else {
      _playCurrentTrack();
    }
  }

  void _playCurrentTrack() {
    setState(() => _isPlaying = true);
    final current = _playlist[_currentTrackIndex];
    ref.read(ttsServiceProvider).speak(current.de);

    _playbackTimer?.cancel();
    // Simulate natural speaking delay + gap based on text length and speed
    final delaySeconds = ((current.de.length / 14) / _playbackSpeed).clamp(3, 10).toInt();

    _playbackTimer = Timer(Duration(seconds: delaySeconds), () {
      if (!mounted || !_isPlaying) return;
      setState(() {
        _elapsedSeconds += delaySeconds;
        if (_currentTrackIndex < _playlist.length - 1) {
          _currentTrackIndex++;
          _playCurrentTrack();
        } else {
          // Loop or check duration
          if (_elapsedSeconds < _targetMinutes * 60) {
            _currentTrackIndex = 0;
            _playCurrentTrack();
          } else {
            _isPlaying = false;
          }
        }
      });
    });
  }

  void _pause() {
    _playbackTimer?.cancel();
    ref.read(ttsServiceProvider).stop();
    setState(() => _isPlaying = false);
  }

  void _skipNext() {
    if (_currentTrackIndex < _playlist.length - 1) {
      setState(() => _currentTrackIndex++);
      if (_isPlaying) _playCurrentTrack();
    }
  }

  void _skipPrevious() {
    if (_currentTrackIndex > 0) {
      setState(() => _currentTrackIndex--);
      if (_isPlaying) _playCurrentTrack();
    }
  }

  void _jumpToTrack(int index) {
    setState(() => _currentTrackIndex = index);
    if (_isPlaying) {
      _playCurrentTrack();
    } else {
      ref.read(ttsServiceProvider).speak(_playlist[index].de);
    }
  }

  String _formatTime(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = ref.watch(appLocaleProvider);
    final isArabic = locale.languageCode == 'ar';
    final current = _playlist[_currentTrackIndex];

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : const Color(0xFFF8F9FD),
      body: SafeArea(
        child: Column(
          children: [
            // Screen Header Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 14, 6),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic ? 'جلسات الاستماع' : 'Listening Sessions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : AppColors.secondary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isArabic ? 'استماع متواصل في الخلفية لتقوية الأذن' : 'Background audio immersion practice',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: isArabic ? 'إظهار / إخفاء الترجمة' : 'Toggle Translations',
                    icon: Icon(
                      _showTranslation ? Icons.subtitles_rounded : Icons.subtitles_off_rounded,
                      color: _showTranslation ? AppColors.primary : Colors.grey,
                    ),
                    onPressed: () => setState(() => _showTranslation = !_showTranslation),
                  ),
                ],
              ),
            ),

            // Top duration selector: 15 / 30 / 60 min
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [15, 30, 60].map((mins) {
                    final selected = _targetMinutes == mins;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _targetMinutes = mins),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              '$mins ${isArabic ? "دقيقة" : "Min"}',
                              style: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : (isDark ? Colors.white70 : Colors.black87),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Background-friendly banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.headphones_rounded, size: 18, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isArabic
                          ? 'يعمل في الخلفية والشاشة مغلقة للاستماع أثناء التنقل والراحة'
                          : 'Plays continuously in background for commute & daily immersion',
                        style: const TextStyle(fontSize: 11, color: Colors.blue, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Transcript list with auto-highlighting
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _playlist.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = _playlist[index];
                  final isCurrent = index == _currentTrackIndex;

                  return GestureDetector(
                    onTap: () => _jumpToTrack(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? (isDark ? AppColors.primary.withValues(alpha: 0.2) : const Color(0xFFFFF3ED))
                            : (isDark ? const Color(0xFF1E1E22) : Colors.white),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isCurrent
                              ? AppColors.primary
                              : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
                          width: isCurrent ? 2 : 1,
                        ),
                        boxShadow: isCurrent
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.12),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                )
                              ]
                            : null,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCurrent
                                  ? AppColors.primary
                                  : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
                            ),
                            child: Icon(
                              isCurrent && _isPlaying ? Icons.volume_up_rounded : Icons.play_arrow_rounded,
                              size: 18,
                              color: isCurrent ? Colors.white : Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      item.speaker,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: isCurrent ? AppColors.primary : Colors.grey,
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.04),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        item.topic,
                                        style: const TextStyle(fontSize: 9.5, color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.de,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                if (_showTranslation) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    isArabic ? item.ar : item.en,
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      color: isDark ? Colors.white60 : Colors.black54,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom Audio Player Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E22) : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Currently playing sentence snapshot
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          current.de,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatTime(_elapsedSeconds),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Playback control row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Speed toggle (0.75x, 1.0x, 1.25x)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_playbackSpeed == 0.75) {
                              _playbackSpeed = 1.0;
                            } else if (_playbackSpeed == 1.0) {
                              _playbackSpeed = 1.25;
                            } else {
                              _playbackSpeed = 0.75;
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${_playbackSpeed}x',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),

                      // Skip previous
                      IconButton(
                        icon: const Icon(Icons.skip_previous_rounded, size: 28),
                        onPressed: _skipPrevious,
                      ),

                      // Main Play/Pause Button
                      GestureDetector(
                        onTap: _togglePlayPause,
                        child: Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.35),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            size: 34,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      // Skip next
                      IconButton(
                        icon: const Icon(Icons.skip_next_rounded, size: 28),
                        onPressed: _skipNext,
                      ),

                      // Listen Comprehension Quiz Modal
                      IconButton(
                        icon: const Icon(Icons.quiz_rounded, size: 24, color: Colors.teal),
                        tooltip: isArabic ? 'اختبر فهمك' : 'Comprehension Quiz',
                        onPressed: () => _showQuickQuiz(context, isDark, isArabic),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickQuiz(BuildContext context, bool isDark, bool isArabic) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isArabic ? 'سؤال فهم سريع' : 'Quick Comprehension Check',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                isArabic
                    ? 'أين اتفق بن وآنا على اللقاء؟'
                    : 'Where did Ben and Anna agree to meet?',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 14),
              ...[
                'Vor der Bibliothek (أمام المكتبة)',
                'Im Supermarkt (في السوبرماركت)',
                'Im Café (في المقهى)',
              ].map((opt) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      final isCorrect = opt.startsWith('Vor der');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isCorrect
                                ? (isArabic ? 'إجابة صحيحة ممتاز! 🎉' : 'Correct answer! 🎉')
                                : (isArabic ? 'إجابة غير صحيحة، حاول مجدداً!' : 'Incorrect, try again!'),
                          ),
                          backgroundColor: isCorrect ? Colors.green : Colors.red,
                        ),
                      );
                    },
                    child: Text(opt),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
