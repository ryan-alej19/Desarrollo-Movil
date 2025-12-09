import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  Color _selectedColor = Colors.blue; // Color por defecto

  Color get selectedColor => _selectedColor;

  void setColor(Color color) {
    _selectedColor = color;
    notifyListeners(); // ⬅️ Notifica a todos los listeners que cambió
  }

  ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _selectedColor, // ⬅️ Usa el color guardado
      ),
    );
  }
}
