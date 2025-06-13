import 'package:freezed_annotation/freezed_annotation.dart';
import '../account/account.dart';
import '../category/category.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({
    required int id,
    required int accountId,
    required int categoryId,
    required String amount,
    required DateTime transactionDate,
    String? comment,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}

@freezed
abstract class TransactionRequest with _$TransactionRequest {
  const factory TransactionRequest({
    required int accountId,
    required int categoryId,
    required String amount,
    required DateTime transactionDate,
    String? comment,
  }) = _TransactionRequest;

  factory TransactionRequest.fromJson(Map<String, dynamic> json) =>
      _$TransactionRequestFromJson(json);
}

@freezed
abstract class TransactionResponse with _$TransactionResponse {
  const factory TransactionResponse({
    required int id,
    required AccountBrief account,
    required Category category,
    required String amount,
    required DateTime transactionDate,
    String? comment,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TransactionResponse;

  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseFromJson(json);
}