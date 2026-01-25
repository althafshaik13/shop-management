import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';
import '../../core/errors/app_error.dart';
import '../../domain/models/battery_model.dart';

class BatteryService {
  final ApiClient _apiClient;

  BatteryService(this._apiClient);

  Future<List<BatteryModel>> getAllBatteries() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.batteries);
      final data = response.data as List<dynamic>;
      return data
          .map((json) => BatteryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is AppError) rethrow;
      throw AppError(
        message: 'Failed to fetch batteries',
        type: ErrorType.apiError,
      );
    }
  }

  Future<BatteryModel> getBatteryById(int id) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.batteryById(id));
      return BatteryModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is AppError) rethrow;
      throw AppError(
        message: 'Failed to fetch battery',
        type: ErrorType.apiError,
      );
    }
  }

  Future<BatteryModel> createBattery(BatteryModel battery) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.batteries,
        data: battery.toJson(),
      );
      return BatteryModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is AppError) rethrow;
      throw AppError(
        message: 'Failed to create battery',
        type: ErrorType.apiError,
      );
    }
  }

  Future<BatteryModel> updateBattery(int id, BatteryModel battery) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.batteryById(id),
        data: battery.toJson(),
      );
      return BatteryModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is AppError) rethrow;
      throw AppError(
        message: 'Failed to update battery',
        type: ErrorType.apiError,
      );
    }
  }

  Future<void> deleteBattery(int id) async {
    try {
      await _apiClient.delete(ApiEndpoints.batteryById(id));
    } catch (e) {
      if (e is AppError) rethrow;
      throw AppError(
        message: 'Failed to delete battery',
        type: ErrorType.apiError,
      );
    }
  }
}
