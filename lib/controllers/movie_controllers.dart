import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:is_dpelicula/models/movie.dart';
import 'package:is_dpelicula/api/movie_methods.dart';

final movieControllerProvider = StateNotifierProvider<MovieController, bool>(
  (ref) {
    return MovieController(
      ref: ref,
      movieAPI: ref.watch(movieAPIProvider),
    );
  },
);

final getAllMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final movieController = ref.watch(movieControllerProvider.notifier);
  return movieController.getAllMovies();
});

final allMoviesProviderFuture = FutureProvider<List<Movie>>((ref) {
  final movieController = ref.read(movieControllerProvider.notifier);
  return movieController.getAllMovies();
});

final movieProviderFamily = FutureProvider.family<Movie, String>((ref, movieId) async {
  final movieController = ref.watch(movieControllerProvider.notifier);
  return movieController.getMovieById(movieId);
});

class MovieController extends StateNotifier<bool> {
  final MovieAPI _movieAPI;
  final Ref _ref;

  MovieController({
    required Ref ref,
    required MovieAPI movieAPI,
  })  : _ref = ref,
        _movieAPI = movieAPI,
        super(false);

  Future<List<Movie>> getComingSoonMovies() async {
    final result = await _movieAPI.getMoviesWithCondition('status', 'muy pronto');
    return result.docs.map((doc) => Movie.fromMap(doc.data(), movieId: doc.id)).toList();
  }

  Future<List<Movie>> getAllMovies() async {
    try {
      final movieList = await _movieAPI.getAllMovies();
      return movieList.docs.map((doc) {
        final movieData = doc.data();
        final movieId = doc.id;
        return Movie.fromMap(movieData, movieId: movieId);
      }).toList();
    } catch (e) {
      print('Error fetching movies: $e');
      return [];
    }
  }

  Future<Movie> getMovieById(String id) async {
    final doc = await _movieAPI.getMovieById(id);
    return Movie.fromMap(doc.data() as Map<String, dynamic>, movieId: id);
  }

  Future<void> addMovie(Movie movie) async {
    state = true;
    final result = await _movieAPI.addMovie(movie);
    result.fold(
      (l) {
        // handle error
        state = false;
      },
      (r) {
        // handle success
        state = false;
      },
    );
  }

  Future<void> updateMovie(Movie movie) async {
    state = true;
    final result = await _movieAPI.updateMovie(movie);
    result.fold(
      (l) {
        // handle error
        state = false;
      },
      (r) {
        // handle success
        state = false;
      },
    );
  }
}
