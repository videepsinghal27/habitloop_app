import 'package:flutter/material.dart';

class HabitCreationScreen extends StatefulWidget {
  const HabitCreationScreen({Key? key}) : super(key: key);

  @override
  _HabitCreationScreenState createState() => _HabitCreationScreenState();
}

class Habit {
  final String title;
  final String emoji;
  final String frequency;
  final TimeOfDay time;

  Habit({
    required this.title,
    required this.emoji,
    required this.frequency,
    required this.time,
  });
}

class _HabitCreationScreenState extends State<HabitCreationScreen> {
  final TextEditingController _titleController = TextEditingController();
  String? _selectedEmoji;
  String _selectedFrequency = 'Daily';
  TimeOfDay _selectedTime = TimeOfDay.now();

  final List<Habit> _habits = [];

  void _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

void _submitHabit() {
  if (_titleController.text.isEmpty || _selectedEmoji == null) return;

  final newHabit = Habit(
    title: _titleController.text,
    emoji: _selectedEmoji!,
    frequency: _selectedFrequency,
    time: _selectedTime,
  );

  setState(() {
    _habits.add(newHabit);
    _titleController.clear();
    _selectedEmoji = null;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Habit added!')),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Habit')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title input
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Habit Title'),
            ),
            SizedBox(height: 16),

            // Improved Emoji Selector
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: ['💪', '📚', '🧘‍♂️', '🍎'].map((emoji) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedEmoji = emoji;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _selectedEmoji == emoji ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedEmoji == emoji ? Colors.blue : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      emoji,
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                );
              }).toList(),
            ),

            // Frequency selector
            DropdownButton<String>(
              value: _selectedFrequency,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFrequency = newValue!;
                });
              },
              items: ['Daily', 'Weekly']
                  .map<DropdownMenuItem<String>>((String value) =>
                      DropdownMenuItem<String>(
                          value: value, child: Text(value)))
                  .toList(),
            ),
            SizedBox(height: 16),

            // Time picker
            ElevatedButton(
              onPressed: _pickTime,
              child: Text('Pick Time: ${_selectedTime.format(context)}'),
            ),
            SizedBox(height: 16),

            // Submit button
            ElevatedButton(
              onPressed: _submitHabit,
              child: Text('Add Habit'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _habits.length,
                itemBuilder: (context, index) {
                  final habit = _habits[index];
                  return ListTile(
                    leading: Text(habit.emoji, style: TextStyle(fontSize: 24)),
                    title: Text(habit.title),
                    subtitle: Text('${habit.frequency} • ${habit.time.format(context)}'),
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
