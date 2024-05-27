import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:is_dpelicula/models/room.dart';

class RoomApi {
  final CollectionReference roomsCollection = FirebaseFirestore.instance.collection('rooms');

  Future<List<Room>> getRooms() async {
    try {
      final querySnapshot = await roomsCollection.get();
      return querySnapshot.docs.map((doc) => Room.fromMap(doc.data() as Map<String, dynamic>, roomId: doc.id)).toList();
    } catch (e) {
      print('Error fetching rooms: $e');
      return [];
    }
  }

  Future<void> addRoom(Room room) async {
    try {
      await roomsCollection.add(room.toJson());
    } catch (e) {
      print('Error adding room: $e');
    }
  }

  Future<void> updateRoom(Room room) async {
    try {
      await roomsCollection.doc(room.id).update(room.toJson());
    } catch (e) {
      print('Error updating room: $e');
    }
  }

  Future<void> deleteRoom(String roomId) async {
    try {
      await roomsCollection.doc(roomId).delete();
    } catch (e) {
      print('Error deleting room: $e');
    }
  }
}
