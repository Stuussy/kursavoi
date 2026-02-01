import '../../../../core/network/dio_client.dart';
import '../../../../core/error/exceptions.dart';

/// Admin statistics model
class AdminStats {
  final int totalUsers;
  final int totalBookings;
  final int totalRestaurants;
  final int activeBookings;

  AdminStats({
    required this.totalUsers,
    required this.totalBookings,
    required this.totalRestaurants,
    required this.activeBookings,
  });

  factory AdminStats.fromJson(Map<String, dynamic> json) {
    return AdminStats(
      totalUsers: json['totalUsers'] as int,
      totalBookings: json['totalBookings'] as int,
      totalRestaurants: json['totalRestaurants'] as int,
      activeBookings: json['activeBookings'] as int,
    );
  }
}

/// Admin user model
class AdminUser {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String role;
  final String createdAt;

  AdminUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    required this.createdAt,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      role: json['role'] as String,
      createdAt: json['createdAt'] as String,
    );
  }
}

/// Admin booking model
class AdminBooking {
  final String id;
  final String restaurantName;
  final String userName;
  final String userEmail;
  final String date;
  final String time;
  final int guests;
  final String status;
  final String? notes;

  AdminBooking({
    required this.id,
    required this.restaurantName,
    required this.userName,
    required this.userEmail,
    required this.date,
    required this.time,
    required this.guests,
    required this.status,
    this.notes,
  });

  factory AdminBooking.fromJson(Map<String, dynamic> json) {
    // Backend returns user info in nested "user" object
    final user = json['user'] as Map<String, dynamic>?;
    return AdminBooking(
      id: json['id'] as String,
      restaurantName: json['restaurantName'] as String,
      userName: user?['name'] as String? ?? 'Белгісіз',
      userEmail: user?['email'] as String? ?? '',
      date: json['date'] as String,
      time: json['time'] as String,
      guests: json['guests'] as int,
      status: json['status'] as String,
      notes: json['notes'] as String?,
    );
  }
}

/// Admin restaurant model
class AdminRestaurant {
  final String id;
  final String name;
  final String description;
  final String cuisine;
  final String address;
  final String phone;
  final double rating;
  final int reviewCount;
  final String priceRange;
  final String imageUrl;
  final List<String> openingHours;
  final bool isOpen;

  AdminRestaurant({
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
    required this.isOpen,
  });

  factory AdminRestaurant.fromJson(Map<String, dynamic> json) {
    return AdminRestaurant(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      cuisine: json['cuisine'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      priceRange: json['priceRange'] as String,
      imageUrl: json['imageUrl'] as String? ?? '',
      openingHours: (json['openingHours'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      isOpen: json['isOpen'] as bool? ?? true,
    );
  }
}

/// Admin remote data source
class AdminRemoteDataSource {
  final DioClient dioClient;

  AdminRemoteDataSource(this.dioClient);

  /// Get admin statistics
  Future<AdminStats> getStats() async {
    try {
      final response = await dioClient.get('/admin/stats');
      if (response.data['data'] != null) {
        return AdminStats.fromJson(response.data['data']);
      }
      throw ServerException('Invalid response format');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  /// Get all users
  Future<List<AdminUser>> getUsers() async {
    try {
      final response = await dioClient.get('/admin/users');
      if (response.data['data'] != null) {
        final List<dynamic> usersJson = response.data['data'];
        return usersJson.map((json) => AdminUser.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  /// Get all bookings
  Future<List<AdminBooking>> getBookings() async {
    try {
      final response = await dioClient.get('/admin/bookings');
      if (response.data['data'] != null) {
        final List<dynamic> bookingsJson = response.data['data'];
        return bookingsJson.map((json) => AdminBooking.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  /// Get all restaurants
  Future<List<AdminRestaurant>> getRestaurants() async {
    try {
      final response = await dioClient.get('/admin/restaurants');
      if (response.data['data'] != null) {
        final List<dynamic> json = response.data['data'];
        return json.map((e) => AdminRestaurant.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  /// Create restaurant
  Future<AdminRestaurant> createRestaurant({
    required String name,
    required String description,
    required String cuisine,
    required String address,
    required String phone,
    required String priceRange,
    String? imageUrl,
    bool isOpen = true,
  }) async {
    try {
      final response = await dioClient.post('/admin/restaurants', data: {
        'name': name,
        'description': description,
        'cuisine': cuisine,
        'address': address,
        'phone': phone,
        'priceRange': priceRange,
        'imageUrl': imageUrl ?? '',
        'isOpen': isOpen,
      });
      return AdminRestaurant.fromJson(response.data['data']);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  /// Delete restaurant
  Future<void> deleteRestaurant(String id) async {
    try {
      await dioClient.delete('/admin/restaurants/$id');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
