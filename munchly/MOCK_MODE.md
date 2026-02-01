# Mock Mode - Разработка без Backend

Mock режим позволяет разрабатывать и тестировать UI приложения без подключения к реальному backend API.

## Включение Mock Mode

В файле [lib/core/config/app_config.dart](lib/core/config/app_config.dart):

```dart
class AppConfig {
  static const bool useMockData = true;  // true - mock режим, false - real API
}
```

## Тестовые учетные данные

При включенном mock режиме доступны следующие аккаунты:

### Аккаунт 1
- **Email**: `test@munchly.com`
- **Password**: `password123`
- **Name**: Test User
- **Phone**: +1234567890

### Аккаунт 2
- **Email**: `demo@munchly.com`
- **Password**: `demo123`
- **Name**: Demo User

## Возможности Mock Mode

✅ **Регистрация** - можно регистрировать новых пользователей
✅ **Вход** - работает с тестовыми аккаунтами
✅ **Выход** - очистка сессии
✅ **Валидация** - все проверки работают как с real API
✅ **Задержки** - эмуляция сетевых задержек (1 сек для login/register)

## Особенности

1. **Данные в памяти** - все данные хранятся только в runtime, перезапуск сбрасывает базу
2. **Токены** - генерируются mock токены, сохраняются в SharedPreferences
3. **Ошибки** - эмулируются реальные ошибки (неверный пароль, пользователь существует)

## Переключение на Real API

Когда backend будет готов:

1. Откройте [lib/core/config/app_config.dart](lib/core/config/app_config.dart)
2. Измените `useMockData` на `false`
3. Настройте URL в [lib/core/config/api_config.dart](lib/core/config/api_config.dart)

```dart
class AppConfig {
  static const bool useMockData = false;  // Использовать real API
}
```

```dart
class ApiConfig {
  static const String baseUrl = 'https://your-backend-url.com';
}
```

## Добавление тестовых пользователей

В [lib/core/config/dependency_injection.dart](lib/core/config/dependency_injection.dart):

```dart
if (AppConfig.useMockData) {
  _authMockDataSource = AuthMockDataSource();

  // Добавьте своих пользователей
  _authMockDataSource!.addTestUser(
    email: 'your@email.com',
    password: 'yourpassword',
    name: 'Your Name',
    phone: '+1234567890', // опционально
  );

  authRemoteDataSource = _authMockDataSource!;
}
```

## UI подсказки

При включенном mock режиме на экране логина отображается подсказка с тестовыми учетными данными:

- Синяя карточка с credentials
- Кнопка копирования для быстрого заполнения
- Информация о возможности регистрации

## Что дальше?

После тестирования UI в mock режиме:

1. Разработайте REST API backend
2. Настройте endpoints в `api_config.dart`
3. Переключите `useMockData = false`
4. Протестируйте с реальным API

## Структура Mock DataSource

Mock data source реализует интерфейс `AuthRemoteDataSource`:

```dart
class AuthMockDataSource implements AuthRemoteDataSource {
  final List<Map<String, dynamic>> _users = [];  // In-memory storage
  String? _currentUserId;

  Future<AuthTokensModel> login(...) { }
  Future<AuthTokensModel> register(...) { }
  Future<void> logout() { }
  Future<UserModel> getCurrentUser() { }
  Future<AuthTokensModel> refreshToken(...) { }
}
```

Все методы эмулируют задержки сети и возвращают корректные данные.
