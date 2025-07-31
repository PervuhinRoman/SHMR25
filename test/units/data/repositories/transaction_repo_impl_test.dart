// Юнит-тесты для TransactionRepoImp
// Тестируются: получение транзакций за период (API), сохранение в БД, получение из БД, создание, удаление
// Все зависимости замоканы через mocktail, тесты только happy-path

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shmr_finance/data/repositories/transaction_repo_impl.dart';
import 'package:shmr_finance/data/repositories/category_repo.dart';
import 'package:shmr_finance/data/repositories/account_repo.dart';
import 'package:shmr_finance/data/services/api_service.dart';
import 'package:shmr_finance/data/database/transaction_database.dart';
import 'package:shmr_finance/domain/models/transaction/transaction.dart';
import 'package:shmr_finance/domain/models/account/account.dart';
import 'package:shmr_finance/domain/models/category/category.dart';

// Моки для зависимостей
class MockCategoryRepo extends Mock implements CategoryRepository {}

class MockAccountRepo extends Mock implements AccountRepository {}

class MockApiService extends Mock implements ApiService {}

class MockAppDatabase extends Mock implements AppDatabase {}

class MockAccountBriefDBTable extends Mock implements $AccountBriefDBTable {}

class MockCategoryDBTable extends Mock implements $CategoryDBTable {}

