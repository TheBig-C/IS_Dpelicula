// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'functionCine.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FunctionCine _$FunctionCineFromJson(Map<String, dynamic> json) {
  return _FunctionCine.fromJson(json);
}

/// @nodoc
mixin _$FunctionCine {
  String get id => throw _privateConstructorUsedError;
  String get movieId => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  String get roomId => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FunctionCineCopyWith<FunctionCine> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FunctionCineCopyWith<$Res> {
  factory $FunctionCineCopyWith(
          FunctionCine value, $Res Function(FunctionCine) then) =
      _$FunctionCineCopyWithImpl<$Res, FunctionCine>;
  @useResult
  $Res call(
      {String id,
      String movieId,
      DateTime startTime,
      DateTime endTime,
      String roomId,
      double price,
      String type,
      String createdBy});
}

/// @nodoc
class _$FunctionCineCopyWithImpl<$Res, $Val extends FunctionCine>
    implements $FunctionCineCopyWith<$Res> {
  _$FunctionCineCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? movieId = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? roomId = null,
    Object? price = null,
    Object? type = null,
    Object? createdBy = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      movieId: null == movieId
          ? _value.movieId
          : movieId // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      roomId: null == roomId
          ? _value.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FunctionCineImplCopyWith<$Res>
    implements $FunctionCineCopyWith<$Res> {
  factory _$$FunctionCineImplCopyWith(
          _$FunctionCineImpl value, $Res Function(_$FunctionCineImpl) then) =
      __$$FunctionCineImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String movieId,
      DateTime startTime,
      DateTime endTime,
      String roomId,
      double price,
      String type,
      String createdBy});
}

/// @nodoc
class __$$FunctionCineImplCopyWithImpl<$Res>
    extends _$FunctionCineCopyWithImpl<$Res, _$FunctionCineImpl>
    implements _$$FunctionCineImplCopyWith<$Res> {
  __$$FunctionCineImplCopyWithImpl(
      _$FunctionCineImpl _value, $Res Function(_$FunctionCineImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? movieId = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? roomId = null,
    Object? price = null,
    Object? type = null,
    Object? createdBy = null,
  }) {
    return _then(_$FunctionCineImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      movieId: null == movieId
          ? _value.movieId
          : movieId // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      roomId: null == roomId
          ? _value.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FunctionCineImpl implements _FunctionCine {
  const _$FunctionCineImpl(
      {required this.id,
      required this.movieId,
      required this.startTime,
      required this.endTime,
      required this.roomId,
      required this.price,
      required this.type,
      required this.createdBy});

  factory _$FunctionCineImpl.fromJson(Map<String, dynamic> json) =>
      _$$FunctionCineImplFromJson(json);

  @override
  final String id;
  @override
  final String movieId;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  final String roomId;
  @override
  final double price;
  @override
  final String type;
  @override
  final String createdBy;

  @override
  String toString() {
    return 'FunctionCine(id: $id, movieId: $movieId, startTime: $startTime, endTime: $endTime, roomId: $roomId, price: $price, type: $type, createdBy: $createdBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FunctionCineImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.movieId, movieId) || other.movieId == movieId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, movieId, startTime, endTime,
      roomId, price, type, createdBy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FunctionCineImplCopyWith<_$FunctionCineImpl> get copyWith =>
      __$$FunctionCineImplCopyWithImpl<_$FunctionCineImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FunctionCineImplToJson(
      this,
    );
  }
}

abstract class _FunctionCine implements FunctionCine {
  const factory _FunctionCine(
      {required final String id,
      required final String movieId,
      required final DateTime startTime,
      required final DateTime endTime,
      required final String roomId,
      required final double price,
      required final String type,
      required final String createdBy}) = _$FunctionCineImpl;

  factory _FunctionCine.fromJson(Map<String, dynamic> json) =
      _$FunctionCineImpl.fromJson;

  @override
  String get id;
  @override
  String get movieId;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  String get roomId;
  @override
  double get price;
  @override
  String get type;
  @override
  String get createdBy;
  @override
  @JsonKey(ignore: true)
  _$$FunctionCineImplCopyWith<_$FunctionCineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
