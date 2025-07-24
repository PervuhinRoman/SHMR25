import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shmr_finance/app_theme.dart';
import 'package:shmr_finance/data/repositories/account_repo_impl.dart';
import 'package:shmr_finance/domain/cubit/account/account_cubit.dart';
import 'package:shmr_finance/domain/cubit/transactions/transaction_cubit.dart';
import 'package:shmr_finance/domain/models/account/account.dart';
import 'package:shmr_finance/domain/models/currency/currency.dart';
import 'package:shmr_finance/presentation/account_delete_page.dart';
import 'package:shmr_finance/presentation/edit_account_page.dart';
import 'package:shmr_finance/presentation/widgets/animated_balance_tile.dart';
import 'package:shmr_finance/presentation/widgets/custom_appbar.dart';
import 'package:bar_chart_widget/bar_chart_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../domain/models/transaction/transaction.dart';
import 'services/balance_visibility_service.dart';
import '../domain/cubit/account/blur_cubit.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final AccountRepoImp _accountRepo = AccountRepoImp();
  AccountResponse? _accountData;
  bool _isLoading = true;
  String? _error;

  final BalanceVisibilityService _balanceVisibilityService =
      BalanceVisibilityService();
  bool _isServiceInitialized = false;

  // Состояние для segmented control
  int _selectedPeriodIndex = 0; // 0 - дни, 1 - месяцы
  List<BarData> _chartData = [];
  bool _isChartLoading = false;
  List<Account> _accounts = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isServiceInitialized) {
      _initializeBalanceVisibilityService();
      _isServiceInitialized = true;
    }
  }

  Future<void> _initializeBalanceVisibilityService() async {
    final blurCubit = context.read<BlurCubit>();
    await _balanceVisibilityService.initialize(blurCubit);
  }

  @override
  void dispose() {
    _balanceVisibilityService.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadAccountData();
    _loadChartData();
  }

  Future<void> _loadAccountData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Загружаем все счета пользователя
      final accounts = await _accountRepo.getAllAccounts();
      setState(() {
        _accounts = accounts;
        _accountData =
            accounts.isNotEmpty
                ? AccountResponse(
                  id: accounts.first.id,
                  name: accounts.first.name,
                  balance: accounts.first.balance,
                  currency: accounts.first.currency,
                  incomeStats: [],
                  expenseStats: [],
                  createdAt: accounts.first.createdAt,
                  updatedAt: accounts.first.updatedAt,
                )
                : null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _showCurrencySelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildCurrencySelector(),
    );
  }

  Widget _buildCurrencySelector() {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<MyAccountCubit, MyAccountState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.selectCurrency,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Currencies.available.length,
                  itemBuilder: (context, index) {
                    final currency = Currencies.available[index];
                    final isSelected =
                        currency.code == state.selectedCurrency.code;

                    return ListTile(
                      leading: Text(
                        currency.icon,
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Text(currency.name),
                      subtitle: Text('${currency.code} ${currency.symbol}'),
                      trailing:
                          isSelected
                              ? Icon(
                                Icons.check,
                                color: Theme.of(
                                  context,
                                ).primaryColor.withValues(alpha: 0.3),
                              )
                              : null,
                      onTap: () {
                        context.read<MyAccountCubit>().setCurrency(currency);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<MyAccountCubit, MyAccountState>(
      builder: (context, accountState) {
        return Scaffold(
          appBar: CustomAppBar(
            title: _accountData?.name ?? l10n.myAccount,
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.mode_edit_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return AccountDeletePage(account: _accountData!);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          body:
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(child: Text('${l10n.error}: $_error'))
                  : _accountData == null
                  ? Center(child: Text(l10n.noAccounts))
                  : _buildAccountContent(),
        );
      },
    );
  }

  Widget _buildAccountContent() {
    final l10n = AppLocalizations.of(context)!;
    final account = _accountData!;
    final balance = double.tryParse(account.balance) ?? 0.0;

    return BlocBuilder<MyAccountCubit, MyAccountState>(
      builder: (context, currencyState) {
        if (currencyState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  // Баланс с анимацией скрытия
                  AnimatedBalanceTile(
                    icon: '💰',
                    title: l10n.balance,
                    value:
                        "${NumberFormat('#,##0.00', 'ru_RU').format(balance)} ${currencyState.selectedCurrency.symbol}",
                    onTap: _navigateToEditPage,
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: CustomAppTheme.figmaBgGrayColor,
                  ),
                  // Валюта
                  _AccountListTile(
                    icon: currencyState.selectedCurrency.icon,
                    title: l10n.currency,
                    value: currencyState.selectedCurrency.symbol,
                    onTap: _showCurrencySelector,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // График баланса
              _buildBalanceChart(),
            ],
          ),
        );
      },
    );
  }

  /// Строит виджет графика баланса
  Widget _buildBalanceChart() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Segmented Control
          Container(
            decoration: BoxDecoration(
              color: CustomAppTheme.figmaBgGrayColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildPeriodButton(
                    title: l10n.days30,
                    isSelected: _selectedPeriodIndex == 0,
                    onTap: () => _onPeriodChanged(0),
                  ),
                ),
                Expanded(
                  child: _buildPeriodButton(
                    title: l10n.months12,
                    isSelected: _selectedPeriodIndex == 1,
                    onTap: () => _onPeriodChanged(1),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // График
          SizedBox(
            height: 300,
            child:
                _isChartLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _chartData.isEmpty
                    ? Center(
                      child: Text(
                        l10n.noDataToDisplay,
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                    : BarChartWidget(
                      bars: _chartData,
                      config: BarChartConfig(
                        height: 250,
                        barWidth: 8,
                        positiveColor: CustomAppTheme.figmaMainColor,
                        negativeColor: CustomAppTheme.figmaRedColor,
                        textColor: CustomAppTheme.figmaDarkGrayColor,
                        gridColor: CustomAppTheme.figmaBgGrayColor,
                        labelFontSize: 8,
                        enableTooltips: true,
                        numberFormat: '#,##0',
                        showGrid: false,
                        onBoard: 1000.0, // Базовая линия на уровне 1000 рублей
                      ),
                      onBarTap: (bar) {
                        // Обработка нажатия на столбец
                        log(
                          'Нажат столбец: ${bar.formattedDate} - ${bar.value}',
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  /// Строит кнопку периода для segmented control
  Widget _buildPeriodButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color:
              isSelected ? Theme.of(context).primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color:
                isSelected ? Colors.white : CustomAppTheme.figmaDarkGrayColor,
          ),
        ),
      ),
    );
  }

  void _navigateToEditPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditAccountPage()),
    );
  }

  /// Загружает данные для графика
  Future<void> _loadChartData() async {
    setState(() {
      _isChartLoading = true;
    });

    try {
      final endDate = DateTime.now();
      final startDate =
          _selectedPeriodIndex == 0
              ? endDate.subtract(const Duration(days: 30)) // 30 дней
              : DateTime(endDate.year - 1, endDate.month, 1); // 12 месяцев

      final accountId = _accountData?.id;
      if (accountId == null) return;

      // Загружаем все транзакции за период
      await context.read<TransactionCubit>().fetchTransactions(
        accountId: accountId,
        startDate: startDate,
        endDate: endDate,
        isIncome: true, // Доходы
      );

      // Получаем состояние с транзакциями
      final transactionState = context.read<TransactionCubit>().state;
      final incomeTransactions = transactionState.transactions;

      // Загружаем расходы
      await context.read<TransactionCubit>().fetchTransactions(
        accountId: accountId,
        startDate: startDate,
        endDate: endDate,
        isIncome: false, // Расходы
      );

      if (!context.mounted) return;

      final updatedState = context.read<TransactionCubit>().state;
      final expenseTransactions = updatedState.transactions;

      // Генерируем данные для графика
      _generateChartData(
        incomeTransactions,
        expenseTransactions,
        startDate,
        endDate,
      );
    } catch (e) {
      debugPrint('Ошибка загрузки данных графика: $e');
    } finally {
      setState(() {
        _isChartLoading = false;
      });
    }
  }

  /// Генерирует данные для графика на основе транзакций
  void _generateChartData(
    List<TransactionResponse> incomeTransactions,
    List<TransactionResponse> expenseTransactions,
    DateTime startDate,
    DateTime endDate,
  ) {
    final chartData = <BarData>[];

    if (_selectedPeriodIndex == 0) {
      // Группируем по дням
      for (int i = 0; i < 30; i++) {
        final date = endDate.subtract(Duration(days: 29 - i));
        final dayStart = DateTime(date.year, date.month, date.day);
        final dayEnd = dayStart.add(const Duration(days: 1));

        final dayIncome = incomeTransactions
            .where(
              (t) =>
                  t.transactionDate.isAfter(dayStart) &&
                  t.transactionDate.isBefore(dayEnd),
            )
            .fold<double>(
              0,
              (sum, t) => sum + (double.tryParse(t.amount) ?? 0),
            );

        final dayExpense = expenseTransactions
            .where(
              (t) =>
                  t.transactionDate.isAfter(dayStart) &&
                  t.transactionDate.isBefore(dayEnd),
            )
            .fold<double>(
              0,
              (sum, t) => sum + (double.tryParse(t.amount) ?? 0),
            );

        final balance = dayIncome - dayExpense;

        chartData.add(
          BarData.fromData(
            date: date,
            value: balance,
            positiveColor: CustomAppTheme.figmaMainColor.toARGB32(),
            negativeColor: CustomAppTheme.figmaRedColor.toARGB32(),
            dateFormat: 'dd.MM',
          ),
        );
      }
    } else {
      // Группируем по месяцам
      for (int i = 0; i < 12; i++) {
        final date = DateTime(endDate.year, endDate.month - 11 + i, 1);
        final monthStart = DateTime(date.year, date.month, 1);
        final monthEnd = DateTime(date.year, date.month + 1, 1);

        final monthIncome = incomeTransactions
            .where(
              (t) =>
                  t.transactionDate.isAfter(monthStart) &&
                  t.transactionDate.isBefore(monthEnd),
            )
            .fold<double>(
              0,
              (sum, t) => sum + (double.tryParse(t.amount) ?? 0),
            );

        final monthExpense = expenseTransactions
            .where(
              (t) =>
                  t.transactionDate.isAfter(monthStart) &&
                  t.transactionDate.isBefore(monthEnd),
            )
            .fold<double>(
              0,
              (sum, t) => sum + (double.tryParse(t.amount) ?? 0),
            );

        final balance = monthIncome - monthExpense;

        chartData.add(
          BarData.fromData(
            date: date,
            value: balance,
            positiveColor: CustomAppTheme.figmaMainColor.toARGB32(),
            negativeColor: CustomAppTheme.figmaRedColor.toARGB32(),
            dateFormat: 'MM.yy',
          ),
        );
      }
    }

    setState(() {
      _chartData = chartData;
    });
  }

  /// Обработчик изменения периода
  void _onPeriodChanged(int index) {
    setState(() {
      _selectedPeriodIndex = index;
    });
    _loadChartData();
  }
}

// Кастомный ListTile для блока Баланс и Валюта
class _AccountListTile extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  const _AccountListTile({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(child: Text(title)),
              Text(value),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
