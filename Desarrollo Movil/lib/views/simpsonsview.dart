import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class SimpsonsView extends StatefulWidget {
  const SimpsonsView({super.key});

  @override
  State<SimpsonsView> createState() => _SimpsonsViewState();
}

class _SimpsonsViewState extends State<SimpsonsView> {
  Future<Map<String, dynamic>>? _future;

  Future<Map<String, dynamic>> _fetchCharacter() async {
    final randomId = Random().nextInt(50) + 1;
    final uri = Uri.parse('https://thesimpsonsapi.com/api/characters/$randomId');
    
    debugPrint('🌐 Consultando: $uri');
    
    final resp = await http.get(uri).timeout(const Duration(seconds: 30));
    
    if (resp.statusCode != 200) {
      throw 'Error HTTP ${resp.statusCode}: No se pudieron obtener los datos';
    }
    
    final data = jsonDecode(resp.body);
    
    if (data is List && data.isNotEmpty) {
      return data[0] as Map<String, dynamic>;
    }
    
    throw 'No se pudo obtener un personaje válido de la API';
  }

  // ✅ FUNCIÓN PARA CONSTRUIR URL CORRECTA DEL CDN
  String _buildImageUrl(String portraitPath, int characterId) {
    // Las imágenes están en el CDN: https://cdn.thesimpsonsapi.com/500/character/{id}.webp
    final correctUrl = 'https://cdn.thesimpsonsapi.com/500/character/$characterId.webp';
    debugPrint('🎯 URL CDN CORRECTA: $correctUrl');
    return correctUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Los Simpsons API'),
        centerTitle: true,
        backgroundColor: Colors.amber[700],
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
                    Icon(Icons.tv, size: 40, color: Colors.amber),
                    SizedBox(height: 8),
                    Text(
                      '📺 Simpsons API',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Obtén personajes aleatorios con imágenes',
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
                  _future = _fetchCharacter();
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text(
                'Obtener Personaje Aleatorio',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 6,
              ),
            ),
            const SizedBox(height: 28),
            if (_future != null)
              FutureBuilder<Map<String, dynamic>>(
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
                        const Text(
                          'Cargando personaje...',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }

                  if (snapshot.hasError) {
                    final msg = snapshot.error?.toString() ?? 'Error';
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
                            Icon(Icons.error, size: 36, color: Colors.red[700]),
                            const SizedBox(height: 8),
                            Text(
                              msg,
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
                    
                    final name = (c['name'] ?? 'Desconocido').toString();
                    final age = (c['age'] ?? 'Desconocida').toString();
                    final occupation = (c['occupation'] ?? 'Desconocida').toString();
                    final gender = (c['gender'] ?? 'Desconocido').toString();
                    final portraitPath = (c['portrait'] ?? '').toString();
                    final characterId = c['id'] as int;
                    
                    debugPrint('=== PERSONAJE ENCONTRADO ===');
                    debugPrint('ID: $characterId');
                    debugPrint('Nombre: $name');
                    debugPrint('Portrait Path (API): $portraitPath');
                    debugPrint('==========================');

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
                                const Icon(
                                  Icons.person,
                                  color: Colors.amber,
                                  size: 28,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Personaje:',
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        const Text(
                                          '👤 Edad:',
                                          style: TextStyle(
                                            color: Colors.amber,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(age),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        const Text(
                                          '⚧ Género:',
                                          style: TextStyle(
                                            color: Colors.amber,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(gender),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  '💼 Ocupación:',
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  occupation,
                                  style: const TextStyle(color: Colors.black54),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Colors.amber[100]!,
                              width: 1,
                            ),
                          ),
                          elevation: 4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: portraitPath.isNotEmpty
                                ? Image.network(
                                    _buildImageUrl(portraitPath, characterId),
                                    height: 320,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, prog) {
                                      if (prog == null) return child;
                                      return Container(
                                        height: 320,
                                        color: Colors.grey[200],
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                Colors.amber[700]!,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            const Text(
                                              'Cargando imagen...',
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      debugPrint('❌ Error: $error');
                                      debugPrint('❌ URL que falló: ${_buildImageUrl(portraitPath, characterId)}');
                                      
                                      return Container(
                                        height: 320,
                                        color: Colors.grey[300],
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.broken_image,
                                              size: 64,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              'Imagen no disponible',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    height: 320,
                                    color: Colors.grey[200],
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.person_outline,
                                          size: 88,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'No hay retrato disponible',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    );
                  }

                  return const Center(child: Text('Sin datos disponibles'));
                },
              ),
          ],
        ),
      ),
    );
  }
}