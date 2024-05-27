// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoomImpl _$$RoomImplFromJson(Map<String, dynamic> json) => _$RoomImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      rows: (json['rows'] as num).toInt(),
      columns: (json['columns'] as num).toInt(),
      totalSeats: (json['totalSeats'] as num).toInt(),
    );

Map<String, dynamic> _$$RoomImplToJson(_$RoomImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'rows': instance.rows,
      'columns': instance.columns,
      'totalSeats': instance.totalSeats,
    };
