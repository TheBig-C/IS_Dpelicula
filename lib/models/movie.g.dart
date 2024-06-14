// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MovieImpl _$$MovieImplFromJson(Map<String, dynamic> json) => _$MovieImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      vote_average: (json['vote_average'] as num).toDouble(),
      overview: json['overview'] as String,
      status: json['status'] as String,
      poster_path: json['poster_path'] as String?,
      backdrop_path: json['backdrop_path'] as String?,
      genres:
          (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
      directorNames: (json['directorNames'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      leadActors: (json['leadActors'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      registeredBy: json['registeredBy'] as String,
      durationInMinutes: (json['durationInMinutes'] as num?)?.toInt() ?? 0,
      usBoxOffice: (json['usBoxOffice'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$MovieImplToJson(_$MovieImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'vote_average': instance.vote_average,
      'overview': instance.overview,
      'status': instance.status,
      'poster_path': instance.poster_path,
      'backdrop_path': instance.backdrop_path,
      'genres': instance.genres,
      'directorNames': instance.directorNames,
      'leadActors': instance.leadActors,
      'registeredBy': instance.registeredBy,
      'durationInMinutes': instance.durationInMinutes,
      'usBoxOffice': instance.usBoxOffice,
    };
