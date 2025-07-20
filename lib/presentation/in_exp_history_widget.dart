import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shmr_finance/app_theme.dart';
import 'package:shmr_finance/domain/cubit/account/account_cubit.dart';
import 'package:shmr_finance/domain/cubit/transactions/datepicker_cubit.dart';
import 'package:shmr_finance/domain/cubit/transactions/sort_type_cubit.dart';
import 'package:shmr_finance/domain/cubit/transactions/transaction_cubit.dart';
import 'package:shmr_finance/presentation/analyze_page.dart';
import 'package:shmr_finance/presentation/transaction_dialog.dart';
import 'package:shmr_finance/presentation/widgets/custom_appbar.dart';
import 'package:shmr_finance/presentation/widgets/item_inexp.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InExpHistoryWidget extends StatefulWidget {
  final bool isIncome;

  const InExpHistoryWidget({super.key, required this.isIncome});

  @override
  State<InExpHistoryWidget> createState() => _InExpHistoryWidgetState();
}

class _InExpHistoryWidgetState extends State<InExpHistoryWidget> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final datePickerState = context.read<DatePickerCubit>().state;
      final accountState = context.read<MyAccountCubit>().state;
      final accountId = accountState.accountId ?? 1;
      context.read<TransactionCubit>().fetchTransactions(
        accountId: accountId,
        startDate: datePickerState.startDate!,
        endDate: datePickerState.endDate!,
        isIncome: widget.isIncome,
      );
    });
  }

  @override
  void didUpdateWidget(covariant InExpHistoryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isIncome != widget.isIncome) {
      final datePickerState = context.read<DatePickerCubit>().state;
      final accountState = context.read<MyAccountCubit>().state;
      final accountId = accountState.accountId ?? 1;
      context.read<TransactionCubit>().fetchTransactions(
        accountId: accountId,
        startDate: datePickerState.startDate!,
        endDate: datePickerState.endDate!,
        isIncome: widget.isIncome,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    DatePickerCubit datePickerCubit = context.read<DatePickerCubit>();
    TransactionCubit transactionCubit = context.read<TransactionCubit>();
    SortTypeCubit sortTypeCubit = context.read<SortTypeCubit>();

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.isIncome ? l10n.incomeHistory : l10n.expenseHistory,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider<DatePickerCubit>(
                          create: (context) => DatePickerCubit(),
                        ),
                        BlocProvider<TransactionCubit>(
                          create: (context) => TransactionCubit(),
                        ),
                      ],
                      child: AnalyzePage(isIncome: widget.isIncome),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<SortTypeCubit, SortTypeState>(
        builder: (context, sortState) {
          return BlocBuilder<DatePickerCubit, DatePickerState>(
            builder: (context, datePickerState) {
              return BlocBuilder<TransactionCubit, TransactionState>(
                builder: (context, transactionState) {
                  final transactions = transactionState.transactions;
                  final totalSum = transactions.fold<num>(
                    0,
                    (sum, item) => sum + double.parse(item.amount),
                  );
                  return Column(
                    children: [
                      // Начало
                      GestureDetector(
                        onTap: () async {
                          final DateTime? resultStartDate =
                              await showDatePicker(
                                context: context,
                                initialDate:
                                    datePickerState.startDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                helpText: l10n.selectStartDate,
                                cancelText: l10n.cancel,
                                confirmText: l10n.ok,
                              );
                          if (resultStartDate != null) {
                            datePickerCubit.setStartDate(resultStartDate);
                            final accountState =
                                context.read<MyAccountCubit>().state;
                            final accountId = accountState.accountId ?? 1;
                            transactionCubit.fetchTransactions(
                              accountId: accountId,
                              startDate: resultStartDate,
                              endDate: datePickerState.endDate,
                              isIncome: widget.isIncome,
                            );
                          }
                        },
                        child: Container(
                          color: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.3),
                          height: 56,
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: Text(
                                    l10n.start,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: Text(
                                    datePickerState.startDate != null
                                        ? DateFormat(
                                          'dd.MM.yyyy',
                                        ).format(datePickerState.startDate!)
                                        : l10n.selectDate,
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: CustomAppTheme.figmaBgGrayColor,
                      ),
                      // Конец
                      GestureDetector(
                        onTap: () async {
                          final DateTime? resultEndDate = await showDatePicker(
                            context: context,
                            initialDate:
                                datePickerState.endDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            helpText: l10n.selectEndDate,
                            cancelText: l10n.cancel,
                            confirmText: l10n.ok,
                          );
                          if (resultEndDate != null) {
                            datePickerCubit.setEndDate(resultEndDate);
                            final accountState =
                                context.read<MyAccountCubit>().state;
                            final accountId = accountState.accountId ?? 1;
                            transactionCubit.fetchTransactions(
                              accountId: accountId,
                              startDate: datePickerState.startDate,
                              endDate: resultEndDate,
                              isIncome: widget.isIncome,
                            );
                          }
                        },
                        child: Container(
                          color: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.3),
                          height: 56,
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Text(
                                    l10n.end,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: Text(
                                    datePickerState.endDate != null
                                        ? DateFormat(
                                          'dd.MM.yyyy',
                                        ).format(datePickerState.endDate!)
                                        : l10n.selectDate,
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: CustomAppTheme.figmaBgGrayColor,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await showModalBottomSheet(
                            context: context,
                            builder:
                                (ctx) => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      title: Text(l10n.sortByDate),
                                      trailing: const Icon(Icons.date_range),
                                      onTap: () {
                                        sortTypeCubit.changeSortType(
                                          SortType.date,
                                        );
                                        transactionCubit.sort(SortType.date);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: Text(l10n.sortByAmount),
                                      trailing: const Icon(Icons.attach_money),
                                      onTap: () {
                                        sortTypeCubit.changeSortType(
                                          SortType.amount,
                                        );
                                        transactionCubit.sort(SortType.amount);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                          );
                        },
                        child: Container(
                          color: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.3),
                          height: 56,
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: Text(
                                    l10n.sorting,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: Text(
                                    sortState.sortType == SortType.date
                                        ? l10n.sortByDate
                                        : l10n.sortByAmount,
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: CustomAppTheme.figmaBgGrayColor,
                      ),
                      // Сумма
                      Container(
                        color: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: 0.3),
                        height: 56,
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Text(
                                  l10n.transactionAmount,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: Text(
                                  "${NumberFormat('#,##0.00', 'ru_RU').format(totalSum)} ₽",
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Индикатор источника данных
                      if (transactionState.dataSource != null)
                        Container(
                          color:
                              transactionState.dataSource == DataSource.cache
                                  ? Colors.orange.withValues(alpha: 0.1)
                                  : Colors.green.withValues(alpha: 0.1),
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                transactionState.dataSource == DataSource.cache
                                    ? Icons.storage
                                    : Icons.cloud_download,
                                size: 16,
                                color:
                                    transactionState.dataSource ==
                                            DataSource.cache
                                        ? Colors.orange
                                        : Colors.green,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                transactionState.dataSource == DataSource.cache
                                    ? "Данные из кэша"
                                    : "Данные из сети",
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      transactionState.dataSource ==
                                              DataSource.cache
                                          ? Colors.orange
                                          : Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      // Список транзакций
                      Expanded(
                        child: () {
                          if (transactionState.status ==
                              TransactionStatus.loading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (transactionState.status ==
                              TransactionStatus.error) {
                            return Center(
                              child: Text(
                                '${l10n.error}: ${transactionState.error}',
                              ),
                            );
                          }
                          if (transactions.isEmpty) {
                            return Center(child: Text(l10n.noDataForPeriod));
                          } else {
                            return ListView.builder(
                              itemCount: transactions.length * 2 + 1,
                              itemBuilder: (context, index) {
                                if (index.isEven) {
                                  return const Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: CustomAppTheme.figmaBgGrayColor,
                                  );
                                } else {
                                  final itemIndex = index ~/ 2;
                                  if (itemIndex >= transactions.length) {
                                    return const SizedBox.shrink();
                                  }
                                  final item = transactions[itemIndex];
                                  return InExpItem(
                                    categoryTitle: item.category.name,
                                    amount: item.amount,
                                    icon: item.category.emoji,
                                    time: item.transactionDate,
                                    comment: item.comment,
                                    onTap: () {
                                      showGeneralDialog(
                                        context: context,
                                        pageBuilder: (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) {
                                          return BlocProvider(
                                            create:
                                                (context) => TransactionCubit(),
                                            child: TransactionPage(
                                              isAdd: false,
                                              isIncome: widget.isIncome,
                                              accountName: item.account.name,
                                              categoryName: item.category.name,
                                              categoryEmoji:
                                                  item.category.emoji,
                                              categoryIndex:
                                                  item
                                                      .category
                                                      .id, // Предполагаем, что id используется как индекс
                                              amount: double.tryParse(
                                                item.amount,
                                              ),
                                              dateTime: item.transactionDate,
                                              title: item.comment,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                }
                              },
                            );
                          }
                        }(),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        child: Icon(Icons.add),
        onPressed:
            () => showGeneralDialog(
              context: context,
              pageBuilder: (context, animation, secondaryAnimation) {
                return BlocProvider(
                  create: (context) => TransactionCubit(),
                  child: TransactionPage(
                    isAdd: true,
                    isIncome: widget.isIncome,
                  ),
                );
              },
            ),
      ),
    );
  }
}
