import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:is_dpelicula/controllers/room_controllers.dart';
import 'package:is_dpelicula/models/functionCine.dart';
import 'package:is_dpelicula/models/movie.dart';
import 'package:is_dpelicula/models/room.dart';
import 'package:is_dpelicula/pages/tickets/TicketPurchasePage.dart';
import 'package:is_dpelicula/widgets/custom_app_bar.dart';
import 'package:is_dpelicula/widgets/desktop_footer.dart';

class FunctionDetailsPage extends ConsumerWidget {
  final FunctionCine function;
  final Movie movie;

  FunctionDetailsPage({required this.function, required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: CustomAppBar(isDesktop: isDesktop),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detalles de la Función',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 20),
                _buildFunctionDetail(context, ref),
                const SizedBox(height: 30),
                if (isDesktop) const DesktopFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFunctionDetail(BuildContext context, WidgetRef ref) {
    final roomAsyncValue = ref.watch(roomControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: _loadImageWidget(
                  movie.poster_path as String, 600, BoxFit.cover),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Información de la Película y Función',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailedInfo(context, movie, function, ref),
                ],
              ),
            ),
          ],
        ),
      ],
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

  Widget _buildDetailedInfo(BuildContext context, Movie movie, FunctionCine function, WidgetRef ref) {
    final roomAsyncValue = ref.watch(roomControllerProvider);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(movie.title,
                style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple)),
            Text('Rating: ${movie.vote_average}',
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const Text(
              'Descripción',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              movie.overview,
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8.0,
              children: movie.genres!
                  .map((genre) => Chip(
                      label: Text(genre,
                          style: const TextStyle(color: Colors.black))))
                  .toList(),
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
            const SizedBox(height: 20),
            Text('Información de la Función',
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 20),
            Text('Hora de inicio: ${function.startTime}',
                style: const TextStyle(fontSize: 18, color: Colors.black)),
            Text('Hora de fin: ${function.endTime}',
                style: const TextStyle(fontSize: 18, color: Colors.black)),
            Text('Precio: \$${function.price}',
                style: const TextStyle(fontSize: 18, color: Colors.black)),
            roomAsyncValue.when(
              data: (rooms) {
                final room = rooms.firstWhere((room) => room.id == function.roomId);
                return Text('Sala: ${room.name}',
                    style: const TextStyle(fontSize: 18, color: Colors.black));
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) => Text('Error: $error'),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TicketPurchasePage(function: function, movie: movie)),
                  );
                },
                child: Text('Comprar Ticket'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: Colors.amber, // Color del texto
                  textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
