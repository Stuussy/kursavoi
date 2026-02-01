import 'package:equatable/equatable.dart';

/// Booking entity
class Booking extends Equatable {
  final String id;
  final String restaurantId;
  final String restaurantName;
  final String tableId;
  final int tableNumber;
  final String userId;
  final DateTime date;
  final String time;
  final int guests;
  final BookingStatus status;

  const Booking({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.tableId,
    required this.tableNumber,
    required this.userId,
    required this.date,
    required this.time,
    required this.guests,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        restaurantId,
        restaurantName,
        tableId,
        tableNumber,
        userId,
        date,
        time,
        guests,
        status,
      ];

  /// Copy with method for updating booking
  Booking copyWith({
    String? id,
    String? restaurantId,
    String? restaurantName,
    String? tableId,
    int? tableNumber,
    String? userId,
    DateTime? date,
    String? time,
    int? guests,
    BookingStatus? status,
  }) {
    return Booking(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      tableId: tableId ?? this.tableId,
      tableNumber: tableNumber ?? this.tableNumber,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      time: time ?? this.time,
      guests: guests ?? this.guests,
      status: status ?? this.status,
    );
  }
}

/// Booking status enum
enum BookingStatus {
  pending,
  confirmed,
  cancelled,
  completed;

  String get displayName {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.completed:
        return 'Completed';
    }
  }
}
