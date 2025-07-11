import 'package:drift/drift.dart';

class AccountBriefDB extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get balance => text()();
  TextColumn get currency => text()();
} 