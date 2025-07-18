import 'dart:convert';
import 'dart:developer';

import 'package:shmr_finance/data/database/transaction_database.dart';
import 'package:shmr_finance/data/services/api_service.dart';
import 'package:shmr_finance/domain/models/transaction/transaction.dart';

class TransactionSyncService {
  final AppDatabase _db;
  final ApiService _apiService;

  TransactionSyncService({
    AppDatabase? db,
    ApiService? apiService,
  })  : _db = db ?? AppDatabase.instance,
        _apiService = apiService ?? ApiService();

  /// Синхронизировать все pending diff-операции
  Future<void> syncPendingDiffs() async {
    final diffs = await _db.getPendingDiffs();
    for (final diff in diffs) {
      try {
        switch (diff.operation) {
          case 'create':
            final req = TransactionRequest.fromJson(jsonDecode(diff.transactionJson!));
            final created = await _apiService.createTransaction(req);
            log('✅ Синхронизирована create-операция для транзакции id=${created.id}', name: 'TransactionSync');
            break;
          case 'update':
            final req = TransactionRequest.fromJson(jsonDecode(diff.transactionJson!));
            await _apiService.updateTransaction(diff.id, req);
            log('✅ Синхронизирована update-операция для транзакции id=${diff.id}', name: 'TransactionSync');
            break;
          case 'delete':
            await _apiService.deleteTransaction(diff.id);
            log('✅ Синхронизирована delete-операция для транзакции id=${diff.id}', name: 'TransactionSync');
            break;
        }
        // После успешной sync удаляем diff
        await _db.deleteDiffById(diff.id);
      } catch (e) {
        log('❌ Ошибка sync diff-операции id=${diff.id}: $e', name: 'TransactionSync');
        // Можно обновить статус diff на 'error' для UI
        await _db.upsertTransactionDiff(
          id: diff.id,
          operation: diff.operation,
          transactionJson: diff.transactionJson,
          timestamp: diff.timestamp,
          syncStatus: 'error',
        );
      }
    }
  }
} 