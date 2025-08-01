import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shmr_finance/domain/cubit/transactions/transaction_cubit.dart';
import 'package:shmr_finance/presentation/widgets/custom_appbar.dart';
import 'package:shmr_finance/presentation/widgets/item_inexp.dart';
import 'package:shmr_finance/l10n/app_localizations.dart';
import 'package:shmr_finance/presentation/transaction_dialog.dart';

import 'package:shmr_finance/app_theme.dart';
import 'package:shmr_finance/domain/cubit/transactions/datepicker_cubit.dart';
import 'package:shmr_finance/domain/cubit/transactions/sort_type_cubit.dart';
import 'in_exp_history_widget.dart';
import 'package:shmr_finance/domain/cubit/account/account_cubit.dart';
import 'package:shmr_finance/presentation/services/haptic_service.dart';

class InExpWidget extends StatefulWidget {
  final bool isIncome;
  const InExpWidget({super.key, required this.isIncome});

  @override
  State<InExpWidget> createState() => _InExpWidgetState();
}

class _InExpWidgetState extends State<InExpWidget> {
  @override
  void initState() {
    super.initState();
    final transactionCubit = context.read<TransactionCubit>();
    final accountState = context.read<MyAccountCubit>().state;
    final accountId = accountState.accountId ?? 730; // TODO: как я так?
    transactionCubit.fetchTransactions(
      accountId: accountId,
      startDate: DateTime.now().copyWith(hour: 0, minute: 0, second: 0),
      endDate: DateTime.now().copyWith(hour: 23, minute: 59, second: 59),
      isIncome: widget.isIncome,
    );
    log(
      '🚀 InExpWidget initState вызван для ${widget.isIncome ? "доходов" : "расходов"}',
      name: "InExpWidget",
    );
  }

  @override
  void didUpdateWidget(covariant InExpWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    log(
      '🚀 InExpWidget didUpdateWidget вызван для ${widget.isIncome ? "доходов" : "расходов"}',
      name: "InExpWidget",
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      log('🔄 InExpWidget: вызываю fetchTransactions', name: "InExpWidget");
      final transactionCubit = context.read<TransactionCubit>();
      final accountState = context.read<MyAccountCubit>().state;
      final accountId = accountState.accountId ?? 1;
      transactionCubit.fetchTransactions(
        accountId: accountId,
        startDate: DateTime.now().copyWith(hour: 0, minute: 0, second: 0),
        endDate: DateTime.now().copyWith(hour: 23, minute: 59, second: 59),
        isIncome: widget.isIncome,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.isIncome ? l10n.incomeToday : l10n.expenseToday,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              HapticService().lightImpact();
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
                        BlocProvider<SortTypeCubit>(
                          create: (context) => SortTypeCubit(),
                        ),
                      ],
                      child: InExpHistoryWidget(isIncome: widget.isIncome),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
          log(
            '🔄 Состояние UI: ${state.status}, транзакций: ${state.transactions.length}, источник: ${state.dataSource}',
            name: "InExpWidget",
          );
          final transactions = state.transactions;
          log(
            '📊 Транзакции для отображения: ${transactions.length}',
            name: "InExpWidget",
          );

          // Проверяем первые несколько транзакций
          for (int i = 0; i < transactions.length && i < 3; i++) {
            final t = transactions[i];
            log(
              '📋 Транзакция $i: id=${t.id}, amount=${t.amount}, category=${t.category.name}, isIncome=${t.category.isIncome}',
              name: "InExpWidget",
            );
          }

          final totalSum = transactions.fold<num>(
            0,
            (sum, item) => sum + double.parse(item.amount),
          );
          log('💰 Общая сумма: $totalSum', name: "InExpWidget");

          return Column(
            children: [
              Container(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                height: 56,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(l10n.total, textAlign: TextAlign.start),
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
              if (state.dataSource != null)
                Container(
                  color: state.dataSource == DataSource.cache
                      ? Colors.orange.withValues(alpha: 0.1)
                      : Colors.green.withValues(alpha: 0.1),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        state.dataSource == DataSource.cache
                            ? Icons.storage
                            : Icons.cloud_download,
                        size: 16,
                        color: state.dataSource == DataSource.cache
                            ? Colors.orange
                            : Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        state.dataSource == DataSource.cache
                            ? l10n.dataFromCache
                            : l10n.dataFromNetwork,
                        style: TextStyle(
                          fontSize: 12,
                          color: state.dataSource == DataSource.cache
                              ? Colors.orange
                              : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: () {
                  log(
                    '🎨 Рендеринг списка: статус=${state.status}, количество=${transactions.length}',
                    name: "InExpWidget",
                  );
                  if (state.status == TransactionStatus.loading) {
                    log('⏳ Показываю индикатор загрузки', name: "InExpWidget");
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == TransactionStatus.error) {
                    log(
                      '❌ Показываю ошибку: ${state.error}',
                      name: "InExpWidget",
                    );
                    return Center(child: Text('${l10n.error}: ${state.error}'));
                  }
                  if (transactions.isEmpty) {
                    log('📭 Показываю "Нет данных"', name: "InExpWidget");
                    return Center(child: Text(l10n.noDataForPeriod));
                  } else {
                    log(
                      '📋 Показываю список из ${transactions.length} транзакций',
                      name: "InExpWidget",
                    );
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
                              HapticService().lightImpact();
                              showGeneralDialog(
                                context: context,
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                      return BlocProvider(
                                        create: (context) => TransactionCubit(),
                                        child: TransactionPage(
                                          isAdd: false,
                                          isIncome: widget.isIncome,
                                          accountName: item.account.name,
                                          categoryName: item.category.name,
                                          categoryEmoji: item.category.emoji,
                                          categoryIndex: item
                                              .category
                                              .id, // Предполагаем, что id используется как индекс
                                          amount: double.tryParse(item.amount),
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
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        child: Icon(Icons.add),
        onPressed: () {
          HapticService().mediumImpact();
          showGeneralDialog(
            context: context,
            pageBuilder: (context, animation, secondaryAnimation) {
              return BlocProvider(
                create: (context) => TransactionCubit(),
                child: TransactionPage(isAdd: true, isIncome: widget.isIncome),
              );
            },
          );
        },
      ),
    );
  }
}
