import '../../domain/entities/restaurant.dart';

/// Mock data source for restaurants
class RestaurantsMockDataSource {
  final List<Restaurant> _restaurants = [];

  RestaurantsMockDataSource() {
    _initializeMockData();
  }

  void _initializeMockData() {
    _restaurants.addAll([
      Restaurant(
        id: '1',
        name: 'La Bella Italia',
        description:
            'Authentic Italian cuisine with a modern twist. Fresh pasta made daily and traditional recipes passed down through generations.',
        cuisine: 'Italian',
        address: '123 Main St, Downtown',
        phone: '+1 (555) 123-4567',
        rating: 4.8,
        reviewCount: 342,
        priceRange: '\$\$\$',
        imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&q=80',
        openingHours: ['Mon-Fri: 11:00 AM - 10:00 PM', 'Sat-Sun: 12:00 PM - 11:00 PM'],
        isOpen: true,
        tables: [
          const Table(
            id: 't1',
            restaurantId: '1',
            number: 1,
            capacity: 2,
            isAvailable: true,
            location: 'window',
          ),
          const Table(
            id: 't2',
            restaurantId: '1',
            number: 2,
            capacity: 4,
            isAvailable: true,
            location: 'center',
          ),
          const Table(
            id: 't3',
            restaurantId: '1',
            number: 3,
            capacity: 6,
            isAvailable: false,
            location: 'outdoor',
          ),
          const Table(
            id: 't4',
            restaurantId: '1',
            number: 4,
            capacity: 2,
            isAvailable: true,
            location: 'window',
          ),
          const Table(
            id: 't5',
            restaurantId: '1',
            number: 5,
            capacity: 4,
            isAvailable: true,
            location: 'center',
          ),
        ],
      ),
      Restaurant(
        id: '2',
        name: 'Sushi Master',
        description:
            'Premium sushi and Japanese cuisine. Experience the art of sushi-making with our master chefs.',
        cuisine: 'Japanese',
        address: '456 Ocean Ave, Marina District',
        phone: '+1 (555) 234-5678',
        rating: 4.9,
        reviewCount: 521,
        priceRange: '\$\$\$\$',
        imageUrl: 'https://images.unsplash.com/photo-1579027989536-b7b1f875659b?w=800&q=80',
        openingHours: ['Mon-Sun: 5:00 PM - 11:00 PM'],
        isOpen: true,
        tables: [
          const Table(
            id: 't6',
            restaurantId: '2',
            number: 1,
            capacity: 2,
            isAvailable: true,
            location: 'sushi bar',
          ),
          const Table(
            id: 't7',
            restaurantId: '2',
            number: 2,
            capacity: 4,
            isAvailable: false,
            location: 'private room',
          ),
          const Table(
            id: 't8',
            restaurantId: '2',
            number: 3,
            capacity: 2,
            isAvailable: true,
            location: 'sushi bar',
          ),
          const Table(
            id: 't9',
            restaurantId: '2',
            number: 4,
            capacity: 6,
            isAvailable: true,
            location: 'private room',
          ),
        ],
      ),
      Restaurant(
        id: '3',
        name: 'The Burger Joint',
        description:
            'Gourmet burgers and craft beers. Locally sourced ingredients and unique flavor combinations.',
        cuisine: 'American',
        address: '789 Park Lane, Westside',
        phone: '+1 (555) 345-6789',
        rating: 4.6,
        reviewCount: 287,
        priceRange: '\$\$',
        imageUrl: 'https://images.unsplash.com/photo-1514933651103-005eec06c04b?w=800&q=80',
        openingHours: ['Mon-Sun: 11:00 AM - 10:00 PM'],
        isOpen: true,
        tables: [
          const Table(
            id: 't10',
            restaurantId: '3',
            number: 1,
            capacity: 2,
            isAvailable: true,
            location: 'booth',
          ),
          const Table(
            id: 't11',
            restaurantId: '3',
            number: 2,
            capacity: 4,
            isAvailable: true,
            location: 'booth',
          ),
          const Table(
            id: 't12',
            restaurantId: '3',
            number: 3,
            capacity: 4,
            isAvailable: false,
            location: 'center',
          ),
          const Table(
            id: 't13',
            restaurantId: '3',
            number: 4,
            capacity: 6,
            isAvailable: true,
            location: 'outdoor',
          ),
          const Table(
            id: 't14',
            restaurantId: '3',
            number: 5,
            capacity: 2,
            isAvailable: true,
            location: 'bar',
          ),
        ],
      ),
      Restaurant(
        id: '4',
        name: 'Spice Garden',
        description:
            'Authentic Indian cuisine with bold flavors. Traditional clay oven dishes and aromatic curries.',
        cuisine: 'Indian',
        address: '321 Curry Street, Eastside',
        phone: '+1 (555) 456-7890',
        rating: 4.7,
        reviewCount: 198,
        priceRange: '\$\$',
        imageUrl: 'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=800&q=80',
        openingHours: ['Mon-Sun: 12:00 PM - 10:00 PM'],
        isOpen: true,
        tables: [
          const Table(
            id: 't15',
            restaurantId: '4',
            number: 1,
            capacity: 4,
            isAvailable: true,
            location: 'center',
          ),
          const Table(
            id: 't16',
            restaurantId: '4',
            number: 2,
            capacity: 2,
            isAvailable: true,
            location: 'window',
          ),
          const Table(
            id: 't17',
            restaurantId: '4',
            number: 3,
            capacity: 6,
            isAvailable: false,
            location: 'private room',
          ),
          const Table(
            id: 't18',
            restaurantId: '4',
            number: 4,
            capacity: 4,
            isAvailable: true,
            location: 'center',
          ),
        ],
      ),
      Restaurant(
        id: '5',
        name: 'Le Petit Bistro',
        description:
            'Charming French bistro with classic dishes. Cozy atmosphere and excellent wine selection.',
        cuisine: 'French',
        address: '567 Vineyard Road, Old Town',
        phone: '+1 (555) 567-8901',
        rating: 4.9,
        reviewCount: 445,
        priceRange: '\$\$\$\$',
        imageUrl: 'https://images.unsplash.com/photo-1533777324565-a040eb52facd?w=800&q=80',
        openingHours: ['Tue-Sun: 5:00 PM - 10:00 PM', 'Closed on Mondays'],
        isOpen: false,
        tables: [
          const Table(
            id: 't19',
            restaurantId: '5',
            number: 1,
            capacity: 2,
            isAvailable: true,
            location: 'outdoor',
          ),
          const Table(
            id: 't20',
            restaurantId: '5',
            number: 2,
            capacity: 4,
            isAvailable: true,
            location: 'window',
          ),
          const Table(
            id: 't21',
            restaurantId: '5',
            number: 3,
            capacity: 2,
            isAvailable: false,
            location: 'corner',
          ),
        ],
      ),
      Restaurant(
        id: '6',
        name: 'Taco Fiesta',
        description:
            'Vibrant Mexican street food. Fresh ingredients and authentic recipes from Mexico City.',
        cuisine: 'Mexican',
        address: '890 Salsa Street, South End',
        phone: '+1 (555) 678-9012',
        rating: 4.5,
        reviewCount: 312,
        priceRange: '\$',
        imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&q=80',
        openingHours: ['Mon-Sun: 10:00 AM - 11:00 PM'],
        isOpen: true,
        tables: [
          const Table(
            id: 't22',
            restaurantId: '6',
            number: 1,
            capacity: 4,
            isAvailable: true,
            location: 'outdoor',
          ),
          const Table(
            id: 't23',
            restaurantId: '6',
            number: 2,
            capacity: 4,
            isAvailable: true,
            location: 'outdoor',
          ),
          const Table(
            id: 't24',
            restaurantId: '6',
            number: 3,
            capacity: 6,
            isAvailable: false,
            location: 'center',
          ),
          const Table(
            id: 't25',
            restaurantId: '6',
            number: 4,
            capacity: 2,
            isAvailable: true,
            location: 'bar',
          ),
        ],
      ),
    ]);
  }

  /// Get all restaurants
  List<Restaurant> getAllRestaurants() {
    return List.unmodifiable(_restaurants);
  }

  /// Get restaurant by ID
  Restaurant? getRestaurantById(String id) {
    try {
      return _restaurants.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get restaurants by cuisine
  List<Restaurant> getRestaurantsByCuisine(String cuisine) {
    return _restaurants
        .where((r) => r.cuisine.toLowerCase() == cuisine.toLowerCase())
        .toList();
  }

  /// Search restaurants
  List<Restaurant> searchRestaurants(String query) {
    final lowerQuery = query.toLowerCase();
    return _restaurants.where((r) {
      return r.name.toLowerCase().contains(lowerQuery) ||
          r.cuisine.toLowerCase().contains(lowerQuery) ||
          r.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Get available tables for restaurant
  List<Table> getAvailableTables(String restaurantId) {
    final restaurant = getRestaurantById(restaurantId);
    if (restaurant == null) return [];
    return restaurant.tables.where((t) => t.isAvailable).toList();
  }
}