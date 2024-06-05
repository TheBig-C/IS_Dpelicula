import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:is_dpelicula/models/functionCine.dart';

class FunctionCineApi {
  final CollectionReference _functionCinesCollection = FirebaseFirestore.instance.collection('functions');

  Future<List<FunctionCine>> getAllFunctionCines() async {
    try {
      final querySnapshot = await _functionCinesCollection.get();
      return querySnapshot.docs.map((doc) => FunctionCine.fromMap(doc.data() as Map<String, dynamic>, functionCineId: doc.id)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<FunctionCine?> getFunctionCineById(String id) async {
    try {
      final docSnapshot = await _functionCinesCollection.doc(id).get();
      if (docSnapshot.exists) {
        return FunctionCine.fromMap(docSnapshot.data() as Map<String, dynamic>, functionCineId: docSnapshot.id);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addFunctionCine(FunctionCine functionCine) async {
    try {
      await _functionCinesCollection.add(functionCine.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateFunctionCine(FunctionCine functionCine) async {
    try {
      await _functionCinesCollection.doc(functionCine.id).update(functionCine.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteFunctionCine(String functionCineId) async {
    try {
      await _functionCinesCollection.doc(functionCineId).delete();
    } catch (e) {
      rethrow;
    }
  }
}
