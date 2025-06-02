import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habitloop_app/main.dart';

void main() {
  testWidgets('Habit Creation screen loads correctly', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(HabitLoopApp());

    // Verify key UI elements exist
    expect(find.text('Create Habit'), findsOneWidget);
    expect(find.text('Habit Title'), findsOneWidget);
    expect(find.text('Add Habit'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(DropdownButton<String>), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNWidgets(2)); // Time and Submit
  });
}