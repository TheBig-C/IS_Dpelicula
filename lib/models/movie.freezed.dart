// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Movie _$MovieFromJson(Map<String, dynamic> json) {
  return _Movie.fromJson(json);
}

/// @nodoc
mixin _$Movie {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  double get vote_average => throw _privateConstructorUsedError;
  String get overview => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get poster_path => throw _privateConstructorUsedError;
  String? get backdrop_path => throw _privateConstructorUsedError;
  List<String>? get genres => throw _privateConstructorUsedError;
  List<String> get directorNames => throw _privateConstructorUsedError;
  List<String> get leadActors => throw _privateConstructorUsedError;
  String get registeredBy => throw _privateConstructorUsedError;
  int get durationInMinutes =>
      throw _privateConstructorUsedError; // Nueva propiedad para la duración de la película
  int get usBoxOffice => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MovieCopyWith<Movie> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MovieCopyWith<$Res> {
  factory $MovieCopyWith(Movie value, $Res Function(Movie) then) =
      _$MovieCopyWithImpl<$Res, Movie>;
  @useResult
  $Res call(
      {String id,
      String title,
      double vote_average,
      String overview,
      String status,
      String? poster_path,
      String? backdrop_path,
      List<String>? genres,
      List<String> directorNames,
      List<String> leadActors,
      String registeredBy,
      int durationInMinutes,
      int usBoxOffice});
}

/// @nodoc
class _$MovieCopyWithImpl<$Res, $Val extends Movie>
    implements $MovieCopyWith<$Res> {
  _$MovieCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? vote_average = null,
    Object? overview = null,
    Object? status = null,
    Object? poster_path = freezed,
    Object? backdrop_path = freezed,
    Object? genres = freezed,
    Object? directorNames = null,
    Object? leadActors = null,
    Object? registeredBy = null,
    Object? durationInMinutes = null,
    Object? usBoxOffice = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      vote_average: null == vote_average
          ? _value.vote_average
          : vote_average // ignore: cast_nullable_to_non_nullable
              as double,
      overview: null == overview
          ? _value.overview
          : overview // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      poster_path: freezed == poster_path
          ? _value.poster_path
          : poster_path // ignore: cast_nullable_to_non_nullable
              as String?,
      backdrop_path: freezed == backdrop_path
          ? _value.backdrop_path
          : backdrop_path // ignore: cast_nullable_to_non_nullable
              as String?,
      genres: freezed == genres
          ? _value.genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      directorNames: null == directorNames
          ? _value.directorNames
          : directorNames // ignore: cast_nullable_to_non_nullable
              as List<String>,
      leadActors: null == leadActors
          ? _value.leadActors
          : leadActors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      registeredBy: null == registeredBy
          ? _value.registeredBy
          : registeredBy // ignore: cast_nullable_to_non_nullable
              as String,
      durationInMinutes: null == durationInMinutes
          ? _value.durationInMinutes
          : durationInMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      usBoxOffice: null == usBoxOffice
          ? _value.usBoxOffice
          : usBoxOffice // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MovieImplCopyWith<$Res> implements $MovieCopyWith<$Res> {
  factory _$$MovieImplCopyWith(
          _$MovieImpl value, $Res Function(_$MovieImpl) then) =
      __$$MovieImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      double vote_average,
      String overview,
      String status,
      String? poster_path,
      String? backdrop_path,
      List<String>? genres,
      List<String> directorNames,
      List<String> leadActors,
      String registeredBy,
      int durationInMinutes,
      int usBoxOffice});
}

