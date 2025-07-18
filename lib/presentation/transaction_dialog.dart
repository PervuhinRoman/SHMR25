import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shmr_finance/domain/cubit/categories/category_cubit.dart';
import 'package:shmr_finance/presentation/widgets/custom_appbar.dart';
import 'package:flutter/services.dart';
import 'dart:developer';
import 'package:shmr_finance/domain/cubit/transactions/transaction_cubit.dart';
import 'package:shmr_finance/domain/models/transaction/transaction.dart';
import 'package:shmr_finance/data/repositories/account_repo_impl.dart';
import 'package:shmr_finance/domain/models/account/account.dart';

import '../app_theme.dart';

class TransactionPage extends StatefulWidget {
  final bool isAdd;
  final bool isIncome;
  final String? categoryName;
  final String? categoryEmoji;
  final int? categoryIndex;
  final String? accountName;
  final int? accountIndex;
  final double? amount;
  final DateTime? dateTime;
  final String? title;

  const TransactionPage({
    super.key,
    required this.isAdd,
    required this.isIncome,
    this.categoryName,
    this.categoryEmoji,
    this.categoryIndex,
    this.accountName,
    this.accountIndex,
    this.amount,
    this.dateTime,
    this.title,
  });

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  int? _selectedCategoryInd;
  String? _selectedCategoryName;
  int? _selectedAccountInd;
  String? _selectedAccountName;
  double? _amount;
  final _amountController = TextEditingController();
  final _amountFocusNode = FocusNode();
  DateTime _selectedDateTime = DateTime.now();
  String? _title;
  final _titleController = TextEditingController();
  final _titleFocusNode = FocusNode();
  List<Account> _accounts = [];
  bool _accountsLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAccounts();

    // Инициализация полей данными из существующей транзакции
    _selectedCategoryInd = widget.categoryIndex;
    _selectedCategoryName = widget.categoryName;
    _selectedAccountInd = widget.accountIndex;
    _selectedAccountName = widget.accountName;
    _amount = widget.amount;
    _selectedDateTime = widget.dateTime ?? DateTime.now();
    _title = widget.title;

    // Установка текста в контроллеры
    if (_amount != null) {
      _amountController.text = NumberFormat(
        '#,##0.00',
        'ru_RU',
      ).format(_amount);
    }
    if (_title != null) {
      _titleController.text = _title!;
    }

