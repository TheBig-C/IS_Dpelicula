import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:is_dpelicula/api/billboard_methods.dart';
import 'package:is_dpelicula/models/billBoard.dart';

// Define the provider for BillboardApi
final billboardApiProvider = Provider<BillboardApi>((ref) {
  return BillboardApi();
});

// Define the StateNotifierProvider for BillboardController
final billboardControllerProvider = StateNotifierProvider<BillboardController, AsyncValue<List<BillBoard>>>((ref) {
  return BillboardController(ref);
});

class BillboardController extends StateNotifier<AsyncValue<List<BillBoard>>> {
  BillboardController(this.ref) : super(const AsyncValue.loading()) {
    fetchBillboards();
  }

  final Ref ref;

  Future<void> fetchBillboards() async {
    try {
      final billboardApi = ref.read(billboardApiProvider);
      final billboards = await billboardApi.getAllBillboards();
      print("Fetched billboards: ${billboards.length}");
      state = AsyncValue.data(billboards);
    } catch (e, stackTrace) {
      print("Error fetching billboards: $e");
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> addBillboard(BillBoard billboard) async {
    try {
      final billboardApi = ref.read(billboardApiProvider);
      await billboardApi.addBillboard(billboard);
      fetchBillboards();
    } catch (e, stackTrace) {
      print("Error adding billboard: $e");
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateBillboard(BillBoard billboard) async {
    try {
      final billboardApi = ref.read(billboardApiProvider);
      await billboardApi.updateBillboard(billboard);
      fetchBillboards();
    } catch (e, stackTrace) {
      print("Error updating billboard: $e");
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteBillboard(String billboardId) async {
    try {
      final billboardApi = ref.read(billboardApiProvider);
      await billboardApi.deleteBillboard(billboardId);
      fetchBillboards();
    } catch (e, stackTrace) {
      print("Error deleting billboard: $e");
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
