import 'package:flutter/material.dart';
// Nota: en la estructura real sería 'package:prueba_parcial_2/views/registro_view.dart',
// pero como estamos moviendo archivos y la estructura del pubspec a veces varía,
// uso ruta relativa o package según corresponda.
// A nivel de 'lib/main.dart', la ruta correcta para importar algo de la misma lib es relative o package.
// Usaré relative para evitar lios si el package name no es exacto.
import 'views/registro_view.dart';

void main() {
  runApp(const MiAppEstudiantil());
}

class MiAppEstudiantil extends StatelessWidget {
  const MiAppEstudiantil({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Validación Cédula',
      theme: ThemeData(
        // Mantenemos el verde serio
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      // La pantalla de inicio ahora está en la carpeta views
      home: const VistaRegistro(),
    );
  }
}
