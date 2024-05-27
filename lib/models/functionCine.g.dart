// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'functionCine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FunctionCineImpl _$$FunctionCineImplFromJson(Map<String, dynamic> json) =>
    _$FunctionCineImpl(
      id: json['id'] as String,
      movieId: json['movieId'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      roomId: json['roomId'] as String,
      price: (json['price'] as num).toDouble(),
      type: json['type'] as String,
      createdBy: json['createdBy'] as String,
    );

Map<String, dynamic> _$$FunctionCineImplToJson(_$FunctionCineImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'movieId': instance.movieId,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'roomId': instance.roomId,
      'price': instance.price,
      'type': instance.type,
      'createdBy': instance.createdBy,
    };
