import 'package:flutter/foundation.dart';
import '../../domain/entities/booking.dart';
import '../../domain/repositories/bookings_repository.dart';

/// Bookings state provider
class BookingsProvider extends ChangeNotifier {
  final BookingsRepository _repository;

  BookingsProvider({required BookingsRepository repository})
      : _repository = repository;

  List<Booking> _bookings = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Booking> get bookings => _bookings;
  int get bookingsCount => _bookings.length;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load user bookings
  Future<void> loadBookings(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _bookings = await _repository.getMyBookings(userId);
    } catch (e) {
      _errorMessage = 'Брондарды жүктеу мүмкін болмады';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create a new booking
  Future<bool> createBooking({
    required String restaurantId,
    required String restaurantName,
    required String tableId,
    required int tableNumber,
    required String userId,
    required DateTime date,
    required String time,
    required int guests,
  }) async {
    try {
      final booking = await _repository.createBooking(
        restaurantId: restaurantId,
        restaurantName: restaurantName,
        tableId: tableId,
        tableNumber: tableNumber,
        userId: userId,
        date: date,
        time: time,
        guests: guests,
      );
      _bookings.add(booking);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Брондау мүмкін болмады';
      notifyListeners();
      return false;
    }
  }

  /// Cancel a booking
  Future<bool> cancelBooking(String bookingId) async {
    try {
      final success = await _repository.cancelBooking(bookingId);
      if (success) {
        final index = _bookings.indexWhere((b) => b.id == bookingId);
        if (index != -1) {
          _bookings[index] = _bookings[index].copyWith(status: BookingStatus.cancelled);
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      _errorMessage = 'Болдырмау мүмкін болмады';
      notifyListeners();
      return false;
    }
  }
}
