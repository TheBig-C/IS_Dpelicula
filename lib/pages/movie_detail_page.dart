import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
              flex: 3,
              child: Image.network(movie.posterPath, height: 400),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 7,
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
        // Agregar la imagen backdrop_path aquí
 Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            
          ),
          child: Image.network(
            '${movie.backdropPath}',
            height: 500, // Establecer el tamaño deseado de la imagen
            fit: BoxFit.cover, // Ajustar la imagen para cubrir el contenedor
          ),
        ),        const SizedBox(height: 30),
      ],
    ),
  );
}


  Widget _buildDetailedInfo(Movie movie) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(movie.title, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.purple) ),
                Text('Rating: ${movie.voteAverage}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.black),),
            Text(
              'Descripción',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Text(
              movie.overview,
              style: TextStyle(fontSize: 18,  color: Colors.black),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8.0,
              children: movie.genres!.map((genre) => Chip(label: Text(genre, style: TextStyle(color: Colors.black)))).toList(),
            ),
            const SizedBox(height: 20),
            Text(
              'Director(s): ${movie.directorNames.join(', ')}',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            const SizedBox(height: 20),
            Text(
              'Actores principales: ${movie.leadActors.join(', ')}',
              style: TextStyle(fontSize: 18, color: Colors.black),
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
