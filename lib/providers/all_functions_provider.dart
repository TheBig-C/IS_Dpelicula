import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:is_dpelicula/models/functionCine.dart';

final allFunctionsProvider = FutureProvider<List<FunctionCine>>((ref) async {
  final snapshot = await FirebaseFirestore.instance.collection('functions').get();
  return snapshot.docs.map((doc) => FunctionCine.fromJson(doc.data())).toList();
});
