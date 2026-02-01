const express = require('express');
const Favorite = require('../models/Favorite');
const auth = require('../middleware/auth');

const router = express.Router();

// All favorite routes require authentication
router.use(auth);

// POST /api/favorites - Add restaurant to favorites
router.post('/', async (req, res) => {
  try {
    const {
      restaurantId,
      restaurantName,
      cuisine,
      rating,
      reviewCount,
      address,
      priceRange,
      description,
      isOpen,
    } = req.body;

    // Validate required fields
    if (!restaurantId || !restaurantName || !cuisine || !address || !priceRange || !description) {
      return res.status(400).json({
        error: {
          code: 'VALIDATION_ERROR',
          message: 'All restaurant fields are required',
        },
      });
    }

    // Check if already favorited
    const existingFavorite = await Favorite.findOne({
      userId: req.userId,
      restaurantId,
    });

    if (existingFavorite) {
      return res.status(400).json({
        error: {
          code: 'ALREADY_FAVORITED',
          message: 'Restaurant is already in favorites',
        },
      });
    }

    // Create favorite
    const favorite = new Favorite({
      userId: req.userId,
      restaurantId,
      restaurantName,
      cuisine,
      rating: rating || 0,
      reviewCount: reviewCount || 0,
      address,
      priceRange,
      description,
      isOpen: isOpen !== undefined ? isOpen : true,
    });

    await favorite.save();

    res.status(201).json({
      data: favorite.toJSON(),
      message: 'Restaurant added to favorites',
    });
  } catch (error) {
    console.error('Add to favorites error:', error);
    res.status(500).json({
      error: {
        code: 'INTERNAL_SERVER_ERROR',
        message: 'Failed to add to favorites',
      },
    });
  }
});

// GET /api/favorites/my - Get current user's favorite restaurants
router.get('/my', async (req, res) => {
  try {
    const favorites = await Favorite.find({ userId: req.userId }).sort({ createdAt: -1 });

    const formattedFavorites = favorites.map((favorite) => favorite.toJSON());

    res.status(200).json({
      data: formattedFavorites,
      message: 'Favorites fetched successfully',
    });
  } catch (error) {
    console.error('Get favorites error:', error);
    res.status(500).json({
      error: {
        code: 'INTERNAL_SERVER_ERROR',
        message: 'Failed to fetch favorites',
      },
    });
  }
});

// GET /api/favorites/check/:restaurantId - Check if restaurant is favorited
router.get('/check/:restaurantId', async (req, res) => {
  try {
    const { restaurantId } = req.params;

    const favorite = await Favorite.findOne({
      userId: req.userId,
      restaurantId,
    });

    res.status(200).json({
      data: { isFavorited: !!favorite },
      message: 'Favorite status checked',
    });
  } catch (error) {
    console.error('Check favorite error:', error);
    res.status(500).json({
      error: {
        code: 'INTERNAL_SERVER_ERROR',
        message: 'Failed to check favorite status',
      },
    });
  }
});

// DELETE /api/favorites/:restaurantId - Remove restaurant from favorites
router.delete('/:restaurantId', async (req, res) => {
  try {
    const { restaurantId } = req.params;

    const favorite = await Favorite.findOne({
      userId: req.userId,
      restaurantId,
    });

    if (!favorite) {
      return res.status(404).json({
        error: {
          code: 'FAVORITE_NOT_FOUND',
          message: 'Restaurant not found in favorites',
        },
      });
    }

    await favorite.deleteOne();

    res.status(200).json({
      message: 'Restaurant removed from favorites',
    });
  } catch (error) {
    console.error('Remove from favorites error:', error);
    res.status(500).json({
      error: {
        code: 'INTERNAL_SERVER_ERROR',
        message: 'Failed to remove from favorites',
      },
    });
  }
});

module.exports = router;
