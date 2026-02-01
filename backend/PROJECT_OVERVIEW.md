# Munchly Backend - Project Overview

## Summary

A complete Node.js/Express REST API backend for the Munchly restaurant booking application with MongoDB database, JWT authentication, and comprehensive error handling.

## Technology Stack

- **Runtime**: Node.js
- **Framework**: Express.js v4.19.2
- **Database**: MongoDB (via Mongoose v8.3.2)
- **Authentication**: JWT (jsonwebtoken v9.0.2)
- **Password Security**: bcryptjs v2.4.3
- **CORS**: cors v2.8.5
- **Environment Config**: dotenv v16.4.5
- **Dev Tool**: nodemon v3.1.0

## Project Structure

```
backend/
├── src/
│   ├── config/
│   │   └── database.js              # MongoDB connection configuration
│   ├── middleware/
│   │   └── auth.js                  # JWT authentication middleware
│   ├── models/
│   │   ├── User.js                  # User model with bcrypt hashing
│   │   └── Booking.js               # Booking model with validation
│   ├── routes/
│   │   ├── auth.js                  # Auth endpoints (register, login, etc.)
│   │   └── bookings.js              # Booking endpoints (CRUD operations)
│   └── server.js                    # Main application entry point
├── .env                             # Environment variables
├── .gitignore                       # Git ignore rules
├── package.json                     # Dependencies and scripts
├── README.md                        # Main documentation
├── SETUP_INSTRUCTIONS.md            # Step-by-step setup guide
├── PROJECT_OVERVIEW.md              # This file
├── test-api.sh                      # API test script (Bash)
└── test-api.bat                     # API test script (Windows)
```

## Features Implemented

### Authentication System
- ✓ User registration with validation
- ✓ User login with credential verification
- ✓ JWT access tokens (1 day expiry)
- ✓ JWT refresh tokens (7 day expiry)
- ✓ Token refresh endpoint
- ✓ Get current user info
- ✓ Logout endpoint
- ✓ Password hashing with bcrypt (10 rounds)
- ✓ Bearer token authentication

### Booking System
- ✓ Create new bookings
- ✓ Get user's bookings (sorted by date)
- ✓ Get single booking by ID
- ✓ Cancel booking
- ✓ Booking validation (date, time, guests)
- ✓ User authorization (users can only access their own bookings)

### API Response Format
- ✓ Standardized success responses: `{data, message}`
- ✓ Standardized error responses: `{error: {code, message}}`
- ✓ Proper HTTP status codes
- ✓ Detailed error messages

### Security Features
- ✓ Password hashing with bcrypt
- ✓ JWT token-based authentication
- ✓ Protected routes with auth middleware
- ✓ User authorization checks
- ✓ CORS enabled for cross-origin requests
- ✓ Input validation on all endpoints

### Database Models

#### User Schema
```javascript
{
  email: String (unique, required, validated),
  password: String (hashed, required, min 6 chars),
  name: String (required),
  phone: String (optional),
  createdAt: Date,
  updatedAt: Date
}
```

#### Booking Schema
```javascript
{
  userId: ObjectId (ref: User, required),
  restaurantId: String (required),
  restaurantName: String (required),
  tableId: String (required),
  tableNumber: Number (required),
  date: String (YYYY-MM-DD, required),
  time: String (HH:MM, required),
  guests: Number (min: 1, required),
  status: String (pending|confirmed|cancelled|completed),
  createdAt: Date,
  updatedAt: Date
}
```

## API Endpoints

### Base URL: `http://localhost:3000/api`

### Authentication Routes (`/api/auth`)
| Method | Endpoint | Auth Required | Description |
|--------|----------|---------------|-------------|
| POST | `/auth/register` | No | Register new user |
| POST | `/auth/login` | No | Login user |
| POST | `/auth/logout` | Yes | Logout user |
| GET | `/auth/me` | Yes | Get current user |
| POST | `/auth/refresh` | No | Refresh access token |

### Booking Routes (`/api/bookings`)
| Method | Endpoint | Auth Required | Description |
|--------|----------|---------------|-------------|
| POST | `/bookings` | Yes | Create booking |
| GET | `/bookings/my` | Yes | Get user's bookings |
| GET | `/bookings/:id` | Yes | Get single booking |
| DELETE | `/bookings/:id/cancel` | Yes | Cancel booking |

### Utility Routes
| Method | Endpoint | Auth Required | Description |
|--------|----------|---------------|-------------|
| GET | `/` | No | API information |
| GET | `/health` | No | Health check |

## Environment Variables

```env
PORT=3000                                           # Server port
MONGODB_URI=mongodb://localhost:27017/munchly      # MongoDB connection
JWT_SECRET=your_secret_key_here                    # JWT access token secret
JWT_REFRESH_SECRET=your_refresh_secret_key_here    # JWT refresh token secret
JWT_EXPIRES_IN=1d                                  # Access token expiry
JWT_REFRESH_EXPIRES_IN=7d                          # Refresh token expiry
```

## NPM Scripts

```json
{
  "start": "node src/server.js",          // Production mode
  "dev": "nodemon src/server.js",         // Development mode with auto-reload
  "test": "echo \"Error: no test specified\" && exit 1"
}
```

