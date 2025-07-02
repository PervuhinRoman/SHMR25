import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TransactionDatabase {
  static final TransactionDatabase instance = TransactionDatabase._init();
  static Database? _database;

  TransactionDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('transactions.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions(
        id TEXT PRIMARY KEY,
        amount REAL,
        category TEXT,
        date TEXT,
        note TEXT
      )
    ''');
  }

  Future<void> insertTransaction(Map<String, dynamic> json) async {
    final db = await instance.database;
    await db.insert(
      'transactions',
      json,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getTransactionsByDate(String date) async {
    final db = await instance.database;
    final result = await db.query(
      'transactions',
      where: 'date = ?',
      whereArgs: [date],
    );
    log(
      '📖 Загружено из кэша за дату $date: ${result.length} транзакций',
      time: DateTime.now(),
    );
    return result;
  }

  Future<List<Map<String, dynamic>>> getTransactionsByPeriod(
    String startDate,
    String endDate,
  ) async {
    final db = await instance.database;
    final result = await db.query(
      'transactions',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startDate, endDate],
    );
    log(
      '📖 Загружено из кэша за период $startDate - $endDate: ${result.length} транзакций',
      name: "TransactionDatabase",
    );
    return result;
  }

  Future<void> saveTransactionsForPeriod(
    List<Map<String, dynamic>> transactions,
    String startDate,
    String endDate,
  ) async {
    final db = await instance.database;
    log('🗑️ Удаление старых транзакций за период $startDate - $endDate');
    // Удаляем старые транзакции за этот период
    await db.delete(
      'transactions',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startDate, endDate],
    );
    // Вставляем новые
    for (final transaction in transactions) {
      await db.insert(
        'transactions',
        transaction,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    log(
      '💾 Сохранено в кэш за период $startDate - $endDate: ${transactions.length} транзакций',
    );
  }

  Future<void> clearTransactions() async {
    final db = await instance.database;
    await db.delete('transactions');
  }

  Future close() async {
    final db = _database;
    if (db != null) {
      await db.close();
    }
  }
}
