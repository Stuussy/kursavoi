import '../entities/booking.dart';

/// Repository interface for bookings
abstract class BookingsRepository {
  /// Create a new booking
  Future<Booking> createBooking({
    required String restaurantId,
    required String restaurantName,
    required String tableId,
    required int tableNumber,
    required String userId,
    required DateTime date,
    required String time,
    required int guests,
  });

  /// Get all bookings for a user
  Future<List<Booking>> getMyBookings(String userId);

  /// Get a specific booking by ID
  Future<Booking?> getBookingById(String id);

  /// Cancel a booking
  Future<bool> cancelBooking(String id);
}
