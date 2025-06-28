import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shmr_finance/app_theme.dart';
import 'package:shmr_finance/data/repositories/account_repo_imp.dart';
import 'package:shmr_finance/domain/cubit/currency_cubit.dart';
import 'package:shmr_finance/domain/models/account/account.dart';
import 'package:shmr_finance/domain/models/currency/currency.dart';
import 'package:shmr_finance/presentation/account_delete_page.dart';
import 'package:shmr_finance/presentation/widgets/custom_appbar.dart';

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

  @override
  void initState() {
    super.initState();
    _loadAccountData();
  }

  Future<void> _loadAccountData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      
      // Загружаем данные основного счета (ID = 1)
      final accountData = await _accountRepo.getAccountById(1);
      
      setState(() {
        _accountData = accountData;
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
    return BlocBuilder<CurrencyCubit, CurrencyState>(
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
              const Text(
                'Выберите валюту',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Currencies.available.length,
                  itemBuilder: (context, index) {
                    final currency = Currencies.available[index];
                    final isSelected = currency.code == state.selectedCurrency.code;
                    
                    return ListTile(
                      leading: Text(
                        currency.icon,
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Text(currency.name),
                      subtitle: Text('${currency.code} ${currency.symbol}'),
                      trailing: isSelected 
                        ? Icon(Icons.check, color: CustomAppTheme.figmaMainColor)
                        : null,
                      onTap: () {
                        context.read<CurrencyCubit>().setCurrency(currency);
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
    return Scaffold(
      appBar: CustomAppBar(
        title: "Мой счёт",
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.mode_edit_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return Scaffold(
                      appBar: AppBar(title: Text("Редактировать счёт")),
                      body: Center(child: Text("Форма редактирования")),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Ошибка: $_error'))
              : _accountData == null
                  ? const Center(child: Text('Нет данных'))
                  : _buildAccountContent(),
    );
  }

  Widget _buildAccountContent() {
    final account = _accountData!;
    final balance = double.tryParse(account.balance) ?? 0.0;
    
    return BlocBuilder<CurrencyCubit, CurrencyState>(
      builder: (context, currencyState) {
        if (currencyState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  // Баланс
                  _AccountListTile(
                    icon: '💰',
                    title: 'Баланс',
                    value: "${NumberFormat("0.00").format(balance)} ${currencyState.selectedCurrency.symbol}",
                    onTap: _navigateToDeletePage,
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: CustomAppTheme.figmaBgGrayColor,
                  ),
                  // Валюта
                  _AccountListTile(
                    icon: currencyState.selectedCurrency.icon,
                    title: 'Валюта',
                    value: currencyState.selectedCurrency.symbol,
                    onTap: _showCurrencySelector,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToDeletePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountDeletePage(account: _accountData!),
      ),
    );
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
      color: CustomAppTheme.figmaMainLightColor,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                ),
              ),
              Text(
                value,
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

