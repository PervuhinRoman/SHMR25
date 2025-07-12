import 'dart:developer';
import 'api_service.dart';

/// Пример использования десериализации через изоляты
class IsolateExample {
  final ApiService _apiService = ApiService();

  /// Пример получения больших списков транзакций
  Future<void> exampleLargeTransactions() async {
    try {
      log('🔄 Получаем большой список транзакций...', name: 'IsolateExample');
      
      // Этот запрос будет автоматически десериализован через изолят
      // если размер ответа превышает 50KB
      final transactions = await _apiService.getPeriodTransactionsByAccount(
        1,
        startDate: DateTime.now().subtract(const Duration(days: 90)), // 3 месяца
        endDate: DateTime.now(),
      );
      
      log('✅ Транзакции получены: ${transactions.length} записей', name: 'IsolateExample');
      
      // Показываем информацию о первых транзакциях
      for (int i = 0; i < transactions.take(3).length; i++) {
        final transaction = transactions[i];
        log('💳 Транзакция ${i + 1}: ${transaction.amount} - ${transaction.category.name}', name: 'IsolateExample');
      }
    } catch (e) {
      log('❌ Ошибка при получении транзакций: $e', name: 'IsolateExample');
    }
  }

  /// Пример получения всех категорий
  Future<void> exampleCategories() async {
    try {
      log('📂 Получаем все категории...', name: 'IsolateExample');
      
      // Категории обычно небольшие, но интерцептор проверит размер
      final categories = await _apiService.getCategories();
      
      log('✅ Категории получены: ${categories.length}', name: 'IsolateExample');
      
      final incomeCategories = categories.where((c) => c.isIncome).toList();
      final expenseCategories = categories.where((c) => !c.isIncome).toList();
      
      log('💰 Доходы: ${incomeCategories.length}, Расходы: ${expenseCategories.length}', name: 'IsolateExample');
    } catch (e) {
      log('❌ Ошибка при получении категорий: $e', name: 'IsolateExample');
    }
  }

  /// Пример получения всех счетов
  Future<void> exampleAccounts() async {
    try {
      log('🏦 Получаем все счета...', name: 'IsolateExample');
      
      final accounts = await _apiService.getAccounts();
      
      log('✅ Счета получены: ${accounts.length}', name: 'IsolateExample');
      
      for (final account in accounts) {
        log('💰 Счет: ${account.name} - ${account.balance} ${account.currency}', name: 'IsolateExample');
      }
    } catch (e) {
      log('❌ Ошибка при получении счетов: $e', name: 'IsolateExample');
    }
  }

  /// Пример симуляции больших данных
  Future<void> simulateLargeData() async {
    try {
      log('🧪 Симулируем получение больших данных...', name: 'IsolateExample');
      
      // Выполняем несколько запросов подряд для демонстрации
      final futures = <Future>[];
      
      // Запросы за разные периоды
      for (int i = 1; i <= 3; i++) {
        futures.add(_apiService.getPeriodTransactionsByAccount(
          1,
          startDate: DateTime.now().subtract(Duration(days: 30 * i)),
          endDate: DateTime.now().subtract(Duration(days: 30 * (i - 1))),
        ));
      }
      
      final results = await Future.wait(futures);
      
      for (int i = 0; i < results.length; i++) {
        final transactions = results[i] as List;
        log('📊 Период ${i + 1}: ${transactions.length} транзакций', name: 'IsolateExample');
      }
      
    } catch (e) {
      log('❌ Ошибка в симуляции: $e', name: 'IsolateExample');
    }
  }

  /// Демонстрация производительности
  Future<void> demonstratePerformance() async {
    try {
      log('⏱️ Демонстрируем производительность...', name: 'IsolateExample');
      
      final startTime = DateTime.now();
      
      // Выполняем запрос, который может использовать изолят
      final transactions = await _apiService.getPeriodTransactionsByAccount(
        1,
        startDate: DateTime.now().subtract(const Duration(days: 60)),
        endDate: DateTime.now(),
      );
      
      final duration = DateTime.now().difference(startTime);
      
      log(
        '📈 Производительность: ${transactions.length} транзакций за ${duration.inMilliseconds}ms',
        name: 'IsolateExample',
      );
      
      // Показываем среднее время на транзакцию
      if (transactions.isNotEmpty) {
        final avgTime = duration.inMicroseconds / transactions.length;
        log('📊 Среднее время на транзакцию: ${avgTime.toStringAsFixed(2)}μs', name: 'IsolateExample');
      }
      
    } catch (e) {
      log('❌ Ошибка в демонстрации производительности: $e', name: 'IsolateExample');
    }
  }

  /// Запуск всех примеров
  Future<void> runAllExamples() async {
    log('🚀 Запускаем примеры десериализации через изоляты', name: 'IsolateExample');
    
    await exampleCategories();
    await exampleAccounts();
    await exampleLargeTransactions();
    await simulateLargeData();
    await demonstratePerformance();
    
    log('✅ Все примеры выполнены', name: 'IsolateExample');
  }
} 