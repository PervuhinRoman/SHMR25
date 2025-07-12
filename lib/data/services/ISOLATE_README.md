# Десериализация через Изоляты - Документация

## Обзор

Реализована автоматическая десериализация больших ответов API через пул изолятов с использованием библиотеки `worker_manager`. Это улучшает производительность UI при обработке больших объемов данных.

## Принцип работы

### Автоматическое переключение
```dart
// Простая проверка размера перед использованием изолята
bool _shouldUseIsolate(String json) {
  const threshold = 50 * 1024; // 50KB порог
  return json.length > threshold;
}
```

### Универсальный метод десериализации
```dart
Future<T> deserialize<T>(String json) async {
  if (_shouldUseIsolate(json)) {
    return await isolateDeserialize<T>(json); // Через изолят
  } else {
    return _syncDeserialize<T>(json); // Синхронно
  }
}
```

## Конфигурация

### Инициализация в main.dart
```dart
void main() async {
  await WorkerManager().initialize(
    maxWorkers: 2, // Оптимально для мобильных устройств
    taskTimeout: Duration(seconds: 5),
  );
}
```

### Настройки по умолчанию
- **Порог размера**: 50KB
- **Количество изолятов**: 2
- **Таймаут операции**: 5 секунд
- **Приоритет**: High

## Критичные эндпоинты

Автоматически используются изоляты для:
- `/transactions` - списки транзакций
- `/transactions/account` - транзакции по счету
- `/categories` - списки категорий
- `/accounts` - списки счетов

## Поддерживаемые модели

### TransactionResponse
```dart
// Автоматическая десериализация списков транзакций
final transactions = await apiService.getPeriodTransactionsByAccount(1);
```

### Category
```dart
// Десериализация категорий (если размер > 50KB)
final categories = await apiService.getCategories();
```

### Account
```dart
// Десериализация счетов
final accounts = await apiService.getAccounts();
```

## Обработка ошибок

### Минимально жизнеспособная обработка
```dart
Future<T> safeDeserialize<T>(String json) async {
  try {
    return await deserialize<T>(json);
  } catch (e) {
    log('Deserialize error: $e');
    return _syncDeserialize<T>(json); // Fallback
  }
}
```

### Логируемая информация
- Тип ошибки (FormatException и т.д.)
- Размер JSON
- Имя модели

## Производительность

### Простейший замер времени
```dart
void _logPerf(String operation, Duration time) {
  if (time > Duration(milliseconds: 100)) {
    log('$operation took ${time.inMilliseconds}ms');
  }
}
```

### Когда замеряется
- Только для десериализации в изолятах
- Логируются только медленные (>100ms) операции

## Интеграция

### Минимальные изменения
```dart
// В ApiService автоматически используется
final transactions = await apiService.getPeriodTransactionsByAccount(1);
// ↑ Автоматически использует изоляты при необходимости
```

### Совместимость
- Старый код продолжает работать
- Новые вызовы автоматически используют изоляты
- Fallback к синхронной десериализации при ошибках

## Логирование

### Префиксы логов
- `⏱️` - Измерение производительности
- `🔄` - Десериализация через изолят
- `❌` - Ошибки десериализации

### Примеры логов
```
⏱️ Isolate deserialization took 150ms for 75.2KB
🔄 Deserializing TransactionResponse list (1000 items)
❌ Isolate deserialization failed: FormatException
```

## Примеры использования

### Получение больших списков
```dart
// Автоматически использует изолят при размере > 50KB
final transactions = await apiService.getPeriodTransactionsByAccount(
  1,
  startDate: DateTime.now().subtract(Duration(days: 90)),
  endDate: DateTime.now(),
);
```

### Обычные запросы
```dart
// Использует синхронную десериализацию
final categories = await apiService.getCategories();
```

## Преимущества

### 1. Производительность UI
- Десериализация не блокирует главный поток
- Плавная анимация и отзывчивость интерфейса

### 2. Автоматическое переключение
- Не нужно думать о том, когда использовать изоляты
- Оптимальное решение для каждого случая

### 3. Отказоустойчивость
- Fallback к синхронной десериализации
- Логирование ошибок для отладки

### 4. Простота использования
- Минимальные изменения в существующем коде
- Прозрачная работа для разработчиков

## Рекомендации

1. **Мониторьте логи** - следите за производительностью
2. **Тестируйте с реальными данными** - проверяйте на больших объемах
3. **Настройте порог** - адаптируйте под ваши требования
4. **Используйте профилирование** - измеряйте реальную производительность

## Примеры

См. файл `isolate_example.dart` для полных примеров использования всех возможностей десериализации через изоляты. 