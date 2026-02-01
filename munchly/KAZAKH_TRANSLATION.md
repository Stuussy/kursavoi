# Қазақша аударма / Казахский перевод

## Аяқталды / Завершено

✅ Басты бет (Home) - толық аударылған
✅ Төменгі навигация - толық аударылған
✅ Ас түрлері - толық аударылған

## Қалған тәржімелер / Остальные переводы

Барлық аудармалар `lib/core/l10n/app_localizations_kk.dart` файлында.

### Негізгі экрандар / Основные экраны:

1. **Кіру экраны (Login)**
   - Кіру → Жүйеге кіру
   - Email → Электрондық пошта
   - Password → Құпия сөз

2. **Тіркелу (Register)**
   - Register → Тіркелу
   - Name → Аты-жөні
   - Phone → Телефон нөмірі

3. **Мейрамханалар (Restaurants)**
   - Search restaurants... → Мейрамханаларды іздеу...
   - All Cuisines → Барлық ас түрлері
   - No restaurants found → Мейрамханалар табылмады

4. **Мейрамхана деректемелері (Restaurant Details)**
   - About → Туралы
   - Available Tables → Қолжетімді үстелдер
   - Table → Үстел
   - Capacity → Сыйымдылық
   - Book Now → Қазір брондау

5. **Бронд жасау (Booking)**
   - Complete Booking → Брондауды аяқтау
   - Booking Details → Бронд мәліметтері
   - Date → Күні
   - Time → Уақыты
   - Number of Guests → Қонақтар саны
   - Confirm Booking → Брондауды растау
   - Booking Confirmed! → Бронд расталды!

6. **Менің брондарым (My Bookings)**
   - No bookings yet → Әзірге брондар жоқ
   - Cancel Booking → Брондауды болдырмау
   - Are you sure? → Сенімдісіз бе?
   - Yes, Cancel → Иә, болдырмау

7. **Профиль (Profile)**
   - Account Settings → Аккаунт параметрлері
   - Edit Profile → Профильді өңдеу
   - Favorites → Таңдаулылар
   - Help & Support → Көмек және қолдау
   - Logout → Шығу

## Брондардың күйлері / Статусы бронирований

- Confirmed → Расталған
- Pending → Күтілуде
- Cancelled → Болдырылған
- Completed → Аяқталған

## Ас түрлері / Типы кухонь

- Italian → Итальяндық
- Japanese → Жапондық
- American → Американдық
- Indian → Үнді
- French → Француз
- Mexican → Мексикалық

## Аптаның күндері / Дни недели

- Monday → Дүйсенбі
- Tuesday → Сейсенбі
- Wednesday → Сәрсенбі
- Thursday → Бейсенбі
- Friday → Жұма
- Saturday → Сенбі
- Sunday → Жексенбі

## Айлар / Месяцы

- January → Қаңтар
- February → Ақпан
- March → Наурыз
- April → Сәуір
- May → Мамыр
- June → Маусым
- July → Шілде
- August → Тамыз
- September → Қыркүйек
- October → Қазан
- November → Қараша
- December → Желтоқсан

## Қолдану / Использование

Аудармаларды қолдану үшін мәтіндерді осы файлдағы аудармалармен ауыстырыңыз:

```dart
// Бұрын / Раньше:
Text('Login')

// Енді / Теперь:
Text('Кіру')
```

Немесе константалар файлын қолданыңыз:

```dart
import '../../../../core/l10n/app_localizations_kk.dart';

Text(AppLocalizationsKk.login)
```