import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyFormPage());
  }
}

class MyFormPage extends StatefulWidget {
  const MyFormPage({super.key});

  @override
  State<MyFormPage> createState() => _MyFormPageState();
}

class _MyFormPageState extends State<MyFormPage> {
  // Clave para identificar el formulario
  final _formKey = GlobalKey<FormState>();

  String? validarCedula(String? valor) {
    // Si esta vacio
    if (valor == null || valor.isEmpty) {
      return 'Por favor ingrese numero de cedula';
    }

    // Si no es numero
    if (int.tryParse(valor) == null) {
      return 'Ingrese solo numeros';
    }

    // Si no tiene 10 digitos
    if (valor.length != 10) {
      return 'La cedula debe tener 10 digitos';
    }

    return null;
  }

  void enviarFormulario() {
    // Validar el formulario
    if (_formKey.currentState!.validate()) {
      // Si es valido mostrar mensaje
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cedula valida')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Validador de Cedula')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                key: const Key('campo_cedula'),
                decoration: const InputDecoration(
                  labelText: 'Ingrese Cedula',
                  border: OutlineInputBorder(),
                ),
                validator: validarCedula,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                key: const Key('boton_enviar'),
                onPressed: enviarFormulario,
                child: const Text('Ingresar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
