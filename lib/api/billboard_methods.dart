import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:is_dpelicula/models/billBoard.dart';

class BillboardApi {
  final CollectionReference _billboardsCollection = FirebaseFirestore.instance.collection('billboards');

  Future<List<BillBoard>> getAllBillboards() async {
    try {
      final querySnapshot = await _billboardsCollection.get();
      return querySnapshot.docs.map((doc) => BillBoard.fromMap(doc.data() as Map<String, dynamic>, billBoardId: doc.id)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addBillboard(BillBoard billboard) async {
    try {
      await _billboardsCollection.add(billboard.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateBillboard(BillBoard billboard) async {
    try {
      await _billboardsCollection.doc(billboard.id).update(billboard.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteBillboard(String billboardId) async {
    try {
      await _billboardsCollection.doc(billboardId).delete();
    } catch (e) {
      rethrow;
    }
  }
}
