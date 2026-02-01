// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) => BookingModel(
  id: json['id'] as String,
  userId: json['userId'] as String,
  restaurantId: json['restaurantId'] as String,
  restaurantName: json['restaurantName'] as String,
  tableId: json['tableId'] as String,
  tableNumber: (json['tableNumber'] as num).toInt(),
  date: json['date'] as String,
  time: json['time'] as String,
  guests: (json['guests'] as num).toInt(),
  status: json['status'] as String,
  createdAt: json['createdAt'] as String?,
);

Map<String, dynamic> _$BookingModelToJson(BookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'restaurantId': instance.restaurantId,
      'restaurantName': instance.restaurantName,
      'tableId': instance.tableId,
      'tableNumber': instance.tableNumber,
      'date': instance.date,
      'time': instance.time,
      'guests': instance.guests,
      'status': instance.status,
      'createdAt': instance.createdAt,
    };
