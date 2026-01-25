class ApiEndpoints {
  // Auth Endpoints
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';

  // Battery Endpoints
  static const String batteries = '/batteries';
  static String batteryById(int id) => '/batteries/$id';

  // Spare Part Endpoints
  static const String spareParts = '/spare-parts';
  static String sparePartById(int id) => '/spare-parts/$id';

  // Sale Endpoints
  static const String sales = '/sales';

  // Image Endpoints
  static const String uploadImage = '/images/upload';
}
