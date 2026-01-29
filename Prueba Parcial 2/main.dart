import 'package:flutter/material.dart';

void main() {
  runApp(const MiAppEstudiantil());
}

class MiAppEstudiantil extends StatelessWidget {
  const MiAppEstudiantil({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Validación Cédula',
      theme: ThemeData(
        // DIFERENCIA 1: Color distinto al del compañero (que usa morado)
        // Uso un verde "bosque" para que se vea serio pero diferente
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const VistaRegistro(),
    );
  }
}

// --- PANTALLA PRINCIPAL ---
class VistaRegistro extends StatefulWidget {
  const VistaRegistro({super.key});

  @override
  State<VistaRegistro> createState() => _VistaRegistroState();
}

class _VistaRegistroState extends State<VistaRegistro> {
  // Nombres de variables en español simple
  final _controladorCedula = TextEditingController();
  final _llaveFormulario = GlobalKey<FormState>();

  // Variable para mensaje de error en pantalla (si se requiere)
  String? _errorMensaje;

  void _accionBoton() {
    // Escondemos el teclado
    FocusScope.of(context).unfocus();

    String textoIngresado = _controladorCedula.text;

    // Validación básica de vacío
    if (textoIngresado.isEmpty) {
      setState(() {
        _errorMensaje = "Escribe algo primero";
      });
      return;
    }

    // Llamamos a nuestra función de lógica "manual"
    if (validarConAlgoritmoPropio(textoIngresado)) {
      setState(() {
        _errorMensaje = null;
      });

      // DIFERENCIA DE FLUJO: Navegar a pantalla de éxito (como él lo tiene)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VistaExito()),
      );
    } else {
      setState(() {
        _errorMensaje = "La cédula NO es válida";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro de Usuario"),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _llaveFormulario,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono para decorar un poco (sin emojis)
              const Icon(
                Icons.person_pin_outlined,
                size: 80,
                color: Colors.green,
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _controladorCedula,
                maxLength: 10,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Número de Identificación',
                  errorText: _errorMensaje,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  // Icono interno diferente
                  prefixIcon: const Icon(Icons.credit_card),
                ),
              ),
              const SizedBox(height: 30),

              // DIFERENCIA VISUAL: Botón ancho pero con borde, no relleno sólido por defecto
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: _accionBoton,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.green, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "VERIFICAR Y ENTRAR",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- PANTALLA DE ÉXITO (Para igualar la estructura de navegación del compañero) ---
class VistaExito extends StatelessWidget {
  const VistaExito({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bienvenido")),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 100,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            const Text(
              "¡Validación Exitosa!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("El documento es correcto."),
            const SizedBox(height: 40),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("VOLVER"),
            ),
          ],
        ),
      ),
    );
  }
}

// --- LÓGICA (ALGORITMO) ---
// La pongo aquí abajo para que esté en un solo archivo pero separado visualmente.

bool validarConAlgoritmoPropio(String aux) {
  // Validaciones previas
  if (aux.length != 10) return false;

  // Convertimos a enteros paso a paso

  // Región (1-24)
  int region = int.parse(aux.substring(0, 2));
  if (region < 1 || region > 24) return false;

  // Tercer dígito < 6
  int n3 = int.parse(aux.substring(2, 3));
  if (n3 >= 6) return false;

  // Algoritmo Módulo 10 usando WHILE (Diferencia clave con el compañero)
  int i = 0;
  int acumulador = 0;

  while (i < 9) {
    // Tomamos el dígito actual
    int n = int.parse(aux.substring(i, i + 1));

    // Si la posición es par (0, 2, 4...) multiplicamos por 2
    // Si es impar (1, 3, 5...) por 1
    if (i % 2 == 0) {
      n = n * 2;
      if (n > 9) {
        n = n - 9;
      }
    }

    acumulador = acumulador + n; // Suma 'manual'
    i++;
  }

  int verificador = int.parse(aux.substring(9, 10));
  int decena = (acumulador + 9) ~/ 10 * 10;
  int resta = decena - acumulador;

  if (resta == 10) resta = 0;

  return resta == verificador;
}
