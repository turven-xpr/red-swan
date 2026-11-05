// OS-level local notifications for daily review reminders.
//
// The user must explicitly enable reminders in Settings;  we never
// request notification permission on first launch (it would tank
// Play Store + App Store ratings).
//
// Architecture:
//   * NotificationService is a thin singleton — one instance per
//     app run, kept alive via a Riverpod provider.
//   * `init()` requests permissions on Android 13+ / iOS 16+ once.
//   * `setDailyReminder(time)` schedules a single repeating
//     notification at the supplied local time.  Replaces any
//     previously-scheduled reminder so the latest setting wins.
//   * `cancelDailyReminder()` clears the schedule.

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Static id used for the daily reminder notification.
const int _kDailyReminderId = 1;

class NotificationService {
  NotificationService();
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialised = false;

  /// Initialise the plugin + request permissions.  Safe to call more
  /// than once — repeats are no-ops.
  Future<void> init() async {
    if (kIsWeb) return; // Local notifications are mobile-only
    if (_initialised) return;
    try {
      tzdata.initializeTimeZones();
      // Best-effort: use the system local timezone.  In a future
      // release we can pull this from `flutter_timezone`.
      tz.setLocalLocation(tz.getLocation(tz.local.name));
    } catch (e) {
      debugPrint('timezone init failed: $e');
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    try {
      await _plugin.initialize(
        const InitializationSettings(android: android, iOS: ios),
      );
      _initialised = true;
    } catch (e) {
      debugPrint('notifications init failed: $e');
    }
  }

  /// Ask the OS for the right to show notifications.  Only call after
  /// the user toggles the reminder switch on, so we don't request
  /// until we need it.
  Future<bool> requestPermissions() async {
    if (!_initialised) await init();
    try {
      // iOS
      final iosImpl = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      final iosGranted = await iosImpl?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          true; // On non-iOS, default true.

      // Android 13+
      final androidImpl = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final androidGranted =
          await androidImpl?.requestNotificationsPermission() ?? true;

      return iosGranted && androidGranted;
    } catch (e) {
      debugPrint('permission request failed: $e');
      return false;
    }
  }

  /// Schedule (or replace) a daily reminder at the given local time.
  Future<void> setDailyReminder({required int hour, required int minute}) async {
    if (!_initialised) await init();
    try {
      await cancelDailyReminder();
      final next = _nextInstanceOfTime(hour, minute);
      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          'deutschy_daily_reminder',
          'Daily review reminder',
          channelDescription: 'Gentle reminder to complete today\'s reviews.',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'Deutschy',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );
      await _plugin.zonedSchedule(
        _kDailyReminderId,
        'Heute noch ein paar Karten?',
        'Halte deine Streak — 5 Minuten reichen!',
        next,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      debugPrint('setDailyReminder failed: $e');
    }
  }

  /// Cancel the daily reminder.
  Future<void> cancelDailyReminder() async {
    if (!_initialised) return;
    try {
      await _plugin.cancel(_kDailyReminderId);
    } catch (e) {
      debugPrint('cancel failed: $e');
    }
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var when =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (when.isBefore(now)) {
      when = when.add(const Duration(days: 1));
    }
    return when;
  }
}

/// Singleton notifier that lives in Riverpod.
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});