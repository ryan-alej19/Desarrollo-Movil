class ValidacionesPropias {
  // 1. Validar Cédula (Mismo algoritmo "while" que ya teníamos, para no copiar)
  static bool validarCedulaEcuatoriana(String? dato) {
    if (dato == null || dato.isEmpty) return false;
    if (dato.length != 10) return false;

    try {
      int.parse(dato);
    } catch (e) {
      return false;
    }

    // Provincia
    int provincia = int.parse(dato.substring(0, 2));
    if (provincia < 1 || provincia > 24) return false;

    // Tercer dígito
    int tercerDigito = int.parse(dato[2]);
    if (tercerDigito >= 6) return false;

    // Algoritmo manual con While (Identidad del estudiante)
    int acumulado = 0;
    int contador = 0;
    List<int> digitos = dato.split('').map(int.parse).toList();

    while (contador < 9) {
      int valor = digitos[contador];
      if (contador % 2 == 0) {
        valor = valor * 2;
        if (valor > 9) valor -= 9;
      }
      acumulado += valor;
      contador++;
    }

    int digitoVerificador = digitos[9];
    int decenaSuperior = (acumulado + 9) ~/ 10 * 10;
    int calculado = decenaSuperior - acumulado;
    if (calculado == 10) calculado = 0;

    return calculado == digitoVerificador;
  }

  // 2. Validar Correo (Regex estándar pero simple)
  static bool validarCorreo(String? email) {
    if (email == null || email.isEmpty) return false;
    // Regex común para email
    final RegExp regex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return regex.hasMatch(email);
  }

  // 3. Validar Password (Hardening: Mayúscula, Número, Caracter Especial, Min 8)
  static String? validarContrasenaSegura(String? password) {
    if (password == null || password.isEmpty)
      return "La contraseña es requerida";
    if (password.length < 8) return "Mínimo 8 caracteres";

    bool tieneMayuscula = password.contains(RegExp(r'[A-Z]'));
    bool tieneNumero = password.contains(RegExp(r'[0-9]'));
    // Caracteres especiales
    bool tieneEspecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (!tieneMayuscula) return "Debe tener al menos una mayúscula";
    if (!tieneNumero) return "Debe tener al menos un número";
    if (!tieneEspecial) return "Debe tener al menos un signo (!@#...)";

    return null; // Todo correcto
  }
}
