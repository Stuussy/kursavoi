/// Application constants
class AppConstants {
  // App info
  static const String appName = 'Munchly';
  static const String appVersion = '1.0.0';

  // Storage keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String userEmailKey = 'user_email';

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  // Booking constraints
  static const int maxGuestsPerBooking = 20;
  static const int minGuestsPerBooking = 1;
  static const int maxAdvanceBookingDays = 30;

  // Map configuration
  static const double defaultMapZoom = 15.0;
  static const double tableMapZoom = 18.0;
}
