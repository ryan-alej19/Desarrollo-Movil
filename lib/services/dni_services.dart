class DniServices {
  String dni;
  DniServices(this.dni);

  bool isValid() {
    if (dni.length < 3) return false;
    final int thirdDigit = int.parse(dni[2]);
    return thirdDigit < 6;
  }
}
