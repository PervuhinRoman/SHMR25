import 'package:mocktail/mocktail.dart';
import 'package:shmr_finance/data/repositories/account_repo_impl.dart';
import 'package:shmr_finance/domain/models/account/account.dart';

class MockAccountRepo extends Mock implements AccountRepoImp {
  final Account _defaultAccount = Account(
    id: 1,
    userId: 1,
    name: "Основной счет",
    balance: "1000.00",
    currency: "RUB",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  @override
  Future<List<Account>> getAllAccounts() async {
    return [_defaultAccount];
  }

  @override
  Future<Account> updateAccount(int id, AccountUpdateRequest request) async {
    return _defaultAccount.copyWith(
      name: request.name,
      balance: request.balance,
      currency: request.currency,
    );
  }

  void mockUpdateSuccess() {
    when(() => updateAccount(any(), any())).thenAnswer(
      (_) async => _defaultAccount.copyWith(name: "Обновленный счет"),
    );
  }

  void mockUpdateError() {
    when(
      () => updateAccount(any(), any()),
    ).thenThrow(Exception("Ошибка обновления"));
  }
}