/// @nodoc
class __$$MovieImplCopyWithImpl<$Res>
    extends _$MovieCopyWithImpl<$Res, _$MovieImpl>
    implements _$$MovieImplCopyWith<$Res> {
  __$$MovieImplCopyWithImpl(
      _$MovieImpl _value, $Res Function(_$MovieImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? vote_average = null,
    Object? overview = null,
    Object? status = null,
    Object? poster_path = freezed,
    Object? backdrop_path = freezed,
    Object? genres = freezed,
    Object? directorNames = null,
    Object? leadActors = null,
    Object? registeredBy = null,
    Object? durationInMinutes = null,
    Object? usBoxOffice = null,
  }) {
    return _then(_$MovieImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      vote_average: null == vote_average
          ? _value.vote_average
          : vote_average // ignore: cast_nullable_to_non_nullable
              as double,
      overview: null == overview
          ? _value.overview
          : overview // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      poster_path: freezed == poster_path
          ? _value.poster_path
          : poster_path // ignore: cast_nullable_to_non_nullable
              as String?,
      backdrop_path: freezed == backdrop_path
          ? _value.backdrop_path
          : backdrop_path // ignore: cast_nullable_to_non_nullable
              as String?,
      genres: freezed == genres
          ? _value._genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      directorNames: null == directorNames
          ? _value._directorNames
          : directorNames // ignore: cast_nullable_to_non_nullable
              as List<String>,
      leadActors: null == leadActors
          ? _value._leadActors
          : leadActors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      registeredBy: null == registeredBy
          ? _value.registeredBy
          : registeredBy // ignore: cast_nullable_to_non_nullable
              as String,
      durationInMinutes: null == durationInMinutes
          ? _value.durationInMinutes
          : durationInMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      usBoxOffice: null == usBoxOffice
          ? _value.usBoxOffice
          : usBoxOffice // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MovieImpl implements _Movie {
  const _$MovieImpl(
      {required this.id,
      required this.title,
      required this.vote_average,
      required this.overview,
      required this.status,
      required this.poster_path,
      required this.backdrop_path,
      final List<String>? genres,
      required final List<String> directorNames,
      required final List<String> leadActors,
      required this.registeredBy,
      this.durationInMinutes = 0,
      this.usBoxOffice = 0})
      : _genres = genres,
        _directorNames = directorNames,
        _leadActors = leadActors;

  factory _$MovieImpl.fromJson(Map<String, dynamic> json) =>
      _$$MovieImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final double vote_average;
  @override
  final String overview;
  @override
  final String status;
  @override
  final String? poster_path;
  @override
  final String? backdrop_path;
  final List<String>? _genres;
  @override
  List<String>? get genres {
    final value = _genres;
    if (value == null) return null;
    if (_genres is EqualUnmodifiableListView) return _genres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String> _directorNames;
  @override
  List<String> get directorNames {
    if (_directorNames is EqualUnmodifiableListView) return _directorNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_directorNames);
  }

  final List<String> _leadActors;
  @override
  List<String> get leadActors {
    if (_leadActors is EqualUnmodifiableListView) return _leadActors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_leadActors);
  }

  @override
  final String registeredBy;
  @override
  @JsonKey()
  final int durationInMinutes;
// Nueva propiedad para la duración de la película
  @override
  @JsonKey()
  final int usBoxOffice;

  @override
  String toString() {
    return 'Movie(id: $id, title: $title, vote_average: $vote_average, overview: $overview, status: $status, poster_path: $poster_path, backdrop_path: $backdrop_path, genres: $genres, directorNames: $directorNames, leadActors: $leadActors, registeredBy: $registeredBy, durationInMinutes: $durationInMinutes, usBoxOffice: $usBoxOffice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MovieImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.vote_average, vote_average) ||
                other.vote_average == vote_average) &&
            (identical(other.overview, overview) ||
                other.overview == overview) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.poster_path, poster_path) ||
                other.poster_path == poster_path) &&
            (identical(other.backdrop_path, backdrop_path) ||
                other.backdrop_path == backdrop_path) &&
            const DeepCollectionEquality().equals(other._genres, _genres) &&
            const DeepCollectionEquality()
                .equals(other._directorNames, _directorNames) &&
            const DeepCollectionEquality()
                .equals(other._leadActors, _leadActors) &&
            (identical(other.registeredBy, registeredBy) ||
                other.registeredBy == registeredBy) &&
            (identical(other.durationInMinutes, durationInMinutes) ||
                other.durationInMinutes == durationInMinutes) &&
            (identical(other.usBoxOffice, usBoxOffice) ||
                other.usBoxOffice == usBoxOffice));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      vote_average,
      overview,
      status,
      poster_path,
      backdrop_path,
      const DeepCollectionEquality().hash(_genres),
      const DeepCollectionEquality().hash(_directorNames),
      const DeepCollectionEquality().hash(_leadActors),
      registeredBy,
      durationInMinutes,
      usBoxOffice);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MovieImplCopyWith<_$MovieImpl> get copyWith =>
      __$$MovieImplCopyWithImpl<_$MovieImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MovieImplToJson(
      this,
    );
  }
}

abstract class _Movie implements Movie {
  const factory _Movie(
      {required final String id,
      required final String title,
      required final double vote_average,
      required final String overview,
      required final String status,
      required final String? poster_path,
      required final String? backdrop_path,
      final List<String>? genres,
      required final List<String> directorNames,
      required final List<String> leadActors,
      required final String registeredBy,
      final int durationInMinutes,
      final int usBoxOffice}) = _$MovieImpl;

  factory _Movie.fromJson(Map<String, dynamic> json) = _$MovieImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  double get vote_average;
  @override
  String get overview;
  @override
  String get status;
  @override
  String? get poster_path;
  @override
  String? get backdrop_path;
  @override
  List<String>? get genres;
  @override
  List<String> get directorNames;
  @override
  List<String> get leadActors;
  @override
  String get registeredBy;
  @override
  int get durationInMinutes;
  @override // Nueva propiedad para la duración de la película
  int get usBoxOffice;
  @override
  @JsonKey(ignore: true)
  _$$MovieImplCopyWith<_$MovieImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
