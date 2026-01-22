import 'package:flutter_test/flutter_test.dart';
import 'package:test_demo/services/dni_services.dart';

void main() {
  group('validations of input <DNI>', () {
    test('Validate the input has 10 characters', () {
      //arrange
      final dniServices = DniServices('1234567890');
      //act
      //assert
    });

    test('Validate the third digit is less than 6', () {
      //arrange
      final dniServices = DniServices('1204567890'); // 3rd digit is 0 (< 6)
      //act
      final isValid = dniServices.isValid();
      //assert
      expect(isValid, true);
    });

    test('Validate province based on the first two digits', () {
      // arrange
      final dniServices = DniServices('10012345678'); // 04 Carchi
      // act
      final province = dniServices.getProvince();
      // assert
      expect(province, 'Carchi');
    });
  });
}
