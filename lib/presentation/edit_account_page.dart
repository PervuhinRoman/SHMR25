import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance/app_theme.dart';
import 'package:shmr_finance/domain/cubit/account/account_cubit.dart';
import 'package:shmr_finance/presentation/widgets/custom_appbar.dart';
import 'package:shmr_finance/data/repositories/account_repo_impl.dart';
import 'package:shmr_finance/domain/models/account/account.dart';

class EditAccountPage extends StatefulWidget {
  const EditAccountPage({super.key});

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  late TextEditingController _accountNameController;
  Account? _currentAccount;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _accountNameController = TextEditingController();
    _loadAccount();
  }

  Future<void> _loadAccount() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final repo = AccountRepoImp();
      final accounts = await repo.getAllAccounts();
      setState(() {
        _currentAccount = accounts.isNotEmpty ? accounts.first : null;
        _accountNameController.text = _currentAccount?.name ?? '';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveAccountName() async {
    if (_currentAccount == null) return;
    final newName = _accountNameController.text.trim();
    if (newName.isEmpty) return;
    try {
      final repo = AccountRepoImp();
      await repo.updateAccount(
        _currentAccount!.id,
        AccountUpdateRequest(
          name: newName,
          balance: _currentAccount!.balance,
          currency: _currentAccount!.currency,
        ),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Имя счета обновлено'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка при обновлении: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Устанавливаем текущее имя счета из AccountCubit
    final accountState = context.read<MyAccountCubit>().state;
    if (_accountNameController.text.isEmpty &&
        accountState.accountName.isNotEmpty) {
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
      appBar: CustomAppBar(
        title: _currentAccount?.name ?? "Редактировать счёт",
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Container(
                    height: 56,
                    color: CustomAppTheme.figmaNavBarColor,
                    child: TextField(
                      controller: _accountNameController,
                      onChanged: (value) {
                        context.read<MyAccountCubit>().setAccountName(value);
                      },
                      onEditingComplete: _saveAccountName,
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
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: CustomAppTheme.figmaBgGrayColor,
                  ),
                ],
              ),
    );
  }
}
