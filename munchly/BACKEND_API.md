# Munchly Backend API Documentation

## MongoDB Connection
```
mongodb://localhost:27017/munchly
```

## Collections

### users
```json
{
  "_id": ObjectId,
  "email": String (unique),
  "password": String (hashed with bcrypt),
  "name": String,
  "phone": String (optional),
  "createdAt": Date,
  "updatedAt": Date
}
```

### bookings
```json
{
  "_id": ObjectId,
  "userId": ObjectId (ref: users),
  "restaurantId": String,
  "restaurantName": String,
  "tableId": String,
  "tableNumber": Number,
  "date": String (YYYY-MM-DD),
  "time": String (HH:MM),
  "guests": Number,
  "status": String (pending|confirmed|cancelled|completed),
  "createdAt": Date,
  "updatedAt": Date
}
```

## API Endpoints

Base URL: `http://localhost:3000/api`

### Authentication

#### POST /auth/register
Register a new user

**Request:**
```json
{
  "email": "user@example.com",
  "password": "password123",
  "name": "John Doe",
  "phone": "+1234567890" // optional
}
```

**Response (201):**
```json
{
  "data": {
    "user": {
      "id": "user_id",
      "email": "user@example.com",
      "name": "John Doe",
      "phone": "+1234567890"
    },
    "accessToken": "jwt_token_here",
    "refreshToken": "refresh_token_here"
  },
  "message": "User registered successfully"
}
```

#### POST /auth/login
Login existing user

**Request:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response (200):**
```json
{
  "data": {
    "user": {
      "id": "user_id",
      "email": "user@example.com",
      "name": "John Doe",
      "phone": "+1234567890"
    },
    "accessToken": "jwt_token_here",
    "refreshToken": "refresh_token_here"
  },
  "message": "Login successful"
}
```

#### POST /auth/logout
Logout user (requires authentication)

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response (200):**
```json
{
  "message": "Logout successful"
}
```

#### GET /auth/me
Get current user info (requires authentication)

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response (200):**
```json
{
  "data": {
    "id": "user_id",
    "email": "user@example.com",
    "name": "John Doe",
    "phone": "+1234567890"
  },
  "message": "User fetched successfully"
}
```

#### POST /auth/refresh
Refresh access token

**Request:**
```json
{
  "refreshToken": "refresh_token_here"
}
```

**Response (200):**
```json
{
  "data": {
    "accessToken": "new_jwt_token_here",
    "refreshToken": "new_refresh_token_here"
  },
  "message": "Token refreshed successfully"
}
```

### Bookings

#### POST /bookings
Create a new booking (requires authentication)

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Request:**
```json
{
  "restaurantId": "1",
  "restaurantName": "La Bella Italia",
  "tableId": "t1",
  "tableNumber": 1,
  "date": "2024-02-15",
  "time": "19:00",
  "guests": 2
}
```

**Response (201):**
```json
{
  "data": {
    "id": "booking_id",
    "userId": "user_id",
    "restaurantId": "1",
    "restaurantName": "La Bella Italia",
    "tableId": "t1",
    "tableNumber": 1,
    "date": "2024-02-15",
    "time": "19:00",
    "guests": 2,
    "status": "confirmed",
    "createdAt": "2024-02-10T10:00:00.000Z"
  },
  "message": "Booking created successfully"
}
```

#### GET /bookings/my
Get current user's bookings (requires authentication)

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response (200):**
```json
{
  "data": [
    {
      "id": "booking_id",
      "userId": "user_id",
      "restaurantId": "1",
      "restaurantName": "La Bella Italia",
      "tableId": "t1",
      "tableNumber": 1,
      "date": "2024-02-15",
      "time": "19:00",
      "guests": 2,
      "status": "confirmed",
      "createdAt": "2024-02-10T10:00:00.000Z"
    }
  ],
  "message": "Bookings fetched successfully"
}
```

#### DELETE /bookings/:id/cancel
Cancel a booking (requires authentication)

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response (200):**
```json
{
  "message": "Booking cancelled successfully"
}
```

#### GET /bookings/:id
Get single booking (requires authentication)

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response (200):**
```json
{
  "data": {
    "id": "booking_id",
    "userId": "user_id",
    "restaurantId": "1",
    "restaurantName": "La Bella Italia",
    "tableId": "t1",
    "tableNumber": 1,
    "date": "2024-02-15",
    "time": "19:00",
    "guests": 2,
    "status": "confirmed",
    "createdAt": "2024-02-10T10:00:00.000Z"
  },
  "message": "Booking fetched successfully"
}
```

## Error Responses

All error responses follow this format:

**Response (4xx/5xx):**
```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable error message"
  }
}
```

### Common Error Codes

- `400` - Bad Request (invalid input)
- `401` - Unauthorized (missing or invalid token)
- `404` - Not Found (resource doesn't exist)
- `409` - Conflict (duplicate email, etc.)
- `500` - Internal Server Error

## Quick Start Backend Implementation

### 1. Initialize Node.js Project

```bash
mkdir munchly-backend
cd munchly-backend
npm init -y
npm install express mongoose bcryptjs jsonwebtoken cors dotenv
npm install -D nodemon
```

### 2. Create `.env` file

```env
PORT=3000
MONGODB_URI=mongodb://localhost:27017/munchly
JWT_SECRET=your_secret_key_here_change_in_production
JWT_REFRESH_SECRET=your_refresh_secret_key_here
JWT_EXPIRES_IN=1d
JWT_REFRESH_EXPIRES_IN=7d
```

### 3. Project Structure

```
munchly-backend/
├── src/
│   ├── models/
│   │   ├── User.js
│   │   └── Booking.js
│   ├── routes/
│   │   ├── auth.js
│   │   └── bookings.js
│   ├── middleware/
│   │   └── auth.js
│   ├── config/
│   │   └── database.js
│   └── server.js
├── .env
└── package.json
```

### 4. Run Backend

```bash
# Development
npm run dev

# Production
npm start
```

### 5. Testing

Start backend first:
```bash
cd munchly-backend
npm run dev
```

Then in Flutter app, change `app_config.dart`:
```dart
static const bool useMockData = false; // Use real API
```

## Notes

- All dates should be in ISO 8601 format
- All times should be in 24-hour format (HH:MM)
- JWT tokens should expire after 1 day (access) and 7 days (refresh)
- Passwords must be hashed with bcrypt (minimum 10 rounds)
- All endpoints except /auth/register and /auth/login require authentication
- Use Bearer token authentication: `Authorization: Bearer {token}`
