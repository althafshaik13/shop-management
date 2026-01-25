import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';
import '../../core/errors/app_error.dart';

class ImageService {
  final ApiClient _apiClient;

  ImageService(this._apiClient);

  Future<String> uploadImage(String filePath, String folderType) async {
    try {
      final response = await _apiClient.uploadFile(
        ApiEndpoints.uploadImage,
        filePath,
        folderType,
      );

      final data = response.data as Map<String, dynamic>;
      return data['imageUrl'] as String;
    } catch (e) {
      if (e is AppError) rethrow;
      throw AppError(
        message: 'Failed to upload image',
        type: ErrorType.apiError,
      );
    }
  }
}
