import 'package:flutter/material.dart';
import 'screens/habit_creation_screen.dart';
import 'screens/today_dashboard_screen.dart';

void main() => runApp(HabitLoopApp());

class HabitLoopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HabitLoop',
      home: TodayDashboardScreen(),
    );
  }
}
