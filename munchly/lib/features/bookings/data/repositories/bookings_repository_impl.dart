import 'package:intl/intl.dart';
import '../../../../core/config/app_config.dart';
import '../../domain/entities/booking.dart';
import '../../domain/repositories/bookings_repository.dart';
import '../datasources/bookings_mock_datasource.dart';
import '../datasources/bookings_remote_datasource.dart';

/// Implementation of BookingsRepository
class BookingsRepositoryImpl implements BookingsRepository {
  final BookingsMockDataSource _mockDataSource;
  final BookingsRemoteDataSource _remoteDataSource;

  BookingsRepositoryImpl({
    required BookingsMockDataSource mockDataSource,
    required BookingsRemoteDataSource remoteDataSource,
  })  : _mockDataSource = mockDataSource,
        _remoteDataSource = remoteDataSource;

  @override
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
    if (AppConfig.useMockData) {
      return await _mockDataSource.createBooking(
        restaurantId: restaurantId,
        restaurantName: restaurantName,
        tableId: tableId,
        tableNumber: tableNumber,
        userId: userId,
        date: date,
        time: time,
        guests: guests,
      );
    } else {
      // Convert DateTime to ISO8601 string for API
      final dateString = DateFormat('yyyy-MM-dd').format(date);

      final model = await _remoteDataSource.createBooking(
        restaurantId: restaurantId,
        restaurantName: restaurantName,
        tableId: tableId,
        tableNumber: tableNumber,
        date: dateString,
        time: time,
        guests: guests,
      );
      return model.toEntity();
    }
  }

  @override
  Future<List<Booking>> getMyBookings(String userId) async {
    if (AppConfig.useMockData) {
      return await _mockDataSource.getBookingsByUser(userId);
    } else {
      final models = await _remoteDataSource.getMyBookings();
      return models.map((model) => model.toEntity()).toList();
    }
  }

  @override
  Future<Booking?> getBookingById(String id) async {
    if (AppConfig.useMockData) {
      return await _mockDataSource.getBookingById(id);
    } else {
      try {
        final model = await _remoteDataSource.getBookingById(id);
        return model.toEntity();
      } catch (e) {
        return null;
      }
    }
  }

  @override
  Future<bool> cancelBooking(String id) async {
    if (AppConfig.useMockData) {
      return await _mockDataSource.cancelBooking(id);
    } else {
      try {
        await _remoteDataSource.cancelBooking(id);
        return true;
      } catch (e) {
        return false;
      }
    }
  }
}
