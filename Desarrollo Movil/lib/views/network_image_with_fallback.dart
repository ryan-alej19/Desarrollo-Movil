import 'package:flutter/material.dart';

class NetworkImageWithFallback extends StatefulWidget {
  final List<String> urls;
  final double? height;

  const NetworkImageWithFallback({Key? key, required this.urls, this.height}) : super(key: key);

  @override
  State<NetworkImageWithFallback> createState() => _NetworkImageWithFallbackState();
}

class _NetworkImageWithFallbackState extends State<NetworkImageWithFallback> {
  int _index = 0;

  void _next() {
    if (_index < widget.urls.length - 1) {
      setState(() {
        _index++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final url = widget.urls[_index];
    return Image.network(
      url,
      height: widget.height,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          height: widget.height ?? 200,
          color: Colors.grey[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text('Cargando retrato del personaje...', style: TextStyle(color: Colors.grey)),
            ],
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        // si hay más candidatos, intentar el siguiente
        WidgetsBinding.instance.addPostFrameCallback((_) => _next());
        // mientras tanto, mostrar placeholder
        return Container(
          height: widget.height ?? 200,
          color: Colors.grey[300],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
              SizedBox(height: 10),
              Text('Retrato del personaje no disponible', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ],
          ),
        );
      },
    );
  }
}
