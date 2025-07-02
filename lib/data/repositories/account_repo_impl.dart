import 'package:shmr_finance/data/repositories/account_repo.dart';
import 'package:shmr_finance/domain/models/account/account.dart';

import '../../domain/models/stat/stat_item.dart';

class AccountRepoImp implements AccountRepository {
  final List<Account> _accounts = [
    Account(
      id: 1,
      userId: 1,
      name: 'Основной счёт',
      balance: '1000.00',
      currency: 'RUB',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Account(
      id: 2,
      userId: 1,
      name: 'Счёт в гурдах',
      balance: '1000.00',
      currency: 'HTG',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  @override
  Future<Account> createAccount(AccountCreateRequest request) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final newAccount = Account(
      id: _accounts.length + 1,
      userId: 1,
      name: request.name,
      balance: request.balance,
      currency: request.currency,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _accounts.add(newAccount);

    return newAccount;

    // TODO: Пу-пу-пу. Как то надо обрабатывать id текущего пользователя
    // TODO: Добавить проверку на уникальность имени аккаунта
  }

  @override
  Future<AccountResponse> getAccountById(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final account = _accounts.firstWhere((account) => account.id == id);

    return AccountResponse(
      id: account.id,
      name: account.name,
      balance: account.balance,
      currency: account.currency,
      incomeStats: [
        StatItem(
          categoryId: 1,
          categoryName: 'Зарплата',
          emoji: '💸',
          amount: '50000.00',
        ),
      ],
      expenseStats: [
        StatItem(
          categoryId: 2,
          categoryName: 'Продукты',
          emoji: '🥩',
          amount: '5000.00',
        ),
      ],
      createdAt: account.createdAt,
      updatedAt: account.updatedAt,
    );
  }

  @override
  Future<AccountHistoryResponse> getAccountHistory(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final account = _accounts.firstWhere((account) => account.id == id);

    return AccountHistoryResponse(
      accountId: account.id,
      accountName: account.name,
      currency: account.currency,
      currentBalance: account.balance,
      history: [
        AccountHistory(
          id: 1,
          accountId: account.id,
          changeType: 'CREATION',
          previousState: null,
          newState: AccountState(
            id: account.id,
            name: account.name,
            balance: account.balance,
            currency: account.currency,
          ),
          changeTimestamp: account.createdAt,
          createdAt: account.createdAt,
        ),
      ],
    );
  }

  @override
  Future<List<Account>> getAllAccounts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _accounts;
  }

  @override
  Future<Account> updateAccount(int id, AccountUpdateRequest request) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final currentAccountIndex = _accounts.indexWhere((account) => account.id == id);

    final updatedAccount = Account(
      id: id,
      userId: _accounts[currentAccountIndex].userId,
      name: request.name,
      balance: request.balance,
      currency: request.currency,
      createdAt: _accounts[currentAccountIndex].createdAt,
      updatedAt: DateTime.now(),
    );

    _accounts[currentAccountIndex] = updatedAccount;
    return updatedAccount;
  }
}