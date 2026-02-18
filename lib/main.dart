import 'package:flutter/material.dart';
import 'login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Variable para controlar el tema
  bool _isDarkTheme = false;

  // Funcion para cambiar el tema
  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Examen Desarrollo Movil',
      // Configuracion del tema
      theme: _isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      // Pagina inicial
      home: LoginPage(toggleTheme: _toggleTheme),
    );
  }
}
