/// Favorite restaurant entity
class Favorite {
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

  const Favorite({
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
}
