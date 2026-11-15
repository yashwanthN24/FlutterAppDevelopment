import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import '../features/reminders/presentation/pages/home_page.dart';

class ReminderApp extends StatelessWidget {
  const ReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RemindMe',
      theme: AppTheme.lightTheme,
      home: const HomePage(),
    );
  }
}
