import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EpisodiosListView extends StatefulWidget {
  const EpisodiosListView({super.key});

  @override
  State<EpisodiosListView> createState() => _EpisodiosListViewState();
}

class _EpisodiosListViewState extends State<EpisodiosListView> {
  List<Map<String, dynamic>> _episodes = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchEpisodes(page: 1);
  }

  Future<void> _fetchEpisodes({required int page}) async {
    if (page < 1) page = 1;
    if (page > _totalPages && _totalPages > 0) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http
          .get(Uri.parse('https://thesimpsonsapi.com/api/episodes?page=$page'))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('⏱️ Tiempo de conexión agotado');
            },
          );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData is Map<String, dynamic> &&
            jsonData['results'] is List &&
            jsonData['pages'] is int) {
          final episodes = List<Map<String, dynamic>>.from(jsonData['results']);

          debugPrint('=== PÁGINA $page DE EPISODIOS ===');
          debugPrint('Total episodios cargados: ${episodes.length}');
          for (var ep in episodes) {
            debugPrint('- S${ep['season']}E${ep['episode_number']}: ${ep['name']}');
            debugPrint('  Image Path: ${ep['image_path']}');
          }
          debugPrint('==========================');

          setState(() {
            _episodes = episodes;
            _currentPage = page;
            _totalPages = jsonData['pages'] ?? 1;
            _errorMessage = null;
          });
        } else {
          throw Exception('Formato de respuesta inválido');
        }
      } else {
        throw Exception('Error ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error en _fetchEpisodes: $e');
      setState(() {
        _errorMessage = '❌ Error al cargar episodios: $e';
        _episodes = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // ✅ FUNCIÓN CORREGIDA - USA CDN CORRECTO
  String _buildEpisodeImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) {
      return imagePath;
    }

    // ✅ Usar el CDN correcto con tamaño 500
    String url = 'https://cdn.thesimpsonsapi.com/500$imagePath';
    debugPrint('🎯 URL Episodio CDN: $url');
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: const Text(
          'Los Simpsons - Episodios',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.blue[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.blue[700]!, width: 2),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.tv, color: Colors.blue[700], size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Episodios (Página $_currentPage/$_totalPages)',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total de episodios: ${_totalPages * 20}',
                      style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red[400]!, width: 2),
                ),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red[800], fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            if (_isLoading)
              Column(
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.blue[700]),
                  ),
                  const SizedBox(height: 12),
                  const Text('Cargando episodios...'),
                ],
              ),
            if (!_isLoading && _episodes.isNotEmpty) ...[
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _episodes.length,
                itemBuilder: (context, index) {
                  final episode = _episodes[index];
                  final episodeName = episode['name'] ?? 'Sin título';
                  final seasonNum = episode['season'] ?? 'N/A';
                  final episodeNum = episode['episode_number'] ?? 'N/A';
                  final airdate = episode['airdate'] ?? 'N/A';
                  final synopsis = episode['synopsis'] ?? '';
                  final imagePath = episode['image_path'];

                  return Card(
                    color: Colors.blue[50],
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.blue[200]!),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue[700],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'S${seasonNum}E$episodeNum',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            episodeName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: Colors.blue[700],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '📅 $airdate',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          if (synopsis.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blue[200]!),
                              ),
                              child: Text(
                                synopsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                  height: 1.4,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                          if (imagePath != null && imagePath.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                _buildEpisodeImageUrl(imagePath),
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return Container(
                                    height: 150,
                                    color: Colors.grey[200],
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                          Colors.blue[700]!,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  debugPrint(
                                    '❌ Error cargando imagen episodio: $error',
                                  );
                                  return Container(
                                    height: 150,
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey,
                                        size: 40,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _currentPage > 1
                          ? () => _fetchEpisodes(page: _currentPage - 1)
                          : null,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('◀ Anterior'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[300],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _currentPage < _totalPages
                          ? () => _fetchEpisodes(page: _currentPage + 1)
                          : null,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Siguiente ▶'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[300],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
