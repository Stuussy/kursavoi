import '../../domain/entities/booking.dart';

/// Mock data source for bookings
class BookingsMockDataSource {
  final List<Booking> _bookings = _generateInitialBookings();
  int _nextId = 4;

  /// Generate initial mock bookings
  static List<Booking> _generateInitialBookings() {
    final now = DateTime.now();
    return [
      Booking(
        id: 'booking_1',
        restaurantId: '1',
        restaurantName: 'Bella Italia',
        tableId: 'table_1',
        tableNumber: 5,
        userId: 'current-user-id',
        date: now.add(const Duration(days: 2)),
        time: '19:00',
        guests: 2,
        status: BookingStatus.confirmed,
      ),
      Booking(
        id: 'booking_2',
        restaurantId: '2',
        restaurantName: 'Sushi Master',
        tableId: 'table_3',
        tableNumber: 3,
        userId: 'current-user-id',
        date: now.add(const Duration(days: 5)),
        time: '20:30',
        guests: 4,
        status: BookingStatus.pending,
      ),
      Booking(
        id: 'booking_3',
        restaurantId: '3',
        restaurantName: 'American Grill',
        tableId: 'table_2',
        tableNumber: 7,
        userId: 'current-user-id',
        date: now.subtract(const Duration(days: 3)),
        time: '18:00',
        guests: 3,
        status: BookingStatus.completed,
      ),
    ];
  }

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
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    final booking = Booking(
      id: 'booking_${_nextId++}',
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      tableId: tableId,
      tableNumber: tableNumber,
      userId: userId,
      date: date,
      time: time,
      guests: guests,
      status: BookingStatus.confirmed,
    );

    _bookings.add(booking);
    return booking;
  }

  /// Get all bookings
  Future<List<Booking>> getAllBookings() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_bookings);
  }

  /// Get bookings by user ID
  Future<List<Booking>> getBookingsByUser(String userId) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));
    return _bookings.where((b) => b.userId == userId).toList();
  }

  /// Get booking by ID
  Future<Booking?> getBookingById(String id) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _bookings.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Cancel a booking
  Future<bool> cancelBooking(String id) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _bookings.indexWhere((b) => b.id == id);
    if (index != -1) {
      _bookings[index] = _bookings[index].copyWith(
        status: BookingStatus.cancelled,
      );
      return true;
    }
    return false;
  }

  /// Update booking status
  Future<bool> updateBookingStatus(String id, BookingStatus status) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _bookings.indexWhere((b) => b.id == id);
    if (index != -1) {
      _bookings[index] = _bookings[index].copyWith(status: status);
      return true;
    }
    return false;
  }

  /// Get bookings by restaurant ID
  Future<List<Booking>> getBookingsByRestaurant(String restaurantId) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));
    return _bookings.where((b) => b.restaurantId == restaurantId).toList();
  }

  /// Get bookings by date
  Future<List<Booking>> getBookingsByDate(DateTime date) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));
    return _bookings.where((b) {
      return b.date.year == date.year &&
          b.date.month == date.month &&
          b.date.day == date.day;
    }).toList();
  }

  /// Clear all bookings (for testing)
  void clearAllBookings() {
    _bookings.clear();
    _nextId = 1;
  }
}
