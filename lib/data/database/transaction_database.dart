import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables/transaction_response_db.dart';
import 'tables/account_brief_db.dart';
import 'tables/category_db.dart';
import 'tables/transaction_diff_db.dart';
import 'package:path_provider/path_provider.dart';

part 'transaction_database.g.dart';

@DriftDatabase(tables: [TransactionResponseDB, AccountBriefDB, CategoryDB, TransactionDiffDB])
class AppDatabase extends _$AppDatabase {
  static final AppDatabase instance = AppDatabase._internal();
  AppDatabase._internal() : super(_openConnection());
  factory AppDatabase() => instance;

  @override
  int get schemaVersion => 1;

  /// Вставка транзакций с учётом связанных аккаунтов и категорий
  Future<void> insertTransactionResponses(
    List<Insertable<TransactionResponseDBData>> transactions,
    List<Insertable<AccountBriefDBData>> accounts,
    List<Insertable<CategoryDBData>> categories,
  ) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(accountBriefDB, accounts);
      batch.insertAllOnConflictUpdate(categoryDB, categories);
      batch.insertAllOnConflictUpdate(transactionResponseDB, transactions);
    });
  }

  /// Получение транзакций за период
  Future<List<TransactionResponseDBData>> getTransactionsByPeriod(
    DateTime start,
    DateTime end,
  ) {
    return (select(transactionResponseDB)..where(
      (tbl) =>
          tbl.transactionDate.isBiggerOrEqualValue(start) &
          tbl.transactionDate.isSmallerOrEqualValue(end),
    )).get();
  }

  /// Удаление транзакций за период
  Future<int> deleteTransactionsByPeriod(DateTime start, DateTime end) {
    return (delete(transactionResponseDB)..where(
      (tbl) =>
          tbl.transactionDate.isBiggerOrEqualValue(start) &
          tbl.transactionDate.isSmallerOrEqualValue(end),
    )).go();
  }

  /// Очистка всех транзакций
  Future<int> clearAllTransactions() {
    return delete(transactionResponseDB).go();
  }

  // Сохранение категорий в кэш
  Future<void> saveCategories(List<Insertable<CategoryDBData>> categories) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(categoryDB, categories);
    });
  }

  // Получение всех категорий из кэша
  Future<List<CategoryDBData>> getCategories() {
    return select(categoryDB).get();
  }

  // Получение категорий по типу (доходы/расходы)
  Future<List<CategoryDBData>> getCategoriesByType(bool isIncome) {
    return (select(categoryDB)
      ..where((c) => c.isIncome.equals(isIncome)))
      .get();
  }

  /// Добавить или обновить diff-операцию (по id транзакции)
  Future<void> upsertTransactionDiff({
    required int id,
    required String operation,
    String? transactionJson,
    required DateTime timestamp,
    String syncStatus = 'pending',
  }) async {
    into(transactionDiffDB).insertOnConflictUpdate(
      TransactionDiffDBCompanion(
        id: Value(id),
        operation: Value(operation),
        transactionJson: Value(transactionJson),
        timestamp: Value(timestamp),
        syncStatus: Value(syncStatus),
      ),
    );
  }

  /// Получить все diff-операции со статусом pending
  Future<List<TransactionDiffDBData>> getPendingDiffs() {
    return (select(transactionDiffDB)..where((tbl) => tbl.syncStatus.equals('pending'))).get();
  }

  /// Удалить diff-операцию по id (после успешной синхронизации)
  Future<int> deleteDiffById(int id) {
    return (delete(transactionDiffDB)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Метод для подключения к БД
  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'app_database',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
