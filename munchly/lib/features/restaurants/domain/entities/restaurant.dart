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

  /// Create Restaurant from JSON
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      cuisine: json['cuisine'] as String? ?? '',
      address: json['address'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      priceRange: json['priceRange'] as String? ?? '\$\$',
      imageUrl: json['imageUrl'] as String? ?? '',
      openingHours: (json['openingHours'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      tables: (json['tables'] as List<dynamic>?)
              ?.map((e) => Table.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      isOpen: json['isOpen'] as bool? ?? true,
    );
  }

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

  /// Create Table from JSON
  factory Table.fromJson(Map<String, dynamic> json) {
    return Table(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      restaurantId: json['restaurantId'] as String? ?? '',
      number: json['number'] as int? ?? 0,
      capacity: json['capacity'] as int? ?? 0,
      isAvailable: json['isAvailable'] as bool? ?? true,
      location: json['location'] as String?,
    );
  }

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