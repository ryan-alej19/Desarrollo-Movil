import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String path;
  final String title;

  const DetailScreen({super.key, required this.path, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: AspectRatio(
          aspectRatio: 0.5,
          child: Image.asset(path, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
