import 'package:equatable/equatable.dart';

/// Restaurant entity
class Restaurant extends Equatable {
  final String id;
  final String name;
  final String description;
  final String cuisine;
  final String address;
  final String phone;
  final double rating;
  final int reviewCount;
  final String priceRange; // $, $$, $$$, $$$$
  final String imageUrl;
  final List<String> openingHours;
  final List<Table> tables;
  final bool isOpen;

  const Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.cuisine,
    required this.address,
    required this.phone,
    required this.rating,
    required this.reviewCount,
    required this.priceRange,
    required this.imageUrl,
    required this.openingHours,
    required this.tables,
    required this.isOpen,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        cuisine,
        address,
        phone,
        rating,
        reviewCount,
        priceRange,
        imageUrl,
        openingHours,
        tables,
        isOpen,
      ];
}

/// Table entity
class Table extends Equatable {
  final String id;
  final String restaurantId;
  final int number;
  final int capacity;
  final bool isAvailable;
  final String? location; // window, center, outdoor, etc.

  const Table({
    required this.id,
    required this.restaurantId,
    required this.number,
    required this.capacity,
    required this.isAvailable,
    this.location,
  });

  @override
  List<Object?> get props => [
        id,
        restaurantId,
        number,
        capacity,
        isAvailable,
        location,
      ];
}