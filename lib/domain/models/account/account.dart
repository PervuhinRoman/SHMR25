import 'package:freezed_annotation/freezed_annotation.dart';
import '../stat/stat_item.dart';

part 'account.freezed.dart';
part 'account.g.dart';

@freezed
abstract class Account with _$Account {
  const factory Account({
    required int id,
    required int userId,
    required String name,
    required String balance,
    required String currency,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
}

@freezed
abstract class AccountCreateRequest with _$AccountCreateRequest {
  const factory AccountCreateRequest({
    required String name,
    required String balance,
    required String currency,
  }) = _AccountCreateRequest;

  factory AccountCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$AccountCreateRequestFromJson(json);
}

@freezed
abstract class AccountUpdateRequest with _$AccountUpdateRequest {
  const factory AccountUpdateRequest({
    required String name,
    required String balance,
    required String currency,
  }) = _AccountUpdateRequest;

  factory AccountUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$AccountUpdateRequestFromJson(json);
}

@freezed
abstract class AccountResponse with _$AccountResponse {
  const factory AccountResponse({
    required int id,
    required String name,
    required String balance,
    required String currency,
    required List<StatItem> incomeStats,
    required List<StatItem> expenseStats,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AccountResponse;

  factory AccountResponse.fromJson(Map<String, dynamic> json) =>
      _$AccountResponseFromJson(json);
}

@freezed
abstract class AccountState with _$AccountState {
  const factory AccountState({
    required int id,
    required String name,
    required String balance,
    required String currency,
  }) = _AccountState;

  factory AccountState.fromJson(Map<String, dynamic> json) =>
      _$AccountStateFromJson(json);
}

@freezed
abstract class AccountHistory with _$AccountHistory {
  const factory AccountHistory({
    required int id,
    required int accountId,
    required String changeType,
    AccountState? previousState,
    required AccountState newState,
    required DateTime changeTimestamp,
    required DateTime createdAt,
  }) = _AccountHistory;

  factory AccountHistory.fromJson(Map<String, dynamic> json) =>
      _$AccountHistoryFromJson(json);
}

@freezed
abstract class AccountHistoryResponse with _$AccountHistoryResponse {
  const factory AccountHistoryResponse({
    required int accountId,
    required String accountName,
    required String currency,
    required String currentBalance,
    required List<AccountHistory> history,
  }) = _AccountHistoryResponse;

  factory AccountHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$AccountHistoryResponseFromJson(json);
}

@freezed
abstract class AccountBrief with _$AccountBrief {
  const factory AccountBrief({
    required int id,
    required String name,
    required String balance,
    required String currency,
  }) = _AccountBrief;

  factory AccountBrief.fromJson(Map<String, dynamic> json) =>
      _$AccountBriefFromJson(json);
}