import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shmr_finance/domain/cubit/account/account_cubit.dart';
import 'package:shmr_finance/domain/models/currency/currency.dart';

import 'mock_account_repo.dart';
import 'mock_shared_preferences.dart';

void main() {
  late MyAccountCubit cubit;
  late MockSharedPreferences mockPrefs;
  late MockAccountRepo mockRepo;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    mockRepo = MockAccountRepo();
    SharedPreferences.setMockInitialValues({});

    cubit = MyAccountCubit();
  });

  tearDown(() {
    cubit.close();
  });

  group('Initial state', () {
    test('should load initial currency', () async {
      expect(cubit.state.selectedCurrency, Currencies.available.first);
    });

    test('should be in loading state initially', () {
      expect(cubit.state.isLoading, true);
    });
  });
}
