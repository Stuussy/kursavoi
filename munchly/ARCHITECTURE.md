# Архитектура Munchly

## Обзор

Munchly — мобильное приложение для бронирования столиков в ресторанах с интерактивной мини-картой зала.

## Технологический стек

- **Frontend**: Flutter 3.7+
- **Backend**: REST API
- **Database**: MongoDB Atlas
- **Auth**: Email/Password
- **Maps**: Flutter Map (Leaflet для Flutter)

## Архитектура

Проект построен на принципах **Clean Architecture** с разделением по feature-модулям.

### Структура проекта

```
lib/
├── core/                      # Общие компоненты
│   ├── config/               # Конфигурации (API, Router)
│   │   ├── api_config.dart
│   │   └── router.dart
│   ├── constants/            # Константы приложения
│   │   └── app_constants.dart
│   ├── error/                # Обработка ошибок
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/              # HTTP клиент
│   │   └── dio_client.dart
│   ├── theme/                # Темы приложения
│   │   └── app_theme.dart
│   ├── utils/                # Утилиты
│   │   └── validators.dart
│   └── widgets/              # Общие виджеты
│
└── features/                  # Модули функциональности
    ├── auth/                  # Аутентификация
    │   ├── data/
    │   │   ├── datasources/   # API calls
    │   │   ├── models/        # Data models
    │   │   └── repositories/  # Repository implementations
    │   ├── domain/
    │   │   ├── entities/      # Business objects
    │   │   ├── repositories/  # Repository interfaces
    │   │   └── usecases/      # Business logic
    │   └── presentation/
    │       ├── providers/     # State management (Provider)
    │       ├── screens/       # UI screens
    │       └── widgets/       # Feature-specific widgets
    │
    ├── restaurants/           # Рестораны и карта столиков
    │   └── [same structure]
    │
    └── bookings/              # Бронирования
        └── [same structure]
```

## Clean Architecture Layers

### 1. Presentation Layer (presentation/)
- **Screens**: UI экраны
- **Widgets**: Переиспользуемые компоненты
- **Providers**: State management с Provider

### 2. Domain Layer (domain/)
- **Entities**: Бизнес-объекты
- **Repositories**: Интерфейсы репозиториев
- **Usecases**: Бизнес-логика приложения

### 3. Data Layer (data/)
- **Models**: DTO (Data Transfer Objects)
- **Repositories**: Реализации репозиториев
- **Datasources**: Источники данных (API, Local storage)

## Основные зависимости

```yaml
dependencies:
  provider: ^6.1.2              # State management
  dio: ^5.7.0                   # HTTP client
  go_router: ^14.6.2            # Navigation
  flutter_map: ^7.0.2           # Interactive maps
  shared_preferences: ^2.3.3    # Local storage
  equatable: ^2.0.7             # Value equality
  logger: ^2.4.0                # Logging
```

## Features (Модули)

### 1. Authentication (`features/auth/`)
- Регистрация пользователя
- Вход по email/password
- Выход из системы
- Хранение токенов

### 2. Restaurants (`features/restaurants/`)
- Список ресторанов
- Детальная информация о ресторане
- Интерактивная карта зала с столиками
- Выбор столика для бронирования

### 3. Bookings (`features/bookings/`)
- Создание бронирования
- Список моих бронирований
- Отмена бронирования
- История бронирований

## Навигация

Используется `go_router` для декларативной навигации:

**Маршруты:**
- `/login` - Вход
- `/register` - Регистрация
- `/restaurants` - Список ресторанов
- `/restaurants/:id` - Детали ресторана
- `/booking` - Оформление бронирования
- `/my-bookings` - Мои бронирования

## Обработка ошибок

**Exceptions** (data layer):
- `ServerException`
- `NetworkException`
- `CacheException`
- `AuthException`

**Failures** (domain layer):
- `ServerFailure`
- `NetworkFailure`
- `CacheFailure`
- `AuthFailure`

## Валидация

Централизованная валидация форм в `core/utils/validators.dart`:
- Email validation
- Password validation
- Phone validation
- Name validation
- Guest count validation

## Конфигурация API

API endpoints настраиваются в `core/config/api_config.dart`:
- Base URL
- Endpoints для каждого модуля
- Timeouts

## Следующие шаги

1. ✅ Настроена архитектура и структура проекта
2. Реализовать слой данных для аутентификации
3. Создать UI для авторизации
4. Интегрировать Flutter Map для карты столиков
5. Реализовать бизнес-логику бронирования
6. Подключить к backend API
7. Добавить тесты
