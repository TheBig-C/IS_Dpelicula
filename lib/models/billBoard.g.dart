// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billBoard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BillBoardImpl _$$BillBoardImplFromJson(Map<String, dynamic> json) =>
    _$BillBoardImpl(
      id: json['id'] as String,
      functionIds: (json['functionIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isActive: json['isActive'] as bool,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      createdBy: json['createdBy'] as String,
    );

Map<String, dynamic> _$$BillBoardImplToJson(_$BillBoardImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'functionIds': instance.functionIds,
      'isActive': instance.isActive,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'createdBy': instance.createdBy,
    };
