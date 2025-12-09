import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:switch_theme/services/theme_service.dart';

class ColorsView extends StatelessWidget {
  const ColorsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona un Tema'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Elige un color para el tema:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _colorButton(context, Colors.blue, 'Azul'),
                  _colorButton(context, Colors.green, 'Verde'),
                  _colorButton(context, Colors.red, 'Rojo'),
                  _colorButton(context, Colors.purple, 'Morado'),
                  _colorButton(context, Colors.orange, 'Naranja'),
                  _colorButton(context, Colors.teal, 'Verde Oscuro'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorButton(BuildContext context, Color color, String nombre) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        onPressed: () {
          Provider.of<ThemeService>(context, listen: false).setColor(color);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tema cambiado a $nombre')),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 20),
        ),
        child: Text(
          nombre,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
