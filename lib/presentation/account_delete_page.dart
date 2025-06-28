import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shmr_finance/app_theme.dart';
import 'package:shmr_finance/domain/models/account/account.dart';

class AccountDeletePage extends StatelessWidget {
  final AccountResponse account;

  const AccountDeletePage({
    super.key,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    final balance = double.tryParse(account.balance) ?? 0.0;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Удаление счета'),
        backgroundColor: CustomAppTheme.figmaMainColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Информация о счете
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: CustomAppTheme.figmaMainColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    account.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Текущий баланс',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${NumberFormat("#,##0.00", "ru_RU").format(balance)} ${account.currency}",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Предупреждение
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange[700],
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Внимание! Удаление счета необратимо. Все данные о транзакциях будут потеряны.',
                      style: TextStyle(
                        color: Colors.orange[700],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const Spacer(),
            
            // Кнопка удаления
            ElevatedButton(
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
          ],
        ),
      ),
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

  void _deleteAccount(BuildContext context) {
    // TODO: Реализовать удаление счета через репозиторий
    print('Удаление счета ${account.id}');
    
    // Показываем уведомление об успешном удалении
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Счет "${account.name}" удален'),
        backgroundColor: Colors.green,
      ),
    );
    
    // Возвращаемся на предыдущий экран
    Navigator.of(context).pop();
  }
} 