import 'package:flutter/material.dart';

import 'package:never_miss_alerts/app/app.dart';
import 'package:alarm/alarm.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Alarm.init();

  runApp(const ReminderApp());
}
