import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  bool _isDarkMode = false;
  Color _primaryColor = Colors.blue; // ⬅️ NUEVO: color del tema

  bool get isDarkMode => _isDarkMode;
  Color get primaryColor => _primaryColor; // ⬅️ NUEVO

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // ⬅️ NUEVO: método para cambiar el color del tema
  void changeColor(Color newColor) {
    _primaryColor = newColor;
    notifyListeners();
  }
}