## Error Codes

| HTTP | Code | Description |
|------|------|-------------|
| 400 | VALIDATION_ERROR | Invalid input data |
| 401 | UNAUTHORIZED | Missing or invalid token |
| 401 | INVALID_CREDENTIALS | Wrong email/password |
| 401 | INVALID_TOKEN | Token is invalid |
| 401 | TOKEN_EXPIRED | Token has expired |
| 403 | FORBIDDEN | Insufficient permissions |
| 404 | NOT_FOUND | Resource not found |
| 404 | BOOKING_NOT_FOUND | Booking not found |
| 409 | USER_EXISTS | Email already registered |
| 500 | INTERNAL_SERVER_ERROR | Server error |

## Request/Response Examples

### Register User
```bash
# Request
POST /api/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123",
  "name": "John Doe",
  "phone": "+1234567890"
}

# Response (201)
{
  "data": {
    "user": {
      "id": "65f1234567890abcdef12345",
      "email": "user@example.com",
      "name": "John Doe",
      "phone": "+1234567890"
    },
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  },
  "message": "User registered successfully"
}
```

### Create Booking
```bash
# Request
POST /api/bookings
Authorization: Bearer {accessToken}
Content-Type: application/json

{
  "restaurantId": "1",
  "restaurantName": "La Bella Italia",
  "tableId": "t1",
  "tableNumber": 1,
  "date": "2024-03-15",
  "time": "19:00",
  "guests": 2
}

# Response (201)
{
  "data": {
    "id": "65f1234567890abcdef12346",
    "userId": "65f1234567890abcdef12345",
    "restaurantId": "1",
    "restaurantName": "La Bella Italia",
    "tableId": "t1",
    "tableNumber": 1,
    "date": "2024-03-15",
    "time": "19:00",
    "guests": 2,
    "status": "confirmed",
    "createdAt": "2024-02-10T10:00:00.000Z"
  },
  "message": "Booking created successfully"
}
```

### Error Response
```bash
# Response (401)
{
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Access token is missing or invalid"
  }
}
```

## Quick Start

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Start MongoDB:**
   ```bash
   # Ensure MongoDB is running on localhost:27017
   mongosh  # Test connection
   ```

3. **Start server:**
   ```bash
   npm run dev  # Development with auto-reload
   # or
   npm start    # Production
   ```

4. **Test API:**
   ```bash
   # Linux/Mac/Git Bash
   ./test-api.sh

   # Windows
   test-api.bat
   ```

## Integration with Flutter App

To connect the Flutter app to this backend:

1. Set `useMockData = false` in `lib/config/app_config.dart`
2. Update `apiBaseUrl`:
   - Localhost: `http://localhost:3000/api`
   - Android Emulator: `http://10.0.2.2:3000/api`
   - Physical Device: `http://YOUR_IP:3000/api`

## Testing Tools

- **Postman**: Import endpoints and test manually
- **Insomnia**: REST client alternative
- **curl**: Command-line testing
- **test-api.sh**: Automated test script (Bash)
- **test-api.bat**: Automated test script (Windows)

## Database Management

View data using MongoDB Shell:
```bash
mongosh
use munchly
db.users.find().pretty()
db.bookings.find().pretty()
```

Or use GUI tools:
- MongoDB Compass (official GUI)
- Robo 3T / Studio 3T
- NoSQLBooster

## Middleware Flow

```
Request
  ↓
CORS Middleware
  ↓
JSON Body Parser
  ↓
Request Logger
  ↓
Route Handlers
  ↓
Auth Middleware (for protected routes)
  ↓
Controller Logic
  ↓
Response / Error Handler
```

## Security Best Practices Implemented

1. ✓ Passwords never stored in plain text
2. ✓ JWT tokens with expiration
3. ✓ Separate access and refresh tokens
4. ✓ Authorization checks on protected routes
5. ✓ Input validation on all endpoints
6. ✓ Mongoose schema validation
7. ✓ Error messages don't leak sensitive info
8. ✓ CORS configured for security

## Future Enhancements

Potential improvements for production:
- [ ] Rate limiting (express-rate-limit)
- [ ] Request validation middleware (joi/yup)
- [ ] API documentation (Swagger/OpenAPI)
- [ ] Unit and integration tests (Jest/Mocha)
- [ ] Token blacklist for logout
- [ ] Email verification
- [ ] Password reset functionality
- [ ] Pagination for bookings list
- [ ] Search and filter bookings
- [ ] Admin routes and permissions
- [ ] Logging service (Winston)
- [ ] Environment-based configs
- [ ] Docker containerization
- [ ] CI/CD pipeline

## Documentation Files

- **README.md**: Main project documentation
- **SETUP_INSTRUCTIONS.md**: Detailed setup guide with troubleshooting
- **PROJECT_OVERVIEW.md**: This file - comprehensive overview
- **BACKEND_API.md**: API specification (in munchly directory)

## Support

For issues or questions:
1. Check SETUP_INSTRUCTIONS.md for troubleshooting
2. Verify MongoDB is running
3. Check environment variables in .env
4. Review server logs for errors
5. Test endpoints with curl or Postman

## License

ISC

---

**Created**: January 2026
**Version**: 1.0.0
**Status**: Production Ready