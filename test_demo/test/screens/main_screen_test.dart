import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_demo/main.dart'; // Correct import

void main() {
  group('looking for input and button existence', () {
    testWidgets('looking for TextField and ElevatedButton', (
      WidgetTester tester,
    ) async {
      //arrange
      // Pump the MyApp widget which already contains MaterialApp
      await tester.pumpWidget(const MyApp());

      //act
      final dniInput = find.byKey(const Key('campo_cedula'));
      final submitButton = find.byKey(const Key('boton_enviar'));

      //assert
      expect(dniInput, findsOneWidget);
      expect(submitButton, findsOneWidget);
    });

    testWidgets('looking for TextField and ElevatedButton by Type', (
      WidgetTester tester,
    ) async {
      // arrange
      await tester.pumpWidget(const MyApp());

      // act
      final textFieldFinder = find.byType(TextField);
      final buttonFinder = find.byType(ElevatedButton);

      // assert
      expect(textFieldFinder, findsOneWidget);
      expect(buttonFinder, findsOneWidget);
    });
  });
}
