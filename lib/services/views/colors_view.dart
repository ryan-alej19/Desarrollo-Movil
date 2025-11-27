import 'package:flutter/material.dart';

class ColorsView extends StatelessWidget {
  const ColorsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de colores con MaterialColor
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.pink,
      Colors.cyan,
      Colors.amber,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Colors')),
      body: ListView.builder(
        itemCount: colors.length,
        itemBuilder: (context, index) {
          return Container(
            height: 100,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors[index],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                'MaterialColor(primary value:\nColor(alpha: 1.0000, red: ${colors[index].red.toStringAsFixed(4)}, green: ${colors[index].green.toStringAsFixed(4)}, blue: ${colors[index].blue.toStringAsFixed(4)}, colorSpace: ColorSpace.sRGB))',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
