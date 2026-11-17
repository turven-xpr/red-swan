import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:deutschy/src/features/study/data/lesson_progress_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('LessonProgressNotifier starts empty and marks lessons completed', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    // Initial state
    expect(container.read(lessonProgressProvider), isEmpty);

    final notifier = container.read(lessonProgressProvider.notifier);
    expect(notifier.isCompleted(10101), isFalse);

    // Mark completed
    await notifier.markLessonCompleted(10101);
    expect(container.read(lessonProgressProvider), contains(10101));
    expect(notifier.isCompleted(10101), isTrue);

    // Mark second lesson
    await notifier.markLessonCompleted(10102);
    expect(container.read(lessonProgressProvider), containsAll([10101, 10102]));

    // Reset progress
    await notifier.resetProgress();
    expect(container.read(lessonProgressProvider), isEmpty);
    expect(notifier.isCompleted(10101), isFalse);
  });
}
