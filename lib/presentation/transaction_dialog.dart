import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shmr_finance/domain/cubit/categories/category_cubit.dart';
import 'package:shmr_finance/presentation/widgets/custom_appbar.dart';
import 'package:flutter/services.dart';

import '../app_theme.dart';

class TransactionPage extends StatefulWidget {
  final bool isAdd;
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

  @override
  void initState() {
    super.initState();
    
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
      _amountController.text = NumberFormat('#,##0.00', 'ru_RU').format(_amount);
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
      lastDate: DateTime(now.year + 5),
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
                  Text("Счёт"),
                  Text(_selectedAccountName ?? "Выберите счёт"),
                ],
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey,
              ),
              onTap: () async {
                // TODO: будем получать то как-то?
                final accounts = [
                  {'name': 'Мой счёт', 'currency': '₽'},
                ];
                final selected =
                    await showModalBottomSheet<Map<String, dynamic>>(
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
                                  'Выберите счёт',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: accounts.length,
                                  itemBuilder: (context, index) {
                                    final account = accounts[index];
                                    return Column(
                                      children: [
                                        ListTile(
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(account['name']!),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                ),
                                                child: Text(
                                                  account['currency']!,
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          trailing:
                                              _selectedAccountInd == index
                                                  ? Icon(
                                                    Icons.check,
                                                    color:
                                                        CustomAppTheme
                                                            .figmaMainColor,
                                                  )
                                                  : null,
                                          onTap: () {
                                            Navigator.of(context).pop({
                                              'index': index,
                                              'name': account['name'],
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
                  Text("Категория"),
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
                          return Padding(
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
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: state.filteredCategories.length,
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
                  const Text("Сумма"),
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
              title: TextField(
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
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: CustomAppTheme.figmaBgGrayColor,
            ),

            Padding(
              padding: const EdgeInsets.only(top: 32.0, left: 16, right: 16),
              child: ElevatedButton(
                onPressed: () {},
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
