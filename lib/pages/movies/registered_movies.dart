import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:is_dpelicula/controllers/movie_controllers.dart';
import 'package:is_dpelicula/models/movie.dart';

class RegisteredMoviesPage extends ConsumerStatefulWidget {
  @override
  _RegisteredMoviesPageState createState() => _RegisteredMoviesPageState();
}

class _RegisteredMoviesPageState extends ConsumerState<RegisteredMoviesPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController titleFilterController = TextEditingController();
  final TextEditingController ratingFilterController = TextEditingController();
  final TextEditingController statusFilterController = TextEditingController();

  String filter = '';

  @override
  Widget build(BuildContext context) {
    final movieListAsyncValue = ref.watch(getAllMoviesProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
            bottomRight: Radius.circular(50.0),
          ),
          child: AppBar(
            backgroundColor: const Color(0xff1C1C27), // Azul oscuro
            centerTitle: true,
            title: Container(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Películas Registradas',
                style: TextStyle(
                  color: const Color(0xfff4b33c), // Naranja
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: MediaQuery.of(context).size.width > 800
            ? Center(
                child: SizedBox(
                    width: 800, child: _buildContent(movieListAsyncValue)),
              )
            : ListView(children: [_buildContent(movieListAsyncValue)]),
      ),
    );
  }

  Widget _buildContent(AsyncValue<List<Movie>> movieListAsyncValue) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: titleFilterController,
                  decoration: _inputDecoration('Buscar por título'),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: ratingFilterController,
                  decoration: _inputDecoration('Buscar por calificación'),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: statusFilterController,
                  decoration: _inputDecoration('Buscar por estado'),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  titleFilterController.clear();
                  ratingFilterController.clear();
                  statusFilterController.clear();
                  setState(() {});
                },
              ),
            ],
          ),
        ),
        Expanded(child: _buildMovieList(movieListAsyncValue)),
      ],
    );
  }

  InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Color(0xfff4b33c)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xfff4b33c)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xfff4b33c)),
      ),
    );
  }

  Widget _buildMovieList(AsyncValue<List<Movie>> movieListAsyncValue) {
    return movieListAsyncValue.when(
      data: (movies) {
        final filteredMovies = movies.where((movie) {
          bool matchesTitle = titleFilterController.text.isEmpty ||
              movie.title
                  .toLowerCase()
                  .contains(titleFilterController.text.toLowerCase());
          bool matchesRating = ratingFilterController.text.isEmpty ||
              movie.vote_average
                  .toString()
                  .contains(ratingFilterController.text);
          bool matchesStatus = statusFilterController.text.isEmpty ||
              movie.status
                  .toLowerCase()
                  .contains(statusFilterController.text.toLowerCase());
          return matchesTitle && matchesRating && matchesStatus;
        }).toList();

        return ListView.builder(
          itemCount: filteredMovies.length,
          itemBuilder: (context, index) {
            final movie = filteredMovies[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 100,
                          child: AspectRatio(
                            aspectRatio: 2 / 3,
                            child: Image.network(
                              movie.poster_path as String,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.title,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text('Calificación: ${movie.vote_average}',
                                  style: TextStyle(color: Colors.black)),
                              Text('Estado: ${movie.status}',
                                  style: TextStyle(color: Colors.black)),
                              Text('Descripción: ${movie.overview}',
                                  style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                _showEditMovieDialog(movie.id, movie);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _showDeleteConfirmationDialog(
                                    movie.id, movie.title);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  void _showEditMovieDialog(String movieId, Movie movieData) {
    final titleController = TextEditingController(text: movieData.title);
    final voteAverageController =
        TextEditingController(text: movieData.vote_average.toString());
    final statusController = TextEditingController(text: movieData.status);
    final overviewController = TextEditingController(text: movieData.overview);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar película', style: TextStyle(color: Colors.black)),
          content: Container(
            width: 400, // Define un ancho fijo para la ventana de edición
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                          labelText: 'Título',
                          labelStyle: TextStyle(color: Colors.black)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese un título';
                        }
                        return null;
                      },
                      style: TextStyle(color: Colors.black),
                    ),
                    TextFormField(
                      controller: voteAverageController,
                      decoration: InputDecoration(
                          labelText: 'Calificación',
                          labelStyle: TextStyle(color: Colors.black)),
                      style: TextStyle(color: Colors.black),
                    ),
                    TextFormField(
                      controller: statusController,
                      decoration: InputDecoration(
                          labelText: 'Estado',
                          labelStyle: TextStyle(color: Colors.black)),
                      style: TextStyle(color: Colors.black),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight:
                            200, // Limita la altura del campo de descripción
                      ),
                      child: TextFormField(
                        controller: overviewController,
                        decoration: InputDecoration(
                            labelText: 'Descripción',
                            labelStyle: TextStyle(color: Colors.black)),
                        style: TextStyle(color: Colors.black),
                        maxLines: null, // Permitir múltiples líneas
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancelar', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Guardar', style: TextStyle(color: Colors.black)),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  _updateMovie(
                      movieId,
                      titleController.text,
                      voteAverageController.text,
                      statusController.text,
                      overviewController.text);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateMovie(String movieId, String title, String voteAverage,
      String status, String overview) async {
    try {
      await FirebaseFirestore.instance
          .collection('movies')
          .doc(movieId)
          .update({
        'title': title,
        'voteAverage': double.parse(voteAverage),
        'status': status,
        'overview': overview,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Película actualizada con éxito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar la película: $e')),
      );
    }
  }

  void _showDeleteConfirmationDialog(String movieId, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación',
              style: TextStyle(color: Colors.black)),
          content: Text('¿Estás seguro de que deseas eliminar esta película?',
              style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              child: Text('Cancelar', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar', style: TextStyle(color: Colors.black)),
              onPressed: () {
                _deleteMovie(movieId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteMovie(String movieId) async {
    try {
      await FirebaseFirestore.instance
          .collection('movies')
          .doc(movieId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Película eliminada con éxito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar la película: $e')),
      );
    }
  }
}
