# Authentication Module

Модуль аутентификации для приложения Munchly.

## Архитектура

Модуль построен по принципам Clean Architecture с разделением на 3 слоя:

### Domain Layer (Бизнес-логика)

**Entities:**
- `User` - сущность пользователя
- `AuthTokens` - токены аутентификации (access + refresh)

**Use Cases:**
- `LoginUseCase` - вход в систему
- `RegisterUseCase` - регистрация нового пользователя
- `LogoutUseCase` - выход из системы
- `GetCurrentUserUseCase` - получение текущего пользователя

**Repository Interface:**
- `AuthRepository` - интерфейс репозитория аутентификации

### Data Layer (Источники данных)

**Models:**
- `UserModel` - модель пользователя с JSON serialization
- `AuthTokensModel` - модель токенов с JSON serialization

**Data Sources:**
- `AuthRemoteDataSource` - работа с API (Dio)
- `AuthLocalDataSource` - локальное хранилище (SharedPreferences)

**Repository Implementation:**
- `AuthRepositoryImpl` - реализация репозитория с обработкой ошибок

### Presentation Layer (UI)

**Provider:**
- `AuthProvider` - управление состоянием аутентификации

**Screens:**
- `LoginScreen` - экран входа
- `RegisterScreen` - экран регистрации

**Widgets:**
- `CustomTextField` - переиспользуемое поле ввода

## Состояния аутентификации

```dart
enum AuthState {
  initial,        // Начальное состояние
  loading,        // Загрузка
  authenticated,  // Пользователь авторизован
  unauthenticated, // Пользователь не авторизован
  error,          // Ошибка
}
```

## Использование

### 1. Вход в систему

```dart
final authProvider = context.read<AuthProvider>();

final success = await authProvider.login(
  email: 'user@example.com',
  password: 'password123',
);

if (success) {
  // Переход на главный экран
  context.go('/restaurants');
} else {
  // Показать ошибку
  print(authProvider.errorMessage);
}
```

### 2. Регистрация

```dart
final authProvider = context.read<AuthProvider>();

final success = await authProvider.register(
  email: 'user@example.com',
  password: 'password123',
  name: 'John Doe',
  phone: '+1234567890', // опционально
);
```

### 3. Выход

```dart
final authProvider = context.read<AuthProvider>();
await authProvider.logout();
context.go('/login');
```

### 4. Проверка статуса

```dart
final authProvider = context.watch<AuthProvider>();

if (authProvider.isAuthenticated) {
  // Пользователь авторизован
  print('Welcome, ${authProvider.user?.name}');
}
```

## API Endpoints

Настроены в `core/config/api_config.dart`:

- `POST /auth/login` - вход
- `POST /auth/register` - регистрация
- `POST /auth/logout` - выход
- `POST /auth/refresh` - обновление токена
- `GET /users/me` - текущий пользователь

## Валидация

Используются валидаторы из `core/utils/validators.dart`:

- **Email**: проверка на валидный формат
- **Password**: минимум 8 символов
- **Name**: минимум 2 символа
- **Phone**: опциональное поле

## Хранение данных

Токены и данные пользователя сохраняются в SharedPreferences:

- `access_token` - JWT токен доступа
- `refresh_token` - токен обновления
- `user_id` - ID пользователя

## Обработка ошибок

**Exceptions** (Data Layer):
- `AuthException` - ошибки аутентификации (неверный пароль, пользователь существует)
- `NetworkException` - проблемы с сетью
- `ServerException` - серверные ошибки

**Failures** (Domain Layer):
- `AuthFailure` - ошибка аутентификации
- `NetworkFailure` - нет интернета
- `ServerFailure` - ошибка сервера

## Dependency Injection

Все зависимости настраиваются в `core/config/dependency_injection.dart`:

```dart
await DependencyInjection.init();
final authProvider = DependencyInjection.authProvider;
```

## Тестирование

TODO: Добавить unit и widget тесты

## Следующие шаги

- [ ] Добавить "Forgot Password" функционал
- [ ] Реализовать OAuth (Google, Facebook)
- [ ] Добавить биометрическую аутентификацию
- [ ] Реализовать автоматическое обновление токенов
