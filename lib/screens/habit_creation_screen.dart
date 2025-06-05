import 'package:flutter/material.dart';
import '../data/habit_store.dart';


class HabitCreationScreen extends StatefulWidget {
  const HabitCreationScreen({Key? key}) : super(key: key);

  @override
  _HabitCreationScreenState createState() => _HabitCreationScreenState();
}

class Habit {
  String title;
  String emoji;
  String frequency;
  TimeOfDay time;
  TimeOfDay? reminderTime;
  String? description;
  String? priority;
  DateTime? date;
  bool isCompleted;

  Habit({
    required this.title,
    required this.emoji,
    required this.frequency,
    required this.time,
    this.reminderTime,
    this.description,
    this.priority,
    this.date,
    this.isCompleted = false,
  });
}

class _HabitCreationScreenState extends State<HabitCreationScreen> {
  final TextEditingController _titleController = TextEditingController();
  String? _selectedEmoji;
  String _selectedFrequency = 'Daily';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  final List<Habit> _habits = [];

  void _pickDate() async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: _selectedDate,
    firstDate: DateTime.now().subtract(const Duration(days: 365)),
    lastDate: DateTime.now().add(const Duration(days: 365)),
  );
  if (picked != null && picked != _selectedDate) {
    setState(() {
      _selectedDate = picked;
    });
  }
}

  void _showHabitDetailsModal(Habit habit, int index) {
  final descController = TextEditingController(text: habit.description ?? '');
  String selectedPriority = habit.priority ?? 'Medium';
  DateTime selectedDate = habit.date ?? DateTime.now();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Habit Details'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('📝 ${habit.title}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),

            // Description
            TextField(
              controller: descController,
              decoration: InputDecoration(labelText: 'Description'),
            ),

            // Priority Dropdown
            DropdownButtonFormField<String>(
              value: selectedPriority,
              items: ['Low', 'Medium', 'High'].map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(priority),
                );
              }).toList(),
              onChanged: (value) {
                selectedPriority = value!;
              },
              decoration: InputDecoration(labelText: 'Priority'),
            ),

            // Date Picker
            SizedBox(height: 12),
            TextButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now().subtract(Duration(days: 365)),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (picked != null) selectedDate = picked;
              },
              child: Text('📅 Pick Date'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              habit.description = descController.text;
              habit.priority = selectedPriority;
              habit.date = selectedDate;
            });
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              HabitStore.habits.removeAt(index);
              HabitStore.habits.remove(habit);
            });
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${habit.title} deleted')),
            );
          },
          child: Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}

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
    date: _selectedDate,
  );

  setState(() {
    HabitStore.habits.add(newHabit);
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

            // Date picker
            ElevatedButton(
              onPressed: _pickDate,
              child: Text('Pick Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
            ),

            // Submit button
            ElevatedButton(
              onPressed: _submitHabit,
              child: Text('Add Habit'),
            ),
            Expanded(
              child: ListView.builder(
              itemCount: HabitStore.habits.length,
              itemBuilder: (context, index) {
                final habit = HabitStore.habits[index];
              return ListTile(
                onTap: () => _showHabitDetailsModal(habit, index),
                leading: Text(habit.emoji, style: TextStyle(fontSize: 24)),
                title: Text(habit.title),
                subtitle: Text(
                  '${habit.frequency} • ${habit.time.format(context)}'
                  '${habit.reminderTime != null ? ' • Reminder: ${habit.reminderTime!.format(context)}' : ''}',
                ),
                trailing: Icon(Icons.info_outline, color: Colors.blue),
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
