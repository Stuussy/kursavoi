import '../../domain/entities/favorite.dart';

/// Favorite restaurant model
class FavoriteModel {
  final String id;
  final String userId;
  final String restaurantId;
  final String restaurantName;
  final String cuisine;
  final double rating;
  final int reviewCount;
  final String address;
  final String priceRange;
  final String description;
  final bool isOpen;
  final DateTime createdAt;

  const FavoriteModel({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    required this.cuisine,
    required this.rating,
    required this.reviewCount,
    required this.address,
    required this.priceRange,
    required this.description,
    required this.isOpen,
    required this.createdAt,
  });

  /// Convert model to entity
  Favorite toEntity() {
    return Favorite(
      id: id,
      userId: userId,
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      cuisine: cuisine,
      rating: rating,
      reviewCount: reviewCount,
      address: address,
      priceRange: priceRange,
      description: description,
      isOpen: isOpen,
      createdAt: createdAt,
    );
  }

  /// Create model from JSON
  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      restaurantId: json['restaurantId'] as String,
      restaurantName: json['restaurantName'] as String,
      cuisine: json['cuisine'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      address: json['address'] as String,
      priceRange: json['priceRange'] as String,
      description: json['description'] as String,
      isOpen: json['isOpen'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'cuisine': cuisine,
      'rating': rating,
      'reviewCount': reviewCount,
      'address': address,
      'priceRange': priceRange,
      'description': description,
      'isOpen': isOpen,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
