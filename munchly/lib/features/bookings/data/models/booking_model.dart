import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/booking.dart';

part 'booking_model.g.dart';

/// Booking data model for API serialization
@JsonSerializable()
class BookingModel {
  final String id;
  final String userId;
  final String restaurantId;
  final String restaurantName;
  final String tableId;
  final int tableNumber;
  final String date;
  final String time;
  final int guests;
  final String status;
  final String? createdAt;

  BookingModel({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    required this.tableId,
    required this.tableNumber,
    required this.date,
    required this.time,
    required this.guests,
    required this.status,
    this.createdAt,
  });

  /// Convert from JSON
  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$BookingModelToJson(this);

  /// Convert to domain entity
  Booking toEntity() {
    return Booking(
      id: id,
      userId: userId,
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      tableId: tableId,
      tableNumber: tableNumber,
      date: DateTime.parse(date),
      time: time,
      guests: guests,
      status: _parseStatus(status),
    );
  }

  /// Convert from domain entity
  factory BookingModel.fromEntity(Booking booking) {
    return BookingModel(
      id: booking.id,
      userId: booking.userId,
      restaurantId: booking.restaurantId,
      restaurantName: booking.restaurantName,
      tableId: booking.tableId,
      tableNumber: booking.tableNumber,
      date: booking.date.toIso8601String().split('T')[0],
      time: booking.time,
      guests: booking.guests,
      status: booking.status.toString().split('.').last,
    );
  }

  BookingStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return BookingStatus.pending;
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'cancelled':
        return BookingStatus.cancelled;
      case 'completed':
        return BookingStatus.completed;
      default:
        return BookingStatus.pending;
    }
  }
}
