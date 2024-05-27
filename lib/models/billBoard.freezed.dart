// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'billBoard.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BillBoard _$BillBoardFromJson(Map<String, dynamic> json) {
  return _BillBoard.fromJson(json);
}

/// @nodoc
mixin _$BillBoard {
  String get id => throw _privateConstructorUsedError;
  List<String> get functionIds => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BillBoardCopyWith<BillBoard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BillBoardCopyWith<$Res> {
  factory $BillBoardCopyWith(BillBoard value, $Res Function(BillBoard) then) =
      _$BillBoardCopyWithImpl<$Res, BillBoard>;
  @useResult
  $Res call(
      {String id,
      List<String> functionIds,
      bool isActive,
      DateTime startDate,
      DateTime endDate,
      String createdBy});
}

/// @nodoc
class _$BillBoardCopyWithImpl<$Res, $Val extends BillBoard>
    implements $BillBoardCopyWith<$Res> {
  _$BillBoardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? functionIds = null,
    Object? isActive = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? createdBy = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      functionIds: null == functionIds
          ? _value.functionIds
          : functionIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BillBoardImplCopyWith<$Res>
    implements $BillBoardCopyWith<$Res> {
  factory _$$BillBoardImplCopyWith(
          _$BillBoardImpl value, $Res Function(_$BillBoardImpl) then) =
      __$$BillBoardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      List<String> functionIds,
      bool isActive,
      DateTime startDate,
      DateTime endDate,
      String createdBy});
}

/// @nodoc
class __$$BillBoardImplCopyWithImpl<$Res>
    extends _$BillBoardCopyWithImpl<$Res, _$BillBoardImpl>
    implements _$$BillBoardImplCopyWith<$Res> {
  __$$BillBoardImplCopyWithImpl(
      _$BillBoardImpl _value, $Res Function(_$BillBoardImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? functionIds = null,
    Object? isActive = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? createdBy = null,
  }) {
    return _then(_$BillBoardImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      functionIds: null == functionIds
          ? _value._functionIds
          : functionIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BillBoardImpl implements _BillBoard {
  const _$BillBoardImpl(
      {required this.id,
      required final List<String> functionIds,
      required this.isActive,
      required this.startDate,
      required this.endDate,
      required this.createdBy})
      : _functionIds = functionIds;

  factory _$BillBoardImpl.fromJson(Map<String, dynamic> json) =>
      _$$BillBoardImplFromJson(json);

  @override
  final String id;
  final List<String> _functionIds;
  @override
  List<String> get functionIds {
    if (_functionIds is EqualUnmodifiableListView) return _functionIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_functionIds);
  }

  @override
  final bool isActive;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final String createdBy;

  @override
  String toString() {
    return 'BillBoard(id: $id, functionIds: $functionIds, isActive: $isActive, startDate: $startDate, endDate: $endDate, createdBy: $createdBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BillBoardImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality()
                .equals(other._functionIds, _functionIds) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      const DeepCollectionEquality().hash(_functionIds),
      isActive,
      startDate,
      endDate,
      createdBy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BillBoardImplCopyWith<_$BillBoardImpl> get copyWith =>
      __$$BillBoardImplCopyWithImpl<_$BillBoardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BillBoardImplToJson(
      this,
    );
  }
}

abstract class _BillBoard implements BillBoard {
  const factory _BillBoard(
      {required final String id,
      required final List<String> functionIds,
      required final bool isActive,
      required final DateTime startDate,
      required final DateTime endDate,
      required final String createdBy}) = _$BillBoardImpl;

  factory _BillBoard.fromJson(Map<String, dynamic> json) =
      _$BillBoardImpl.fromJson;

  @override
  String get id;
  @override
  List<String> get functionIds;
  @override
  bool get isActive;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  String get createdBy;
  @override
  @JsonKey(ignore: true)
  _$$BillBoardImplCopyWith<_$BillBoardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
