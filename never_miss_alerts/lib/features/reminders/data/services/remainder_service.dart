import 'dart:convert';
import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/remainder.dart';

class ReminderService {
  static const String _storageKey = 'reminders';

  Future<void> _requestPermissions() async {
    if (!Platform.isAndroid) return;

    final notificationStatus = await Permission.notification.request();
    final alarmStatus = await Permission.scheduleExactAlarm.request();

    if (!notificationStatus.isGranted || !alarmStatus.isGranted) {
      throw Exception('Please grant notification and exact alarm permissions.');
    }
  }

  Future<List<Reminder>> getReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final storedReminders = prefs.getStringList(_storageKey) ?? [];

    final reminders = storedReminders.map((item) {
      return Reminder.fromJson(jsonDecode(item) as Map<String, dynamic>);
    }).toList();

    reminders.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

    return reminders;
  }

  Future<void> _saveReminders(List<Reminder> reminders) async {
    final prefs = await SharedPreferences.getInstance();

    final data = reminders.map((reminder) {
      return jsonEncode(reminder.toJson());
    }).toList();

    await prefs.setStringList(_storageKey, data);
  }

  Future<void> _scheduleReminder(Reminder reminder) async {
    await Alarm.set(
      alarmSettings: AlarmSettings(
        id: reminder.id,
        dateTime: reminder.scheduledAt,
        volumeSettings: VolumeSettings.fixed(),
        assetAudioPath: null,
        loopAudio: true,
        vibrate: true,
        androidFullScreenIntent: true,
        androidAlarmClock: true,
        androidStopAlarmOnTermination: false,
        notificationSettings: const NotificationSettings(
          title: 'Reminder is ringing!',
          body: 'Time to complete your task.',
          stopButton: 'Stop',
          androidStopAlarmOnDismiss: false,
        ),
      ),
    );
  }

  Future<void> addReminder(Reminder reminder) async {
    await _requestPermissions();

    await _scheduleReminder(reminder);

    final reminders = await getReminders();
    reminders.add(reminder);

    await _saveReminders(reminders);
  }

  Future<void> deleteReminder(int id) async {
    await Alarm.stop(id);

    final reminders = await getReminders();
    reminders.removeWhere((reminder) => reminder.id == id);

    await _saveReminders(reminders);
  }

  // Called when the user stops a ringing reminder.
  Future<void> completeReminder(int id) async {
    await Alarm.stop(id);

    final reminders = await getReminders();

    final index = reminders.indexWhere((reminder) => reminder.id == id);

    if (index == -1) return;

    final reminder = reminders[index];

    // One-time reminder: mark it completed.
    if (reminder.repeat == ReminderRepeat.none) {
      reminders[index] = reminder.copyWith(isCompleted: true);
      await _saveReminders(reminders);
      return;
    }

    // Recurring reminder: schedule the next occurrence.
    final nextDate = _calculateNextOccurrence(reminder, DateTime.now());

    final updatedReminder = reminder.copyWith(
      scheduledAt: nextDate,
      isCompleted: false,
    );

    await _scheduleReminder(updatedReminder);

    reminders[index] = updatedReminder;
    await _saveReminders(reminders);
  }

  DateTime _calculateNextOccurrence(Reminder reminder, DateTime now) {
    final hour = reminder.scheduledAt.hour;
    final minute = reminder.scheduledAt.minute;

    DateTime createDate(DateTime date) {
      return DateTime(date.year, date.month, date.day, hour, minute);
    }

    switch (reminder.repeat) {
      case ReminderRepeat.none:
        return reminder.scheduledAt;

      case ReminderRepeat.daily:
        return createDate(DateTime(now.year, now.month, now.day + 1));

      case ReminderRepeat.weekdays:
        for (int offset = 1; offset <= 7; offset++) {
          final date = DateTime(now.year, now.month, now.day + offset);

          if (date.weekday >= DateTime.monday &&
              date.weekday <= DateTime.friday) {
            return createDate(date);
          }
        }
        break;

      case ReminderRepeat.weekends:
        for (int offset = 1; offset <= 7; offset++) {
          final date = DateTime(now.year, now.month, now.day + offset);

          if (date.weekday == DateTime.saturday ||
              date.weekday == DateTime.sunday) {
            return createDate(date);
          }
        }
        break;

      case ReminderRepeat.weekly:
        final targetWeekday =
            reminder.repeatWeekday ?? reminder.scheduledAt.weekday;

        var daysUntil = (targetWeekday - now.weekday + 7) % 7;

        if (daysUntil == 0) {
          daysUntil = 7;
        }

        var nextDate = createDate(
          DateTime(now.year, now.month, now.day + daysUntil),
        );

        if (!nextDate.isAfter(now)) {
          nextDate = nextDate.add(const Duration(days: 7));
        }

        return nextDate;

      case ReminderRepeat.monthly:
        final targetDay = reminder.repeatDayOfMonth ?? reminder.scheduledAt.day;

        for (int offset = 0; offset < 24; offset++) {
          final firstOfMonth = DateTime(now.year, now.month + offset, 1);

          final lastDayOfMonth = DateTime(
            firstOfMonth.year,
            firstOfMonth.month + 1,
            0,
          ).day;

          final day = targetDay.clamp(1, lastDayOfMonth);

          final candidate = DateTime(
            firstOfMonth.year,
            firstOfMonth.month,
            day,
            hour,
            minute,
          );

          if (candidate.isAfter(now)) {
            return candidate;
          }
        }
        break;
    }

    throw Exception('Could not calculate the next reminder date.');
  }

  Future<int> scheduleTestAlarm() async {
    await _requestPermissions();

    final testId = DateTime.now().millisecondsSinceEpoch % 2147483647;

    await Alarm.set(
      alarmSettings: AlarmSettings(
        id: testId,
        dateTime: DateTime.now().add(const Duration(seconds: 10)),
        volumeSettings: VolumeSettings.fixed(),
        assetAudioPath: null,
        loopAudio: true,
        vibrate: true,
        androidFullScreenIntent: true,
        androidAlarmClock: true,
        androidStopAlarmOnTermination: false,
        notificationSettings: const NotificationSettings(
          title: 'Test alarm',
          body: 'Your alarm engine is working!',
          stopButton: 'Stop',
          androidStopAlarmOnDismiss: false,
        ),
      ),
    );

    return testId;
  }
}
