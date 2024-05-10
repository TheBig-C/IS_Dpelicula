import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final firebaseAuthProvider = FutureProvider<FirebaseAuth>((ref) async {
  await Firebase.initializeApp();
  return FirebaseAuth.instance;
});

final firebaseFirestoreProvider = Provider((ref) {
  return FirebaseFirestore.instance;
});

final firebaseStorageProvider = Provider((ref) {
  return FirebaseStorage.instance;
});


