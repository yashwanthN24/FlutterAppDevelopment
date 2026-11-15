import 'package:flutter/material.dart';

import '../../data/models/remainder.dart';

class AddReminderPage extends StatefulWidget {
  const AddReminderPage({super.key});

  @override
  State<AddReminderPage> createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  void _saveReminder() {
    final title = _titleController.text.trim();

    if (title.isEmpty) {
      _showError('Please enter a reminder title.');
      return;
    }

    final scheduledAt = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    if (!scheduledAt.isAfter(DateTime.now())) {
      _showError('Please select a future date and time.');
      return;
    }

    final reminder = Reminder(
      id: DateTime.now().millisecondsSinceEpoch % 2147483647,
      title: title,
      description: _descriptionController.text.trim(),
      scheduledAt: scheduledAt,
    );

    Navigator.pop(context, reminder);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Reminder',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What do you need to remember?',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              'We will make sure you never miss it.',
              style: TextStyle(color: Colors.grey.shade600),
            ),

            const SizedBox(height: 32),

            _sectionLabel('REMINDER TITLE'),
            const SizedBox(height: 10),

            TextField(
              controller: _titleController,
              autofocus: true,
              decoration: _inputDecoration(
                'e.g. Study Spring Boot',
                Icons.edit_rounded,
              ),
            ),

            const SizedBox(height: 24),

            _sectionLabel('DESCRIPTION (OPTIONAL)'),
            const SizedBox(height: 10),

            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: _inputDecoration(
                'Add some details...',
                Icons.notes_rounded,
              ),
            ),

            const SizedBox(height: 32),

            _sectionLabel('WHEN SHOULD WE REMIND YOU?'),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _selectionCard(
                    icon: Icons.calendar_month_rounded,
                    label: 'Date',
                    value:
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    onTap: _pickDate,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _selectionCard(
                    icon: Icons.access_time_rounded,
                    label: 'Time',
                    value: _selectedTime.format(context),
                    onTap: _pickTime,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _saveReminder,
                icon: const Icon(Icons.alarm_add_rounded),
                label: const Text(
                  'Save Reminder',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF635BFF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
        color: Colors.grey.shade600,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
    );
  }

  Widget _selectionCard({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF635BFF)),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
