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
  @JsonKey(name: 'vote_average')
  double get voteAverage => throw _privateConstructorUsedError;
  String get overview => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'poster_path')
  String get posterPath => throw _privateConstructorUsedError;
  @JsonKey(name: 'backdrop_path')
  String? get backdropPath => throw _privateConstructorUsedError;
  List<String>? get genres => throw _privateConstructorUsedError;
  List<String> get directorNames => throw _privateConstructorUsedError;
  List<String> get leadActors => throw _privateConstructorUsedError;
  String get registeredBy => throw _privateConstructorUsedError;

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
      @JsonKey(name: 'vote_average') double voteAverage,
      String overview,
      String status,
      @JsonKey(name: 'poster_path') String posterPath,
      @JsonKey(name: 'backdrop_path') String? backdropPath,
      List<String>? genres,
      List<String> directorNames,
      List<String> leadActors,
      String registeredBy});
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
    Object? voteAverage = null,
    Object? overview = null,
    Object? status = null,
    Object? posterPath = null,
    Object? backdropPath = freezed,
    Object? genres = freezed,
    Object? directorNames = null,
    Object? leadActors = null,
    Object? registeredBy = null,
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
      voteAverage: null == voteAverage
          ? _value.voteAverage
          : voteAverage // ignore: cast_nullable_to_non_nullable
              as double,
      overview: null == overview
          ? _value.overview
          : overview // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      posterPath: null == posterPath
          ? _value.posterPath
          : posterPath // ignore: cast_nullable_to_non_nullable
              as String,
      backdropPath: freezed == backdropPath
          ? _value.backdropPath
          : backdropPath // ignore: cast_nullable_to_non_nullable
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
      @JsonKey(name: 'vote_average') double voteAverage,
      String overview,
      String status,
      @JsonKey(name: 'poster_path') String posterPath,
      @JsonKey(name: 'backdrop_path') String? backdropPath,
      List<String>? genres,
      List<String> directorNames,
      List<String> leadActors,
      String registeredBy});
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
    Object? voteAverage = null,
    Object? overview = null,
    Object? status = null,
    Object? posterPath = null,
    Object? backdropPath = freezed,
    Object? genres = freezed,
    Object? directorNames = null,
    Object? leadActors = null,
    Object? registeredBy = null,
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
      voteAverage: null == voteAverage
          ? _value.voteAverage
          : voteAverage // ignore: cast_nullable_to_non_nullable
              as double,
      overview: null == overview
          ? _value.overview
          : overview // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      posterPath: null == posterPath
          ? _value.posterPath
          : posterPath // ignore: cast_nullable_to_non_nullable
              as String,
      backdropPath: freezed == backdropPath
          ? _value.backdropPath
          : backdropPath // ignore: cast_nullable_to_non_nullable
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MovieImpl implements _Movie {
  const _$MovieImpl(
      {required this.id,
      required this.title,
      @JsonKey(name: 'vote_average') required this.voteAverage,
      required this.overview,
      required this.status,
      @JsonKey(name: 'poster_path') required this.posterPath,
      @JsonKey(name: 'backdrop_path') this.backdropPath,
      final List<String>? genres,
      required final List<String> directorNames,
      required final List<String> leadActors,
      required this.registeredBy})
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
  @JsonKey(name: 'vote_average')
  final double voteAverage;
  @override
  final String overview;
  @override
  final String status;
  @override
  @JsonKey(name: 'poster_path')
  final String posterPath;
  @override
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
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
  String toString() {
    return 'Movie(id: $id, title: $title, voteAverage: $voteAverage, overview: $overview, status: $status, posterPath: $posterPath, backdropPath: $backdropPath, genres: $genres, directorNames: $directorNames, leadActors: $leadActors, registeredBy: $registeredBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MovieImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.voteAverage, voteAverage) ||
                other.voteAverage == voteAverage) &&
            (identical(other.overview, overview) ||
                other.overview == overview) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.posterPath, posterPath) ||
                other.posterPath == posterPath) &&
            (identical(other.backdropPath, backdropPath) ||
                other.backdropPath == backdropPath) &&
            const DeepCollectionEquality().equals(other._genres, _genres) &&
            const DeepCollectionEquality()
                .equals(other._directorNames, _directorNames) &&
            const DeepCollectionEquality()
                .equals(other._leadActors, _leadActors) &&
            (identical(other.registeredBy, registeredBy) ||
                other.registeredBy == registeredBy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      voteAverage,
      overview,
      status,
      posterPath,
      backdropPath,
      const DeepCollectionEquality().hash(_genres),
      const DeepCollectionEquality().hash(_directorNames),
      const DeepCollectionEquality().hash(_leadActors),
      registeredBy);

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
      @JsonKey(name: 'vote_average') required final double voteAverage,
      required final String overview,
      required final String status,
      @JsonKey(name: 'poster_path') required final String posterPath,
      @JsonKey(name: 'backdrop_path') final String? backdropPath,
      final List<String>? genres,
      required final List<String> directorNames,
      required final List<String> leadActors,
      required final String registeredBy}) = _$MovieImpl;

  factory _Movie.fromJson(Map<String, dynamic> json) = _$MovieImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  @JsonKey(name: 'vote_average')
  double get voteAverage;
  @override
  String get overview;
  @override
  String get status;
  @override
  @JsonKey(name: 'poster_path')
  String get posterPath;
  @override
  @JsonKey(name: 'backdrop_path')
  String? get backdropPath;
  @override
  List<String>? get genres;
  @override
  List<String> get directorNames;
  @override
  List<String> get leadActors;
  @override
  String get registeredBy;
  @override
  @JsonKey(ignore: true)
  _$$MovieImplCopyWith<_$MovieImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
