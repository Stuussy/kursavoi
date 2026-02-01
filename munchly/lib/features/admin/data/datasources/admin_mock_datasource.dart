import 'admin_remote_datasource.dart';

/// Mock admin data source
class AdminMockDataSource {
  /// Get statistics
  Future<AdminStats> getStats() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return AdminStats(
      totalUsers: 3,
      totalBookings: 0,
      totalRestaurants: 6,
      activeBookings: 0,
    );
  }

  /// Get all users
  Future<List<AdminUser>> getUsers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      AdminUser(
        id: 'user_1',
        name: 'Test User',
        email: 'test@munchly.com',
        phone: '+1234567890',
        role: 'user',
        createdAt:
            DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
      ),
      AdminUser(
        id: 'user_2',
        name: 'Demo User',
        email: 'demo@munchly.com',
        phone: null,
        role: 'user',
        createdAt:
            DateTime.now().subtract(const Duration(days: 15)).toIso8601String(),
      ),
      AdminUser(
        id: 'user_3',
        name: 'Admin User',
        email: 'admin@munchly.kz',
        phone: '+1234567890',
        role: 'admin',
        createdAt:
            DateTime.now().subtract(const Duration(days: 60)).toIso8601String(),
      ),
    ];
  }

  /// Get all bookings
  Future<List<AdminBooking>> getBookings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      AdminBooking(
        id: 'booking_1',
        restaurantName: 'La Bella Italia',
        userName: 'Test User',
        userEmail: 'test@munchly.com',
        date: '2026-02-15',
        time: '19:00',
        guests: 4,
        status: 'confirmed',
        notes: 'Window seat please',
      ),
      AdminBooking(
        id: 'booking_2',
        restaurantName: 'Sushi Master',
        userName: 'Demo User',
        userEmail: 'demo@munchly.com',
        date: '2026-02-20',
        time: '20:30',
        guests: 2,
        status: 'pending',
        notes: null,
      ),
    ];
  }
}
