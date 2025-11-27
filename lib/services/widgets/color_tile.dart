import 'package:flutter/material.dart';

class ColorTile extends StatelessWidget {
  final Color color;
  final String colorName;

  const ColorTile({
    super.key,
    required this.color,
    required this.colorName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 10,
          ),
        ],
      ),
      child: Center(
        child: Text(
          colorName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
