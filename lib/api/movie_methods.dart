import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'package:is_dpelicula/models/movie.dart';

import '../core/core.dart';


final movieAPIProvider = Provider((ref) {
  return MovieAPI(
    firestore: FirebaseFirestore.instance,
  );
});

abstract class IMovieAPI {
  Future<Either<Failure, DocumentSnapshot>> addMovie(Movie movie);
  Future<QuerySnapshot<Map<String, dynamic>>> getAllMovies();
  Stream<QuerySnapshot<Map<String, dynamic>>> watchMovies();
  Future<Either<Failure, void>> updateMovie(Movie movie);
  Future<DocumentSnapshot<Map<String, dynamic>>> getMovieById(String id);
    Future<QuerySnapshot<Map<String, dynamic>>> getMoviesWithCondition(String field, String value);

}
class MovieAPI implements IMovieAPI {
  final FirebaseFirestore _firestore;

  MovieAPI({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  @override
  Future<Either<Failure, DocumentSnapshot>> addMovie(Movie movie) async {
    try {
      final DocumentReference docRef = await _firestore.collection('movies').add(movie.toJson());
      final DocumentSnapshot docSnapshot = await docRef.get();
      return right(docSnapshot);
    } on FirebaseException catch (e) {
return Left(Failure(e.message ?? 'Error adding movie'));
    }
  }
  Future<QuerySnapshot<Map<String, dynamic>>> getMoviesWithCondition(String field, String value) async {
    return await _firestore.collection('movies')
        .where(field, isEqualTo: value)
        .get();
  }
  @override
  Future<QuerySnapshot<Map<String, dynamic>>> getAllMovies() async {
    return await _firestore.collection('movies').get();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> watchMovies() {
    return _firestore.collection('movies').snapshots();
  }

  @override
  Future<Either<Failure, void>> updateMovie(Movie movie) async {
    try {
      await _firestore.collection('movies').doc(movie.id.toString()).update(movie.toJson());
      return right(unit);
    } on FirebaseException catch (e) {
      return left(Failure(e.message ?? 'Error updating movie'));
    }
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> getMovieById(String id) async {
    return await _firestore.collection('movies').doc(id).get();
  }
}
