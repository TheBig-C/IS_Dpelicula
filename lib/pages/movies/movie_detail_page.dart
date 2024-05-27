import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:is_dpelicula/controllers/movie_controllers.dart';
import 'package:is_dpelicula/models/movie.dart';
import 'package:is_dpelicula/widgets/custom_app_bar.dart';
import 'package:is_dpelicula/widgets/desktop_footer.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailPage extends ConsumerWidget {
  final String movieId;

  const MovieDetailPage({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    final movieFuture = ref.watch(movieProvider(movieId));

    return Scaffold(
      appBar: CustomAppBar(isDesktop: isDesktop),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildMovieDetail(context, ref, movieFuture),
                const SizedBox(height: 30),
                if (isDesktop) const DesktopFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMovieDetail(BuildContext context, WidgetRef ref, AsyncValue<Movie> movieFuture) {
    return movieFuture.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (movie) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: _loadImageWidget(movie.posterPath as String, 600, BoxFit.cover),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información de la Película',
                      style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    _buildDetailedInfo(movie),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: _loadImageWidget('${movie.backdropPath}', 500, BoxFit.cover),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _loadImageWidget(String imageUrl, double height, BoxFit fit) {
    return Container(
      height: height,
      alignment: Alignment.center,
      child: isFirebaseUrl(imageUrl)
        ? FutureBuilder<Uint8List>(
            future: _loadFirebaseImage(imageUrl),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Image.memory(
                    snapshot.data!,
                    fit: fit,
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
              }
              return const CircularProgressIndicator();
            },
          )
        : Image.network(
            imageUrl,
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              return Center(child: Text('Error loading image'));
            },
          ),
    );
  }

  bool isFirebaseUrl(String url) {
    return url.contains('firebasestorage.googleapis.com');
  }

  Future<Uint8List> _loadFirebaseImage(String path) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(path);
      final bytes = await ref.getData();
      if (bytes != null) {
        print('Image loaded successfully: $path');
        return bytes;
      } else {
        throw Exception('No data found at path: $path');
      }
    } catch (e) {
      print('Error loading image from Firebase: $e');
      throw Exception('Error loading image from Firebase: $e');
    }
  }

  Widget _buildDetailedInfo(Movie movie) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(movie.title, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.purple)),
            Text('Rating: ${movie.voteAverage}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
            const Text(
              'Descripción',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Text(
              movie.overview,
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8.0,
              children: movie.genres!.map((genre) => Chip(label: Text(genre, style: const TextStyle(color: Colors.black)))).toList(),
            ),
            const SizedBox(height: 20),
            Text(
              'Director(s): ${movie.directorNames.join(', ')}',
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
            const SizedBox(height: 20),
            Text(
              'Actores principales: ${movie.leadActors.join(', ')}',
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

final movieProvider = FutureProvider.family<Movie, String>((ref, id) {
  final movieController = ref.read(movieControllerProvider.notifier);
  return movieController.getMovieById(id);
});
