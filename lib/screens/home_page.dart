import 'package:flutter/material.dart';
import '../widgets/input_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TEST')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: InputWidget()),
      ),
    );
  }
}
