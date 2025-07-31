// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SHMR Finance';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get systemTheme => 'System theme';

  @override
  String get primaryColor => 'Primary color';

  @override
  String get hapticFeedback => 'Haptic feedback';

  @override
  String get language => 'Language';

  @override
  String get security => 'Security';

  @override
  String get pinCode => 'PIN code';

  @override
  String get pinCodeRequired => 'Please enable PIN code first';

  @override
  String get biometrics => 'Biometrics';

  @override
  String get appBlur => 'App blur';

  @override
  String get appBlurDescription => 'Blur screen in multitasking mode';

  @override
  String get testPinCode => 'Test PIN code';

  @override
  String get testPinCodeDescription => 'Check PIN code input';

  @override
  String get testBlur => 'Test blur';

  @override
  String get testBlurDescription => 'Force apply blur';

  @override
  String get pinCodeSetup => 'PIN code setup';

  @override
  String get pinCodeInput => 'PIN code input';

  @override
  String get enterPinCode => 'Enter PIN code';

  @override
  String get confirmPinCode => 'Confirm PIN code';

  @override
  String get pinCodesDoNotMatch => 'PIN codes do not match';

  @override
  String get pinCodeSetSuccessfully => 'PIN code set successfully';

  @override
  String get pinCodeEnteredCorrectly => 'PIN code entered correctly!';

  @override
  String get blurApplied => 'Blur applied! Minimize the app to check.';

  @override
  String get appLocked => 'App is locked';

  @override
  String get minimizeToUnlock => 'Minimize the app to unlock';

  @override
  String get accounts => 'Accounts';

  @override
  String get addAccount => 'Add account';

  @override
  String get editAccount => 'Edit account';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get accountName => 'Account name';

  @override
  String get accountBalance => 'Account balance';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get confirm => 'Confirm';

  @override
  String get deleteAccountConfirmation =>
      'Are you sure you want to delete this account?';

  @override
  String get categories => 'Categories';

  @override
  String get addCategory => 'Add category';

  @override
  String get categoryName => 'Category name';

  @override
  String get income => 'Income';

  @override
  String get expense => 'Expense';

  @override
  String get transactions => 'Transactions';

  @override
  String get addTransaction => 'Add transaction';

  @override
  String get transactionAmount => 'Amount';

  @override
  String get transactionDescription => 'Description';

  @override
  String get transactionDate => 'Date';

  @override
  String get transactionCategory => 'Category';

  @override
  String get transactionAccount => 'Account';

  @override
  String get analysis => 'Analysis';

  @override
  String get totalBalance => 'Total balance';

  @override
  String get totalIncome => 'Total income';

  @override
  String get totalExpense => 'Total expense';

  @override
  String get thisMonth => 'This month';

  @override
  String get lastMonth => 'Last month';

  @override
  String get thisYear => 'This year';

  @override
  String get noData => 'No data';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get loading => 'Loading...';

  @override
  String get retry => 'Retry';

  @override
  String get close => 'Close';

  @override
  String get ok => 'OK';

  @override
  String get reset => 'Reset';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get sort => 'Sort';

  @override
  String get all => 'All';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get thisWeek => 'This week';

  @override
  String get lastWeek => 'Last week';

  @override
  String get currency => 'Currency';

  @override
  String get rub => 'RUB';

  @override
  String get usd => 'USD';

  @override
  String get eur => 'EUR';

  @override
  String get amount => 'Amount';

  @override
  String get description => 'Description';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get name => 'Name';

  @override
  String get type => 'Type';

  @override
  String get status => 'Status';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get enabled => 'Enabled';

  @override
  String get disabled => 'Disabled';

  @override
  String get on => 'On';

  @override
  String get off => 'Off';

  @override
  String get biometricNotAvailable =>
      'Biometric authentication is not available';

  @override
  String get biometricNotConfigured =>
      'Biometric authentication is not configured on this device';

  @override
  String get biometricSetupRequired =>
      'Please set up biometric authentication in your device settings';

  @override
  String get usePinCode => 'Use PIN code';

  @override
  String get useBiometrics => 'Use biometrics';

  @override
  String get faceId => 'Face ID';

  @override
  String get touchId => 'Touch ID';

  @override
  String get fingerprint => 'Fingerprint';

  @override
  String get authenticationRequired => 'Authentication required';

  @override
  String get pleaseAuthenticate => 'Please authenticate to continue';

  @override
  String get authenticationFailed => 'Authentication failed';

  @override
  String get tryAgain => 'Try again';

  @override
  String transactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions',
      one: '1 transaction',
      zero: 'No transactions',
    );
    return '$_temp0';
  }

  @override
  String accountCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count accounts',
      one: '1 account',
      zero: 'No accounts',
    );
    return '$_temp0';
  }

  @override
  String categoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count categories',
      one: '1 category',
      zero: 'No categories',
    );
    return '$_temp0';
  }

  @override
  String get fillAllFields => 'Fill all fields';

  @override
  String get confirmDelete => 'Confirm deletion';

  @override
  String get confirmDeleteTransaction =>
      'Are you sure you want to delete this transaction?';

  @override
  String get total => 'Total';

  @override
  String get noDataForPeriod => 'No data for period';

  @override
  String get unlock => 'Unlock';

  @override
  String get sortByDate => 'By date';

  @override
  String get sortByAmount => 'By amount';

  @override
  String get accountNameUpdated => 'Account name updated';

  @override
  String get updateError => 'Update error';

  @override
  String get noCategories => 'No categories';

  @override
  String get periodStart => 'Period: start';

  @override
  String get periodEnd => 'Period: end';

  @override
  String get noAccounts => 'No accounts';

  @override
  String get deleteConfirmation => 'Delete confirmation';

  @override
  String get deleteNotSupported => 'Account deletion is not supported';

  @override
  String get myCategories => 'My categories';

  @override
  String get required => ' *';

  @override
  String get myAccount => 'My account';

  @override
  String get balance => 'Balance';

  @override
  String get noDataToDisplay => 'No data to display';

  @override
  String get days30 => '30 days';

  @override
  String get months12 => '12 months';

  @override
  String get dataFromCache => 'Data from cache';

  @override
  String get dataFromNetwork => 'Data from network';

  @override
  String get incomeToday => 'Income today';

  @override
  String get expenseToday => 'Expense today';

  @override
  String get incomeHistory => 'Income history';

  @override
  String get expenseHistory => 'Expense history';

  @override
  String get start => 'Start';

  @override
  String get end => 'End';

  @override
  String get selectDate => 'Select date';

  @override
  String get selectStartDate => 'Select start date';

  @override
  String get selectEndDate => 'Select end date';

  @override
  String get findArticle => 'Find article...';

  @override
  String get articleNotFound => 'Article not found';

  @override
  String get selectCurrency => 'Select currency';

  @override
  String get sorting => 'Sorting';

  @override
  String get editTransaction => 'Edit transaction';

  @override
  String get transactionName => 'Name / description';

  @override
  String get deleteTransaction => 'Delete transaction';

  @override
  String get selectAccount => 'Select account';

  @override
  String get confirmIdentity => 'Confirm your identity';

  @override
  String get biometricUnavailable =>
      'Biometric authentication is unavailable or not configured. Use PIN code.';

  @override
  String get faceIdTouchId => 'Face ID / Touch ID';

  @override
  String get setupPinCode => 'Setup PIN code';

  @override
  String get pinCodeSaveError => 'Error saving PIN code';

  @override
  String get pinCodesDontMatch => 'PIN codes don\'t match';

  @override
  String get incorrectPinCode => 'Incorrect PIN code';
}
