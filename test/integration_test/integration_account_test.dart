import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shmr_finance/domain/cubit/account/account_cubit.dart';
import 'package:shmr_finance/domain/models/currency/currency.dart';

import '../fakes/fake_currency.dart';

class MockAccountCubit extends Mock implements MyAccountCubit {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late MockAccountCubit cubit;

  setUp(() {
    cubit = MockAccountCubit();
    registerFallbackValue(FakeCurrency());

    // Стандартная настройка мока
    when(() => cubit.state).thenReturn(
      MyAccountState(
        selectedCurrency: Currencies.available.first,
        isLoading: false,
        accountName: 'Test Account',
        accountId: 1,
      ),
    );
  });

  test('should mock initial state correctly', () {
    expect(cubit.state.accountName, 'Test Account');
    expect(cubit.state.selectedCurrency, Currencies.available.first);
  });

  test('should mock setCurrency', () async {
    // 1. Сначала настраиваем мок
    when(() => cubit.setCurrency(any())).thenAnswer((_) async {});

    // 2. Затем вызываем метод
    final testCurrency = Currencies.available.last;
    await cubit.setCurrency(testCurrency);

    // 3. Проверяем вызов
    verify(() => cubit.setCurrency(testCurrency)).called(1);
  });

  test('should allow custom state mocking', () {
    const testState = MyAccountState(
      selectedCurrency: Currency(
        code: 'TEST',
        symbol: 'T',
        name: 'Test',
        icon: '⭐',
      ),
      isLoading: true,
      accountName: 'Custom Account',
      accountId: 2,
    );

    // Изменяем возвращаемое состояние
    when(() => cubit.state).thenReturn(testState);

    expect(cubit.state, testState);
  });
}
