import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  final String id;
  final String userId;
  final String row;
  final String seat;
  final Timestamp functionDateTime;
  final String functionId;
  final double price;

  Ticket({
    required this.id,
    required this.userId,
    required this.row,
    required this.seat,
    required this.functionDateTime,
    required this.functionId,
    required this.price,
  });

  factory Ticket.fromMap(Map<String, dynamic> map, {required String ticketId}) {
    return Ticket(
      id: ticketId,
      userId: map['userId'] as String? ?? '',
      row: map['row'] as String? ?? '',
      seat: map['seat'] as String? ?? '',
      functionDateTime: map['functionDateTime'] ?? Timestamp.now(),
      functionId: map['functionId'] as String? ?? '',
      price: (map['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'row': row,
      'seat': seat,
      'functionDateTime': functionDateTime,
      'functionId': functionId,
      'price': price,
    };
  }
}
