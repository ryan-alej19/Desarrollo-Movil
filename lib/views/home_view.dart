import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:switch_theme/views/colors_view.dart';
import 'package:switch_theme/views/inputs_view.dart';
import 'package:switch_theme/views/http_view.dart';

class HomeView extends StatelessWidget {
  final VoidCallback onToggleDarkMode;
  final bool isDarkMode;

  const HomeView({
    super.key,
    required this.onToggleDarkMode,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Switch Theme'), elevation: 0),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🐱 ANIMACIÓN LOTTIE DEL GATO
              SizedBox(
                height: 250,
                width: 250,
                child: Center(
                  child: Lottie.asset(
                    'lib/assets/Loadercat.json',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // TÍTULO
              const Text(
                'Switch Theme',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Cambia el tema de tu aplicación',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 60),

              // BOTÓN 1: IR A COLORES
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ColorsView()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  elevation: 5,
                ),
                child: const Text(
                  'Go to Colors View',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 20),

              // BOTÓN 2: IR A INPUTS
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const InputsView()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  elevation: 5,
                ),
                child: const Text(
                  'Go to Inputs View',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 20),

              // BOTÓN 3: IR A HTTP VIEW
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HttpView()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  elevation: 5,
                ),
                child: const Text(
                  'Go to HTTP View',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),

      // BOTÓN FLOTANTE PARA CAMBIAR TEMA
      floatingActionButton: FloatingActionButton(
        onPressed: onToggleDarkMode,
        tooltip: isDarkMode ? 'Modo claro' : 'Modo oscuro',
        child: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode, size: 28),
      ),
    );
  }
}
