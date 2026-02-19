import 'package:flutter/material.dart';
import 'registro_page.dart';
import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  final Function
  toggleTheme; // Recibimos la funcion para cambiar tema aunque aqui no se use directo, a veces se pasa

  const LoginPage({super.key, required this.toggleTheme});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controladores para los campos de texto
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Lo del Formulario para validar los campos
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Llenar correo
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su correo';
                  }
                  if (!value.contains('@')) {
                    return 'Ingrese un correo valido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Campo de la contraseña
              TextFormField(
                controller: _passwordController,
                obscureText:
                    true, // Le oculta el texto para que no se vea la contraseña
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su contraseña';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // El boton de Login
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // si va bien va al dashboard
                    // Navegamos al Dashboard y que este el boton salir y pasamos la funcion del tema
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DashboardPage(toggleTheme: widget.toggleTheme),
                      ),
                    );
                  }
                },
                child: const Text('Iniciar Sesión'),
              ),
              TextButton(
                onPressed: () {
                  // Ir a la pagina del registro y que este el boton de volverp
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RegistroPage(toggleTheme: widget.toggleTheme),
                    ),
                  );
                },
                child: const Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
