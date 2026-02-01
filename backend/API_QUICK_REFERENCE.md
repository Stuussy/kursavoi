# Munchly API Quick Reference

Base URL: `http://localhost:3000/api`

## Authentication Endpoints

### Register User
```bash
POST /api/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123",
  "name": "John Doe",
  "phone": "+1234567890"  // optional
}
```

### Login
```bash
POST /api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

### Get Current User
```bash
GET /api/auth/me
Authorization: Bearer {accessToken}
```

### Refresh Token
```bash
POST /api/auth/refresh
Content-Type: application/json

{
  "refreshToken": "refresh_token_here"
}
```

### Logout
```bash
POST /api/auth/logout
Authorization: Bearer {accessToken}
```

## Booking Endpoints

### Create Booking
```bash
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
```

### Get My Bookings
```bash
GET /api/bookings/my
Authorization: Bearer {accessToken}
```

### Get Single Booking
```bash
GET /api/bookings/:id
Authorization: Bearer {accessToken}
```

### Cancel Booking
```bash
DELETE /api/bookings/:id/cancel
Authorization: Bearer {accessToken}
```

## Utility Endpoints

### Health Check
```bash
GET /health
```

### API Info
```bash
GET /
```

## cURL Examples

### Register
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123","name":"Test User"}'
```

### Login
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'
```

### Get User
```bash
curl http://localhost:3000/api/auth/me \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### Create Booking
```bash
curl -X POST http://localhost:3000/api/bookings \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{"restaurantId":"1","restaurantName":"La Bella Italia","tableId":"t1","tableNumber":1,"date":"2024-03-15","time":"19:00","guests":2}'
```

### Get Bookings
```bash
curl http://localhost:3000/api/bookings/my \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### Cancel Booking
```bash
curl -X DELETE http://localhost:3000/api/bookings/BOOKING_ID/cancel \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

## Response Formats

### Success Response
```json
{
  "data": { /* response data */ },
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

## Common HTTP Status Codes

- `200` - Success
- `201` - Created
- `400` - Bad Request (validation error)
- `401` - Unauthorized (missing/invalid token)
- `403` - Forbidden (insufficient permissions)
- `404` - Not Found
- `409` - Conflict (duplicate resource)
- `500` - Internal Server Error

## Token Usage

1. Register or login to get tokens
2. Use accessToken in Authorization header: `Bearer {accessToken}`
3. When accessToken expires, use refreshToken to get new tokens
4. Tokens are JWT format with expiration

## Date/Time Formats

- **Date**: YYYY-MM-DD (e.g., "2024-03-15")
- **Time**: HH:MM (e.g., "19:00")

## Environment Setup

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Start production server
npm start
```

## MongoDB Connection

Default: `mongodb://localhost:27017/munchly`

View data:
```bash
mongosh
use munchly
db.users.find().pretty()
db.bookings.find().pretty()
```

## Testing

```bash
# Linux/Mac/Git Bash
./test-api.sh

# Windows
test-api.bat

# Or use Postman/Insomnia
```