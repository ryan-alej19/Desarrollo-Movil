import 'package:flutter/material.dart';

class EpisodeCard extends StatelessWidget {
  final String name;
  final String image;
  final int season;
  final int episode;

  const EpisodeCard({
    super.key,
    required this.name,
    required this.image,
    required this.season,
    required this.episode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            image,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: 60,
                height: 60,
                color: Colors.grey.shade200,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              print('❌ Error cargando imagen episodio: $error');
              return Container(
                width: 60,
                height: 60,
                color: Colors.blue.shade100,
                child: const Icon(Icons.tv, size: 30, color: Colors.blue),
              );
            },
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Temporada $season - Episodio $episode'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Acción al tocar el episodio
          print('📺 Episodio seleccionado: $name');
        },
      ),
    );
  }
}
