import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'billBoard.freezed.dart';
part 'billBoard.g.dart';

@freezed
class BillBoard with _$BillBoard {
  const factory BillBoard({
    required String id,
    required List<String> functionIds,
    required bool isActive,
    required DateTime startDate,
    required DateTime endDate,
    required String createdBy,
  }) = _BillBoard;

  factory BillBoard.fromJson(Map<String, dynamic> json) => _$BillBoardFromJson(json);

  factory BillBoard.fromMap(Map<String, dynamic> map, {required String billBoardId}) {
    return BillBoard(
      id: billBoardId,
      functionIds: List<String>.from(map['functionIds']),
      isActive: map['isActive'] as bool,
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      createdBy: map['createdBy'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'functionIds': functionIds,
    'isActive': isActive,
    'startDate': Timestamp.fromDate(startDate),
    'endDate': Timestamp.fromDate(endDate),
    'createdBy': createdBy,
  };
}
