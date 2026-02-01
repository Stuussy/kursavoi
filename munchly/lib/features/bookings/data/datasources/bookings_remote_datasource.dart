import '../../../../core/config/api_config.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/booking_model.dart';

/// Remote data source for bookings via API
class BookingsRemoteDataSource {
  final DioClient dioClient;

  BookingsRemoteDataSource(this.dioClient);

  /// Create a new booking
  /// Note: userId is automatically taken from auth token by backend
  Future<BookingModel> createBooking({
    required String restaurantId,
    required String restaurantName,
    required String tableId,
    required int tableNumber,
    required String date,
    required String time,
    required int guests,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConfig.createBookingEndpoint,
        data: {
          'restaurantId': restaurantId,
          'restaurantName': restaurantName,
          'tableId': tableId,
          'tableNumber': tableNumber,
          'date': date,
          'time': time,
          'guests': guests,
        },
      );

      if (response.data['data'] != null) {
        return BookingModel.fromJson(response.data['data']);
      }

      throw ServerException('Invalid response format');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  /// Get all bookings for current user
  Future<List<BookingModel>> getMyBookings() async {
    try {
      final response = await dioClient.get(ApiConfig.myBookingsEndpoint);

      if (response.data['data'] != null) {
        final List<dynamic> bookingsJson = response.data['data'];
        return bookingsJson
            .map((json) => BookingModel.fromJson(json))
            .toList();
      }

      return [];
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  /// Get booking by ID
  Future<BookingModel> getBookingById(String id) async {
    try {
      final endpoint = '${ApiConfig.bookingsEndpoint}/$id';
      final response = await dioClient.get(endpoint);

      if (response.data['data'] != null) {
        return BookingModel.fromJson(response.data['data']);
      }

      throw ServerException('Booking not found');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  /// Cancel booking
  Future<void> cancelBooking(String id) async {
    try {
      final endpoint = ApiConfig.cancelBookingEndpoint.replaceAll('{id}', id);
      await dioClient.delete(endpoint);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
