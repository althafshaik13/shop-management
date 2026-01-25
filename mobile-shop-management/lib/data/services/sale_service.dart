import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';
import '../../core/errors/app_error.dart';
import '../../domain/models/sale_model.dart';
import '../../domain/enums/product_type.dart';
import '../../domain/enums/payment_status.dart';

class SaleService {
  final ApiClient _apiClient;

  SaleService(this._apiClient);

  Future<SaleModel> createSale(SaleModel sale) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.sales,
        data: sale.toJson(),
      );
      return SaleModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is AppError) rethrow;
      throw AppError(
        message: 'Failed to create sale',
        type: ErrorType.apiError,
      );
    }
  }

  Future<List<SaleModel>> getSalesByDateRange({
    DateTime? startDate,
    DateTime? endDate,
    ProductType? productType,
    PaymentStatus? paymentStatus,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String().split('T')[0];
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String().split('T')[0];
      }
      if (productType != null) {
        queryParams['productType'] = productType.name;
      }
      if (paymentStatus != null) {
        queryParams['paymentStatus'] = paymentStatus.name;
      }

      final response = await _apiClient.get(
        ApiEndpoints.sales,
        queryParameters: queryParams,
      );

      final data = response.data as List<dynamic>;
      return data
          .map((json) => SaleModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is AppError) rethrow;
      throw AppError(
        message: 'Failed to fetch sales',
        type: ErrorType.apiError,
      );
    }
  }
}
