import 'package:flutter/foundation.dart';
import '../../data/services/spare_part_service.dart';
import '../../data/services/image_service.dart';
import '../../domain/models/spare_part_model.dart';
import '../../core/errors/app_error.dart';

enum SparePartLoadingState { idle, loading, success, error }

class SparePartProvider with ChangeNotifier {
  final SparePartService _sparePartService;
  final ImageService _imageService;

  List<SparePartModel> _spareParts = [];
  SparePartLoadingState _state = SparePartLoadingState.idle;
  String? _errorMessage;
  bool _isUploading = false;

  SparePartProvider(this._sparePartService, this._imageService);

  List<SparePartModel> get spareParts => _spareParts;
  SparePartLoadingState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == SparePartLoadingState.loading;
  bool get isUploading => _isUploading;

  Future<void> loadSpareParts() async {
    try {
      _state = SparePartLoadingState.loading;
      _errorMessage = null;
      notifyListeners();

      _spareParts = await _sparePartService.getAllSpareParts();
      _state = SparePartLoadingState.success;
      notifyListeners();
    } on AppError catch (e) {
      _state = SparePartLoadingState.error;
      _errorMessage = e.message;
      notifyListeners();
    } catch (e) {
      _state = SparePartLoadingState.error;
      _errorMessage = 'An unexpected error occurred';
      notifyListeners();
    }
  }

  Future<SparePartModel?> getSparePartById(int id) async {
    try {
      return await _sparePartService.getSparePartById(id);
    } on AppError catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return null;
    }
  }

  Future<bool> createSparePart(SparePartModel sparePart) async {
    try {
      _state = SparePartLoadingState.loading;
      _errorMessage = null;
      notifyListeners();

      final created = await _sparePartService.createSparePart(sparePart);
      _spareParts.add(created);
      _state = SparePartLoadingState.success;
      notifyListeners();
      return true;
    } on AppError catch (e) {
      _state = SparePartLoadingState.error;
      _errorMessage = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateSparePart(int id, SparePartModel sparePart) async {
    try {
      _state = SparePartLoadingState.loading;
      _errorMessage = null;
      notifyListeners();

      final updated = await _sparePartService.updateSparePart(id, sparePart);
      final index = _spareParts.indexWhere((s) => s.id == id);
      if (index != -1) {
        _spareParts[index] = updated;
      }
      _state = SparePartLoadingState.success;
      notifyListeners();
      return true;
    } on AppError catch (e) {
      _state = SparePartLoadingState.error;
      _errorMessage = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteSparePart(int id) async {
    try {
      _state = SparePartLoadingState.loading;
      _errorMessage = null;
      notifyListeners();

      await _sparePartService.deleteSparePart(id);
      _spareParts.removeWhere((s) => s.id == id);
      _state = SparePartLoadingState.success;
      notifyListeners();
      return true;
    } on AppError catch (e) {
      _state = SparePartLoadingState.error;
      _errorMessage = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<String?> uploadImage(String filePath) async {
    try {
      _isUploading = true;
      notifyListeners();

      final imageUrl = await _imageService.uploadImage(filePath, 'spare-parts');
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
