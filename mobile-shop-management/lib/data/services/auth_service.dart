import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';
import '../../core/errors/app_error.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService(this._apiClient);

  Future<String> sendOtp(String phone) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.sendOtp,
        queryParameters: {'phone': phone},
      );
      // Backend returns plain string response
      if (response.data is String) {
        return response.data as String;
      }
      return response.data.toString();
    } catch (e) {
      if (e is AppError) rethrow;
      throw AppError(message: 'Failed to send OTP', type: ErrorType.apiError);
    }
  }

  Future<String> verifyOtp(String phone, String otp) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.verifyOtp,
        queryParameters: {'phone': phone, 'otp': otp},
      );
      final data = response.data as Map<String, dynamic>;
      return data['token'] as String;
    } catch (e) {
      if (e is AppError) rethrow;
      throw AppError(message: 'Failed to verify OTP', type: ErrorType.apiError);
    }
  }
}
