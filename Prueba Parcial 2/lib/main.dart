import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  String? _validateCedula(String? value) {
    if (value == null || value.isEmpty) {
      return 'El campo es obligatorio';
    }
    // Validation: Numbers only
    if (int.tryParse(value) == null) {
      return 'La cedula solo debe contener numeros';
    }
    // Validation: Exact 10 digits
    if (value.length != 10) {
      return 'La cedula debe tener exactamente 10 digitos';
    }
    return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cedula valida')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Validacion Cedula')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                key: const Key('campo_cedula'),
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Cedula',
                  hintText: 'Ingrese su cedula',
                ),
                keyboardType: TextInputType.number,
                validator: _validateCedula,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                key: const Key('boton_enviar'),
                onPressed: _submit,
                child: const Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
