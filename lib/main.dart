import 'package:flutter/material.dart';
import 'screens/habit_creation_screen.dart';
import 'screens/today_dashboard_screen.dart';

void main() => runApp(HabitLoopApp());

class HabitLoopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HabitLoop',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HabitLoop')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HabitCreationScreen()),
                );
              },
              child: Text('Create Habit'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TodayDashboardScreen()),
                );
              },
              child: Text("Today's Habits"),
            ),
          ],
        ),
      ),
    );
  }
}