    _amountFocusNode.addListener(() {
      if (!_amountFocusNode.hasFocus) {
        _saveAmount();
      }
    });
    _titleFocusNode.addListener(() {
      if (!_titleFocusNode.hasFocus) {
        _saveTitle();
      }
    });
  }

  Future<void> _loadAccounts() async {
    setState(() {
      _accountsLoading = true;
    });
    try {
      final repo = AccountRepoImp();
      final accounts = await repo.getAllAccounts();
      setState(() {
        _accounts = accounts;
        _accountsLoading = false;
      });

      // Если это новая транзакция и аккаунт не выбран, выбираем первый
      if (widget.isAdd && _selectedAccountInd == null && accounts.isNotEmpty) {
        setState(() {
          _selectedAccountInd = accounts.first.id;
          _selectedAccountName = accounts.first.name;
        });
        log(
          'Автоматически выбран первый аккаунт: ${accounts.first.name} (id: ${accounts.first.id})',
          name: 'TransactionDialog',
        );
      }

      // Если это новая транзакция и категория не выбрана, выбираем первую соответствующего типа
      if (widget.isAdd && _selectedCategoryInd == null) {
        final categoryCubit = context.read<CategoryCubit>();
        // Убеждаемся, что категории загружены
        if (categoryCubit.state.categories.isEmpty) {
          await categoryCubit.loadCategoriesByType(widget.isIncome);
        }
        final categories =
            categoryCubit.state.categories
                .where((c) => c.isIncome == widget.isIncome)
                .toList();
        if (categories.isNotEmpty) {
          setState(() {
            _selectedCategoryInd = categories.first.id;
            _selectedCategoryName = categories.first.name;
          });
          log(
            'Автоматически выбрана первая категория: ${categories.first.name} (id: ${categories.first.id})',
            name: 'TransactionDialog',
          );
        }
      }
    } catch (e) {
      setState(() {
        _accountsLoading = false;
      });
      log('Ошибка загрузки счетов: $e', name: 'TransactionDialog');
    }
  }

  void _saveAmount() {
    final text = _amountController.text.replaceAll(',', '.');
    final parsed = double.tryParse(text);
    if (parsed != null) {
      setState(() {
        _amount = parsed;
        _amountController.text = NumberFormat(
          '#,##0.00',
          'ru_RU',
        ).format(_amount);
        _amountController.selection = TextSelection.fromPosition(
          TextPosition(offset: _amountController.text.length),
        );
      });
    }
  }

  void _saveTitle() {
    setState(() {
      _title = _titleController.text;
    });
  }

  bool _validateFields() {
    if (_selectedAccountInd == null) {
      _showValidationDialog("Выберите счёт");
      return false;
    }
    if (_selectedCategoryInd == null) {
      _showValidationDialog("Выберите категорию");
      return false;
    }
    if (_amount == null || _amount == 0) {
      _showValidationDialog("Введите сумму");
      return false;
    }
    if (_title == null || _title!.trim().isEmpty) {
      _showValidationDialog("Введите название транзакции");
      return false;
    }
    return true;
  }

  void _showValidationDialog(String message) {
    log('Ошибка валидации: $message', name: 'TransactionDialog');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Заполните все поля'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveTransaction() async {
    log('Пользователь нажал сохранить транзакцию', name: 'TransactionDialog');
    log('_selectedAccountInd: $_selectedAccountInd', name: 'TransactionDialog');
    log(
      '_selectedCategoryInd: $_selectedCategoryInd',
      name: 'TransactionDialog',
    );
    log('_amount: $_amount', name: 'TransactionDialog');
    log('_title: $_title', name: 'TransactionDialog');
    log('_selectedDateTime: $_selectedDateTime', name: 'TransactionDialog');
    log('_accounts.length: ${_accounts.length}', name: 'TransactionDialog');
    if (_accounts.isNotEmpty) {
      log(
        '_accounts.first.id: ${_accounts.first.id}',
        name: 'TransactionDialog',
      );
    }

    if (_validateFields()) {
      try {
        final cubit = context.read<TransactionCubit>();

        // Используем только валидные данные (fallback убраны, так как валидация уже прошла)
        final accountId = _selectedAccountInd!;
        final categoryId = _selectedCategoryInd!;
        final amount = _amount!.toString();
        final comment = _title!;

        log(
          'Создание TransactionRequest с параметрами:',
          name: 'TransactionDialog',
        );
        log('accountId: $accountId', name: 'TransactionDialog');
        log('categoryId: $categoryId', name: 'TransactionDialog');
        log('amount: $amount', name: 'TransactionDialog');
        log('transactionDate: $_selectedDateTime', name: 'TransactionDialog');
        log('comment: $comment', name: 'TransactionDialog');

        final request = TransactionRequest(
          accountId: accountId,
          categoryId: categoryId,
          amount: amount,
          transactionDate: _selectedDateTime,
          comment: comment,
        );

        log(
          'TransactionRequest создан: ${request.toString()}',
          name: 'TransactionDialog',
        );

        if (widget.isAdd) {
          log('Создание новой транзакции', name: 'TransactionDialog');
          await cubit.createTransaction(request);
          log('Транзакция успешно создана', name: 'TransactionDialog');
        } else {
          log('Обновление транзакции', name: 'TransactionDialog');
          // Для update нужен id транзакции, здесь предполагается, что он есть в widget
          await cubit.updateTransaction(
            widget.categoryIndex ?? 1,
            request,
          ); // TODO: заменить на реальный id транзакции
          log('Транзакция успешно обновлена', name: 'TransactionDialog');
        }
        Navigator.of(context).pop();
      } catch (e) {
        log('Ошибка при сохранении транзакции: $e', name: 'TransactionDialog');
        _showValidationDialog('Ошибка при сохранении транзакции: $e');
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    _titleController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    _amountFocusNode.unfocus();
    _titleFocusNode.unfocus();
    await Future.delayed(const Duration(milliseconds: 100));
    if (!context.mounted) return;
    FocusScope.of(context).unfocus();
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime.now(),
    );
    if (!context.mounted) return;
    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );
      if (!context.mounted) return;
      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
    await Future.delayed(const Duration(milliseconds: 50));
    if (!context.mounted) return;
    _amountFocusNode.unfocus();
    _titleFocusNode.unfocus();
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтвердите удаление'),
          content: const Text('Вы уверены, что хотите удалить эту транзакцию?'),
          actions: [
            TextButton(
              onPressed: () {
                log(
                  'Пользователь отменил удаление транзакции',
                  name: 'TransactionDialog',
                );
                Navigator.of(context).pop();
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () async {
                log(
                  'Пользователь подтвердил удаление транзакции',
                  name: 'TransactionDialog',
                );
                try {
                  final cubit = context.read<TransactionCubit>();
                  await cubit.deleteTransaction(
                    widget.categoryIndex ?? 1,
                  ); // TODO: заменить на реальный id транзакции
                  log('Транзакция успешно удалена', name: 'TransactionDialog');
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                } catch (e) {
                  log(
                    'Ошибка при удалении транзакции: $e',
                    name: 'TransactionDialog',
                  );
                  _showValidationDialog('Ошибка при удалении транзакции: $e');
                }
              },
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title:
            widget.isAdd ? 'Добавить транзакцию' : 'Редактировать транзакцию',
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              _saveTransaction();
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
      body: SingleChildScrollView(
        // `SingleChildScrollView` необходим, чтобы клавиатура не перекрывала виджеты
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Счёт
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("Счёт"),
                      Text(" *", style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  Text(_selectedAccountName ?? "Выберите счёт"),
                ],
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey,
              ),
              onTap: () async {
                if (_accountsLoading) return;
                final selected = await showModalBottomSheet<
                  Map<String, dynamic>
                >(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder:
                      (context) => Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child:
                            _accountsLoading
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 4,
                                      margin: const EdgeInsets.only(
                                        bottom: 16,
                                        top: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const Text(
                                      'Выберите счёт',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: _accounts.length,
                                      itemBuilder: (context, index) {
                                        final account = _accounts[index];
                                        return Column(
                                          children: [
                                            ListTile(
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(account.name),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          left: 8.0,
                                                        ),
                                                    child: Text(
                                                      account.currency,
                                                      style: TextStyle(
                                                        fontSize: 24,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              trailing:
                                                  _selectedAccountInd ==
                                                          account.id
                                                      ? Icon(
                                                        Icons.check,
                                                        color:
                                                            CustomAppTheme
                                                                .figmaMainColor,
                                                      )
                                                      : null,
                                              onTap: () {
                                                log(
                                                  'Пользователь выбрал счёт: ${account.name}',
                                                  name: 'TransactionDialog',
                                                );
                                                Navigator.of(context).pop({
                                                  'index': account.id,
                                                  'name': account.name,
                                                });
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 24),
                                  ],
                                ),
                      ),
                );
                if (!context.mounted) return;
                if (selected != null) {
                  setState(() {
                    _selectedAccountInd = selected['index'] as int?;
                    _selectedAccountName = selected['name'] as String?;
                  });
                }
              },
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: CustomAppTheme.figmaBgGrayColor,
            ),

            // Категория
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("Категория"),
                      Text(" *", style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  Text(_selectedCategoryName ?? "Выберите категорию"),
                ],
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey,
              ),
              onTap: () async {
                final selected = await showModalBottomSheet<
                  Map<String, dynamic>
                >(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder:
                      (context) => BlocBuilder<CategoryCubit, CategoryState>(
                        builder: (context, state) {
                          context.read<CategoryCubit>().loadCategoriesByType(
                            widget.isIncome,
                          );
                          return SingleChildScrollView(
                            child: Padding(
                              padding: MediaQuery.of(context).viewInsets,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 4,
                                    margin: const EdgeInsets.only(
                                      bottom: 16,
                                      top: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const Text(
                                    'Выберите категорию',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: state.categories.length,
                                    itemBuilder: (context, index) {
                                      final category = state.categories[index];
                                      return Column(
                                        children: [
                                          ListTile(
                                            leading: Text(category.emoji),
                                            title: Text(category.name),
                                            trailing:
                                                _selectedCategoryInd == index
                                                    ? Icon(
                                                      Icons.check,
                                                      color:
                                                          CustomAppTheme
                                                              .figmaMainColor,
                                                    )
                                                    : null,
                                            onTap: () {
                                              log(
                                                'Пользователь выбрал категорию: ${category.name}',
                                                name: 'TransactionDialog',
                                              );
                                              Navigator.of(context).pop({
                                                'index': index,
                                                'name': category.name,
                                              });
                                            },
                                          ),
                                          const Divider(
                                            height: 1,
                                            thickness: 1,
                                            color:
                                                CustomAppTheme.figmaBgGrayColor,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 32),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                );
                if (selected != null) {
                  setState(() {
                    _selectedCategoryInd = selected['index'] as int?;
                    _selectedCategoryName = selected['name'] as String?;
                  });
                }
              },
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: CustomAppTheme.figmaBgGrayColor,
            ),

            // Сумма
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text("Сумма"),
                      Text(" *", style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      focusNode: _amountFocusNode,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^[0-9]+([.,][0-9]{0,2})?'),
                        ),
                      ],
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '0.00',
                        suffixText: '₽',
                      ),
                      onChanged: (value) {
                        final parsed = double.tryParse(value);
                        if (parsed != null) {
                          setState(() {
                            _amount = parsed;
                          });
                        }
                      },
                      onEditingComplete: () {
                        _saveAmount();
                        FocusScope.of(context).unfocus();
                      },
                      onSubmitted: (_) {
                        _saveAmount();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: CustomAppTheme.figmaBgGrayColor,
            ),

            // Время
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Время"),
                  Text(DateFormat('HH:mm').format(_selectedDateTime)),
                ],
              ),
              onTap: _pickDateTime,
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: CustomAppTheme.figmaBgGrayColor,
            ),

            // Название
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleController,
                    focusNode: _titleFocusNode,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Название / описание',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _title = value;
                      });
                    },
                    onEditingComplete: () {
                      _saveTitle();
                      FocusScope.of(context).unfocus();
                    },
                    onSubmitted: (_) {
                      _saveTitle();
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: CustomAppTheme.figmaBgGrayColor,
            ),

            Padding(
              padding: const EdgeInsets.only(top: 32.0, left: 16, right: 16),
              child: ElevatedButton(
                onPressed: () {
                  log(
                    widget.isAdd
                        ? 'Пользователь отменил создание транзакции'
                        : 'Пользователь инициировал удаление транзакции',
                    name: 'TransactionDialog',
                  );
                  if (widget.isAdd) {
                    Navigator.of(context).pop();
                  } else {
                    _showDeleteConfirmationDialog();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomAppTheme.figmaRedColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1000),
                  ),
                ),
                child: Text(
                  widget.isAdd ? 'Отмена' : 'Удалить транзакцию',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
