// Юнит-тесты для ApiService
// Все внешние зависимости (Dio) замоканы через mocktail, тесты только happy-path

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:shmr_finance/data/services/api_service.dart';
import 'package:shmr_finance/domain/models/account/account.dart';
import 'package:shmr_finance/domain/models/category/category.dart';
import 'package:shmr_finance/domain/models/transaction/transaction.dart';

class MockDio extends Mock implements Dio {
  final Interceptors _interceptors = Interceptors();

  @override
  Interceptors get interceptors => _interceptors;
}

class MockResponse<T> extends Mock implements Response<T> {}

void main() {
  group('ApiService', () {
    late MockDio mockDio;
    late ApiService apiService;

    setUp(() {
      mockDio = MockDio();
      apiService = ApiService(dio: mockDio);
    });

    test('getAccounts: возвращает список Account — happy path', () async {
      // Description: Проверяет, что при успешном ответе Dio возвращается корректный список Account.
      final mockResponse = MockResponse();
      final accountsJson = [
        {
          'id': 1,
          'userId': 1,
          'name': 'A',
          'balance': '100',
          'currency': 'RUB',
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        },
      ];
      when(() => mockResponse.data).thenReturn(accountsJson);
      when(
        () => mockDio.get('/accounts'),
      ).thenAnswer((_) async => mockResponse);

      final result = await apiService.getAccounts();
      expect(result, isA<List<Account>>());
      expect(result.length, 1);
      expect(result.first.name, 'A');
      verify(() => mockDio.get('/accounts')).called(1);
    });

    test(
      'createAccount: возвращает Account после успешного создания — happy path',
      () async {
        // Description: Проверяет, что при успешном ответе Dio возвращается корректный Account.
        final mockResponse = MockResponse();
        final accountJson = {
          'id': 1,
          'userId': 1,
          'name': 'A',
          'balance': '100',
          'currency': 'RUB',
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        };
        when(() => mockResponse.data).thenReturn(accountJson);
        when(
          () => mockDio.post('/accounts', data: any(named: 'data')),
        ).thenAnswer((_) async => mockResponse);

        final request = AccountCreateRequest(
          name: 'A',
          balance: '100',
          currency: 'RUB',
        );
        final result = await apiService.createAccount(request);
        expect(result, isA<Account>());
        expect(result.name, 'A');
        verify(
          () => mockDio.post('/accounts', data: any(named: 'data')),
        ).called(1);
      },
    );

    test('getCategories: возвращает список Category — happy path', () async {
      // Description: Проверяет, что при успешном ответе Dio возвращается корректный список Category.
      final mockResponse = MockResponse();
      final categoriesJson = [
        {'id': 1, 'name': 'Cat', 'emoji': '💰', 'isIncome': false},
      ];
      when(() => mockResponse.data).thenReturn(categoriesJson);
      when(
        () => mockDio.get('/categories'),
      ).thenAnswer((_) async => mockResponse);

      final result = await apiService.getCategories();
      expect(result, isA<List<Category>>());
      expect(result.length, 1);
      expect(result.first.name, 'Cat');
      verify(() => mockDio.get('/categories')).called(1);
    });

    test(
      'createTransaction: возвращает Transaction после успешного создания — happy path',
      () async {
        // Description: Проверяет, что при успешном ответе Dio возвращается корректный Transaction.
        final mockResponse = MockResponse();
        final now = DateTime.now();
        final transactionJson = {
          'id': 1,
          'accountId': 1,
          'categoryId': 1,
          'amount': '100',
          'transactionDate': now.toIso8601String(),
          'comment': 'Test',
          'createdAt': now.toIso8601String(),
          'updatedAt': now.toIso8601String(),
        };
        when(() => mockResponse.data).thenReturn(transactionJson);
        when(
          () => mockDio.post('/transactions', data: any(named: 'data')),
        ).thenAnswer((_) async => mockResponse);

        final request = TransactionRequest(
          accountId: 1,
          categoryId: 1,
          amount: '100',
          transactionDate: now,
          comment: 'Test',
        );
        final result = await apiService.createTransaction(request);
        expect(result, isA<Transaction>());
        expect(result.amount, '100');
        verify(
          () => mockDio.post('/transactions', data: any(named: 'data')),
        ).called(1);
      },
    );
  });
}
