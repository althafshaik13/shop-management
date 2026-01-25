import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/services/auth_service.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/app_error.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  final SharedPreferences _prefs;

  AuthStatus _status = AuthStatus.initial;
  String? _phoneNumber;
  String? _errorMessage;
  String? _otpMessage;

  AuthProvider(this._authService, this._prefs) {
    _checkAuthStatus();
  }

  AuthStatus get status => _status;
  String? get phoneNumber => _phoneNumber;
  String? get errorMessage => _errorMessage;
  String? get otpMessage => _otpMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  Future<void> _checkAuthStatus() async {
    try {
      final token = _prefs.getString(AppConstants.authTokenKey);
      final phone = _prefs.getString(AppConstants.phoneNumberKey);

      if (token != null && token.isNotEmpty) {
        _status = AuthStatus.authenticated;
        _phoneNumber = phone;
      } else {
        _status = AuthStatus.unauthenticated;
      }
      notifyListeners();
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  Future<void> sendOtp(String phone) async {
    try {
      _status = AuthStatus.loading;
      _errorMessage = null;
      _otpMessage = null;
      notifyListeners();

      final message = await _authService.sendOtp(phone);
      _phoneNumber = phone;
      _otpMessage = message;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    } on AppError catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.message;
      notifyListeners();
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'An unexpected error occurred';
      notifyListeners();
    }
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    try {
      _status = AuthStatus.loading;
      _errorMessage = null;
      notifyListeners();

      final token = await _authService.verifyOtp(phone, otp);

      await _prefs.setString(AppConstants.authTokenKey, token);
      await _prefs.setString(AppConstants.phoneNumberKey, phone);

      _phoneNumber = phone;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } on AppError catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'An unexpected error occurred';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _prefs.remove(AppConstants.authTokenKey);
    await _prefs.remove(AppConstants.phoneNumberKey);
    _status = AuthStatus.unauthenticated;
    _phoneNumber = null;
    _errorMessage = null;
    _otpMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
