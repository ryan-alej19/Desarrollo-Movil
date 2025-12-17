import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:switch_theme/models/character_model.dart';

// Resultado posible de resolución de imagen: URL válida o bytes descargados
class _ImageResult {
  final String? url;
  final Uint8List? bytes;
  _ImageResult({this.url, this.bytes});
}

class HttpView extends StatefulWidget {
  const HttpView({Key? key}) : super(key: key);

  @override
  State<HttpView> createState() => _HttpViewState();
}


class _HttpViewState extends State<HttpView> {
  Future<CharacterModel>? _future;

  Future<CharacterModel> _fetchSimpsonsCharacter() async {
    try {
      // Generar número aleatorio entre 1 y 900 (hay ~900 personajes)
      final random = (DateTime.now().millisecondsSinceEpoch % 900) + 1;

      final response = await http
          .get(Uri.parse('https://thesimpsonsapi.com/api/characters/$random'))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw 'Timeout: La solicitud tardó demasiado',
          );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final character = CharacterModel.fromJson(jsonData);

        // PRINT EN DEBUG CONSOLE
        try {
          print('Simpson API Character: ${character.name}');
        } catch (_) {
          print('Simpson API Character: <sin nombre>');
        }

        return character;
      } else {
        throw 'Error ${response.statusCode}: No se pudo obtener los datos';
      }
    } catch (e) {
      print('❌ Error en _resolveImage: $e');
    }
    return null;
  }

  // Construye una URL usando el proxy images.weserv.nl para evitar bloqueos de Referer
  String _buildWeservProxyUrl(String originalUrl) {
    try {
      final u = Uri.parse(originalUrl);
      // images.weserv.nl acepta la URL original; incluir el esquema completo ayuda a evitar errores
      final enc = Uri.encodeComponent(u.toString());
      // w (width) se puede ajustar; n=-1 evita el sharpen automático
      return 'https://images.weserv.nl/?url=$enc&n=-1';
    } catch (_) {
      return originalUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[700],
        title: const Text('Los Simpsons API', 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.amber[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.amber[700]!, width: 2),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: const [
                    Icon(Icons.person, size: 40, color: Colors.amber),
                    SizedBox(height: 8),
                    Text('📺 Simpsons API',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    Text('Obtén información de personajes aleatorios',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _future = _fetchSimpsonsCharacter();
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Obtener Personaje Aleatorio',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 6,
              ),
            ),
            const SizedBox(height: 28),
            if (_future != null)
              FutureBuilder<CharacterModel>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.amber[700]!,
                          ),
                          strokeWidth: 4,
                        ),
                        const SizedBox(height: 12),
                        const Text('Cargando personaje...',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }

                  if (snapshot.hasError) {
                    final msg = snapshot.error?.toString() ?? 'Error inesperado';
                    return Card(
                      elevation: 4,
                      color: Colors.red[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.red[400]!, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            Icon(Icons.error, color: Colors.red[700], size: 40),
                            const SizedBox(height: 10),
                            Text(
                              'Error Respuesta inesperada de la API',
                              style: TextStyle(
                                color: Colors.red[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (snapshot.hasData) {
                    final c = snapshot.data!;
                    final portraitRaw = c.portraitPath?.trim();
                    final Future<_ImageResult?> imageFuture = (portraitRaw != null && portraitRaw.isNotEmpty)
                      ? _resolveImage(portraitRaw)
                      : Future.value(null);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                          color: Colors.amber[50],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Colors.amber[700]!,
                              width: 2,
                            ),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const Icon(Icons.person,
                                  color: Colors.amber,
                                  size: 28,
                                ),
                                const SizedBox(height: 8),
                                const Text('Personaje:',
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(c.name ?? 'Desconocido',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text('Edad: ${c.age?.toString() ?? "N/A"}',
                                  style: const TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text('Ocupación: ${c.occupation ?? "N/A"}',
                                  style: const TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (c.description != null && 
                          c.description!.isNotEmpty)
                          Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: Colors.amber[200]!,
                                width: 1,
                              ),
                            ),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.description,
                                    color: Colors.amber[700],
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      c.description!,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // CARD 3: IMAGEN (usa portraitPath)
                        if (character.portraitPath != null &&
                            character.portraitPath!.isNotEmpty)
                          Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                'https://thesimpsonsapi.com/api/characters/${character.id}/portrait.webp',
                                height: 350,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 350,
                                    color: Colors.grey[300],
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.image_not_supported,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(height: 10),
                                        const Text(
                                          'Imagen no disponible',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        const SizedBox(height: 30),
                      ],
                    );
                  }

                  return const Center(
                    child: Text('Sin datos disponibles'),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
