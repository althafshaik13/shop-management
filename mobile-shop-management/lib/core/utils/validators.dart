import '../constants/app_constants.dart';

class Validators {
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    final phoneRegex = RegExp(r'^[0-9]{10}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }

    return null;
  }

  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }

    if (value.length != AppConstants.otpLength) {
      return 'OTP must be ${AppConstants.otpLength} digits';
    }

    final otpRegex = RegExp(r'^[0-9]+$');
    if (!otpRegex.hasMatch(value)) {
      return 'OTP must contain only numbers';
    }

    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Price is required';
    }

    final price = double.tryParse(value);
    if (price == null || price < 0) {
      return 'Please enter a valid price';
    }

    return null;
  }

  static String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Quantity is required';
    }

    final quantity = int.tryParse(value);
    if (quantity == null || quantity < 0) {
      return 'Please enter a valid quantity';
    }

    return null;
  }

  static String? validatePositiveNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    final number = int.tryParse(value);
    if (number == null || number <= 0) {
      return 'Please enter a valid $fieldName';
    }

    return null;
  }
}
