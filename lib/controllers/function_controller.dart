import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:is_dpelicula/api/function_methods.dart';
import 'package:is_dpelicula/models/functionCine.dart';

// Define the provider for FunctionCineApi
final functionCineApiProvider = Provider<FunctionCineApi>((ref) {
  return FunctionCineApi();
});

// Define the StateNotifierProvider for FunctionCineController
final functionCineControllerProvider = StateNotifierProvider<FunctionCineController, AsyncValue<List<FunctionCine>>>((ref) {
  return FunctionCineController(ref);
});

class FunctionCineController extends StateNotifier<AsyncValue<List<FunctionCine>>> {
  FunctionCineController(this.ref) : super(const AsyncValue.loading()) {
    fetchFunctionCines();
  }

  final Ref ref;

  Future<void> fetchFunctionCines() async {
    try {
      final functionCineApi = ref.read(functionCineApiProvider);
      final functionCines = await functionCineApi.getAllFunctionCines();
      state = AsyncValue.data(functionCines);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> addFunctionCine(FunctionCine functionCine) async {
    try {
      final functionCineApi = ref.read(functionCineApiProvider);
      await functionCineApi.addFunctionCine(functionCine);
      fetchFunctionCines();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateFunctionCine(FunctionCine functionCine) async {
    try {
      final functionCineApi = ref.read(functionCineApiProvider);
      await functionCineApi.updateFunctionCine(functionCine);
      fetchFunctionCines();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteFunctionCine(String functionCineId) async {
    try {
      final functionCineApi = ref.read(functionCineApiProvider);
      await functionCineApi.deleteFunctionCine(functionCineId);
      fetchFunctionCines();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
