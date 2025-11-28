import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:switch_theme/services/theme_service.dart';
import 'package:switch_theme/views/colors_view.dart';

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
            // Título "Switch Theme" en el centro
            Text(
              'Switch Theme',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            // Botón rojo "Go to colors view"
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
          ],
        ),
      ),
      // Botón flotante Luna/Sol
      floatingActionButton: Builder(
        builder: (context) {
          final themeService = context.watch<ThemeService>();
          return FloatingActionButton(
            backgroundColor: themeService.isDarkMode
                ? Colors.white
                : Colors.black,
            foregroundColor: themeService.isDarkMode
                ? Colors.black
                : Colors.white,
            onPressed: () => context.read<ThemeService>().toggleTheme(),
            tooltip: themeService.isDarkMode
                ? 'Switch to light mode'
                : 'Switch to dark mode',
            child: Icon(
              themeService.isDarkMode ? Icons.wb_sunny : Icons.nights_stay,
            ),
          );
        },
      ),
    );
  }
}
