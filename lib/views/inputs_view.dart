import 'package:flutter/material.dart';

class InputsView extends StatefulWidget {
  const InputsView({super.key});

  @override
  State<InputsView> createState() => _InputsViewState();
}

class _InputsViewState extends State<InputsView> {
  bool checkValue = false;
  bool switchValue = false;
  double sliderValue = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Inputs View'),
      ),
      body: SingleChildScrollView(  // ⬅️ Para hacer scroll
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TextField
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                helperText: "It's necessary your full name",
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Checkbox
            Row(
              children: [
                Checkbox(
                  value: checkValue,
                  onChanged: (value) {
                    setState(() {
                      checkValue = value!;
                    });
                  },
                ),
                const Text('Check me'),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Switch
            Row(
              children: [
                Switch(
                  value: switchValue,
                  onChanged: (value) {
                    setState(() {
                      switchValue = value;
                    });
                  },
                ),
                const Text('Switch me'),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // Slider
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Slider'),
                Slider(
                  value: sliderValue,
                  min: 0.0,
                  max: 1.0,
                  onChanged: (value) {
                    setState(() {
                      sliderValue = value;
                    });
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 40),
            
            // ⬇️ NUEVOS BOTONES
            Center(
              child: Column(
                children: [
                  // 1. Elevated Button
                  ElevatedButton(
                    onPressed: () {
                      print('Elevated Button pressed');
                    },
                    child: const Text('Elevated Button'),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // 2. Filled Button
                  FilledButton(
                    onPressed: () {
                      print('Filled Button pressed');
                    },
                    child: const Text('Filled Button'),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // 3. Text Button
                  TextButton(
                    onPressed: () {
                      print('Text Button pressed');
                    },
                    child: const Text('Text Button'),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // 4. Outline Button
                  OutlinedButton(
                    onPressed: () {
                      print('Outline Button pressed');
                    },
                    child: const Text('Outline Button'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
