import 'package:drift/drift.dart';

/// Тип операции: create, update, delete
class TransactionDiffDB extends Table {
  IntColumn get id => integer()(); // id транзакции (primary key)
  TextColumn get operation => text()(); // 'create', 'update', 'delete'
  TextColumn get transactionJson => text().nullable()(); // json транзакции (для create/update)
  DateTimeColumn get timestamp => dateTime()(); // время операции
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))(); // 'pending', 'syncing', 'error', 'synced'

  @override
  Set<Column> get primaryKey => {id};
} 