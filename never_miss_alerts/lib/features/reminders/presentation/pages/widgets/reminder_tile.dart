import 'package:flutter/material.dart';

import '../../../data/models/remainder.dart';

class ReminderTile extends StatelessWidget {
  final Reminder reminder;
  final bool isRinging;
  final VoidCallback onDelete;
  final VoidCallback onStop;

  const ReminderTile({
    super.key,
    required this.reminder,
    required this.isRinging,
    required this.onDelete,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    final time = TimeOfDay.fromDateTime(reminder.scheduledAt).format(context);

    final date = reminder.scheduledAt;
    final dateLabel = '${date.day}/${date.month}/${date.year}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isRinging ? Colors.red.shade200 : Colors.grey.shade100,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: reminder.isCompleted
                  ? Colors.grey.shade200
                  : const Color(0xFFEAE8FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              reminder.isCompleted ? Icons.check_rounded : Icons.alarm_rounded,
              color: const Color(0xFF635BFF),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reminder.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    decoration: reminder.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  reminder.description.isEmpty
                      ? dateLabel
                      : reminder.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),

                const SizedBox(height: 5),

                Text(
                  reminder.isCompleted
                      ? 'Completed'
                      : isRinging
                      ? 'RINGING NOW'
                      : time,
                  style: TextStyle(
                    color: isRinging ? Colors.red : const Color(0xFF635BFF),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          if (isRinging)
            IconButton(
              tooltip: 'Stop alarm',
              onPressed: onStop,
              icon: const Icon(
                Icons.stop_circle_rounded,
                color: Colors.red,
                size: 30,
              ),
            )
          else
            IconButton(
              tooltip: 'Delete reminder',
              onPressed: onDelete,
              icon: Icon(
                Icons.delete_outline_rounded,
                color: Colors.grey.shade600,
              ),
            ),
        ],
      ),
    );
  }
}
