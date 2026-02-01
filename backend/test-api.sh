#!/bin/bash

# Munchly Backend API Test Script
# This script tests the basic endpoints of the Munchly backend

BASE_URL="http://localhost:3000"
API_URL="$BASE_URL/api"

echo "=========================================="
echo "Munchly Backend API Test"
echo "=========================================="
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test 1: Health Check
echo -e "${YELLOW}Test 1: Health Check${NC}"
echo "GET $BASE_URL/health"
RESPONSE=$(curl -s -w "\n%{http_code}" "$BASE_URL/health")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | head -n-1)

if [ "$HTTP_CODE" == "200" ]; then
    echo -e "${GREEN}✓ Health check passed${NC}"
    echo "$BODY" | jq .
else
    echo -e "${RED}✗ Health check failed (HTTP $HTTP_CODE)${NC}"
fi
echo ""

# Test 2: Register User
echo -e "${YELLOW}Test 2: Register New User${NC}"
echo "POST $API_URL/auth/register"
REGISTER_DATA='{
  "email": "testuser@example.com",
  "password": "password123",
  "name": "Test User",
  "phone": "+1234567890"
}'

RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$API_URL/auth/register" \
  -H "Content-Type: application/json" \
  -d "$REGISTER_DATA")

HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | head -n-1)

if [ "$HTTP_CODE" == "201" ]; then
    echo -e "${GREEN}✓ User registration successful${NC}"
    ACCESS_TOKEN=$(echo "$BODY" | jq -r '.data.accessToken')
    REFRESH_TOKEN=$(echo "$BODY" | jq -r '.data.refreshToken')
    echo "$BODY" | jq .
else
    echo -e "${RED}✗ User registration failed (HTTP $HTTP_CODE)${NC}"
    echo "$BODY" | jq .

    # Try login instead if user already exists
    if [ "$HTTP_CODE" == "409" ]; then
        echo -e "${YELLOW}User exists, trying login instead...${NC}"
        LOGIN_DATA='{
          "email": "testuser@example.com",
          "password": "password123"
        }'

        RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$API_URL/auth/login" \
          -H "Content-Type: application/json" \
          -d "$LOGIN_DATA")

        HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
        BODY=$(echo "$RESPONSE" | head -n-1)

        if [ "$HTTP_CODE" == "200" ]; then
            echo -e "${GREEN}✓ Login successful${NC}"
            ACCESS_TOKEN=$(echo "$BODY" | jq -r '.data.accessToken')
            REFRESH_TOKEN=$(echo "$BODY" | jq -r '.data.refreshToken')
            echo "$BODY" | jq .
        fi
    fi
fi
echo ""

# Test 3: Get Current User
echo -e "${YELLOW}Test 3: Get Current User Info${NC}"
echo "GET $API_URL/auth/me"

if [ -z "$ACCESS_TOKEN" ]; then
    echo -e "${RED}✗ Skipping (no access token)${NC}"
else
    RESPONSE=$(curl -s -w "\n%{http_code}" "$API_URL/auth/me" \
      -H "Authorization: Bearer $ACCESS_TOKEN")

    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    BODY=$(echo "$RESPONSE" | head -n-1)

    if [ "$HTTP_CODE" == "200" ]; then
        echo -e "${GREEN}✓ Get user info successful${NC}"
        echo "$BODY" | jq .
    else
        echo -e "${RED}✗ Get user info failed (HTTP $HTTP_CODE)${NC}"
        echo "$BODY" | jq .
    fi
fi
echo ""

# Test 4: Create Booking
echo -e "${YELLOW}Test 4: Create Booking${NC}"
echo "POST $API_URL/bookings"

if [ -z "$ACCESS_TOKEN" ]; then
    echo -e "${RED}✗ Skipping (no access token)${NC}"
else
    BOOKING_DATA='{
      "restaurantId": "1",
      "restaurantName": "La Bella Italia",
      "tableId": "t1",
      "tableNumber": 1,
      "date": "2024-03-15",
      "time": "19:00",
      "guests": 2
    }'

    RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$API_URL/bookings" \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $ACCESS_TOKEN" \
      -d "$BOOKING_DATA")

    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    BODY=$(echo "$RESPONSE" | head -n-1)

    if [ "$HTTP_CODE" == "201" ]; then
        echo -e "${GREEN}✓ Booking created successfully${NC}"
        BOOKING_ID=$(echo "$BODY" | jq -r '.data.id')
        echo "$BODY" | jq .
    else
        echo -e "${RED}✗ Create booking failed (HTTP $HTTP_CODE)${NC}"
        echo "$BODY" | jq .
    fi
fi
echo ""

# Test 5: Get My Bookings
echo -e "${YELLOW}Test 5: Get My Bookings${NC}"
echo "GET $API_URL/bookings/my"

if [ -z "$ACCESS_TOKEN" ]; then
    echo -e "${RED}✗ Skipping (no access token)${NC}"
else
    RESPONSE=$(curl -s -w "\n%{http_code}" "$API_URL/bookings/my" \
      -H "Authorization: Bearer $ACCESS_TOKEN")

    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    BODY=$(echo "$RESPONSE" | head -n-1)

    if [ "$HTTP_CODE" == "200" ]; then
        echo -e "${GREEN}✓ Get bookings successful${NC}"
        echo "$BODY" | jq .
    else
        echo -e "${RED}✗ Get bookings failed (HTTP $HTTP_CODE)${NC}"
        echo "$BODY" | jq .
    fi
fi
echo ""

# Test 6: Cancel Booking
if [ -n "$BOOKING_ID" ] && [ "$BOOKING_ID" != "null" ]; then
    echo -e "${YELLOW}Test 6: Cancel Booking${NC}"
    echo "DELETE $API_URL/bookings/$BOOKING_ID/cancel"

    RESPONSE=$(curl -s -w "\n%{http_code}" -X DELETE "$API_URL/bookings/$BOOKING_ID/cancel" \
      -H "Authorization: Bearer $ACCESS_TOKEN")

    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    BODY=$(echo "$RESPONSE" | head -n-1)

    if [ "$HTTP_CODE" == "200" ]; then
        echo -e "${GREEN}✓ Booking cancelled successfully${NC}"
        echo "$BODY" | jq .
    else
        echo -e "${RED}✗ Cancel booking failed (HTTP $HTTP_CODE)${NC}"
        echo "$BODY" | jq .
    fi
    echo ""
fi

# Test 7: Refresh Token
echo -e "${YELLOW}Test 7: Refresh Token${NC}"
echo "POST $API_URL/auth/refresh"

if [ -z "$REFRESH_TOKEN" ]; then
    echo -e "${RED}✗ Skipping (no refresh token)${NC}"
else
    REFRESH_DATA=$(cat <<EOF
{
  "refreshToken": "$REFRESH_TOKEN"
}
EOF
)

    RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$API_URL/auth/refresh" \
      -H "Content-Type: application/json" \
      -d "$REFRESH_DATA")

    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    BODY=$(echo "$RESPONSE" | head -n-1)

    if [ "$HTTP_CODE" == "200" ]; then
        echo -e "${GREEN}✓ Token refresh successful${NC}"
        echo "$BODY" | jq .
    else
        echo -e "${RED}✗ Token refresh failed (HTTP $HTTP_CODE)${NC}"
        echo "$BODY" | jq .
    fi
fi
echo ""

echo "=========================================="
echo "Test Complete!"
echo "=========================================="