import 'package:flutter/material.dart';

class HabitCreationScreen extends StatefulWidget {
  @override
  _HabitCreationScreenState createState() => _HabitCreationScreenState();
}

class _HabitCreationScreenState extends State<HabitCreationScreen> {
  final TextEditingController _titleController = TextEditingController();
  String? _selectedEmoji;
  String _selectedFrequency = 'Daily';
  TimeOfDay _selectedTime = TimeOfDay.now();

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
    print('Title: ${_titleController.text}');
    print('Emoji: $_selectedEmoji');
    print('Frequency: $_selectedFrequency');
    print('Time: ${_selectedTime.format(context)}');
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
          ],
        ),
      ),
    );
  }
}