void main() {
  group('TransactionRepoImp', () {
    late MockCategoryRepo mockCategoryRepo;
    late MockAccountRepo mockAccountRepo;
    late MockApiService mockApiService;
    late MockAppDatabase mockAppDatabase;
    late MockAccountBriefDBTable mockAccountBriefDB;
    late MockCategoryDBTable mockCategoryDB;
    late TransactionRepoImp repo;

    setUp(() {
      mockCategoryRepo = MockCategoryRepo();
      mockAccountRepo = MockAccountRepo();
      mockApiService = MockApiService();
      mockAppDatabase = MockAppDatabase();
      mockAccountBriefDB = MockAccountBriefDBTable();
      mockCategoryDB = MockCategoryDBTable();
      when(() => mockAppDatabase.accountBriefDB).thenReturn(mockAccountBriefDB);
      when(() => mockAppDatabase.categoryDB).thenReturn(mockCategoryDB);
      repo = TransactionRepoImp(
        mockAccountRepo,
        mockCategoryRepo,
        mockAppDatabase,
        mockApiService,
      );
    });

    test(
      'getPeriodTransactionsByAccount: возвращает отсортированный список транзакций за период (API) — happy path',
      () async {
        // Description: Проверяет, что при запросе транзакций за период вызывается нужный метод у ApiService,
        // результат сортируется по дате (новые сначала) и возвращается корректно.
        final accountId = 1;
        final now = DateTime.now();
        final tx1 = TransactionResponse(
          id: 1,
          account: AccountBrief(
            id: 1,
            name: 'A',
            balance: '100',
            currency: 'RUB',
          ),
          category: Category(id: 1, name: 'Cat', emoji: '💰', isIncome: false),
          amount: '100',
          transactionDate: now.subtract(const Duration(days: 1)),
          comment: 'First',
          createdAt: now.subtract(const Duration(days: 1)),
          updatedAt: now.subtract(const Duration(days: 1)),
        );
        final tx2 = TransactionResponse(
          id: 2,
          account: AccountBrief(
            id: 1,
            name: 'A',
            balance: '100',
            currency: 'RUB',
          ),
          category: Category(id: 1, name: 'Cat', emoji: '💰', isIncome: false),
          amount: '200',
          transactionDate: now,
          comment: 'Second',
          createdAt: now,
          updatedAt: now,
        );
        when(
          () => mockApiService.getPeriodTransactionsByAccount(
            accountId,
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          ),
        ).thenAnswer((_) async => [tx1, tx2]);

        final result = await repo.getPeriodTransactionsByAccount(
          accountId,
          startDate: now.subtract(const Duration(days: 2)),
          endDate: now,
        );

        expect(result, isA<List<TransactionResponse>>());
        expect(result.length, 2);
        // Проверяем сортировку: tx2 (новее) должен быть первым
        expect(result.first.id, tx2.id);
        expect(result.last.id, tx1.id);
        verify(
          () => mockApiService.getPeriodTransactionsByAccount(
            accountId,
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          ),
        ).called(1);
      },
    );

    test(
      'saveTransactionsForPeriodDrift: сохраняет транзакции в БД — happy path',
      () async {
        // Description: Проверяет, что при сохранении транзакций за период вызывается удаление старых и вставка новых данных через insertTransactionResponses у AppDatabase с корректными параметрами.
        final now = DateTime.now();
        final tx = TransactionResponse(
          id: 1,
          account: AccountBrief(
            id: 1,
            name: 'A',
            balance: '100',
            currency: 'RUB',
          ),
          category: Category(id: 1, name: 'Cat', emoji: '💰', isIncome: false),
          amount: '100',
          transactionDate: now,
          comment: 'Test',
          createdAt: now,
          updatedAt: now,
        );
        when(
          () => mockAppDatabase.deleteTransactionsByPeriod(any(), any()),
        ).thenAnswer((_) async => 1);
        when(
          () => mockAppDatabase.insertTransactionResponses(any(), any(), any()),
        ).thenAnswer((_) async {});

        await repo.saveTransactionsForPeriodDrift(
          [tx],
          now.subtract(const Duration(days: 1)),
          now,
          mockAppDatabase,
        );

        verify(
          () => mockAppDatabase.deleteTransactionsByPeriod(any(), any()),
        ).called(1);
        verify(
          () => mockAppDatabase.insertTransactionResponses(any(), any(), any()),
        ).called(1);
      },
    );

    test(
      'createTransaction: создает транзакцию через ApiService и очищает diff в БД — happy path',
      () async {
        // Description: Проверяет, что при создании транзакции:
        // 1) diff сохраняется в БД,
        // 2) вызывается создание через ApiService,
        // 3) diff удаляется после успешного sync,
        // 4) возвращается корректный TransactionResponse.
        final now = DateTime.now();
        final request = TransactionRequest(
          accountId: 1,
          categoryId: 1,
          amount: '100',
          transactionDate: now,
          comment: 'Test',
        );
        final transaction = Transaction(
          id: 1,
          accountId: 1,
          categoryId: 1,
          amount: '100',
          transactionDate: now,
          comment: 'Test',
          createdAt: now,
          updatedAt: now,
        );
        final category = Category(id: 1, name: 'Cat', emoji: '💰', isIncome: false);
        final account = AccountBrief(id: 1, name: 'A', balance: '100', currency: 'RUB');
        when(() => mockAppDatabase.upsertTransactionDiff(
          id: any(named: 'id'),
          operation: any(named: 'operation'),
          transactionJson: any(named: 'transactionJson'),
          timestamp: any(named: 'timestamp'),
        )).thenAnswer((_) async {});
        when(() => mockApiService.createTransaction(request)).thenAnswer((_) async => transaction);
        when(() => mockAppDatabase.deleteDiffById(any())).thenAnswer((_) async => 1);
        when(() => mockCategoryRepo.getAllCategories()).thenAnswer((_) async => [category]);
        when(() => mockAccountRepo.getAccountById(1)).thenAnswer((_) async => AccountResponse(
          id: 1,
          name: 'A',
          balance: '100',
          currency: 'RUB',
          incomeStats: [],
          expenseStats: [],
          createdAt: now,
          updatedAt: now,
        ));

        final result = await repo.createTransaction(request);

        expect(result, isA<TransactionResponse>());
        expect(result.id, 1);
        expect(result.account.id, 1);
        expect(result.category.id, 1);
        verify(() => mockAppDatabase.upsertTransactionDiff(
          id: any(named: 'id'),
          operation: any(named: 'operation'),
          transactionJson: any(named: 'transactionJson'),
          timestamp: any(named: 'timestamp'),
        )).called(1);
        verify(() => mockApiService.createTransaction(request)).called(1);
        verify(() => mockAppDatabase.deleteDiffById(any())).called(1);
      },
    );

    test(
      'deleteTransaction: удаляет транзакцию через ApiService и очищает diff в БД — happy path',
      () async {
        // Description: Проверяет, что при удалении транзакции:
        // 1) diff сохраняется в БД,
        // 2) вызывается удаление через ApiService,
        // 3) diff удаляется после успешного sync.
        final now = DateTime.now();
        when(() => mockAppDatabase.upsertTransactionDiff(
          id: any(named: 'id'),
          operation: any(named: 'operation'),
          transactionJson: any(named: 'transactionJson'),
          timestamp: any(named: 'timestamp'),
        )).thenAnswer((_) async {});
        when(() => mockApiService.deleteTransaction(1)).thenAnswer((_) async {});
        when(() => mockAppDatabase.deleteDiffById(1)).thenAnswer((_) async => 1);

        await repo.deleteTransaction(1);

        verify(() => mockAppDatabase.upsertTransactionDiff(
          id: any(named: 'id'),
          operation: any(named: 'operation'),
          transactionJson: any(named: 'transactionJson'),
          timestamp: any(named: 'timestamp'),
        )).called(1);
        verify(() => mockApiService.deleteTransaction(1)).called(1);
        verify(() => mockAppDatabase.deleteDiffById(1)).called(1);
      },
    );
  });
}
