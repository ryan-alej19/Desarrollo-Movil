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
  Future<CharacterModel>? _future;

  Future<CharacterModel> _fetchSimpsonsCharacter() async {
    try {
      // Usar la API CORRECTA de Simpsons que devuelve personajes válidos
      final response = await http
          .get(Uri.parse('https://thesimpsonsapi.com/api/characters'))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw 'Timeout: La solicitud tardó demasiado',
          );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        
        // DEBUG: Imprimir el JSON completo
        print('===== API RESPONSE =====');
        print('Response Type: ${jsonData.runtimeType}');
        if (jsonData is List) {
          print('Total personajes: ${jsonData.length}');
          if (jsonData.isNotEmpty) {
            print('Primer personaje: ${jsonData[0]}');
            // Seleccionar un personaje aleatorio
            final random = (DateTime.now().millisecondsSinceEpoch % jsonData.length).toInt();
            final selectedCharacter = jsonData[random];
            print('Personaje seleccionado (índice $random): $selectedCharacter');
            print('========================');
            return CharacterModel.fromJson(selectedCharacter);
          }
        }
        print('========================');
        throw 'No hay personajes disponibles';
      } else {
        throw 'Error ${response.statusCode}: No se pudo obtener los datos';
      }
    } catch (e) {
      print('Error Simpson API: ${e.toString()}');
      throw 'Error: ${e.toString()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HTTP View',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.teal[600],
        elevation: 5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // CONTAINER SUPERIOR CON INFO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal[600]!, width: 2),
              ),
              child: Column(
                children: [
                  Icon(Icons.person, size: 40, color: Colors.teal[600]),
                  const SizedBox(height: 10),
                  const Text(
                    '📺 Simpsons API',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Obtén información de personajes',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // BOTÓN QUE DISPARA LA PETICIÓN
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _future = _fetchSimpsonsCharacter();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                elevation: 5,
              ),
              icon: const Icon(Icons.download),
              label: const Text(
                'Cargar Personaje Simpson',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 40),

            // FUTUREBUILDER QUE CONTROLA EL _future
            if (_future != null)
              FutureBuilder<CharacterModel>(
                future: _future,
                builder: (context, snapshot) {
                  // ESTADO 1: CARGANDO
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.teal[600]!,
                            ),
                            strokeWidth: 5,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Cargando personaje...',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }

                  // ESTADO 2: ERROR
                  if (snapshot.hasError) {
                    return Card(
                      elevation: 5,
                      color: Colors.red[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.red[400]!, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Icon(Icons.error, color: Colors.red[700], size: 40),
                            const SizedBox(height: 10),
                            Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(
                                color: Colors.red[700],
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // ESTADO 3: DATOS CARGADOS
                  if (snapshot.hasData) {
                    final character = snapshot.data!;
                    return Column(
                      children: [
                        // CARD 1: NOMBRE DEL PERSONAJE
                        Card(
                          elevation: 5,
                          color: Colors.teal[50],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Colors.teal[600]!,
                              width: 2,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 30,
                                  color: Colors.teal[600],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Personaje:',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.teal[600],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  character.name ?? 'Desconocido',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Edad: ${character.age ?? 'N/A'}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.teal[600],
                                  ),
                                ),
                                Text(
                                  'Ocupación: ${character.occupation ?? 'N/A'}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.teal[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // CARD 2: DESCRIPCIÓN
                        Card(
                          elevation: 5,
                          color: Colors.teal[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Colors.teal[600]!,
                              width: 2,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.description,
                                      color: Colors.teal[600],
                                      size: 24,
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'Descripción:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  character.description ?? 'Sin descripción',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // CARD 3: IMAGEN CON MEJOR MANEJO DE ERRORES
                        if (character.portraitPath != null && character.portraitPath!.isNotEmpty)
                          Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                character.portraitPath!,
                                height: 350,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Container(
                                    height: 350,
                                    color: Colors.grey[200],
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            Colors.teal[600]!,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const Text('Cargando imagen...'),
                                      ],
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  print('Error cargando imagen: $error');
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
                          )
                        else
                          Card(
                            elevation: 5,
                            color: Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              height: 350,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Imagen no disponible para este personaje',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(height: 30),
                      ],
                    );
                  }

                  // ESTADO 4: SIN DATOS
                  return const Center(child: Text('Sin datos disponibles'));
                },
              ),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
