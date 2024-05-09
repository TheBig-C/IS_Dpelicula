// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MovieImpl _$$MovieImplFromJson(Map<String, dynamic> json) => _$MovieImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      voteAverage: (json['vote_average'] as num).toDouble(),
      overview: json['overview'] as String,
      status: json['status'] as String,
      posterPath: json['poster_path'] as String,
      backdropPath: json['backdrop_path'] as String?,
      genres:
          (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
      directorNames: (json['directorNames'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      leadActors: (json['leadActors'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      registeredBy: json['registeredBy'] as String,
    );

Map<String, dynamic> _$$MovieImplToJson(_$MovieImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'vote_average': instance.voteAverage,
      'overview': instance.overview,
      'status': instance.status,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'genres': instance.genres,
      'directorNames': instance.directorNames,
      'leadActors': instance.leadActors,
      'registeredBy': instance.registeredBy,
    };
