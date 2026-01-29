import 'package:flutter_test/flutter_test.dart';
import 'package:test_demo/services/dni_services.dart';

void main() {
  group('validations of input <DNI>', () {
    test('Validate the input has 10 characters', () {
      //arrange
      final dniServices = DniServices('1234567890');
      //act
      //assert
      expect(dniServices.dni.length, 10);
    });

    test('Validate province based on the first two digits', () {
      // arrange
      final dniServices = DniServices('0412345678'); // 04 es del Carchi
      // act
      final province = dniServices.getProvince();
      // assert
      expect(province, 'Carchi');
    });

    test('Validate correct verification digit ', () {
      // arrange
      // Valid DNI from example: 0903686962 (Check digit is 2)
      // We change the last digit to 3 to make it invalid
      final dniServices = DniServices('0903686963');
      // act
      final isValid = dniServices.isValid();
      // assert
      expect(isValid, false);
    });
  });
}
