# Munchly - Setup Guide

## Запуск приложения с MongoDB

### 1. Запустите MongoDB

Убедитесь, что MongoDB запущена и доступна по адресу:
```
mongodb://localhost:27017/munchly
```

Если MongoDB не установлена:
- **Windows**: Скачайте с https://www.mongodb.com/try/download/community
- **Проверка**: Запустите `mongo --version` в командной строке

### 2. Запустите Backend сервер

```bash
cd o:\Codes\munchly\backend
npm install  # первый раз
npm start
```

Backend должен запуститься на `http://localhost:3000`

### 3. Запустите Flutter приложение

```bash
cd o:\Codes\munchly\munchly
flutter pub get  # первый раз
flutter run
```

## Структура приложения

### Главный экран (Home)
- Избранные рестораны
- Быстрые действия
- Категории кухонь

### Рестораны
- Список всех ресторанов
- Поиск и фильтры
- Детальная информация
- Бронирование столов

### Мои брони
- Список всех бронирований
- Отмена броней
- Статусы бронирований

### Профиль
- Информация о пользователе
- Настройки аккаунта
- Выход из системы

## Тестовые учетные записи

При использовании mock режима (AppConfig.useMockData = true):
- Email: `test@munchly.com`, Password: `password123`
- Email: `demo@munchly.com`, Password: `demo123`

При использовании реальной базы данных:
- Зарегистрируйтесь через приложение

## Конфигурация

Файл: `lib/core/config/app_config.dart`

```dart
class AppConfig {
  // false = MongoDB, true = Mock данные
  static const bool useMockData = false;
}
```

## API Endpoints

### Authentication
- POST `/api/auth/register` - Регистрация
- POST `/api/auth/login` - Вход
- POST `/api/auth/logout` - Выход
- GET `/api/auth/me` - Текущий пользователь

### Bookings
- POST `/api/bookings` - Создать бронь
- GET `/api/bookings/my` - Мои брони
- GET `/api/bookings/:id` - Получить бронь
- DELETE `/api/bookings/:id` - Отменить бронь

## Troubleshooting

### Данные не сохраняются
1. Убедитесь, что MongoDB запущена
2. Проверьте, что backend работает
3. Проверьте `app_config.dart` - должно быть `useMockData = false`

### Ошибка подключения к базе данных
1. Проверьте, что MongoDB доступна на порту 27017
2. Проверьте консоль backend на наличие ошибок
3. Попробуйте перезапустить MongoDB

### Backend не запускается
```bash
cd o:\Codes\munchly\backend
rm -rf node_modules
npm install
npm start
```

## Особенности

✅ Реальное сохранение в MongoDB для:
- Аутентификация (регистрация/вход)
- Бронирования

✅ Mock данные для:
- Рестораны (6 ресторанов разных кухонь)

✅ Функции:
- Регистрация и вход
- Просмотр ресторанов
- Бронирование столов
- Просмотр и отмена броней
- Профиль пользователя
- Bottom navigation

## Архитектура

```
lib/
├── core/               # Основные утилиты
│   ├── config/        # Конфигурация
│   ├── theme/         # Тема приложения
│   └── network/       # HTTP клиент
├── features/          # Модули приложения
│   ├── auth/          # Аутентификация
│   ├── home/          # Главный экран
│   ├── restaurants/   # Рестораны
│   ├── bookings/      # Бронирования
│   ├── profile/       # Профиль
│   └── main/          # Навигация
```

## Цветовая схема

- Primary: Soft Coral Orange (#FF8A65)
- Background: Warm Cream (#FFF8F0)
- Cards: Peachy Cream (#FFEFE0)
- Text: Warm Brown (#5D4E37)
- Secondary: Amber (#FFC107)