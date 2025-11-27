import 'package:flutter/material.dart';

class ThemeService {
  // ValueNotifier = Variable observable
  static ValueNotifier<bool> isDarkMode = ValueNotifier(false);

  // Función para cambiar tema
  static void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    debugPrint('🎨 Tema: ${isDarkMode.value ? "OSCURO 🌙" : "CLARO ☀️"}');
  }

  // Tema claro
  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primarySwatch: Colors.deepPurple,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  // Tema oscuro
  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primarySwatch: Colors.deepPurple,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
