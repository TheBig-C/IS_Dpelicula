import 'package:freezed_annotation/freezed_annotation.dart';

part 'room.freezed.dart';
part 'room.g.dart';

@freezed
class Room with _$Room {
  const factory Room({
    required String id,
    required String name,
    required String type,
    required int rows,
    required int columns,
    required int totalSeats,
  }) = _Room;

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
  static Room fromMap(Map<String, dynamic> map, {required String roomId}) {
    return Room(
      id: roomId,
      name: map['name'] as String,
      type: map['type'] as String,
      rows: map['rows'] as int,
      columns: map['columns'] as int,
      totalSeats: map['totalSeats'] as int,
    );
  }
}
