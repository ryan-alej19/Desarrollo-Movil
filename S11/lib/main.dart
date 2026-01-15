import 'package:flutter/material.dart';
import 'package:s11/container_card.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(title: const Text('Clean UI Widgets'), elevation: 0),
        body: const Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ContainerCard(
                      path: 'assets/img/foto-1.jpg',
                      tittle: 'Titulo 1',
                      description: 'Description 1',
                      isRowReverse: true,
                    ),
                    ContainerCard(
                      path: 'assets/img/foto-2.jpg',
                      tittle: 'Titulo 2',
                      description: 'Description 2',
                      isRowReverse: false,
                    ),
                    ContainerCard(
                      path: 'assets/img/foto-3.jpg',
                      tittle: 'Titulo 3',
                      description: 'Description 3',
                      isRowReverse: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
