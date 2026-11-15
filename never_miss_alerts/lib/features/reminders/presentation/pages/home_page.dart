import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

import '../../data/models/remainder.dart';
import '../../data/services/remainder_service.dart';
import '../pages/widgets/reminder_tile.dart';
import 'add_reminder_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ReminderService _service = ReminderService();

  List<Reminder> _reminders = [];
  Set<int> _ringingIds = {};

  StreamSubscription<dynamic>? _ringingSubscription;

  @override
  void initState() {
    super.initState();

    _loadReminders();

    _ringingSubscription = Alarm.ringing.listen((alarmSet) {
      if (!mounted) return;

      setState(() {
        _ringingIds = alarmSet.alarms.map((alarm) => alarm.id).toSet();
      });
    });
  }

  @override
  void dispose() {
    _ringingSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadReminders() async {
    final reminders = await _service.getReminders();

    if (!mounted) return;

    setState(() {
      _reminders = reminders;
    });
  }

  Future<void> _addReminder() async {
    final reminder = await Navigator.push<Reminder>(
      context,
      MaterialPageRoute(builder: (_) => const AddReminderPage()),
    );

    if (reminder == null || !mounted) return;

    try {
      await _service.addReminder(reminder);
      await _loadReminders();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${reminder.title} scheduled successfully!')),
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage(e.toString());
    }
  }

  Future<void> _deleteReminder(Reminder reminder) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete reminder?'),
          content: Text('Are you sure you want to delete "${reminder.title}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await _service.deleteReminder(reminder.id);
    await _loadReminders();
  }

  Future<void> _stopAlarm(int id) async {
    final reminderExists = _reminders.any((reminder) => reminder.id == id);

    if (reminderExists) {
      await _service.completeReminder(id);
      await _loadReminders();
    } else {
      // Handles the temporary test alarm.
      await Alarm.stop(id);
    }

    if (!mounted) return;

    setState(() {
      _ringingIds.remove(id);
    });
  }

  Future<void> _stopAllAlarms() async {
    final ids = _ringingIds.toList();

    for (final id in ids) {
      await _stopAlarm(id);
    }
  }

  Future<void> _testAlarm() async {
    try {
      await _service.scheduleTestAlarm();

      if (!mounted) return;

      _showMessage('Test alarm scheduled! It will ring in 10 seconds.');
    } catch (e) {
      if (!mounted) return;

      _showMessage(e.toString());
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  String get today {
    final now = DateTime.now();

    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[now.month - 1]} ${now.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        today,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Stay on track.',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFFEAE8FF),
                    child: Icon(Icons.alarm_rounded, color: Color(0xFF635BFF)),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF635BFF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'YOUR DAY',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Make every\nmoment count.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Icon(
                          Icons.notifications_active_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Your reminders, your priorities.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Test alarm button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _testAlarm,
                  icon: const Icon(Icons.volume_up_rounded),
                  label: const Text('Test alarm (10 seconds)'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF635BFF),
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Active alarm banner
              if (_ringingIds.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.alarm_on_rounded, color: Colors.red),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'An alarm is ringing!',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton(
                        onPressed: _stopAllAlarms,
                        child: const Text(
                          'STOP',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Upcoming reminders',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${_reminders.where((r) => !r.isCompleted).length} active',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              if (_reminders.isEmpty)
                _buildEmptyState()
              else
                ..._reminders.map((reminder) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ReminderTile(
                      reminder: reminder,
                      isRinging: _ringingIds.contains(reminder.id),
                      onDelete: () => _deleteReminder(reminder),
                      onStop: () => _stopAlarm(reminder.id),
                    ),
                  );
                }),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addReminder,
        backgroundColor: const Color(0xFF635BFF),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New reminder'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.alarm_off_rounded, size: 42, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const Text(
            'No reminders yet',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Create your first reminder and never miss a task.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
