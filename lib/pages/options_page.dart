import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:is_dpelicula/controllers/movie_controllers.dart';
import 'package:is_dpelicula/widgets/custom_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:is_dpelicula/models/movie.dart';

class OptionsPage extends StatefulWidget {
  @override
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  bool isAdmin = false;
  String selectedPage = 'home';

  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  Future<void> _checkRole() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var docSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (docSnapshot.exists && docSnapshot.data()?['role'] == 'admin') {
        setState(() {
          isAdmin = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    return Scaffold(
      appBar: CustomAppBar(isDesktop: isDesktop),
      body: Row(
        children: [
          Container(
            width: isDesktop ? 300 : 0,
            child: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  _buildDrawerItem(Icons.home, 'Inicio', () => setState(() { selectedPage = 'home'; })),
                  _buildDrawerItem(Icons.history, 'Historial', () => setState(() { selectedPage = 'history'; })),
                  _buildDrawerItem(Icons.account_circle, 'Perfil', () => setState(() { selectedPage = 'profile'; })),
                  _buildDrawerItem(Icons.exit_to_app, 'Cerrar sesión', () {
                    FirebaseAuth.instance.signOut().then((_) => context.goNamed('login'));
                  }),
                  if (isAdmin) _buildDrawerItem(Icons.person_add, 'Registrar Empleado', () => setState(() { selectedPage = 'registerEmployee'; })),
                  if (isAdmin) _buildDrawerItem(Icons.movie, 'Registrar Película', () => setState(() { selectedPage = 'registerMovie'; })),
                  if (isAdmin) _buildDrawerItem(Icons.list, 'Ver Películas', () => setState(() { selectedPage = 'registeredMovies'; })),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Center(
                child: _getPageContent(selectedPage),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _getPageContent(String page) {
    switch (page) {
      case 'registeredMovies':
        return RegisteredMoviesPage();
      case 'home':
      case 'history':
      case 'profile':
      case 'registerEmployee':
      case 'registerMovie':
      default:
        return Text('Contenido principal aquí');
    }
  }
}

class RegisteredMoviesPage extends ConsumerStatefulWidget {
  @override
  _RegisteredMoviesPageState createState() => _RegisteredMoviesPageState();
}

class _RegisteredMoviesPageState extends ConsumerState<RegisteredMoviesPage> {
  String filter = '';

  @override
  Widget build(BuildContext context) {
    final movieListAsyncValue = ref.watch(getAllMoviesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Películas Registradas'),
      ),
      body: movieListAsyncValue.when(
        data: (movies) {
          final filteredMovies = movies.where((movie) {
            return movie.title.toLowerCase().contains(filter.toLowerCase());
          }).toList();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Buscar por título',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      filter = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredMovies.length,
                  itemBuilder: (context, index) {
                    final movie = filteredMovies[index];
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(20),
                        leading: AspectRatio(
                          aspectRatio: 2 / 3,
                          child: Image.network(
                            movie.posterPath,
                            fit: BoxFit.cover, // Aseguramos que la imagen cubra todo el espacio sin recortes
                          ),
                        ),
                        title: Text(movie.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Calificación: ${movie.voteAverage}'),
                            Text('Estado: ${movie.status}'),
                            Text('Descripción: ${movie.overview}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
