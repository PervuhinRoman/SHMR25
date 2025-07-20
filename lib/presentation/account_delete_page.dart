import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shmr_finance/app_theme.dart';
import 'package:shmr_finance/domain/models/account/account.dart';
import 'package:shmr_finance/presentation/widgets/animated_balance_tile.dart';
import 'package:shmr_finance/presentation/widgets/custom_appbar.dart';

import '../domain/cubit/account/account_cubit.dart';

class AccountDeletePage extends StatelessWidget {
  final AccountResponse account;

  const AccountDeletePage({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final balance = double.tryParse(account.balance) ?? 0.0;

    return BlocBuilder<MyAccountCubit, MyAccountState>(
      builder: (context, myAccountState) {
        return Scaffold(
          appBar: CustomAppBar(
            title: account.name,
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
            defaultLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: BlocBuilder<MyAccountCubit, MyAccountState>(
            builder: (context, currencyState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Блок счета с анимацией блюра
                  AnimatedBalanceTile(
                    icon: '💰',
                    title: 'Баланс',
                    value:
                        "${NumberFormat("0.00").format(balance)} ${currencyState.selectedCurrency.symbol}",
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: CustomAppTheme.figmaBgGrayColor,
                  ),

                  const SizedBox(height: 32),

                  // Кнопка удаления
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () => _showDeleteConfirmation(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomAppTheme.figmaRedColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Удалить счет',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтверждение удаления'),
          content: Text(
            'Вы уверены, что хотите удалить счет "${account.name}"? Это действие нельзя отменить.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAccount(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: CustomAppTheme.figmaRedColor,
              ),
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );
  }

  void _deleteAccount(BuildContext context) async {
    // Удаление счета не поддерживается
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Удаление счета не поддерживается'),
        backgroundColor: Colors.orange,
      ),
    );
    Navigator.of(context).pop();
  }
}
