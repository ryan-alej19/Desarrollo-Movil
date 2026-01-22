import 'package:flutter_test/flutter_test.dart';

class DniServices {
  String dni;
  DniServices(this.dni);
}

void main() {
  group('validations of input <DNI>', () {
    test('Validate the input has 10 characters', () {
      //arrange
      final dniServices = DniServices('1234567890');
      //act
      //assert
    });
  });
}
