import 'package:flutter/foundation.dart' show kIsWeb, TargetPlatform, defaultTargetPlatform;

/// API configuration for Munchly application
class ApiConfig {
  // Backend API URL — platform-aware for local development
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000/api';
    }
    return 'http://localhost:3000/api';
  }

  // Auth endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String logoutEndpoint = '/auth/logout';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String meEndpoint = '/auth/me';

  // Restaurants endpoints
  static const String restaurantsEndpoint = '/restaurants';
  static const String restaurantDetailsEndpoint = '/restaurants/{id}';
  static const String restaurantTablesEndpoint = '/restaurants/{id}/tables';

  // Bookings endpoints
  static const String bookingsEndpoint = '/bookings';
  static const String createBookingEndpoint = '/bookings';
  static const String cancelBookingEndpoint = '/bookings/{id}/cancel';
  static const String myBookingsEndpoint = '/bookings/my';

  // Favorites endpoints
  static const String favoritesEndpoint = '/favorites';
  static const String myFavoritesEndpoint = '/favorites/my';
  static const String checkFavoriteEndpoint = '/favorites/check/{restaurantId}';
  static const String removeFavoriteEndpoint = '/favorites/{restaurantId}';

  // Request timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
