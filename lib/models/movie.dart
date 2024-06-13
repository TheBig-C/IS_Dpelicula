import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie.freezed.dart';
part 'movie.g.dart';

@freezed
class Movie with _$Movie {
  const factory Movie({
    required String id,
    required String title,
   required double voteAverage,
    required String overview,
    required String status,
   required String? posterPath,
    required String? backdropPath,
    List<String>? genres,
    required List<String> directorNames,
    required List<String> leadActors,
    required String registeredBy,
     @Default(0)  int durationInMinutes, // Nueva propiedad para la duración de la película
    @Default(0) int usBoxOffice, // Nueva propiedad para la taquilla provisional de EE.UU.
  }) = _Movie;

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

 static Movie fromMap(Map<String, dynamic> map, {required String movieId}) {
  try {
    return Movie(
      id: movieId as String, // Ensure correct parsing of the ID
      title: map['title'] as String,
      voteAverage: double.tryParse(map['vote_average'].toString()) ?? 0.0,
      overview: map['overview'] as String,
      status: map['status'] as String,
      posterPath: map['poster_path'] as String?,
      backdropPath: map['backdrop_path'] as String?,
      genres: List<String>.from(map['genres'] ?? []),
      directorNames: List<String>.from(map['directorNames'] ?? []),
      leadActors: List<String>.from(map['leadActors'] ?? []),
      registeredBy: map['registeredBy'] as String,
      durationInMinutes: map['durationInMinutes'] != null ? map['durationInMinutes'] as int : 0, // Ensure non-null value
      usBoxOffice: map['usBoxOffice'] != null ? map['usBoxOffice'] as int : 0, // Ensure non-null value
    );
  } catch (e) {
    print('Error parsing movie from map: $e');
    throw FormatException('Error parsing movie: $e');
  }
}

}
