import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:switch_theme/main.dart';

void main() {
  testWidgets('Switch Theme app shows title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the title 'Switch Theme' is shown twice
    // (appBar title + centered title in body).
    expect(find.text('Switch Theme'), findsNWidgets(2));

    // Verify that the button 'Go to colors view' exists.
    expect(find.text('Go to colors view'), findsOneWidget);
  });

  testWidgets('Button navigates to colors view', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Tap the button
    await tester.tap(find.text('Go to colors view'));
    await tester.pumpAndSettle();

    // Verify that we're on colors view (look for any widget that appears there)
    // Add more specific verification based on your colors_view.dart
  });

  testWidgets('Dark mode toggle works', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Find the floating action button (moon/sun icon)
    // Note: initial `isDarkMode` is false in `MyApp`, so it shows the moon icon first.
    expect(find.byIcon(Icons.nights_stay), findsOneWidget);

    // Tap it
    await tester.tap(find.byIcon(Icons.nights_stay));
    await tester.pump();

    // After toggle, should show sun icon
    expect(find.byIcon(Icons.wb_sunny), findsOneWidget);
  });
}
