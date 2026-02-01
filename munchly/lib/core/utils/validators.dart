import '../constants/app_constants.dart';

/// Input validators
class Validators {
  /// Validate email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(AppConstants.emailPattern);
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  /// Validate password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }

    if (value.length > AppConstants.maxPasswordLength) {
      return 'Password must be less than ${AppConstants.maxPasswordLength} characters';
    }

    return null;
  }

  /// Validate name
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }

    return null;
  }

  /// Validate phone
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  /// Validate number of guests
  static String? validateGuests(String? value) {
    if (value == null || value.isEmpty) {
      return 'Number of guests is required';
    }

    final guests = int.tryParse(value);
    if (guests == null) {
      return 'Please enter a valid number';
    }

    if (guests < AppConstants.minGuestsPerBooking) {
      return 'Minimum ${AppConstants.minGuestsPerBooking} guest required';
    }

    if (guests > AppConstants.maxGuestsPerBooking) {
      return 'Maximum ${AppConstants.maxGuestsPerBooking} guests allowed';
    }

    return null;
  }
}
