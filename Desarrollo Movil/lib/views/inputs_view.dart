// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

class InputsView extends StatefulWidget {
  const InputsView({super.key});

  @override
  State<InputsView> createState() => _InputsViewState();
}

class _InputsViewState extends State<InputsView> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();

  String _categoria = 'Camisa';
  String _talla = 'M';

  bool _colorRojo = false;
  bool _colorAzul = false;
  bool _colorNegro = false;
  bool _colorBlanco = false;

  double _precio = 50.0;
  bool _enStock = true; // ⬅️ EL 7º ATRIBUTO

  @override
  void dispose() {
    _nombreController.dispose();
    _marcaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Ropa')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // NOMBRE DEL PRODUCTO
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre del Producto',
                border: OutlineInputBorder(),
                hintText: 'Ej: Camiseta Nike',
              ),
            ),
            const SizedBox(height: 20),

            // MARCA
            TextField(
              controller: _marcaController,
              decoration: const InputDecoration(
                labelText: 'Marca',
                border: OutlineInputBorder(),
                hintText: 'Ej: Nike, Adidas',
              ),
            ),
            const SizedBox(height: 20),

            // CATEGORÍA
            const Text(
              'Categoría',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: _categoria,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'Camisa', child: Text('Camisa')),
                DropdownMenuItem(value: 'Pantalón', child: Text('Pantalón')),
                DropdownMenuItem(value: 'Zapatos', child: Text('Zapatos')),
                DropdownMenuItem(value: 'Chaqueta', child: Text('Chaqueta')),
              ],
              onChanged: (value) {
                setState(() {
                  _categoria = value!;
                });
              },
            ),
            const SizedBox(height: 20),

            // TALLA
            const Text(
              'Talla',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                RadioListTile<String>(
                  title: const Text('XS'),
                  value: 'XS',
                  groupValue: _talla,
                  onChanged: (value) {
                    setState(() {
                      _talla = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('S'),
                  value: 'S',
                  groupValue: _talla,
                  onChanged: (value) {
                    setState(() {
                      _talla = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('M'),
                  value: 'M',
                  groupValue: _talla,
                  onChanged: (value) {
                    setState(() {
                      _talla = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('L'),
                  value: 'L',
                  groupValue: _talla,
                  onChanged: (value) {
                    setState(() {
                      _talla = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('XL'),
                  value: 'XL',
                  groupValue: _talla,
                  onChanged: (value) {
                    setState(() {
                      _talla = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // COLORES
            const Text(
              'Colores',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            CheckboxListTile(
              title: const Text('Rojo'),
              value: _colorRojo,
              onChanged: (value) {
                setState(() {
                  _colorRojo = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Azul'),
              value: _colorAzul,
              onChanged: (value) {
                setState(() {
                  _colorAzul = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Negro'),
              value: _colorNegro,
              onChanged: (value) {
                setState(() {
                  _colorNegro = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Blanco'),
              value: _colorBlanco,
              onChanged: (value) {
                setState(() {
                  _colorBlanco = value!;
                });
              },
            ),
            const SizedBox(height: 20),

            // PRECIO
            const Text(
              'Precio (USD)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _precio,
              min: 10.0,
              max: 500.0,
              divisions: 49,
              label: '\$${_precio.round()}',
              onChanged: (value) {
                setState(() {
                  _precio = value;
                });
              },
            ),
            Text('Precio: \$${_precio.round()}'),
            const SizedBox(height: 20),

            // EN STOCK en switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '¿Producto en Stock?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: _enStock,
                  onChanged: (value) {
                    setState(() {
                      _enStock = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),

            // BOTÓN GUARDAR
            Center(
              child: ElevatedButton(
                onPressed: _guardarFormulario,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                ),
                child: const Text(
                  'GUARDAR PRODUCTO',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _guardarFormulario() {
    List<String> coloresSeleccionados = [];
    if (_colorRojo) coloresSeleccionados.add('Rojo');
    if (_colorAzul) coloresSeleccionados.add('Azul');
    if (_colorNegro) coloresSeleccionados.add('Negro');
    if (_colorBlanco) coloresSeleccionados.add('Blanco');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Producto Guardado ✓'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Nombre: ${_nombreController.text}'),
            Text('Marca: ${_marcaController.text}'),
            Text('Categoría: $_categoria'),
            Text('Talla: $_talla'),
            Text(
              'Colores: ${coloresSeleccionados.isEmpty ? "Ninguno" : coloresSeleccionados.join(", ")}',
            ),
            Text('Precio: \$${_precio.round()}'),
            Text('En Stock: ${_enStock ? "Sí ✅" : "No ❌"}'), //
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
