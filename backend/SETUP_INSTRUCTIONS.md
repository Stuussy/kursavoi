# Munchly Backend Setup Instructions

## Quick Start Guide

Follow these steps to get the backend up and running:

### Step 1: Install MongoDB

If you don't have MongoDB installed, download and install it:

**Windows:**
1. Download MongoDB Community Server from https://www.mongodb.com/try/download/community
2. Run the installer and follow the setup wizard
3. MongoDB will start automatically as a Windows service

**Mac (using Homebrew):**
```bash
brew tap mongodb/brew
brew install mongodb-community
brew services start mongodb-community
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get install mongodb
sudo systemctl start mongodb
```

Verify MongoDB is running:
```bash
mongosh --eval "db.version()"
```

### Step 2: Install Node.js Dependencies

Navigate to the backend directory and install packages:

```bash
cd backend
npm install
```

This will install:
- express (web framework)
- mongoose (MongoDB ODM)
- bcryptjs (password hashing)
- jsonwebtoken (JWT tokens)
- cors (cross-origin support)
- dotenv (environment variables)
- nodemon (dev auto-reload)

### Step 3: Configure Environment

The `.env` file is already created with default settings:

```env
PORT=3000
MONGODB_URI=mongodb://localhost:27017/munchly
JWT_SECRET=your_secret_key_here_change_in_production
JWT_REFRESH_SECRET=your_refresh_secret_key_here
JWT_EXPIRES_IN=1d
JWT_REFRESH_EXPIRES_IN=7d
```

**IMPORTANT for Production:**
- Change `JWT_SECRET` and `JWT_REFRESH_SECRET` to secure random strings
- Use a stronger MongoDB URI with authentication
- Consider using environment-specific .env files

### Step 4: Start the Server

**Development mode (with auto-reload):**
```bash
npm run dev
```

**Production mode:**
```bash
npm start
```

You should see output like:
```
MongoDB Connected: localhost
Server is running on http://localhost:3000
API available at http://localhost:3000/api

Available endpoints:
  POST   /api/auth/register
  POST   /api/auth/login
  POST   /api/auth/logout
  GET    /api/auth/me
  POST   /api/auth/refresh
  POST   /api/bookings
  GET    /api/bookings/my
  GET    /api/bookings/:id
  DELETE /api/bookings/:id/cancel
```

### Step 5: Test the API

You can test the API using curl, Postman, or any HTTP client:

**Register a new user:**
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"test@example.com\",\"password\":\"password123\",\"name\":\"Test User\"}"
```

**Expected response:**
```json
{
  "data": {
    "user": {
      "id": "...",
      "email": "test@example.com",
      "name": "Test User",
      "phone": null
    },
    "accessToken": "eyJhbGc...",
    "refreshToken": "eyJhbGc..."
  },
  "message": "User registered successfully"
}
```

**Login:**
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"test@example.com\",\"password\":\"password123\"}"
```

**Get current user (requires token):**
```bash
curl http://localhost:3000/api/auth/me \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN_HERE"
```

**Create a booking (requires token):**
```bash
curl -X POST http://localhost:3000/api/bookings \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN_HERE" \
  -d "{\"restaurantId\":\"1\",\"restaurantName\":\"La Bella Italia\",\"tableId\":\"t1\",\"tableNumber\":1,\"date\":\"2024-03-15\",\"time\":\"19:00\",\"guests\":2}"
```

### Step 6: Connect Flutter App

To connect the Flutter app to this backend:

1. Open `lib/config/app_config.dart` in the Flutter project
2. Set `useMockData = false` to use the real API
3. Update the API base URL if needed:
   ```dart
   static const String apiBaseUrl = 'http://localhost:3000/api';
   ```
4. For Android emulator, use `http://10.0.2.2:3000/api`
5. For iOS simulator, use `http://localhost:3000/api`
6. For physical device, use your computer's local IP (e.g., `http://192.168.1.100:3000/api`)

## Troubleshooting

### MongoDB Connection Error

**Error:** `MongooseServerSelectionError: connect ECONNREFUSED 127.0.0.1:27017`

**Solution:**
1. Check if MongoDB is running:
   ```bash
   mongosh
   ```
2. If not running, start it:
   - Windows: Check Windows Services for MongoDB
   - Mac: `brew services start mongodb-community`
   - Linux: `sudo systemctl start mongodb`

### Port Already in Use

**Error:** `Error: listen EADDRINUSE: address already in use :::3000`

**Solution:**
1. Change the PORT in `.env` file to a different port (e.g., 3001)
2. Or find and kill the process using port 3000:
   - Windows: `netstat -ano | findstr :3000` then `taskkill /PID <PID> /F`
   - Mac/Linux: `lsof -ti:3000 | xargs kill`

### JWT Token Errors

**Error:** `Invalid token` or `Token has expired`

**Solution:**
1. Login again to get a new access token
2. Use the refresh token endpoint to get a new access token:
   ```bash
   curl -X POST http://localhost:3000/api/auth/refresh \
     -H "Content-Type: application/json" \
     -d "{\"refreshToken\":\"YOUR_REFRESH_TOKEN\"}"
   ```

### Package Installation Errors

**Error:** `npm ERR! code ENOENT` or similar

**Solution:**
1. Make sure you're in the backend directory
2. Delete `node_modules` folder and `package-lock.json`
3. Run `npm install` again
4. If still failing, try `npm cache clean --force` then `npm install`

## Viewing Database Contents

To view the data in MongoDB:

1. Open MongoDB Shell:
   ```bash
   mongosh
   ```

2. Switch to munchly database:
   ```
   use munchly
   ```

3. View users:
   ```
   db.users.find().pretty()
   ```

4. View bookings:
   ```
   db.bookings.find().pretty()
   ```

5. Count documents:
   ```
   db.users.countDocuments()
   db.bookings.countDocuments()
   ```

## Next Steps

1. Install and start MongoDB
2. Run `npm install` in the backend directory
3. Run `npm run dev` to start the server
4. Test with curl or Postman
5. Connect your Flutter app
6. Start building!

For detailed API documentation, see [BACKEND_API.md](../munchly/BACKEND_API.md)