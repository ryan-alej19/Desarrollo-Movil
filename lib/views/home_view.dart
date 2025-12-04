import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:switch_theme/services/theme_service.dart';
import 'package:switch_theme/views/colors_view.dart';
import 'package:switch_theme/views/inputs_view.dart'; // ⬅️ AGREGAR ESTE IMPORT

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Switch Theme')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Switch Theme',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            // Botón para Colors View
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ColorsView()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Go to colors view',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20), // ⬅️ Espaciado
            // ⬇️ NUEVO: Botón para Inputs View
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const InputsView()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Go to inputs view',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.watch<ThemeService>().isDarkMode
            ? Colors.white
            : Colors.black,
        foregroundColor: context.watch<ThemeService>().isDarkMode
            ? Colors.black
            : Colors.white,
        onPressed: () {
          context.read<ThemeService>().toggleTheme();
        },
        tooltip: context.watch<ThemeService>().isDarkMode
            ? 'Switch to light mode'
            : 'Switch to dark mode',
        child: Icon(
          context.watch<ThemeService>().isDarkMode
              ? Icons.wb_sunny
              : Icons.nights_stay,
        ),
      ),
    );
  }
}
