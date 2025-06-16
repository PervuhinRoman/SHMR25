import 'package:shmr_finance/domain/models/account/account.dart';

abstract class AccountRepository {
  Future<List<Account>> getAllAccounts();
  Future<AccountResponse> getAccountById(int id);
  Future<Account> createAccount(AccountCreateRequest request);
  Future<Account> updateAccount(int id, AccountUpdateRequest request);
  Future<AccountHistoryResponse> getAccountHistory(int id);
}