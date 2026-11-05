import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsPrefs {
  const NotificationsPrefs({
    required this.enabled,
    required this.reminderTime,
    required this.streakNudges,
  });

  /// Master switch — when false the (future) plugin handler is
  /// silent even if individual toggles are on.
  final bool enabled;

  /// Reminder time of day.  Null means "no specific time".
  final TimeOfDay? reminderTime;

  /// Whether the app should send the once-a-day "You're on a streak"
  /// reminder.
  final bool streakNudges;

  NotificationsPrefs copyWith({
    bool? enabled,
    TimeOfDay? reminderTime,
    bool? streakNudges,
  }) =>
      NotificationsPrefs(
        enabled: enabled ?? this.enabled,
        reminderTime: reminderTime ?? this.reminderTime,
        streakNudges: streakNudges ?? this.streakNudges,
      );

  static const empty = NotificationsPrefs(
    enabled: false,
    reminderTime: null,
    streakNudges: true,
  );
}

class NotificationsPrefsNotifier extends Notifier<NotificationsPrefs> {
  static const _kEnabled = 'notif_enabled';
  static const _kStreak = 'notif_streak_nudges';
  static const _kReminderHour = 'notif_reminder_hour';
  static const _kReminderMinute = 'notif_reminder_minute';

  @override
  NotificationsPrefs build() {
    _load();
    return NotificationsPrefs.empty;
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = NotificationsPrefs(
        enabled: prefs.getBool(_kEnabled) ?? false,
        streakNudges: prefs.getBool(_kStreak) ?? true,
        reminderTime: (prefs.getInt(_kReminderHour) == null)
            ? null
            : TimeOfDay(
                hour: prefs.getInt(_kReminderHour)!,
                minute: prefs.getInt(_kReminderMinute) ?? 0,
              ),
      );
    } catch (_) {
      state = NotificationsPrefs.empty;
    }
  }

  Future<void> setEnabled(bool value) async {
    state = state.copyWith(enabled: value);
    await _persist();
  }

  Future<void> setStreakNudges(bool value) async {
    state = state.copyWith(streakNudges: value);
    await _persist();
  }

  Future<void> setReminderTime(TimeOfDay? time) async {
    state = state.copyWith(reminderTime: time);
    await _persist();
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kEnabled, state.enabled);
      await prefs.setBool(_kStreak, state.streakNudges);
      if (state.reminderTime == null) {
        await prefs.remove(_kReminderHour);
        await prefs.remove(_kReminderMinute);
      } else {
        await prefs.setInt(_kReminderHour, state.reminderTime!.hour);
        await prefs.setInt(_kReminderMinute, state.reminderTime!.minute);
      }
    } catch (_) {/* tolerate (e.g. tests) */}
  }
}

final notificationsPrefsProvider =
    NotifierProvider<NotificationsPrefsNotifier, NotificationsPrefs>(
        NotificationsPrefsNotifier.new);
