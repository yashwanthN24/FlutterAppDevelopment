enum ReminderRepeat { none, daily, weekdays, weekends, weekly, monthly }

class Reminder {
  final int id;
  final String title;
  final String description;
  final DateTime scheduledAt;
  final bool isCompleted;
  final ReminderRepeat repeat;
  final int? repeatWeekday;
  final int? repeatDayOfMonth;

  const Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.scheduledAt,
    this.isCompleted = false,
    this.repeat = ReminderRepeat.none,
    this.repeatWeekday,
    this.repeatDayOfMonth,
  });

  Reminder copyWith({
    String? title,
    String? description,
    DateTime? scheduledAt,
    bool? isCompleted,
    ReminderRepeat? repeat,
    int? repeatWeekday,
    int? repeatDayOfMonth,
  }) {
    return Reminder(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      isCompleted: isCompleted ?? this.isCompleted,
      repeat: repeat ?? this.repeat,
      repeatWeekday: repeatWeekday ?? this.repeatWeekday,
      repeatDayOfMonth: repeatDayOfMonth ?? this.repeatDayOfMonth,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'scheduledAt': scheduledAt.toIso8601String(),
      'isCompleted': isCompleted,
      'repeat': repeat.name,
      'repeatWeekday': repeatWeekday,
      'repeatDayOfMonth': repeatDayOfMonth,
    };
  }

  factory Reminder.fromJson(Map<String, dynamic> json) {
    final repeatName = json['repeat'] as String?;

    final repeat = ReminderRepeat.values.firstWhere(
      (value) => value.name == repeatName,
      orElse: () => ReminderRepeat.none,
    );

    final scheduledAt = DateTime.parse(json['scheduledAt'] as String);

    return Reminder(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      scheduledAt: scheduledAt,
      isCompleted: json['isCompleted'] as bool? ?? false,
      repeat: repeat,
      repeatWeekday: json['repeatWeekday'] as int?,
      repeatDayOfMonth: json['repeatDayOfMonth'] as int? ?? scheduledAt.day,
    );
  }
}
