import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';
import '../../core/errors/app_error.dart';
import '../../domain/models/spare_part_model.dart';

class SparePartService {
  final ApiClient _apiClient;

  SparePartService(this._apiClient);

  Future<List<SparePartModel>> getAllSpareParts() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.spareParts);
      final data = response.data as List<dynamic>;
      return data
          .map((json) => SparePartModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is AppError) rethrow;
      throw AppError(
        message: 'Failed to fetch spare parts',
        type: ErrorType.apiError,
      );
    }
  }

  Future<SparePartModel> getSparePartById(int id) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.sparePartById(id));
      return SparePartModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is AppError) rethrow;
      throw AppError(
        message: 'Failed to fetch spare part',
        type: ErrorType.apiError,
      );
    }
  }

  Future<SparePartModel> createSparePart(SparePartModel sparePart) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.spareParts,
        data: sparePart.toJson(),
      );
      return SparePartModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is AppError) rethrow;
      throw AppError(
        message: 'Failed to create spare part',
        type: ErrorType.apiError,
      );
    }
  }

  Future<SparePartModel> updateSparePart(
    int id,
    SparePartModel sparePart,
  ) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.sparePartById(id),
        data: sparePart.toJson(),
      );
      return SparePartModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is AppError) rethrow;
      throw AppError(
        message: 'Failed to update spare part',
        type: ErrorType.apiError,
      );
    }
  }

  Future<void> deleteSparePart(int id) async {
    try {
      await _apiClient.delete(ApiEndpoints.sparePartById(id));
    } catch (e) {
      if (e is AppError) rethrow;
      throw AppError(
        message: 'Failed to delete spare part',
        type: ErrorType.apiError,
      );
    }
  }
}
