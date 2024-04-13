import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:is_dpelicula/cubit/movies_cubit.dart';
import 'package:is_dpelicula/models/movie.dart';
import 'package:is_dpelicula/services/movie_services.dart';
import 'package:is_dpelicula/widgets/category_card.dart';
import 'package:is_dpelicula/widgets/loading_spinner.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');
    bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1C1C27),
        title: Text(
          "Dpelicula",
          style: TextStyle(color: Colors.white),
        ),
        leading: isDesktop
            ? null
            : Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.menu, color: Colors.white),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
        actions: <Widget>[
          if (isDesktop) ...[
            TextButton(
              onPressed: () => context.goNamed('home'),
              child: Text("Inicio", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () => context.goNamed('aboutUs'),
              child: Text("Nosotros", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () => context.goNamed('contact'),
              child: Text("Contáctanos", style: TextStyle(color: Colors.white)),
            ),
          ],
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                // Implementar acción de búsqueda
              },
            ),
          ),
          if (user != null) ...[
            FutureBuilder<DocumentSnapshot>(
              future: users.doc(user.uid).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  return CircleAvatar(
                    backgroundImage: NetworkImage(
                        data['image_url'] ?? './assets/img/profile.jpg'),
                    radius: 24,
                  );
                } else {
                  return const CircleAvatar(
                    backgroundImage: AssetImage('./assets/img/profile.jpg'),
                    radius: 24,
                  );
                }
              },
            ),
            PopupMenuButton<int>(
              onSelected: (value) {
                switch (value) {
                  case 0:
                    context.goNamed('home');
                    break;
                  case 1:
                    context.goNamed('history');
                    break;
                  case 2:
                    context.goNamed('profile');
                    break;
                  case 3:
                    FirebaseAuth.instance
                        .signOut()
                        .then((_) => context.goNamed('login'));
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem<int>(value: 0, child: Text('Home')),
                const PopupMenuItem<int>(value: 1, child: Text('History')),
                const PopupMenuItem<int>(value: 2, child: Text('Profile')),
                const PopupMenuItem<int>(value: 3, child: Text('Logout')),
              ],
            ),
          ] else ...[
            TextButton(
              onPressed: () => context.goNamed('login'),
              child: Text("Login", style: TextStyle(color: Colors.white)),
            )
          ],
        ],
      ),
      drawer: !isDesktop
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: Colors.blue),
                    child: Text('Menú',
                        style: TextStyle(color: Colors.white, fontSize: 24)),
                  ),
                  ListTile(
                    title: const Text('Inicio'),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.goNamed('home');
                    },
                  ),
                  ListTile(
                    title: const Text('Nosotros'),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.goNamed('aboutUs');
                    },
                  ),
                  ListTile(
                    title: const Text('Contáctanos'),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.goNamed('contact');
                    },
                  ),
                ],
              ),
            )
          : null,
      body: BlocBuilder<MoviesCubit, MoviesState>(
        builder: (context, state) {
          return SafeArea(
              child: ListView(
            children: [
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (isDesktop)
                          PopupMenuButton<String>(
                            onSelected: (String result) {
                              // Handle category selection
                            },
                            child: Text(
                              "Categorías",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).primaryColor),
                            ),
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'Romance',
                                child: Text('Romance'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Horror',
                                child: Text('Horror'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Comedia',
                                child: Text('Comedia'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Sci-fi',
                                child: Text('Sci-fi'),
                              ),
                            ],
                          ),
                        TextButton(
                            onPressed: () {},
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Ver Todo",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      letterSpacing: 0.3,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right_sharp,
                                  color: Theme.of(context).primaryColor,
                                  size: 22,
                                )
                              ],
                            )),
                      ],
                    ),
                    if (!isDesktop)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          CategoryCard(emoji: '🥰', text: 'Romance'),
                          CategoryCard(emoji: '😨', text: 'Horror'),
                          CategoryCard(emoji: '😆', text: 'Comedia'),
                          CategoryCard(emoji: '👽', text: 'Sci-fi'),
                        ],
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Now Playing",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 300,
                child: FutureBuilder(
                    future: MovieServices().getListMovieData(1),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Movie> listMovies = snapshot.data as List<Movie>;
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 24),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 200,
                              height: 300,
                              margin: const EdgeInsets.only(right: 24),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: () {
                                  BlocProvider.of<MoviesCubit>(context)
                                      .getSelectedMovie(listMovies[index]);

                                  context.goNamed('detail', pathParameters: {
                                    'id': '${listMovies[index].id}'
                                  });
                                },
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.network(
                                        'https://image.tmdb.org/t/p/w200${listMovies[index].poster_path}')),
                              ),
                            );
                          },
                        );
                      } else {
                        return const LoadingSpinner();
                      }
                    }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(height: 50),
                      Text(
                        "Proximamente",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ]),
              ),
              FutureBuilder(
                future: MovieServices().getComingSoonMovie(1),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Movie> listMovies = snapshot.data as List<Movie>;
                    return CarouselSlider.builder(
                        itemCount: listMovies.length,
                        itemBuilder: (context, index, realIndex) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        'https://image.tmdb.org/t/p/w400${listMovies[index].backdrop_path}'),
                                    fit: BoxFit.cover)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.4)),
                                  child: Text(
                                    listMovies[index].title,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                                const SizedBox(height: 10)
                              ],
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: 400,
                          initialPage: 0,
                          aspectRatio: 16 / 9,
                          viewportFraction: 0.8,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.2,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 1000),
                          autoPlayCurve: Curves.fastOutSlowIn,
                        ));
                  } else {
                    return const LoadingSpinner();
                  }
                },
              ),
              SizedBox(
                height: 60,
              ),
            ],
          ));
        },
      ),
    );
  }
}
