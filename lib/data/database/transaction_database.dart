import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables/transaction_response_db.dart';
import 'tables/account_brief_db.dart';
import 'tables/category_db.dart';
import 'package:path_provider/path_provider.dart';

part 'transaction_database.g.dart';

@DriftDatabase(tables: [TransactionResponseDB, AccountBriefDB, CategoryDB])
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
