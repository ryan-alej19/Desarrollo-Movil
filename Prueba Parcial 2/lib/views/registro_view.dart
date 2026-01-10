import 'package:flutter/material.dart';
import '../utils/validaciones.dart';
import 'exito_view.dart';

class VistaRegistro extends StatefulWidget {
  const VistaRegistro({super.key});

  @override
  State<VistaRegistro> createState() => _VistaRegistroState();
}

class _VistaRegistroState extends State<VistaRegistro> {
  // Controladores y Llave del Formulario
  final _controladorCedula = TextEditingController();
  final _controladorCorreo = TextEditingController();
  final _controladorPass = TextEditingController();

  final _llaveFormulario = GlobalKey<FormState>();

  // Para mostrar/ocultar contraseña
  bool _mostrarPass = false;

  void _intentarRegistro() {
    // Quitamos foco del teclado
    FocusScope.of(context).unfocus();

    // Ejecutamos validaciones de todo el formulario
    if (_llaveFormulario.currentState!.validate()) {
      // Si todo es válido:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VistaExito()),
      );
    } else {
      // Si falla algo, Flutter muestra los errores automáticamente en los inputs
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor corrija los errores marcados."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear Cuenta"),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        // Para evitar overflow si sale el teclado
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _llaveFormulario,
          child: Column(
            children: [
              const Icon(Icons.security, size: 70, color: Colors.green),
              const SizedBox(height: 30),

              // 1. Cédula
              TextFormField(
                controller: _controladorCedula,
                maxLength: 10,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Cédula de Identidad',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.card_membership),
                ),
                validator: (valor) {
                  if (!ValidacionesPropias.validarCedulaEcuatoriana(valor)) {
                    return "Cédula inválida o incorrecta";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // 2. Correo
              TextFormField(
                controller: _controladorCorreo,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                validator: (valor) {
                  if (!ValidacionesPropias.validarCorreo(valor)) {
                    return "Ingrese un correo válido";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // 3. Contraseña con botón de ver/ocultar
              TextFormField(
                controller: _controladorPass,
                obscureText: !_mostrarPass,
                decoration: InputDecoration(
                  labelText: 'Contraseña Segura',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _mostrarPass ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _mostrarPass = !_mostrarPass;
                      });
                    },
                  ),
                ),
                validator: ValidacionesPropias.validarContrasenaSegura,
              ),
              const SizedBox(height: 5),
              const Text(
                "Debe tener Mayúscula, Número y Símbolo (!@#..)",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),

              const SizedBox(height: 40),

              // Botón de Acción
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: _intentarRegistro,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.green, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "REGISTRARME",
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
