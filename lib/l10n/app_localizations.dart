import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'SHMR Finance'**
  String get appTitle;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Theme settings
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Use system theme setting
  ///
  /// In en, this message translates to:
  /// **'System theme'**
  String get systemTheme;

  /// Primary color picker
  ///
  /// In en, this message translates to:
  /// **'Primary color'**
  String get primaryColor;

  /// Haptic feedback toggle
  ///
  /// In en, this message translates to:
  /// **'Haptic feedback'**
  String get hapticFeedback;

  /// Language setting
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Security settings
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// PIN code setting
  ///
  /// In en, this message translates to:
  /// **'PIN code'**
  String get pinCode;

  /// PIN code required message
  ///
  /// In en, this message translates to:
  /// **'Please enable PIN code first'**
  String get pinCodeRequired;

  /// Biometric authentication
  ///
  /// In en, this message translates to:
  /// **'Biometrics'**
  String get biometrics;

  /// App blur when minimized
  ///
  /// In en, this message translates to:
  /// **'App blur'**
  String get appBlur;

  /// App blur description
  ///
  /// In en, this message translates to:
  /// **'Blur screen in multitasking mode'**
  String get appBlurDescription;

  /// Test PIN code button
  ///
  /// In en, this message translates to:
  /// **'Test PIN code'**
  String get testPinCode;

  /// Test PIN code description
  ///
  /// In en, this message translates to:
  /// **'Check PIN code input'**
  String get testPinCodeDescription;

  /// Test blur button
  ///
  /// In en, this message translates to:
  /// **'Test blur'**
  String get testBlur;

  /// Test blur description
  ///
  /// In en, this message translates to:
  /// **'Force apply blur'**
  String get testBlurDescription;

  /// PIN code setup title
  ///
  /// In en, this message translates to:
  /// **'PIN code setup'**
  String get pinCodeSetup;

  /// PIN code input title
  ///
  /// In en, this message translates to:
  /// **'PIN code input'**
  String get pinCodeInput;

  /// Enter PIN code title
  ///
  /// In en, this message translates to:
  /// **'Enter PIN code'**
  String get enterPinCode;

  /// Confirm PIN code title
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN code'**
  String get confirmPinCode;

  /// PIN codes do not match error
  ///
  /// In en, this message translates to:
  /// **'PIN codes do not match'**
  String get pinCodesDoNotMatch;

  /// PIN code set successfully message
  ///
  /// In en, this message translates to:
  /// **'PIN code set successfully'**
  String get pinCodeSetSuccessfully;

  /// PIN code entered correctly message
  ///
  /// In en, this message translates to:
  /// **'PIN code entered correctly!'**
  String get pinCodeEnteredCorrectly;

  /// Blur applied message
  ///
  /// In en, this message translates to:
  /// **'Blur applied! Minimize the app to check.'**
  String get blurApplied;

  /// App locked message
  ///
  /// In en, this message translates to:
  /// **'App is locked'**
  String get appLocked;

  /// Minimize to unlock message
  ///
  /// In en, this message translates to:
  /// **'Minimize the app to unlock'**
  String get minimizeToUnlock;

  /// Accounts page title
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accounts;

  /// Add account button
  ///
  /// In en, this message translates to:
  /// **'Add account'**
  String get addAccount;

  /// Edit account title
  ///
  /// In en, this message translates to:
  /// **'Edit account'**
  String get editAccount;

  /// Delete account title
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// Account name field
  ///
  /// In en, this message translates to:
  /// **'Account name'**
  String get accountName;

  /// Account balance field
  ///
  /// In en, this message translates to:
  /// **'Account balance'**
  String get accountBalance;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Confirm button
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Delete account confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this account?'**
  String get deleteAccountConfirmation;

  /// Categories page title
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// Add category button
  ///
  /// In en, this message translates to:
  /// **'Add category'**
  String get addCategory;

  /// Category name field
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoryName;

  /// Income category
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// Expense category
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// Transactions page title
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// Add transaction title
  ///
  /// In en, this message translates to:
  /// **'Add transaction'**
  String get addTransaction;

  /// Transaction amount field
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get transactionAmount;

  /// Transaction description field
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get transactionDescription;

  /// Transaction date field
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get transactionDate;

  /// Transaction category field
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get transactionCategory;

  /// Transaction account field
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get transactionAccount;

  /// Analysis page title
  ///
  /// In en, this message translates to:
  /// **'Analysis'**
  String get analysis;

  /// Total balance label
  ///
  /// In en, this message translates to:
  /// **'Total balance'**
  String get totalBalance;

  /// Total income label
  ///
  /// In en, this message translates to:
  /// **'Total income'**
  String get totalIncome;

  /// Total expense label
  ///
  /// In en, this message translates to:
  /// **'Total expense'**
  String get totalExpense;

  /// This month label
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonth;

  /// Last month label
  ///
  /// In en, this message translates to:
  /// **'Last month'**
  String get lastMonth;

  /// This year label
  ///
  /// In en, this message translates to:
  /// **'This year'**
  String get thisYear;

  /// No data message
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// Error message
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Success message
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Retry button
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// OK button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Reset button
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Yes button
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No button
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Back button
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Next button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Previous button
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// Search field
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Filter button
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// Sort button
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// All filter
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Today filter
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Yesterday filter
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// This week filter
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get thisWeek;

  /// Last week filter
  ///
  /// In en, this message translates to:
  /// **'Last week'**
  String get lastWeek;

  /// Currency label
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// Russian ruble
  ///
  /// In en, this message translates to:
  /// **'RUB'**
  String get rub;

  /// US dollar
  ///
  /// In en, this message translates to:
  /// **'USD'**
  String get usd;

  /// Euro
  ///
  /// In en, this message translates to:
  /// **'EUR'**
  String get eur;

  /// Amount field
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// Description field
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Date field
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// Time field
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// Name field
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Type field
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// Status field
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// Active status
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// Inactive status
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// Enabled status
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// Disabled status
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// On status
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// Off status
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// Biometric not available message
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication is not available'**
  String get biometricNotAvailable;

  /// Biometric not configured message
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication is not configured on this device'**
  String get biometricNotConfigured;

  /// Biometric setup required message
  ///
  /// In en, this message translates to:
  /// **'Please set up biometric authentication in your device settings'**
  String get biometricSetupRequired;

  /// Use PIN code button
  ///
  /// In en, this message translates to:
  /// **'Use PIN code'**
  String get usePinCode;

  /// Use biometrics button
  ///
  /// In en, this message translates to:
  /// **'Use biometrics'**
  String get useBiometrics;

  /// Face ID label
  ///
  /// In en, this message translates to:
  /// **'Face ID'**
  String get faceId;

  /// Touch ID label
  ///
  /// In en, this message translates to:
  /// **'Touch ID'**
  String get touchId;

  /// Fingerprint authentication
  ///
  /// In en, this message translates to:
  /// **'Fingerprint'**
  String get fingerprint;

  /// Authentication required message
  ///
  /// In en, this message translates to:
  /// **'Authentication required'**
  String get authenticationRequired;

  /// Please authenticate message
  ///
  /// In en, this message translates to:
  /// **'Please authenticate to continue'**
  String get pleaseAuthenticate;

  /// Authentication failed message
  ///
  /// In en, this message translates to:
  /// **'Authentication failed'**
  String get authenticationFailed;

  /// Try again button
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// Transaction count with pluralization
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No transactions} =1{1 transaction} other{{count} transactions}}'**
  String transactionCount(int count);

  /// Account count with pluralization
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No accounts} =1{1 account} other{{count} accounts}}'**
  String accountCount(int count);

  /// Category count with pluralization
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No categories} =1{1 category} other{{count} categories}}'**
  String categoryCount(int count);

  /// Fill all fields error message
  ///
  /// In en, this message translates to:
  /// **'Fill all fields'**
  String get fillAllFields;

  /// Confirm deletion dialog title
  ///
  /// In en, this message translates to:
  /// **'Confirm deletion'**
  String get confirmDelete;

  /// Confirm delete transaction message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this transaction?'**
  String get confirmDeleteTransaction;

  /// Total label
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No data for period message
  ///
  /// In en, this message translates to:
  /// **'No data for period'**
  String get noDataForPeriod;

  /// Unlock button
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// Sort by date option
  ///
  /// In en, this message translates to:
  /// **'By date'**
  String get sortByDate;

  /// Sort by amount option
  ///
  /// In en, this message translates to:
  /// **'By amount'**
  String get sortByAmount;

  /// Account name updated message
  ///
  /// In en, this message translates to:
  /// **'Account name updated'**
  String get accountNameUpdated;

  /// Update error message
  ///
  /// In en, this message translates to:
  /// **'Update error'**
  String get updateError;

  /// No categories message
  ///
  /// In en, this message translates to:
  /// **'No categories'**
  String get noCategories;

  /// Period start label
  ///
  /// In en, this message translates to:
  /// **'Period: start'**
  String get periodStart;

  /// Period end label
  ///
  /// In en, this message translates to:
  /// **'Period: end'**
  String get periodEnd;

  /// No accounts message
  ///
  /// In en, this message translates to:
  /// **'No accounts'**
  String get noAccounts;

  /// Delete confirmation title
  ///
  /// In en, this message translates to:
  /// **'Delete confirmation'**
  String get deleteConfirmation;

  /// Delete not supported message
  ///
  /// In en, this message translates to:
  /// **'Account deletion is not supported'**
  String get deleteNotSupported;

  /// My categories title
  ///
  /// In en, this message translates to:
  /// **'My categories'**
  String get myCategories;

  /// Required field indicator
  ///
  /// In en, this message translates to:
  /// **' *'**
  String get required;

  /// My account title
  ///
  /// In en, this message translates to:
  /// **'My account'**
  String get myAccount;

  /// Balance label
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No data to display message
  ///
  /// In en, this message translates to:
  /// **'No data to display'**
  String get noDataToDisplay;

  /// 30 days period
  ///
  /// In en, this message translates to:
  /// **'30 days'**
  String get days30;

  /// 12 months period
  ///
  /// In en, this message translates to:
  /// **'12 months'**
  String get months12;

  /// Data from cache message
  ///
  /// In en, this message translates to:
  /// **'Data from cache'**
  String get dataFromCache;

  /// Data from network message
  ///
  /// In en, this message translates to:
  /// **'Data from network'**
  String get dataFromNetwork;

  /// Income today title
  ///
  /// In en, this message translates to:
  /// **'Income today'**
  String get incomeToday;

  /// Expense today title
  ///
  /// In en, this message translates to:
  /// **'Expense today'**
  String get expenseToday;

  /// Income history title
  ///
  /// In en, this message translates to:
  /// **'Income history'**
  String get incomeHistory;

  /// Expense history title
  ///
  /// In en, this message translates to:
  /// **'Expense history'**
  String get expenseHistory;

  /// Start date label
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// End date label
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// Select date placeholder
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// Select start date help text
  ///
  /// In en, this message translates to:
  /// **'Select start date'**
  String get selectStartDate;

  /// Select end date help text
  ///
  /// In en, this message translates to:
  /// **'Select end date'**
  String get selectEndDate;

  /// Find article placeholder
  ///
  /// In en, this message translates to:
  /// **'Find article...'**
  String get findArticle;

  /// Article not found message
  ///
  /// In en, this message translates to:
  /// **'Article not found'**
  String get articleNotFound;

  /// Select currency dialog title
  ///
  /// In en, this message translates to:
  /// **'Select currency'**
  String get selectCurrency;

  /// Sorting label
  ///
  /// In en, this message translates to:
  /// **'Sorting'**
  String get sorting;

  /// Edit transaction title
  ///
  /// In en, this message translates to:
  /// **'Edit transaction'**
  String get editTransaction;

  /// Transaction name placeholder
  ///
  /// In en, this message translates to:
  /// **'Name / description'**
  String get transactionName;

  /// Delete transaction button
  ///
  /// In en, this message translates to:
  /// **'Delete transaction'**
  String get deleteTransaction;

  /// Select account dialog title
  ///
  /// In en, this message translates to:
  /// **'Select account'**
  String get selectAccount;

  /// Confirm identity message
  ///
  /// In en, this message translates to:
  /// **'Confirm your identity'**
  String get confirmIdentity;

  /// Biometric unavailable message
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication is unavailable or not configured. Use PIN code.'**
  String get biometricUnavailable;

  /// Face ID / Touch ID label
  ///
  /// In en, this message translates to:
  /// **'Face ID / Touch ID'**
  String get faceIdTouchId;

  /// Setup PIN code title
  ///
  /// In en, this message translates to:
  /// **'Setup PIN code'**
  String get setupPinCode;

  /// PIN code save error message
  ///
  /// In en, this message translates to:
  /// **'Error saving PIN code'**
  String get pinCodeSaveError;

  /// PIN codes don't match message
  ///
  /// In en, this message translates to:
  /// **'PIN codes don\'t match'**
  String get pinCodesDontMatch;

  /// Incorrect PIN code message
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN code'**
  String get incorrectPinCode;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
