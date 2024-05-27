import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:is_dpelicula/models/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final roomControllerProvider = StateNotifierProvider<RoomController, AsyncValue<List<Room>>>((ref) {
  return RoomController();
});

class RoomController extends StateNotifier<AsyncValue<List<Room>>> {
  RoomController() : super(const AsyncValue.loading()) {
    fetchRooms();
  }

  final CollectionReference roomsCollection = FirebaseFirestore.instance.collection('rooms');

  Future<void> fetchRooms() async {
    try {
      final querySnapshot = await roomsCollection.get();
      final rooms = querySnapshot.docs.map((doc) => Room.fromMap(doc.data() as Map<String, dynamic>, roomId: doc.id)).toList();
      state = AsyncValue.data(rooms);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> addRoom(Room room) async {
    try {
      await roomsCollection.add(room.toJson());
      fetchRooms();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateRoom(Room room) async {
    try {
      await roomsCollection.doc(room.id).update(room.toJson());
      fetchRooms();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteRoom(String roomId) async {
    try {
      await roomsCollection.doc(roomId).delete();
      fetchRooms();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
