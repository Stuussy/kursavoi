const express = require('express');
const router = express.Router();
const Restaurant = require('../models/Restaurant');

/**
 * @route   GET /api/restaurants
 * @desc    Get all restaurants (public endpoint)
 * @access  Public
 */
router.get('/', async (req, res) => {
  try {
    const restaurants = await Restaurant.find().sort({ createdAt: -1 });

    res.status(200).json({
      data: restaurants.map(restaurant => ({
        id: restaurant._id,
        name: restaurant.name,
        description: restaurant.description,
        cuisine: restaurant.cuisine,
        address: restaurant.address,
        phone: restaurant.phone,
        rating: restaurant.rating,
        reviewCount: restaurant.reviewCount,
        priceRange: restaurant.priceRange,
        imageUrl: restaurant.imageUrl,
        openingHours: restaurant.openingHours,
        tables: restaurant.tables,
        isOpen: restaurant.isOpen,
        createdAt: restaurant.createdAt,
        updatedAt: restaurant.updatedAt,
      })),
      message: 'Restaurants fetched successfully',
    });
  } catch (error) {
    console.error('Error fetching restaurants:', error);
    res.status(500).json({
      error: {
        code: 'FETCH_ERROR',
        message: 'Failed to fetch restaurants',
      },
    });
  }
});

/**
 * @route   GET /api/restaurants/:id
 * @desc    Get restaurant by ID (public endpoint)
 * @access  Public
 */
router.get('/:id', async (req, res) => {
  try {
    const restaurant = await Restaurant.findById(req.params.id);

    if (!restaurant) {
      return res.status(404).json({
        error: {
          code: 'NOT_FOUND',
          message: 'Restaurant not found',
        },
      });
    }

    res.status(200).json({
      data: {
        id: restaurant._id,
        name: restaurant.name,
        description: restaurant.description,
        cuisine: restaurant.cuisine,
        address: restaurant.address,
        phone: restaurant.phone,
        rating: restaurant.rating,
        reviewCount: restaurant.reviewCount,
        priceRange: restaurant.priceRange,
        imageUrl: restaurant.imageUrl,
        openingHours: restaurant.openingHours,
        tables: restaurant.tables,
        isOpen: restaurant.isOpen,
        createdAt: restaurant.createdAt,
        updatedAt: restaurant.updatedAt,
      },
      message: 'Restaurant fetched successfully',
    });
  } catch (error) {
    console.error('Error fetching restaurant:', error);
    res.status(500).json({
      error: {
        code: 'FETCH_ERROR',
        message: 'Failed to fetch restaurant',
      },
    });
  }
});

module.exports = router;
