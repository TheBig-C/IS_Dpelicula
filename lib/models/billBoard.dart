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

  static BillBoard fromMap(Map<String, dynamic> map, {required String billBoardId}) {
    DateTime startDate = (map['startDate'] as Timestamp).toDate();
    return BillBoard(
      id: billBoardId,
      functionIds: List<String>.from(map['functionIds']),
      isActive: map['isActive'] as bool,
      startDate: startDate,
      endDate: startDate.add(Duration(days: 7)),
      createdBy: map['createdBy'] as String,
    );
  }
}
