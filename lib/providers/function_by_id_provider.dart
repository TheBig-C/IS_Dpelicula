import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:is_dpelicula/models/functionCine.dart';

final functionByIdProvider = FutureProvider.family<FunctionCine, String>((ref, id) async {
  final doc = await FirebaseFirestore.instance.collection('functions').doc(id).get();
  return FunctionCine.fromJson(doc.data()!);
});
