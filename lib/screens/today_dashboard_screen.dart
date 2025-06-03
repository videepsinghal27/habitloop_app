import 'package:flutter/material.dart';
import 'package:habitloop_app/screens/habit_creation_screen.dart'; // for Habit class

class TodayDashboardScreen extends StatefulWidget {
  const TodayDashboardScreen({Key? key}) : super(key: key);

  @override
  _TodayDashboardScreenState createState() => _TodayDashboardScreenState();
}

class _TodayDashboardScreenState extends State<TodayDashboardScreen> {
  late List<Habit> _todayHabits;

  @override
  void initState() {
    super.initState();
    // Mock today's habits — in real app this would be fetched from DB
    _todayHabits = [
      Habit(title: 'Run', emoji: '🏃‍♂️', frequency: 'Daily', time: TimeOfDay(hour: 6, minute: 0)),
      Habit(title: 'Read', emoji: '📖', frequency: 'Daily', time: TimeOfDay(hour: 20, minute: 0)),
    ];
  }

  int get completedCount => _todayHabits.where((h) => h.isCompleted).length;

  double get progress =>
      _todayHabits.isEmpty ? 0 : completedCount / _todayHabits.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Today's Habits")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Progress Ring Placeholder
            SizedBox(
              height: 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  Text('${(progress * 100).toInt()}%'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // List of Today's Habits
            Expanded(
              child: ListView.builder(
                itemCount: _todayHabits.length,
                itemBuilder: (context, index) {
                  final habit = _todayHabits[index];
                  return CheckboxListTile(
                    title: Text('${habit.emoji} ${habit.title}'),
                    subtitle: Text('${habit.frequency} • ${habit.time.format(context)}'),
                    value: habit.isCompleted,
                    onChanged: (value) {
                      setState(() {
                        habit.isCompleted = value ?? false;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}