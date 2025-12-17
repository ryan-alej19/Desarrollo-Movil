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
      // Solicitar datos con timeout de 30 segundos
      final response = await http
          .get(Uri.parse('https://thesimpsonsapi.com/api/characters'))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw 'Error HTTP ${response.statusCode}: No se pudieron obtener los datos de la API';
      }

      dynamic data = jsonDecode(response.body);
      print('🔍 DEBUG - Tipo de respuesta: ${data.runtimeType}');
      print('🔍 DEBUG - Primeros 500 caracteres: ${data.toString().substring(0, (data.toString().length > 500) ? 500 : data.toString().length)}');

      // Validar que sea una lista o extraer la lista si está dentro de un objeto
      List<dynamic>? characterList;
      
      if (data is List) {
        characterList = data;
      } else if (data is Map<String, dynamic>) {
        // Buscar una propiedad que contenga la lista de personajes
        if (data.containsKey('results') && data['results'] is List) {
          characterList = data['results'] as List;
        } else if (data.containsKey('characters') && data['characters'] is List) {
          characterList = data['characters'] as List;
        } else if (data.containsKey('data') && data['data'] is List) {
          characterList = data['data'] as List;
        }
      }

      if (characterList == null || characterList.isEmpty) {
        throw 'No se encontraron personajes en la respuesta de la API';
      }

      // Seleccionar un personaje aleatorio
      final idx = Random().nextInt(characterList.length);
      final item = characterList[idx];

      if (item == null) {
        throw 'Error: El personaje seleccionado es nulo';
      }

      if (item is! Map<String, dynamic>) {
        throw 'Error: Formato del personaje inválido (se esperaba un objeto)';
      }

      // Construir modelo inicial
      CharacterModel character = CharacterModel.fromJson(item);

      if (character.name == null || character.name!.isEmpty) {
        throw 'Error: El personaje no tiene nombre válido';
      }

      // Debug inicial: mostrar portrait_path del primer candidato
      print('🔎 Intento inicial - Personaje: ${character.name} - portrait_path: ${character.portraitPath ?? "NULL"}');

      // Si el portraitPath no es válido, intentar encontrar otro personaje con imagen
      const int maxRetries = 5;
      int attempts = 0;
      while ((character.portraitPath == null || character.portraitPath!.trim().isEmpty) && attempts < maxRetries) {
        attempts++;
        final altIdx = Random().nextInt(characterList.length);
        if (altIdx == idx) continue; // si sale el mismo, buscamos otro
        final altItem = characterList[altIdx];
        if (altItem is Map<String, dynamic>) {
          final altChar = CharacterModel.fromJson(altItem);
          print('🔁 Reintento #$attempts - Personaje: ${altChar.name} - portrait_path: ${altChar.portraitPath ?? "NULL"}');
          if (altChar.portraitPath != null && altChar.portraitPath!.trim().isNotEmpty) {
            character = altChar;
            break;
          }
        }
      }

      print('✅ Selección final - Personaje: ${character.name} - portrait_path: ${character.portraitPath ?? "NULL"} (intentos: $attempts)');
      print('📋 Todos los datos: ${character.toJson()}');

      // Intentar resolver la imagen del personaje seleccionado antes de devolverlo.
      final portraitRaw = character.portraitPath?.trim();
      if (portraitRaw != null && portraitRaw.isNotEmpty) {
        try {
          final resolved = await _resolveImage(portraitRaw);
          if (resolved != null) {
            if (resolved.url != null) {
              character.portraitPath = resolved.url;
              print('✅ Imagen resuelta y actualizada como URL: ${resolved.url}');
              return character;
            } else if (resolved.bytes != null) {
              // No podemos almacenar bytes en el modelo; devolver personaje y UI usará _resolveImage otra vez para obtener bytes.
              print('✅ Imagen resuelta en bytes (se mostrará desde memoria)');
              return character;
            }
          }
        } catch (e) {
          print('❌ Error resolviendo imagen para personaje: $e');
        }
      }

      // Si no se ha podido resolver la imagen, intentar una API alternativa que ya provea URLs completas
      try {
        final alt = await _fetchAlternativeCharacter();
        if (alt != null) {
          print('🔁 Usando personaje de API alternativa como fallback: ${alt.name}');
          return alt;
        }
      } catch (e) {
        print('❌ Error llamando API alternativa: $e');
      }

      return character;
    } catch (e) {
      print('❌ Error en _fetchSimpsonsCharacter: $e');
      throw e.toString();
    }
  }

  // Llama a una API alternativa pública que devuelve personajes con URLs de imagen completas
  Future<CharacterModel?> _fetchAlternativeCharacter() async {
    try {
      final uri = Uri.parse('https://api.sampleapis.com/simpsons/characters');
      final resp = await http.get(uri).timeout(const Duration(seconds: 20));
      if (resp.statusCode != 200) {
        print('❌ API alternativa respondió con ${resp.statusCode}');
        return null;
      }
      final data = jsonDecode(resp.body);
      if (data is! List || data.isEmpty) return null;

      // Buscar un personaje que tenga campo de imagen
      final candidates = data.where((e) => e is Map<String, dynamic> && (e['image'] ?? e['imageUrl'] ?? e['image_url']) != null).toList();
      if (candidates.isEmpty) return null;
      final idx = Random().nextInt(candidates.length);
      final item = candidates[idx] as Map<String, dynamic>;
      final altChar = CharacterModel.fromJson(item);
      print('✅ API alternativa - personaje: ${altChar.name} - portrait_path: ${altChar.portraitPath}');
      return altChar;
    } catch (e) {
      print('❌ Error en _fetchAlternativeCharacter: $e');
      return null;
    }
  }

  // Comprueba si la URL de la imagen existe (intenta HEAD, hace GET como fallback)
  Future<bool> _imageExists(String url) async {
    try {
      final uri = Uri.parse(url);
      // Intentar HEAD primero
      try {
        final headers = {
          'User-Agent': 'Mozilla/5.0',
          'Referer': 'https://thesimpsonsapi.com',
          'Accept': 'image/*'
        };
        final headResp = await http.head(uri, headers: headers).timeout(const Duration(seconds: 8));
        print('🔁 HEAD $url -> ${headResp.statusCode}');
        print('    HEAD headers: ${headResp.headers}');
        if (headResp.statusCode == 200) {
          final ct = headResp.headers['content-type'] ?? '';
          return ct.startsWith('image');
        }
      } catch (_) {
        // Ignorar y hacer GET como fallback
      }
      final headers = {
        'User-Agent': 'Mozilla/5.0',
        'Referer': 'https://thesimpsonsapi.com',
        'Accept': 'image/*'
      };
      final resp = await http.get(uri, headers: headers).timeout(const Duration(seconds: 12));
      print('🔁 GET $url -> ${resp.statusCode}');
      print('    GET headers: ${resp.headers}');
      print('    bodyBytes: ${resp.bodyBytes.length}');
      if (resp.statusCode == 200 && resp.bodyBytes.isNotEmpty) {
        final ct = resp.headers['content-type'] ?? '';
        return ct.startsWith('image') || resp.bodyBytes.length > 0;
      }
      return false;
    } catch (e) {
      print('❌ Error comprobando imagen $url: $e');
      return false;
    }
  }

  // Genera una lista de URLs candidatas a partir del portraitPath
  List<String> _buildCandidateUrls(String portraitPath) {
    final path = portraitPath.startsWith('/') ? portraitPath : '/$portraitPath';
    final bases = <String>[
      'https://thesimpsonsapi.com',
      'https://thesimpsonsapi.com/api',
      'https://thesimpsonsapi.com/images',
      'https://thesimpsonsapi.com/static',
      'https://cdn.thesimpsonsapi.com'
    ];
    final candidates = <String>[];
    for (final b in bases) {
      candidates.add('$b$path');
    }
    return candidates;
  }

  // Busca la primera URL candidata que responda con una imagen válida
  Future<String?> _findWorkingImageUrl(String portraitPath) async {
    final candidates = _buildCandidateUrls(portraitPath);
    print('🔎 Probando URLs candidatas para portrait_path="$portraitPath"');
    for (final url in candidates) {
      try {
        print('➡ Probando: $url');
        final ok = await _imageExists(url);
        print('   Resultado: $ok');
        if (ok) return url;
      } catch (e) {
        print('   Error probando $url: $e');
      }
    }
    return null;
  }

  // Resultado posible de resolución de imagen: URL válida o bytes descargados
  

  // Intentar descargar bytes directamente de las URLs candidatas (fallback)
  Future<Uint8List?> _downloadImageBytes(String url) async {
    try {
      final uri = Uri.parse(url);
      final headers = {
        'User-Agent': 'Mozilla/5.0',
        'Referer': 'https://thesimpsonsapi.com',
        'Accept': 'image/*'
      };
      final resp = await http.get(uri, headers: headers).timeout(const Duration(seconds: 12));
      print('⬇ DOWNLOAD $url -> ${resp.statusCode}');
      print('    DOWNLOAD headers: ${resp.headers}');
      print('    DOWNLOAD bytes: ${resp.bodyBytes.length}');
      if (resp.statusCode == 200 && resp.bodyBytes.isNotEmpty) {
        final ct = resp.headers['content-type'] ?? '';
        if (ct.startsWith('image') || resp.bodyBytes.length > 10) {
          return resp.bodyBytes;
        }
      }
    } catch (e) {
      print('❌ Error descargando bytes de $url: $e');
    }
    return null;
  }

  // Resuelve la imagen: primero busca una URL válida, si no, intenta descargar bytes
  Future<_ImageResult?> _resolveImage(String portraitPath) async {
    try {
      final url = await _findWorkingImageUrl(portraitPath);
      if (url != null) return _ImageResult(url: url);

      // Si no hay URL que responda, intentar descargar bytes de las candidatas
      final candidates = _buildCandidateUrls(portraitPath);
      for (final c in candidates) {
        print('⬇ Intentando descargar bytes de: $c');
        final bytes = await _downloadImageBytes(c);
        if (bytes != null) {
          print('✅ Descarga exitosa desde: $c (bytes: ${bytes.length})');
          return _ImageResult(bytes: bytes);
        }
      }
      // Si todo falla, intentar a través de un proxy público de imágenes
      // (ej. images.weserv.nl) que puede evitar restricciones por Referer/ACL.
      for (final c in candidates) {
        try {
          final proxy = _buildWeservProxyUrl(c);
          print('🧭 Probando proxy de imagen: $proxy');
          final ok = await _imageExists(proxy);
          print('   Resultado proxy: $ok');
          if (ok) return _ImageResult(url: proxy);

          final bytes = await _downloadImageBytes(proxy);
          if (bytes != null) return _ImageResult(bytes: bytes);
        } catch (e) {
          print('   Error probando proxy para $c: $e');
        }
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
                            Icon(Icons.error, size: 36, color: Colors.red[700]),
                            const SizedBox(height: 8),
                            Text(msg,
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
                            child: FutureBuilder<_ImageResult?>(
                                    future: imageFuture,
                                    builder: (context, snapshotImgUrl) {
                                      // Debug: mostrar la URL candidata/bytes y estado de comprobación
                                      final candidateResult = snapshotImgUrl.data;
                                      print('🔗 Verificando imagen para ${c.name}: ${candidateResult?.url ?? (candidateResult?.bytes != null ? "[bytes]" : "NULL")} - estado: ${snapshotImgUrl.connectionState}');

                                      if (snapshotImgUrl.connectionState == ConnectionState.waiting) {
                                        return Container(
                                          height: 320,
                                          color: Colors.grey[200],
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.amber[700]!)),
                                              const SizedBox(height: 12),
                                              const Text('Comprobando imagen...', style: TextStyle(color: Colors.grey)),
                                            ],
                                          ),
                                        );
                                      }
                                      final result = snapshotImgUrl.data;
                                      print('🔍 Resultado comprobación imagen para ${c.name}: ${result?.url ?? (result?.bytes != null ? "[bytes]" : "NULL")}');

                                      if (result != null && result.url != null) {
                                        return Image.network(
                                          result.url!,
                                          height: 320,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              height: 320,
                                              color: Colors.grey[300],
                                              alignment: Alignment.center,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: const [
                                                  Icon(Icons.broken_image, size: 64, color: Colors.grey),
                                                  SizedBox(height: 10),
                                                  Text('Imagen no disponible', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      }

                                      if (result != null && result.bytes != null) {
                                        return Image.memory(
                                          result.bytes!,
                                          height: 320,
                                          fit: BoxFit.cover,
                                        );
                                      }

                                      // fallback: mostrar icono por defecto
                                      return Container(
                                        height: 320,
                                        color: Colors.grey[200],
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.person_outline, size: 88, color: Colors.grey),
                                            SizedBox(height: 8),
                                            Text('No hay retrato disponible', style: TextStyle(color: Colors.grey)),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),
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
