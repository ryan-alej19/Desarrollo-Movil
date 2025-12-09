import 'package:flutter/material.dart';
import 'package:switch_theme/views/colors_view.dart';
import 'package:switch_theme/views/inputs_view.dart';

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
      appBar: AppBar(
        title: const Text('Switch Theme'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Switch Theme',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ColorsView()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('Go to colors view', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InputsView()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('Go to inputs view', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onToggleDarkMode,
        tooltip: isDarkMode ? 'Modo claro' : 'Modo oscuro',
        child: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
      ),
    );
  }
}
