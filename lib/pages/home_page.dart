import 'package:carousel_slider/carousel_slider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:is_dpelicula/controllers/movie_controllers.dart';
import 'package:is_dpelicula/models/movie.dart';
import 'package:is_dpelicula/widgets/category_card.dart';
import 'package:is_dpelicula/widgets/custom_app_bar.dart';
import 'package:is_dpelicula/widgets/desktop_footer.dart';
import 'package:is_dpelicula/widgets/inactivity_handler.dart';
import 'package:is_dpelicula/widgets/loading_spinner.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return InactivityHandler( // Envuelve Scaffold con InactivityHandler
      child: Scaffold(
      appBar: CustomAppBar(isDesktop: isDesktop),
      drawer: !isDesktop ? _buildDrawer(context) : null,
      body: SafeArea(
        child: ListView(
          children: [
            _buildBanner(context), // Banner actualizado
            const SizedBox(height: 30),
            _buildContent(context, ref),
                        const SizedBox(height: 30),

            _buildNowPlayingMoviesSection(context, ref),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("Próximas películas a estrenarse", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
                        const SizedBox(height: 30),

            _buildComingSoonMoviesSection(ref),
                        const SizedBox(height: 30),

            const SizedBox(height: 30),

            if (isDesktop) const DesktopFooter(),
          ],
        ),
      ),
    ),);
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
                fontSize: 60,  // Tamaño aumentado
                fontWeight: FontWeight.w900,  // Hace el texto más grueso
                fontStyle: FontStyle.italic,  // Estilo itálico
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
Widget _buildMissionVisionSection(BuildContext context) {
  bool isWideScreen = MediaQuery.of(context).size.width > 800;

  return Wrap(
    spacing: 20, // Espacio horizontal entre las tarjetas
    runSpacing: 20, // Espacio vertical entre las tarjetas
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
        children: [
          _buildCategories(context),
          const SizedBox(height: 20),
          const Text("Cartelera", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
          const SizedBox(height: 20),
        ],
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
      // Filtra las películas para incluir solo aquellas que están "en cartelera"
      final nowPlayingMovies = listMovies.where((movie) => movie.status == "en cartelera").toList();
      return _buildMoviesList(context, nowPlayingMovies);
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

  Widget _buildMoviesList(BuildContext context, List<Movie> movies) {
  if (movies.isEmpty) {
    return Center(child: Text('No hay películas disponibles'));
  }

  return SizedBox(
    height: 300,  // Define una altura adecuada para tus elementos dentro del ListView
    child: ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return Container(
          width: 200,
          margin: const EdgeInsets.only(right: 24),
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              context.push('/movie/${movie.id}');
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network('${movie.posterPath}', fit: BoxFit.cover),
            ),
          ),
        );
      },
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
          width: MediaQuery.of(context).size.width * 0.7,  // Ajusta este valor según el diseño que prefieras
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: NetworkImage('${movie.backdropPath}'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    },
    options: CarouselOptions(
      height: 350,
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
