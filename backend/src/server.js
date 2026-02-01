require('dotenv').config();
const express = require('express');
const cors = require('cors');
const connectDB = require('./config/database');
const authRoutes = require('./routes/auth');
const bookingsRoutes = require('./routes/bookings');
const favoritesRoutes = require('./routes/favorites');
const adminRoutes = require('./routes/admin');
const restaurantsRoutes = require('./routes/restaurants');

const app = express();
const PORT = process.env.PORT || 3000;

// Connect to MongoDB
connectDB();

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Request logging middleware
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
  next();
});

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/bookings', bookingsRoutes);
app.use('/api/favorites', favoritesRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api/restaurants', restaurantsRoutes);

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    data: {
      status: 'ok',
      timestamp: new Date().toISOString(),
    },
    message: 'Server is healthy',
  });
});

// Root endpoint
app.get('/', (req, res) => {
  res.status(200).json({
    data: {
      name: 'Munchly Backend API',
      version: '1.0.0',
      endpoints: {
        auth: '/api/auth',
        bookings: '/api/bookings',
        favorites: '/api/favorites',
        admin: '/api/admin',
        restaurants: '/api/restaurants',
        health: '/health',
      },
    },
    message: 'Welcome to Munchly Backend API',
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    error: {
      code: 'NOT_FOUND',
      message: 'Endpoint not found',
    },
  });
});

// Global error handler
app.use((err, req, res, next) => {
  console.error('Error:', err);
  res.status(500).json({
    error: {
      code: 'INTERNAL_SERVER_ERROR',
      message: err.message || 'Something went wrong',
    },
  });
});

// Start server
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
  console.log(`API available at http://localhost:${PORT}/api`);
  console.log('\nAvailable endpoints:');
  console.log('  POST   /api/auth/register');
  console.log('  POST   /api/auth/login');
  console.log('  POST   /api/auth/logout');
  console.log('  GET    /api/auth/me');
  console.log('  POST   /api/auth/refresh');
  console.log('  POST   /api/bookings');
  console.log('  GET    /api/bookings/my');
  console.log('  GET    /api/bookings/:id');
  console.log('  DELETE /api/bookings/:id/cancel');
  console.log('  POST   /api/favorites');
  console.log('  GET    /api/favorites/my');
  console.log('  GET    /api/favorites/check/:restaurantId');
  console.log('  DELETE /api/favorites/:restaurantId');
  console.log('  GET    /api/restaurants');
  console.log('  GET    /api/restaurants/:id');
  console.log('  GET    /api/admin/users');
  console.log('  GET    /api/admin/bookings');
  console.log('  GET    /api/admin/restaurants');
  console.log('  POST   /api/admin/restaurants');
  console.log('  PUT    /api/admin/restaurants/:id');
  console.log('  DELETE /api/admin/restaurants/:id');
  console.log('  GET    /api/admin/stats');
});

module.exports = app;
