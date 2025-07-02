import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance/app_theme.dart';
import 'package:shmr_finance/domain/cubit/account/account_cubit.dart';
import 'package:shmr_finance/presentation/widgets/custom_appbar.dart';

class EditAccountPage extends StatefulWidget {
  const EditAccountPage({super.key});

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  late TextEditingController _accountNameController;

  @override
  void initState() {
    super.initState();
    _accountNameController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Устанавливаем текущее имя счета из AccountCubit
    final accountState = context.read<MyAccountCubit>().state;
    if (_accountNameController.text.isEmpty && accountState.accountName.isNotEmpty) {
      _accountNameController.text = accountState.accountName;
    }
  }

  @override
  void dispose() {
    _accountNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Редактировать счёт"),
      body: Column(
        children: [
          _buildAccountNameField(),
          const Divider(
            height: 1,
            thickness: 1,
            color: CustomAppTheme.figmaBgGrayColor,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountNameField() {
    return Container(
      height: 56,
      color: CustomAppTheme.figmaNavBarColor,
      child: TextField(
        controller: _accountNameController,
        onChanged: (value) {
          // Сохраняем изменения в AccountCubit
          context.read<MyAccountCubit>().setAccountName(value);
        },
        decoration: const InputDecoration(
          hintText: 'Название счета...',
          suffixIcon: Icon(Icons.edit, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
} 