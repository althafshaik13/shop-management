import 'package:flutter/foundation.dart';
import '../../data/services/sale_service.dart';
import '../../domain/models/sale_model.dart';
import '../../domain/models/sale_item_model.dart';
import '../../domain/enums/product_type.dart';
import '../../domain/enums/payment_status.dart';
import '../../domain/enums/payment_type.dart';
import '../../core/errors/app_error.dart';

enum SaleLoadingState { idle, loading, success, error }

class SaleProvider with ChangeNotifier {
  final SaleService _saleService;

  List<SaleModel> _sales = [];
  List<SaleItemModel> _currentSaleItems = [];
  SaleLoadingState _state = SaleLoadingState.idle;
  String? _errorMessage;

  SaleProvider(this._saleService);

  List<SaleModel> get sales => _sales;
  List<SaleItemModel> get currentSaleItems => _currentSaleItems;
  SaleLoadingState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == SaleLoadingState.loading;

  double get currentSaleTotal =>
      _currentSaleItems.fold(0, (sum, item) => sum + item.totalAmount);

  double get currentSaleProfit =>
      _currentSaleItems.fold(0, (sum, item) => sum + item.profit);

  void addSaleItem(SaleItemModel item) {
    _currentSaleItems.add(item);
    notifyListeners();
  }

  void removeSaleItem(int index) {
    _currentSaleItems.removeAt(index);
    notifyListeners();
  }

  void updateSaleItem(int index, SaleItemModel item) {
    _currentSaleItems[index] = item;
    notifyListeners();
  }

  void clearCurrentSale() {
    _currentSaleItems.clear();
    notifyListeners();
  }

  Future<bool> createSale({
    required PaymentType paymentType,
    required PaymentStatus paymentStatus,
    String? customerName,
    String? customerPhone,
    String? customerAddress,
  }) async {
    if (_currentSaleItems.isEmpty) {
      _errorMessage = 'Please add at least one item to the sale';
      notifyListeners();
      return false;
    }

    try {
      _state = SaleLoadingState.loading;
      _errorMessage = null;
      notifyListeners();

      final sale = SaleModel(
        items: _currentSaleItems,
        paymentType: paymentType,
        paymentStatus: paymentStatus,
        customerName: customerName,
        customerPhone: customerPhone,
        customerAddress: customerAddress,
      );

      final created = await _saleService.createSale(sale);
      _sales.insert(0, created);
      _currentSaleItems.clear();
      _state = SaleLoadingState.success;
      notifyListeners();
      return true;
    } on AppError catch (e) {
      _state = SaleLoadingState.error;
      _errorMessage = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<void> loadSales({
    DateTime? startDate,
    DateTime? endDate,
    ProductType? productType,
    PaymentStatus? paymentStatus,
  }) async {
    try {
      _state = SaleLoadingState.loading;
      _errorMessage = null;
      notifyListeners();

      _sales = await _saleService.getSalesByDateRange(
        startDate: startDate,
        endDate: endDate,
        productType: productType,
        paymentStatus: paymentStatus,
      );
      _state = SaleLoadingState.success;
      notifyListeners();
    } on AppError catch (e) {
      _state = SaleLoadingState.error;
      _errorMessage = e.message;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
