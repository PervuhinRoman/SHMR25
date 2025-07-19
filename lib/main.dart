import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:worker_manager/worker_manager.dart';
import 'package:shmr_finance/domain/cubit/account/account_cubit.dart';
import 'package:shmr_finance/domain/cubit/account/blur_cubit.dart';
import 'package:shmr_finance/domain/cubit/categories/category_cubit.dart';
import 'package:shmr_finance/domain/cubit/transactions/transaction_cubit.dart';
import 'package:shmr_finance/presentation/account_page.dart';
import 'package:shmr_finance/presentation/categories_page.dart';
import 'package:shmr_finance/presentation/in_exp_widget.dart';
import 'package:shmr_finance/presentation/settings_page.dart';
import 'package:shmr_finance/presentation/security_screen.dart';
import 'package:shmr_finance/presentation/widgets/app_blur_wrapper.dart';
import 'package:shmr_finance/app_theme.dart';
import 'package:shmr_finance/data/services/theme_service.dart';
import 'package:shmr_finance/data/services/haptic_service.dart';
import 'package:shmr_finance/data/services/security_service.dart';
import 'package:shmr_finance/presentation/services/app_blur_service.dart';
import 'package:flutter/services.dart';

void main() async {
  // Устанавливаем цвета для статус бара и навигационной панели
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: CustomAppTheme.figmaNavBarColor,
      statusBarColor: CustomAppTheme.figmaMainColor,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();

  // Задержка для стабильности инициализации
  await Future.delayed(const Duration(milliseconds: 100));

  // Инициализируем WorkerManager для десериализации через изоляты
  try {
    await workerManager.init(
      isolatesCount: 2, // Оптимально для мобильных устройств
    );
    log(
      '✅ WorkerManager успешно инициализирован',
      time: DateTime.now(),
      name: 'WorkerManager',
    );
  } catch (e) {
    log(
      '❌ Ошибка инициализации WorkerManager: $e',
      time: DateTime.now(),
      name: 'WorkerManager',
    );
  }

  try {
    await SharedPreferences.getInstance(); // Инициализируем SharedPreferences
    log(
      '✅ SharedPreferences успешно инициализирован',
      time: DateTime.now(),
      name: 'SharedPrefs',
    );
  } catch (e) {
    log(
      '❌ Ошибка инициализации SharedPreferences: $e',
      time: DateTime.now(),
      name: 'SharedPrefs',
    );
  }

  // Инициализируем сервисы
  final themeService = ThemeService();
  await themeService.initialize();
  
  final hapticService = HapticService();
  await hapticService.initialize();
  
  final securityService = SecurityService();
  await securityService.initialize();
  
  final appBlurService = AppBlurService();
  await appBlurService.initialize();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TransactionCubit()),
        BlocProvider(create: (_) => MyAccountCubit()),
        BlocProvider(create: (_) => BlurCubit()),
        BlocProvider(create: (_) => CategoryCubit()),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: themeService),
          ChangeNotifierProvider.value(value: securityService),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final shouldShowSecurity = await SecurityService().shouldShowSecurityScreen();
    if (!shouldShowSecurity) {
      setState(() {
        _isAuthenticated = true;
      });
    }
  }

  void _onAuthenticated() {
    setState(() {
      _isAuthenticated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return SafeArea(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'SHMR Finance',
            themeMode: themeService.getThemeMode(),
            theme: themeService.getLightTheme(),
            darkTheme: themeService.getDarkTheme(),
            home: _isAuthenticated 
                ? AppBlurWrapper(child: const BaseScreen())
                : SecurityScreen(onAuthenticated: _onAuthenticated),
          ),
        );
      },
    );
  }
}

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          HapticService().selectionClick();
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        // TODO: ?заменить на svg
        destinations: <Widget>[
          NavigationDestination(
            icon: Image.asset('assets/icons/downtrend.png', width: 32),
            label: 'Расходы',
          ),
          NavigationDestination(
            icon: Image.asset('assets/icons/uptrend.png', width: 32),
            label: 'Доходы',
          ),
          NavigationDestination(
            icon: Image.asset('assets/icons/calc.png', width: 32),
            label: 'Счет',
          ),
          NavigationDestination(
            icon: Image.asset('assets/icons/linear_chart.png', width: 32),
            label: 'Статьи',
          ),
          NavigationDestination(
            icon: Image.asset('assets/icons/settings.png', width: 32),
            label: 'Настройки',
          ),
        ],
      ),
      body:
          [
            InExpWidget(isIncome: false),
            InExpWidget(isIncome: true),
            AccountPage(),
            CategoriesPage(),
            SettingsPage(),
          ][currentPageIndex],
    );
  }
}
