# Админ панель Munchly

## Создание админа

Для создания админского аккаунта выполните:

```bash
cd o:/Codes/munchly/backend
node createAdmin.js
```

Это создаст админа с данными:
- **Email**: `admin@munchly.com`
- **Password**: `admin123`
- **Role**: `admin`

## Вход в админ панель

1. Запустите приложение
2. Войдите с данными админа:
   - Email: `admin@munchly.com`
   - Password: `admin123`
3. Перейдите в **Профиль**
4. Нажмите на **"Админ панель"** (появляется только для админов)

## Функции админ панели

### 1. Қолданушылар (Пользователи)
- Просмотр всех пользователей
- Информация о каждом пользователе

### 2. Брондар (Бронирования)
- Просмотр всех бронирований
- Информация о пользователе для каждого бронирования

### 3. Мейрамханалар (Рестораны)
- Просмотр всех ресторанов
- Добавление новых ресторанов
- Редактирование ресторанов
- Удаление ресторанов

## API Эндпоинты

### Статистика
```
GET /api/admin/stats
```
Возвращает общую статистику:
- Количество пользователей
- Количество бронирований
- Количество ресторанов
- Активные бронирования

### Пользователи
```
GET /api/admin/users
```

### Бронирования
```
GET /api/admin/bookings
```

### Рестораны
```
GET    /api/admin/restaurants
POST   /api/admin/restaurants
PUT    /api/admin/restaurants/:id
DELETE /api/admin/restaurants/:id
```

## Безопасность

- Все админские роуты защищены middleware `adminAuth`
- Доступ имеют только пользователи с `role: 'admin'`
- При попытке доступа обычного пользователя возвращается ошибка 403

## Пример создания ресторана

```bash
POST /api/admin/restaurants
Authorization: Bearer YOUR_TOKEN

{
  "name": "Rumi Restaurant",
  "description": "Modern Central Asian cuisine",
  "cuisine": "Central Asian",
  "address": "123 Main St, Almaty",
  "phone": "+7 777 123 4567",
  "rating": 4.5,
  "reviewCount": 120,
  "priceRange": "$$$",
  "imageUrl": "",
  "openingHours": ["Mon-Fri 11:00-23:00", "Sat-Sun 12:00-00:00"],
  "tables": [
    {
      "number": 1,
      "capacity": 4,
      "location": "Window",
      "isAvailable": true
    }
  ],
  "isOpen": true
}
```
