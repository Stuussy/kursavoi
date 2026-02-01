# Munchly Backend API

Node.js/Express backend for the Munchly restaurant booking application.

## Features

- User authentication (register, login, logout, refresh token)
- JWT-based authorization
- Restaurant booking management
- MongoDB database integration
- RESTful API design
- Error handling with standardized format

## Tech Stack

- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: MongoDB with Mongoose ODM
- **Authentication**: JWT (jsonwebtoken)
- **Password Hashing**: bcryptjs
- **CORS**: Enabled for cross-origin requests
- **Environment**: dotenv for configuration

## Prerequisites

- Node.js (v16 or higher)
- MongoDB (v5 or higher) running on localhost:27017
- npm or yarn package manager

## Installation

1. Navigate to the backend directory:
```bash
cd backend
```

2. Install dependencies:
```bash
npm install
```

3. Configure environment variables:
Edit the `.env` file and update the values if needed:
```env
PORT=3000
MONGODB_URI=mongodb://localhost:27017/munchly
JWT_SECRET=your_secret_key_here_change_in_production
JWT_REFRESH_SECRET=your_refresh_secret_key_here
JWT_EXPIRES_IN=1d
JWT_REFRESH_EXPIRES_IN=7d
```

## Running the Server

### Development Mode (with auto-reload)
```bash
npm run dev
```

### Production Mode
```bash
npm start
```

The server will start on http://localhost:3000

## API Endpoints

### Base URL
```
http://localhost:3000/api
```

### Authentication Endpoints

- `POST /api/auth/register` - Register a new user
- `POST /api/auth/login` - Login existing user
- `POST /api/auth/logout` - Logout user (requires auth)
- `GET /api/auth/me` - Get current user info (requires auth)
- `POST /api/auth/refresh` - Refresh access token

### Booking Endpoints

- `POST /api/bookings` - Create a new booking (requires auth)
- `GET /api/bookings/my` - Get current user's bookings (requires auth)
- `GET /api/bookings/:id` - Get single booking (requires auth)
- `DELETE /api/bookings/:id/cancel` - Cancel a booking (requires auth)

### Other Endpoints

- `GET /health` - Health check
- `GET /` - API information

## Response Format

### Success Response
```json
{
  "data": { ... },
  "message": "Success message"
}
```

### Error Response
```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Error message"
  }
}
```

## Project Structure

```
backend/
├── src/
│   ├── config/
│   │   └── database.js          # MongoDB connection
│   ├── models/
│   │   ├── User.js              # User model
│   │   └── Booking.js           # Booking model
│   ├── routes/
│   │   ├── auth.js              # Authentication routes
│   │   └── bookings.js          # Booking routes
│   ├── middleware/
│   │   └── auth.js              # JWT authentication middleware
│   └── server.js                # Main server file
├── .env                         # Environment variables
├── .gitignore                   # Git ignore file
├── package.json                 # Dependencies and scripts
└── README.md                    # This file
```

## Testing

You can test the API using tools like:
- **Postman** or **Insomnia** (REST clients)
- **cURL** (command line)
- **Flutter app** (set `useMockData = false` in app_config.dart)

### Example: Register a User
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123",
    "name": "Test User",
    "phone": "+1234567890"
  }'
```

### Example: Create a Booking
```bash
curl -X POST http://localhost:3000/api/bookings \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{
    "restaurantId": "1",
    "restaurantName": "La Bella Italia",
    "tableId": "t1",
    "tableNumber": 1,
    "date": "2024-02-15",
    "time": "19:00",
    "guests": 2
  }'
```

## Database Schema

### Users Collection
```javascript
{
  email: String (unique),
  password: String (hashed),
  name: String,
  phone: String (optional),
  createdAt: Date,
  updatedAt: Date
}
```

### Bookings Collection
```javascript
{
  userId: ObjectId (ref: users),
  restaurantId: String,
  restaurantName: String,
  tableId: String,
  tableNumber: Number,
  date: String (YYYY-MM-DD),
  time: String (HH:MM),
  guests: Number,
  status: String (pending|confirmed|cancelled|completed),
  createdAt: Date,
  updatedAt: Date
}
```

## Security

- Passwords are hashed using bcrypt (10 salt rounds)
- JWT tokens are used for authentication
- Access tokens expire after 1 day
- Refresh tokens expire after 7 days
- All booking endpoints require authentication
- Users can only access their own bookings

## Common Error Codes

- `400` - VALIDATION_ERROR: Invalid input data
- `401` - UNAUTHORIZED: Missing or invalid token
- `403` - FORBIDDEN: Insufficient permissions
- `404` - NOT_FOUND: Resource not found
- `409` - CONFLICT: Duplicate resource (e.g., email already exists)
- `500` - INTERNAL_SERVER_ERROR: Server error

## Troubleshooting

### MongoDB Connection Failed
- Ensure MongoDB is running on localhost:27017
- Check the MONGODB_URI in .env file
- Verify MongoDB service is active

### Port Already in Use
- Change the PORT value in .env file
- Or stop the process using port 3000

### JWT Token Errors
- Ensure JWT_SECRET and JWT_REFRESH_SECRET are set in .env
- Check token expiration times
- Verify the Authorization header format: `Bearer <token>`

## License

ISC