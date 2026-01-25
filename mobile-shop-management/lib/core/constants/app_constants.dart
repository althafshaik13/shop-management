class AppConstants {
  // API Configuration
  static const String baseUrl = 'http://localhost:8080/api';
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String phoneNumberKey = 'phone_number';

  // Image Configuration
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png'];

  // App Info
  static const String appName = 'Shop Management';
  static const String appVersion = '1.0.0';

  // Validation
  static const int phoneNumberLength = 10;
  static const int otpLength = 4;
}
