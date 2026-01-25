import 'package:flutter/foundation.dart';
import '../../data/services/battery_service.dart';
import '../../data/services/image_service.dart';
import '../../domain/models/battery_model.dart';
import '../../core/errors/app_error.dart';

enum BatteryLoadingState { idle, loading, success, error }

class BatteryProvider with ChangeNotifier {
  final BatteryService _batteryService;
  final ImageService _imageService;

  List<BatteryModel> _batteries = [];
  BatteryLoadingState _state = BatteryLoadingState.idle;
  String? _errorMessage;
  bool _isUploading = false;

  BatteryProvider(this._batteryService, this._imageService);

  List<BatteryModel> get batteries => _batteries;
  BatteryLoadingState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == BatteryLoadingState.loading;
  bool get isUploading => _isUploading;

  Future<void> loadBatteries() async {
    try {
      _state = BatteryLoadingState.loading;
      _errorMessage = null;
      notifyListeners();

      _batteries = await _batteryService.getAllBatteries();
      _state = BatteryLoadingState.success;
      notifyListeners();
    } on AppError catch (e) {
      _state = BatteryLoadingState.error;
      _errorMessage = e.message;
      notifyListeners();
    } catch (e) {
      _state = BatteryLoadingState.error;
      _errorMessage = 'An unexpected error occurred';
      notifyListeners();
    }
  }

  Future<BatteryModel?> getBatteryById(int id) async {
    try {
      return await _batteryService.getBatteryById(id);
    } on AppError catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return null;
    }
  }

  Future<bool> createBattery(BatteryModel battery) async {
    try {
      _state = BatteryLoadingState.loading;
      _errorMessage = null;
      notifyListeners();

      final created = await _batteryService.createBattery(battery);
      _batteries.add(created);
      _state = BatteryLoadingState.success;
      notifyListeners();
      return true;
    } on AppError catch (e) {
      _state = BatteryLoadingState.error;
      _errorMessage = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateBattery(int id, BatteryModel battery) async {
    try {
      _state = BatteryLoadingState.loading;
      _errorMessage = null;
      notifyListeners();

      final updated = await _batteryService.updateBattery(id, battery);
      final index = _batteries.indexWhere((b) => b.id == id);
      if (index != -1) {
        _batteries[index] = updated;
      }
      _state = BatteryLoadingState.success;
      notifyListeners();
      return true;
    } on AppError catch (e) {
      _state = BatteryLoadingState.error;
      _errorMessage = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteBattery(int id) async {
    try {
      _state = BatteryLoadingState.loading;
      _errorMessage = null;
      notifyListeners();

      await _batteryService.deleteBattery(id);
      _batteries.removeWhere((b) => b.id == id);
      _state = BatteryLoadingState.success;
      notifyListeners();
      return true;
    } on AppError catch (e) {
      _state = BatteryLoadingState.error;
      _errorMessage = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<String?> uploadImage(String filePath) async {
    try {
      _isUploading = true;
      notifyListeners();

      final imageUrl = await _imageService.uploadImage(filePath, 'batteries');
      _isUploading = false;
      notifyListeners();
      return imageUrl;
    } on AppError catch (e) {
      _isUploading = false;
      _errorMessage = e.message;
      notifyListeners();
      return null;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
