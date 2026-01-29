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

    testWidgets('Validation of Label', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(const MyApp());

      // act
      final labelFinder = find.text('Ingrese Cedula');

      // assert
      expect(labelFinder, findsOneWidget);
    });

    testWidgets('Validation of Numeric Input', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(const MyApp());

      // act
      final textFieldFinder = find.byKey(const Key('campo_cedula'));
      final buttonFinder = find.byKey(const Key('boton_enviar'));

      await tester.enterText(textFieldFinder, 'abcd');
      await tester.tap(buttonFinder);
      await tester.pump(); // Rebuild widget

      // assert
      expect(find.text('Ingrese solo numeros'), findsOneWidget);
    });

    testWidgets('Allows to enter only numbers', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(const MyApp());

      // act
      final textFieldFinder = find.byKey(const Key('campo_cedula'));
      final buttonFinder = find.byKey(const Key('boton_enviar'));

      await tester.enterText(textFieldFinder, '1234567890');
      await tester.tap(buttonFinder);
      await tester.pump(); // Rebuild widget

      // assert
      expect(find.text('Cedula valida'), findsOneWidget);
    });

    testWidgets('Validation of Length (less than 10 digits)', (
      WidgetTester tester,
    ) async {
      // arrange
      await tester.pumpWidget(const MyApp());

      // act
      final textFieldFinder = find.byKey(const Key('campo_cedula'));
      final buttonFinder = find.byKey(const Key('boton_enviar'));

      await tester.enterText(textFieldFinder, '12345'); // Less than 10
      await tester.tap(buttonFinder);
      await tester.pump(); // Rebuild widget

      // assert
      expect(find.text('La cedula debe tener 10 digitos'), findsOneWidget);
    });
  });
}
