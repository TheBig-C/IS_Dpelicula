import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'functionCine.freezed.dart';
part 'functionCine.g.dart';

@freezed
class FunctionCine with _$FunctionCine {
  const factory FunctionCine({
    required String id,
    required String movieId,
    required DateTime startTime,
    required DateTime endTime,
    required String roomId,
    required double price,
    required String type,
    required String createdBy,
  }) = _FunctionCine;

  factory FunctionCine.fromJson(Map<String, dynamic> json) => _$FunctionCineFromJson(json);

  factory FunctionCine.fromMap(Map<String, dynamic> map, {required String functionCineId}) {
    return FunctionCine(
      id: functionCineId,
      movieId: map['movieId'] as String,
      startTime: _convertToDateTime(map['startTime']),
      endTime: _convertToDateTime(map['endTime']),
      roomId: map['roomId'] as String,
      price: (map['price'] as num).toDouble(),
      type: map['type'] as String,
      createdBy: map['createdBy'] as String,
    );
  }

  static DateTime _convertToDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      return DateTime.parse(value);
    } else {
      throw ArgumentError('Invalid date format');
    }
  }
}
