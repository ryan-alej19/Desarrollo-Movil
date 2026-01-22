import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  const InputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: 'Cedula',
        border: OutlineInputBorder(),
      ),
    );
  }
}
