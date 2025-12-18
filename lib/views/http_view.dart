import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:switch_theme/models/character_model.dart';

class HttpView extends StatefulWidget {
  const HttpView({Key? key}) : super(key: key);

  @override
  State<HttpView> createState() => _HttpViewState();
}

class _HttpViewState extends State<HttpView> {
  final TextEditingController _characterIdController = TextEditingController();
  CharacterModel? _character;
  bool _isLoadingCharacter = false;
  String? _errorMessageCharacter;

  @override
  void initState() {
    super.initState();
    _characterIdController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _characterIdController.dispose();
    super.dispose();
  }

  Future<void> _searchCharacterById() async {
    final characterId = _characterIdController.text.trim();

    if (characterId.isEmpty) {
      setState(() {
        _errorMessageCharacter =
            '⚠️ Por favor ingresa un número de personaje (1-900)';
        _character = null;
      });
      return;
    }

    final id = int.tryParse(characterId);
    if (id == null) {
      setState(() {
        _errorMessageCharacter = '⚠️ Solo se permiten números';
        _character = null;
      });
      return;
    }

    if (id < 1 || id > 900) {
      setState(() {
        _errorMessageCharacter = '⚠️ El ID debe estar entre 1 y 900';
        _character = null;
      });
      return;
    }

    setState(() {
      _isLoadingCharacter = true;
      _errorMessageCharacter = null;
      _character = null;
    });

    try {
      final response = await http
          .get(Uri.parse('https://thesimpsonsapi.com/api/characters/$id'))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('⏱️ Tiempo de conexión agotado (10s)');
            },
          );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final character = CharacterModel.fromJson(jsonData);

        print('=== PERSONAJE ENCONTRADO ===');
        print('ID: ${character.id}');
        print('Nombre: ${character.name}');
        print('Portrait Path: ${character.portraitPath}');
        print('==========================');

        setState(() {
          _character = character;
          _errorMessageCharacter = null;
        });
      } else if (response.statusCode == 404) {
        setState(() {
          _errorMessageCharacter = '❌ No existe personaje con ID $id';
          _character = null;
        });
      } else {
        setState(() {
          _errorMessageCharacter =
              '❌ Error en la búsqueda (Código: ${response.statusCode})';
          _character = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessageCharacter = '❌ Error: ${e.toString()}';
        _character = null;
      });
    } finally {
      setState(() {
        _isLoadingCharacter = false;
      });
    }
  }

  // 🔴 FUNCIÓN PARA CONSTRUIR URL CORRECTA
  String _buildImageUrl(String portraitPath) {
    if (portraitPath.startsWith('http')) {
      return portraitPath;
    }

    String url =
        'https://thesimpsonsapi.com/api/characters/${_character!.id}/portrait.webp';

    print('🎯 URL construida: $url');
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[700],
        title: const Text(
          'Los Simpsons - Personajes',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_character != null) ...[
              Center(
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.amber[700]!, width: 5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child:
                        _character!.portraitPath != null &&
                            _character!.portraitPath!.isNotEmpty
                        ? Image.network(
                            _buildImageUrl(_character!.portraitPath!),
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.amber,
                                    ),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              print('❌ Error cargando imagen: $error');
                              return Container(
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.person,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.person,
                              size: 80,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                color: Colors.amber[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.amber[700]!, width: 2),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _character!.name ?? 'Desconocido',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 14),
                      if (_character!.age != null)
                        Text(
                          '👤 Edad: ${_character!.age}',
                          style: const TextStyle(color: Colors.black54),
                        ),
                      if (_character!.occupation != null &&
                          _character!.occupation!.isNotEmpty)
                        Text(
                          '💼 Ocupación: ${_character!.occupation}',
                          style: const TextStyle(color: Colors.black54),
                        ),
                      if (_character!.gender != null &&
                          _character!.gender!.isNotEmpty)
                        Text(
                          '⚧ Género: ${_character!.gender}',
                          style: const TextStyle(color: Colors.black54),
                        ),
                      if (_character!.description != null &&
                          _character!.description!.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        const Text(
                          '📝 Descripción:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.amber[200]!),
                          ),
                          child: Text(
                            _character!.description!,
                            style: const TextStyle(
                              color: Colors.black54,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ] else if (_isLoadingCharacter)
              Column(
                children: [
                  const SizedBox(height: 40),
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
                  const SizedBox(height: 40),
                ],
              )
            else
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 60,
                    color: Colors.grey,
                  ),
                ),
              ),
            Card(
              color: Colors.amber[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.amber[700]!, width: 2),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.search, color: Colors.amber[700], size: 28),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Buscar por ID',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _characterIdController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Ej: 1, 25, 100...',
                        labelText: 'ID del personaje (1-900)',
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.amber[700],
                        ),
                        suffixIcon: _characterIdController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.amber[700],
                                ),
                                onPressed: () => _characterIdController.clear(),
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.amber[700]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.amber[700]!,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _searchCharacterById(),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isLoadingCharacter
                            ? null
                            : _searchCharacterById,
                        icon: _isLoadingCharacter
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Icon(Icons.search),
                        label: Text(
                          _isLoadingCharacter ? 'Buscando...' : 'Buscar',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_errorMessageCharacter != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red[400]!, width: 2),
                ),
                child: Text(
                  _errorMessageCharacter!,
                  style: TextStyle(
                    color: Colors.red[800],
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
