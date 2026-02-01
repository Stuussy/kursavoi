@echo off
REM Munchly Backend API Test Script for Windows
REM This script tests the basic endpoints of the Munchly backend
REM Requires curl to be installed (available in Windows 10+)

setlocal enabledelayedexpansion

set BASE_URL=http://localhost:3000
set API_URL=%BASE_URL%/api

echo ==========================================
echo Munchly Backend API Test
echo ==========================================
echo.

REM Test 1: Health Check
echo Test 1: Health Check
echo GET %BASE_URL%/health
curl -s "%BASE_URL%/health"
echo.
echo.

REM Test 2: Register User
echo Test 2: Register New User
echo POST %API_URL%/auth/register
curl -s -X POST "%API_URL%/auth/register" ^
  -H "Content-Type: application/json" ^
  -d "{\"email\":\"testuser@example.com\",\"password\":\"password123\",\"name\":\"Test User\",\"phone\":\"+1234567890\"}"
echo.
echo.

REM Test 3: Login (to get token)
echo Test 3: Login
echo POST %API_URL%/auth/login
curl -s -X POST "%API_URL%/auth/login" ^
  -H "Content-Type: application/json" ^
  -d "{\"email\":\"testuser@example.com\",\"password\":\"password123\"}" > temp_login.json

type temp_login.json
echo.
echo.

REM Extract token (manual step - copy the accessToken from above)
echo NOTE: Copy the accessToken from the login response above
echo Then run these commands manually with your token:
echo.
echo curl -H "Authorization: Bearer YOUR_TOKEN" %API_URL%/auth/me
echo.
echo curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer YOUR_TOKEN" -d "{\"restaurantId\":\"1\",\"restaurantName\":\"La Bella Italia\",\"tableId\":\"t1\",\"tableNumber\":1,\"date\":\"2024-03-15\",\"time\":\"19:00\",\"guests\":2}" %API_URL%/bookings
echo.
echo curl -H "Authorization: Bearer YOUR_TOKEN" %API_URL%/bookings/my
echo.

del temp_login.json 2>nul

echo ==========================================
echo Basic Test Complete!
echo ==========================================
echo.
echo For full testing with authentication, use the test-api.sh script
echo with Git Bash or WSL, or test manually with Postman/Insomnia.

pause