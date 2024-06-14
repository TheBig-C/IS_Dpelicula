import 'package:carousel_slider/carousel_slider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:is_dpelicula/controllers/function_controller.dart';
import 'package:is_dpelicula/controllers/movie_controllers.dart';
import 'package:is_dpelicula/models/functionCine.dart';
import 'package:is_dpelicula/models/movie.dart';
import 'package:is_dpelicula/widgets/custom_app_bar.dart';
import 'package:is_dpelicula/widgets/desktop_footer.dart';
import 'package:is_dpelicula/widgets/inactivity_handler.dart';
import 'package:is_dpelicula/widgets/loading_spinner.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return InactivityHandler(
      child: Scaffold(
        appBar: CustomAppBar(isDesktop: isDesktop),
        drawer: !isDesktop ? _buildDrawer(context) : null,
        body: SafeArea(
          child: ListView(
            children: [
              _buildBanner(context),
              const SizedBox(height: 30),
              _buildContent(context, ref),
              const SizedBox(height: 30),
              _buildFunctionsInBillboardCarousel(context, ref),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Peliculas en estreno:",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),
              _buildNowPlayingMoviesSection(context, ref),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Próximas películas a estrenarse",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),
              _buildComingSoonMoviesSection(ref),
              const SizedBox(height: 30),
              
              
              _buildFunctionsByFunctionTypeCarousel(context, ref),
              const SizedBox(height: 30),
              if (isDesktop) const DesktopFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage("https://th.bing.com/th/id/R.cde6a7cfb6f085bc4e55286d6731f877?rik=9TffBuibVgxpWQ&pid=ImgRaw&r=0"),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 50,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(
                " Donde las historias cobran vida... ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 60,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  shadows: [
                    Shadow(
                      blurRadius: 15.0,
                      color: Colors.black.withOpacity(0.7),
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFunctionsCarousel(BuildContext context, List<FunctionCine> functions, List<Movie> movies, String title) {
  final validFunctions = functions.where((function) {
    return movies.any((movie) => movie.id == function.movieId);
  }).toList();

  if (validFunctions.isEmpty) {
    return Center(child: Text('No hay funciones disponibles'));
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          title,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      const SizedBox(height: 20),
      CarouselSlider.builder(
        itemCount: validFunctions.length,
        itemBuilder: (context, index, realIndex) {
          final function = validFunctions[index];
          final movie = movies.firstWhere((movie) => movie.id == function.movieId);

          return GestureDetector(
            onTap: () {
              context.push('/function/${function.id}');
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(
                        movie.poster_path ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey,
                            child: Icon(Icons.error, color: Colors.red, size: 50),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.title,
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${function.startTime.toLocal()} - ${function.endTime.toLocal()}',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ' ${function.type}',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        options: CarouselOptions(
          height: 650,
          initialPage: 0,
          viewportFraction: 0.4,
          enlargeCenterPage: true,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 1000),
          autoPlayCurve: Curves.fastOutSlowIn,
        ),
      ),
    ],
  );
}

  Widget _buildFunctionsInBillboardCarousel(BuildContext context, WidgetRef ref) {
    final functionCineState = ref.watch(functionCineControllerProvider);
    final moviesAsyncValue = ref.watch(allMoviesProviderFuture);

    return functionCineState.when(
      data: (functions) {
        final sortedFunctions = functions.toList();
        return moviesAsyncValue.when(
          data: (movies) => _buildFunctionsCarousel(context, sortedFunctions, movies, "Funciones en Cartelera"),
          loading: () => Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildFunctionsByRoomTypeCarousel(BuildContext context, WidgetRef ref) {
    final functionCineState = ref.watch(functionCineControllerProvider);
    final moviesAsyncValue = ref.watch(allMoviesProviderFuture);

    return functionCineState.when(
      data: (functions) {
        final roomTypes = functions.map((function) => function.type).toSet().toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: roomTypes.map((roomType) {
            final functionsByRoomType = functions.where((function) => function.type == roomType).toList();
            return moviesAsyncValue.when(
              data: (movies) => _buildFunctionsCarousel(context, functionsByRoomType, movies, "Funciones por tipo de sala: $roomType"),
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(child: Text('Error: $error')),
            );
          }).toList(),
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildFunctionsByFunctionTypeCarousel(BuildContext context, WidgetRef ref) {
    final functionCineState = ref.watch(functionCineControllerProvider);
    final moviesAsyncValue = ref.watch(allMoviesProviderFuture);

    return functionCineState.when(
      data: (functions) {
        final functionTypes = functions.map((function) => function.type).toSet().toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: functionTypes.map((type) {
            final functionsByType = functions.where((function) => function.type == type).toList();
            return moviesAsyncValue.when(
              data: (movies) => _buildFunctionsCarousel(context, functionsByType, movies, "Funciones por tipo de función: $type"),
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(child: Text('Error: $error')),
            );
          }).toList(),
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildMissionVisionSection(BuildContext context) {
    bool isWideScreen = MediaQuery.of(context).size.width > 800;

    return Wrap(
      spacing: 20,
      runSpacing: 20,
      alignment: WrapAlignment.center,
      children: [
        _buildMissionCard(context, isWideScreen),
        _buildVisionCard(context, isWideScreen),
      ],
    );
  }

  Widget _buildMissionCard(BuildContext context, bool isWideScreen) {
    return FlipCard(
      direction: FlipDirection.HORIZONTAL,
      front: Card(
        color: Colors.red,
        child: Container(
          width: isWideScreen ? 300 : MediaQuery.of(context).size.width * 0.9,
          height: 200,
          alignment: Alignment.center,
          child: Text(
            "Misión",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
      back: Card(
        color: Colors.red[800],
        child: Container(
          width: isWideScreen ? 300 : MediaQuery.of(context).size.width * 0.9,
          height: 200,
          padding: EdgeInsets.all(20),
          child: Text(
            "Nuestra misión es brindar una experiencia cinematográfica inigualable para toda la familia. Nos esforzamos por ser mucho más que un lugar para ver películas; somos un espacio donde los sueños cobran vida, donde las risas, los susurros y los aplausos se entrelazan para crear recuerdos inolvidables. Ofrecemos ambientes confortables llenos de luz y color, con un personal capacitado y preparado para otorgar un servicio de calidad.",
            style: TextStyle(fontSize: 18, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildVisionCard(BuildContext context, bool isWideScreen) {
    return FlipCard(
      direction: FlipDirection.HORIZONTAL,
      front: Card(
        color: Colors.blue,
        child: Container(
          width: isWideScreen ? 300 : MediaQuery.of(context).size.width * 0.9,
          height: 200,
          alignment: Alignment.center,
          child: Text(
            "Visión",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
      back: Card(
        color: Colors.blue[800],
        child: Container(
          width: isWideScreen ? 300 : MediaQuery.of(context).size.width * 0.9,
          height: 200,
          padding: EdgeInsets.all(20),
          child: Text(
            "Nos visualizamos como el líder en entretenimiento cinematográfico en Bolivia, reconocidos por nuestras instalaciones de vanguardia equipadas con la última tecnología audiovisual. Valoramos la importancia de la familia y la comunidad, por lo que nos esforzamos por crear un ambiente acogedor y seguro donde todos nuestros usuarios puedan disfrutar de nuevas experiencias de forma segura. En Multicine, no sólo proyectamos películas; creamos experiencias memorables que perduran en el corazón de quienes nos eligen.",
            style: TextStyle(fontSize: 18, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: const Text('Menú', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(title: const Text('Inicio'), onTap: () => context.pop()),
          ListTile(title: const Text('Nosotros'), onTap: () => context.goNamed('aboutUs')),
          ListTile(title: const Text('Contáctanos'), onTap: () => context.goNamed('contact')),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PopupMenuButton<String>(
          onSelected: (String result) {}, // Handle category selection
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(value: 'Romance', child: Text('Romance')),
            const PopupMenuItem<String>(value: 'Horror', child: Text('Horror')),
            const PopupMenuItem<String>(value: 'Comedia', child: Text('Comedia')),
            const PopupMenuItem<String>(value: 'Sci-fi', child: Text('Sci-fi')),
          ],
          child: Text(
            "Categorías",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Theme.of(context).primaryColor),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Row(
            children: [
              Text(
                "Ver Todo",
                style: TextStyle(color: Theme.of(context).primaryColor, letterSpacing: 0.3, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 10),
              Icon(Icons.keyboard_arrow_right_sharp, color: Theme.of(context).primaryColor, size: 22),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNowPlayingMoviesSection(BuildContext context, WidgetRef ref) {
    final moviesAsyncValue = ref.watch(allMoviesProviderFuture);
    return moviesAsyncValue.when(
      data: (listMovies) {
        final nowPlayingMovies = listMovies.where((movie) => movie.status == "en cartelera").toList();
        return _buildNowPlayingCarousel(context, nowPlayingMovies);
      },
      loading: () => const LoadingSpinner(),
      error: (e, _) => Text('Error: $e'),
    );
  }

  Widget _buildComingSoonMoviesSection(WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(movieControllerProvider.notifier).getComingSoonMovies(),
      builder: (context, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingSpinner();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return _buildComingSoonCarousel(snapshot.data!);
        } else {
          return const Text('No hay próximas películas');
        }
      },
    );
  }

  Widget _buildNowPlayingCarousel(BuildContext context, List<Movie> movies) {
    if (movies.isEmpty) {
      return Center(child: Text('No hay películas disponibles'));
    }

    return CarouselSlider.builder(
      itemCount: movies.length,
      itemBuilder: (context, index, realIndex) {
        final movie = movies[index];
        return GestureDetector(
          onTap: () {
            context.push('/movie/${movie.id}');
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                movie.poster_path ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey,
                    child: Icon(Icons.error, color: Colors.red, size: 50),
                  );
                },
              ),
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: 650,
        initialPage: 0,
        viewportFraction: 0.7, // Ajusta este valor para hacer que los pósters sean más grandes
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 1000),
        autoPlayCurve: Curves.fastOutSlowIn,
        disableCenter: true,
      ),
    );
  }

  Widget _buildComingSoonCarousel(List<Movie> movies) {
    if (movies.isEmpty) {
      return Center(child: Text('No hay próximas películas'));
    }

    return CarouselSlider.builder(
      itemCount: movies.length,
      itemBuilder: (context, index, realIndex) {
        final movie = movies[index];
        return GestureDetector(
          onTap: () {
            context.push('/movie/${movie.id}');
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(movie.backdrop_path ?? ''),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: 650,
        initialPage: 0,
        viewportFraction: 0.7,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 1000),
        autoPlayCurve: Curves.fastOutSlowIn,
      ),
    );
  }
}
