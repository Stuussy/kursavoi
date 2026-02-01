const express = require('express');
const Booking = require('../models/Booking');
const auth = require('../middleware/auth');

const router = express.Router();

// All booking routes require authentication
router.use(auth);

// POST /api/bookings - Create a new booking
router.post('/', async (req, res) => {
  try {
    const { restaurantId, restaurantName, tableId, tableNumber, date, time, guests } = req.body;

    // Validate required fields
    if (!restaurantId || !restaurantName || !tableId || !tableNumber || !date || !time || !guests) {
      return res.status(400).json({
        error: {
          code: 'VALIDATION_ERROR',
          message: 'All booking fields are required',
        },
      });
    }

    // Validate date format (YYYY-MM-DD)
    if (!/^\d{4}-\d{2}-\d{2}$/.test(date)) {
      return res.status(400).json({
        error: {
          code: 'VALIDATION_ERROR',
          message: 'Date must be in YYYY-MM-DD format',
        },
      });
    }

    // Validate time format (HH:MM)
    if (!/^\d{2}:\d{2}$/.test(time)) {
      return res.status(400).json({
        error: {
          code: 'VALIDATION_ERROR',
          message: 'Time must be in HH:MM format',
        },
      });
    }

    // Validate guests
    if (typeof guests !== 'number' || guests < 1) {
      return res.status(400).json({
        error: {
          code: 'VALIDATION_ERROR',
          message: 'Number of guests must be at least 1',
        },
      });
    }

    // Create booking
    const booking = new Booking({
      userId: req.userId,
      restaurantId,
      restaurantName,
      tableId,
      tableNumber,
      date,
      time,
      guests,
      status: 'confirmed',
    });

    await booking.save();

    res.status(201).json({
      data: booking.toJSON(),
      message: 'Booking created successfully',
    });
  } catch (error) {
    console.error('Create booking error:', error);
    res.status(500).json({
      error: {
        code: 'INTERNAL_SERVER_ERROR',
        message: 'Failed to create booking',
      },
    });
  }
});

// GET /api/bookings/my - Get current user's bookings
router.get('/my', async (req, res) => {
  try {
    const bookings = await Booking.find({ userId: req.userId }).sort({ createdAt: -1 });

    const formattedBookings = bookings.map((booking) => booking.toJSON());

    res.status(200).json({
      data: formattedBookings,
      message: 'Bookings fetched successfully',
    });
  } catch (error) {
    console.error('Get my bookings error:', error);
    res.status(500).json({
      error: {
        code: 'INTERNAL_SERVER_ERROR',
        message: 'Failed to fetch bookings',
      },
    });
  }
});

// GET /api/bookings/:id - Get single booking
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;

    // Validate ObjectId format
    if (!id.match(/^[0-9a-fA-F]{24}$/)) {
      return res.status(400).json({
        error: {
          code: 'VALIDATION_ERROR',
          message: 'Invalid booking ID format',
        },
      });
    }

    const booking = await Booking.findById(id);

    if (!booking) {
      return res.status(404).json({
        error: {
          code: 'BOOKING_NOT_FOUND',
          message: 'Booking not found',
        },
      });
    }

    // Check if booking belongs to the current user
    if (booking.userId.toString() !== req.userId) {
      return res.status(403).json({
        error: {
          code: 'FORBIDDEN',
          message: 'You do not have permission to access this booking',
        },
      });
    }

    res.status(200).json({
      data: booking.toJSON(),
      message: 'Booking fetched successfully',
    });
  } catch (error) {
    console.error('Get booking error:', error);
    res.status(500).json({
      error: {
        code: 'INTERNAL_SERVER_ERROR',
        message: 'Failed to fetch booking',
      },
    });
  }
});

// DELETE /api/bookings/:id/cancel - Cancel a booking
router.delete('/:id/cancel', async (req, res) => {
  try {
    const { id } = req.params;

    // Validate ObjectId format
    if (!id.match(/^[0-9a-fA-F]{24}$/)) {
      return res.status(400).json({
        error: {
          code: 'VALIDATION_ERROR',
          message: 'Invalid booking ID format',
        },
      });
    }

    const booking = await Booking.findById(id);

    if (!booking) {
      return res.status(404).json({
        error: {
          code: 'BOOKING_NOT_FOUND',
          message: 'Booking not found',
        },
      });
    }

    // Check if booking belongs to the current user
    if (booking.userId.toString() !== req.userId) {
      return res.status(403).json({
        error: {
          code: 'FORBIDDEN',
          message: 'You do not have permission to cancel this booking',
        },
      });
    }

    // Check if booking is already cancelled
    if (booking.status === 'cancelled') {
      return res.status(400).json({
        error: {
          code: 'ALREADY_CANCELLED',
          message: 'Booking is already cancelled',
        },
      });
    }

    // Update booking status
    booking.status = 'cancelled';
    await booking.save();

    res.status(200).json({
      message: 'Booking cancelled successfully',
    });
  } catch (error) {
    console.error('Cancel booking error:', error);
    res.status(500).json({
      error: {
        code: 'INTERNAL_SERVER_ERROR',
        message: 'Failed to cancel booking',
      },
    });
  }
});

module.exports = router;
