import 'package:flutter/material.dart';
import 'dashboard_page.dart';

class RegistroPage extends StatefulWidget {
  final Function toggleTheme; // Recibimos la funcion para cambiar tema

  const RegistroPage({super.key, required this.toggleTheme});

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final _cedulaController = TextEditingController();
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _passController = TextEditingController();
  final _repeatPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Para que no le tape el teclado
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Cedula
                TextFormField(
                  controller: _cedulaController,
                  decoration: const InputDecoration(labelText: 'Cédula'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese cédula';
                    }
                    return null;
                  },
                ),
                // Nombres
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombres Completos',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese nombres';
                    }
                    return null;
                  },
                ),
                // Correo
                TextFormField(
                  controller: _correoController,
                  decoration: const InputDecoration(labelText: 'Correo'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese el correo';
                    }
                    return null;
                  },
                ),
                // Contraseña
                TextFormField(
                  controller: _passController,
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese la contraseña';
                    }
                    return null;
                  },
                ),
                // Repetir Contraseña
                TextFormField(
                  controller: _repeatPassController,
                  decoration: const InputDecoration(
                    labelText: 'Repetir la Contraseña',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Repita la contraseña';
                    }
                    if (value != _passController.text) {
                      return 'Las contraseñas no se coinciden';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Mostrar mensaje de exito
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Registro bien echo')),
                      );
                      // Ir directamente al Dashboard y limpiar la pila de navegación
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DashboardPage(toggleTheme: widget.toggleTheme),
                        ), //lleve a la otra ruta 
                        (route) => false,
                      );
                    }
                  },
                  child: const Text('Registrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
