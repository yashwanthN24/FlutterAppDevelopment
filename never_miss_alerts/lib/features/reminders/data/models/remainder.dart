
class Reminder {
  final int id;
  final String title;
  final String description;
  final DateTime scheduledAt;
  final bool isCompleted;

  const Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.scheduledAt,
    this.isCompleted = false,
  });

  Reminder copyWith({
    String? title,
    String? description,
    DateTime? scheduledAt,
    bool? isCompleted,
  }) {
    return Reminder(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'scheduledAt': scheduledAt.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}
