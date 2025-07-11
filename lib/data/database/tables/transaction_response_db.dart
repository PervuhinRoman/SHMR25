import 'package:drift/drift.dart';

class TransactionResponseDB extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId =>
      integer().customConstraint('REFERENCES account_brief_db(id)')();
  IntColumn get categoryId =>
      integer().customConstraint('REFERENCES category_db(id)')();
  TextColumn get amount => text()();
  DateTimeColumn get transactionDate => dateTime()();
  TextColumn get comment => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
