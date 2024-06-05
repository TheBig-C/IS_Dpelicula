import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:is_dpelicula/models/functionCine.dart';

class FunctionController extends StateNotifier<List<FunctionCine>> {
  FunctionController() : super([]);

  Future<void> fetchFunctions() async {
    final snapshot = await FirebaseFirestore.instance.collection('functions').get();
    state = snapshot.docs.map((doc) => FunctionCine.fromJson(doc.data())).toList();
  }

  Future<void> addFunction(FunctionCine function) async {
    await FirebaseFirestore.instance.collection('functions').add(function.toJson());
    state = [...state, function];
  }

  Future<void> updateFunction(FunctionCine function) async {
    await FirebaseFirestore.instance.collection('functions').doc(function.id).update(function.toJson());
    state = state.map((f) => f.id == function.id ? function : f).toList();
  }

  Future<void> deleteFunction(String id) async {
    await FirebaseFirestore.instance.collection('functions').doc(id).delete();
    state = state.where((f) => f.id != id).toList();
  }
}

final functionControllerProvider = StateNotifierProvider<FunctionController, List<FunctionCine>>((ref) {
  return FunctionController();
});
