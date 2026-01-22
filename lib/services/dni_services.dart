class DniServices {
  String dni;
  DniServices(this.dni);

  bool isValid() {
    if (dni.length != 10) return false;

    // 3rd digit validation
    final int thirdDigit = int.parse(dni[2]);
    if (thirdDigit >= 6) return false;

    // Modulo 10 validation
    final List<int> coefficients = [2, 1, 2, 1, 2, 1, 2, 1, 2];
    int sum = 0;

    for (int i = 0; i < 9; i++) {
      int digit = int.parse(dni[i]);
      int product = digit * coefficients[i];
      if (product >= 10) {
        product -= 9;
      }
      sum += product;
    }

    final int mod = sum % 10;
    final int checkDigit = mod == 0 ? 0 : 10 - mod;
    final int lastDigit = int.parse(dni[9]);

    return checkDigit == lastDigit;
  }

  static const Map<String, String> _provinces = {
    '01': 'Azuay',
    '02': 'Bolívar',
    '03': 'Cañar',
    '04': 'Carchi',
    '05': 'Cotopaxi',
    '06': 'Chimborazo',
    '07': 'El Oro',
    '08': 'Esmeraldas',
    '09': 'Guayas',
    '10': 'Imbabura',
    '11': 'Loja',
    '12': 'Los Ríos',
    '13': 'Manabí',
    '14': 'Morona Santiago',
    '15': 'Napo',
    '16': 'Pastaza',
    '17': 'Pichincha',
    '18': 'Tungurahua',
    '19': 'Zamora Chinchipe',
    '20': 'Galápagos',
    '21': 'Sucumbíos',
    '22': 'Orellana',
    '23': 'Santo Domingo de los Tsáchilas',
    '24': 'Santa Elena',
    '30': 'Exterior',
  };

  String getProvince() {
    if (dni.length < 2) return 'Desconocida';
    final provinceCode = dni.substring(0, 2);
    return _provinces[provinceCode] ?? 'Desconocida';
  }
}
