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

  Future<void> addReminder(Reminder reminder) async {
    await _requestPermissions();

    await Alarm.set(
      alarmSettings: AlarmSettings(
        volumeSettings: VolumeSettings.fixed(),
        id: reminder.id,
        dateTime: reminder.scheduledAt,
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

    final reminders = await getReminders();

    reminders.add(reminder);

    await _saveReminders(reminders);
  }

  Future<void> deleteReminder(int id) async {
    // Cancel the native alarm as well.
    await Alarm.stop(id);

    final reminders = await getReminders();

    reminders.removeWhere((reminder) => reminder.id == id);

    await _saveReminders(reminders);
  }

  Future<void> completeReminder(int id) async {
    await Alarm.stop(id);

    final reminders = await getReminders();

    final index = reminders.indexWhere((reminder) => reminder.id == id);

    if (index == -1) return;

    reminders[index] = reminders[index].copyWith(isCompleted: true);

    await _saveReminders(reminders);
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
