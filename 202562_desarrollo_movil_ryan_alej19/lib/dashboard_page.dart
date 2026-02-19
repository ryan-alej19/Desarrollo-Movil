import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  final Function toggleTheme;

  const DashboardPage({super.key, required this.toggleTheme});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              // Llamamos a la funcion para cambiar tema
              widget.toggleTheme();
            },
            tooltip: 'Cambiar Tema',
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Regresar al login 
            Navigator.pop(context);
          },
          child: const Text('Salir'),
        ),
      ),
    );
  }
}
