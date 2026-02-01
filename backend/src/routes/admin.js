const express = require('express');
const User = require('../models/User');
const Booking = require('../models/Booking');
const Restaurant = require('../models/Restaurant');
const auth = require('../middleware/auth');
const adminAuth = require('../middleware/adminAuth');

const router = express.Router();

// All admin routes require authentication and admin role
router.use(auth);
router.use(adminAuth);

// ==================== USERS MANAGEMENT ====================

// GET /api/admin/users - Get all users
router.get('/users', async (req, res) => {
  try {
    const users = await User.find().sort({ createdAt: -1 });

    res.status(200).json({
      data: users.map(user => user.toJSON()),
      message: 'Users fetched successfully',
    });
  } catch (error) {
    console.error('Get users error:', error);
    res.status(500).json({
      error: {
        code: 'INTERNAL_SERVER_ERROR',
        message: 'Failed to fetch users',
      },
    });
  }
});

// ==================== BOOKINGS MANAGEMENT ====================

// GET /api/admin/bookings - Get all bookings
router.get('/bookings', async (req, res) => {
  try {
    const bookings = await Booking.find().sort({ createdAt: -1 });

    // Populate with user info
    const bookingsWithUsers = await Promise.all(
      bookings.map(async (booking) => {
        const user = await User.findById(booking.userId);
        const bookingObj = booking.toJSON();
        bookingObj.user = user ? { name: user.name, email: user.email } : null;
        return bookingObj;
      })
    );

    res.status(200).json({
      data: bookingsWithUsers,
      message: 'All bookings fetched successfully',
    });
  } catch (error) {
    console.error('Get all bookings error:', error);
    res.status(500).json({
      error: {
        code: 'INTERNAL_SERVER_ERROR',
        message: 'Failed to fetch bookings',
      },
    });
  }
});

// ==================== RESTAURANTS MANAGEMENT ====================

// GET /api/admin/restaurants - Get all restaurants
router.get('/restaurants', async (req, res) => {
  try {
    const restaurants = await Restaurant.find().sort({ createdAt: -1 });

    res.status(200).json({
      data: restaurants.map(restaurant => restaurant.toJSON()),
      message: 'Restaurants fetched successfully',
    });
  } catch (error) {
    console.error('Get restaurants error:', error);
    res.status(500).json({
      error: {
        code: 'INTERNAL_SERVER_ERROR',
        message: 'Failed to fetch restaurants',
      },
    });
  }
});

// POST /api/admin/restaurants - Create new restaurant
router.post('/restaurants', async (req, res) => {
  try {
    const {
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
    } = req.body;

    // Validate required fields
    if (!name || !description || !cuisine || !address || !phone || !priceRange) {
      return res.status(400).json({
        error: {
          code: 'VALIDATION_ERROR',
          message: 'All required restaurant fields must be provided',
        },
      });
    }

    const restaurant = new Restaurant({
      name,
      description,
      cuisine,
      address,
      phone,
      rating: rating || 0,
      reviewCount: reviewCount || 0,
      priceRange,
      imageUrl: imageUrl || '',
      openingHours: openingHours || [],
      tables: tables || [],
      isOpen: isOpen !== undefined ? isOpen : true,
    });

    await restaurant.save();

    res.status(201).json({
      data: restaurant.toJSON(),
      message: 'Restaurant created successfully',
    });
  } catch (error) {
    console.error('Create restaurant error:', error);
    res.status(500).json({
      error: {
        code: 'INTERNAL_SERVER_ERROR',
        message: 'Failed to create restaurant',
      },
    });
  }
});

// PUT /api/admin/restaurants/:id - Update restaurant
router.put('/restaurants/:id', async (req, res) => {
  try {
    const { id } = req.params;

    // Validate ObjectId format
    if (!id.match(/^[0-9a-fA-F]{24}$/)) {
      return res.status(400).json({
        error: {
          code: 'VALIDATION_ERROR',
          message: 'Invalid restaurant ID format',
        },
      });
    }

    const restaurant = await Restaurant.findByIdAndUpdate(
      id,
      { $set: req.body },
      { new: true, runValidators: true }
    );

    if (!restaurant) {
      return res.status(404).json({
        error: {
          code: 'RESTAURANT_NOT_FOUND',
          message: 'Restaurant not found',
        },
      });
    }

    res.status(200).json({
      data: restaurant.toJSON(),
      message: 'Restaurant updated successfully',
    });
  } catch (error) {
    console.error('Update restaurant error:', error);
    res.status(500).json({
      error: {
        code: 'INTERNAL_SERVER_ERROR',
        message: 'Failed to update restaurant',
      },
    });
  }
});

// DELETE /api/admin/restaurants/:id - Delete restaurant
router.delete('/restaurants/:id', async (req, res) => {
  try {
    const { id } = req.params;

    // Validate ObjectId format
    if (!id.match(/^[0-9a-fA-F]{24}$/)) {
      return res.status(400).json({
        error: {
          code: 'VALIDATION_ERROR',
          message: 'Invalid restaurant ID format',
        },
      });
    }

    const restaurant = await Restaurant.findByIdAndDelete(id);

    if (!restaurant) {
      return res.status(404).json({
        error: {
          code: 'RESTAURANT_NOT_FOUND',
          message: 'Restaurant not found',
        },
      });
    }

    res.status(200).json({
      message: 'Restaurant deleted successfully',
    });
  } catch (error) {
    console.error('Delete restaurant error:', error);
    res.status(500).json({
      error: {
        code: 'INTERNAL_SERVER_ERROR',
        message: 'Failed to delete restaurant',
      },
    });
  }
});

// ==================== STATISTICS ====================

// GET /api/admin/stats - Get admin statistics
router.get('/stats', async (req, res) => {
  try {
    const totalUsers = await User.countDocuments();
    const totalBookings = await Booking.countDocuments();
    const totalRestaurants = await Restaurant.countDocuments();
    const activeBookings = await Booking.countDocuments({ status: 'confirmed' });

    res.status(200).json({
      data: {
        totalUsers,
        totalBookings,
        totalRestaurants,
        activeBookings,
      },
      message: 'Statistics fetched successfully',
    });
  } catch (error) {
    console.error('Get stats error:', error);
    res.status(500).json({
      error: {
        code: 'INTERNAL_SERVER_ERROR',
        message: 'Failed to fetch statistics',
      },
    });
  }
});

module.exports = router;
