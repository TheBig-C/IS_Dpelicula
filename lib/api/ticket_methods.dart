import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:is_dpelicula/models/ticket.dart';

class TicketApi {
  final CollectionReference _ticketsCollection = FirebaseFirestore.instance.collection('tickets');

  Future<List<Ticket>> getAllTickets() async {
    try {
      final querySnapshot = await _ticketsCollection.get();
      return querySnapshot.docs.map((doc) => Ticket.fromMap(doc.data() as Map<String, dynamic>, ticketId: doc.id)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Ticket?> getTicketById(String id) async {
    try {
      final docSnapshot = await _ticketsCollection.doc(id).get();
      if (docSnapshot.exists) {
        return Ticket.fromMap(docSnapshot.data() as Map<String, dynamic>, ticketId: docSnapshot.id);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addTicket(Ticket ticket) async {
    try {
      await _ticketsCollection.add(ticket.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTicket(Ticket ticket) async {
    try {
      await _ticketsCollection.doc(ticket.id).update(ticket.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTicket(String ticketId) async {
    try {
      await _ticketsCollection.doc(ticketId).delete();
    } catch (e) {
      rethrow;
    }
  }
}
