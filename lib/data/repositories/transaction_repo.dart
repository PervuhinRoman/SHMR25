import '../../domain/models/transaction/transaction.dart';

abstract class TransactionRepository {
  Future<List<TransactionResponse>> getPeriodTransactionsByAccount(
    int accountId, {
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<TransactionResponse> getTransaction(int id);
  Future<TransactionResponse> createTransaction(TransactionRequest request);
  Future<TransactionResponse> updateTransaction(
    int id,
    TransactionRequest request,
  );
  Future<void> deleteTransaction(int id);
}
