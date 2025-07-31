// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'SHMR Finance';

  @override
  String get settings => 'Настройки';

  @override
  String get theme => 'Тема';

  @override
  String get systemTheme => 'Системная тема';

  @override
  String get primaryColor => 'Основной цвет';

  @override
  String get hapticFeedback => 'Тактильная обратная связь';

  @override
  String get language => 'Язык';

  @override
  String get security => 'Безопасность';

  @override
  String get pinCode => 'PIN-код';

  @override
  String get pinCodeRequired => 'Сначала включите PIN-код';

  @override
  String get biometrics => 'Биометрия';

  @override
  String get appBlur => 'Блюр приложения';

  @override
  String get appBlurDescription =>
      'Для теста!!! Размытие экрана в режиме мультизадачности';

  @override
  String get testPinCode => 'Тест PIN-кода';

  @override
  String get testPinCodeDescription => 'Проверить ввод PIN-кода';

  @override
  String get testBlur => 'Тест блюра';

  @override
  String get testBlurDescription => 'Принудительно применить блюр';

  @override
  String get pinCodeSetup => 'Установка PIN-кода';

  @override
  String get pinCodeInput => 'Ввод PIN-кода';

  @override
  String get enterPinCode => 'Введите PIN-код';

  @override
  String get confirmPinCode => 'Подтвердите PIN-код';

  @override
  String get pinCodesDoNotMatch => 'PIN-коды не совпадают';

  @override
  String get pinCodeSetSuccessfully => 'PIN-код успешно установлен';

  @override
  String get pinCodeEnteredCorrectly => 'PIN-код введен правильно!';

  @override
  String get blurApplied => 'Блюр применен! Сверните приложение для проверки.';

  @override
  String get appLocked => 'Приложение заблокировано';

  @override
  String get minimizeToUnlock => 'Сверните приложение для разблокировки';

  @override
  String get accounts => 'Счета';

  @override
  String get addAccount => 'Добавить счет';

  @override
  String get editAccount => 'Редактировать счет';

  @override
  String get deleteAccount => 'Удалить счет';

  @override
  String get accountName => 'Название счета';

  @override
  String get accountBalance => 'Баланс счета';

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get deleteAccountConfirmation =>
      'Вы уверены, что хотите удалить этот счет?';

  @override
  String get categories => 'Категории';

  @override
  String get addCategory => 'Добавить категорию';

  @override
  String get categoryName => 'Название категории';

  @override
  String get income => 'Доходы';

  @override
  String get expense => 'Расходы';

  @override
  String get transactions => 'Транзакции';

  @override
  String get addTransaction => 'Добавить транзакцию';

  @override
  String get transactionAmount => 'Сумма';

  @override
  String get transactionDescription => 'Описание';

  @override
  String get transactionDate => 'Дата';

  @override
  String get transactionCategory => 'Категория';

  @override
  String get transactionAccount => 'Счет';

  @override
  String get analysis => 'Анализ';

  @override
  String get totalBalance => 'Общий баланс';

  @override
  String get totalIncome => 'Общий доход';

  @override
  String get totalExpense => 'Общий расход';

  @override
  String get thisMonth => 'Этот месяц';

  @override
  String get lastMonth => 'Прошлый месяц';

  @override
  String get thisYear => 'Этот год';

  @override
  String get noData => 'Нет данных';

  @override
  String get error => 'Ошибка';

  @override
  String get success => 'Успех';

  @override
  String get loading => 'Загрузка...';

  @override
  String get retry => 'Повторить';

  @override
  String get close => 'Закрыть';

  @override
  String get ok => 'ОК';

  @override
  String get reset => 'Сбросить';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get back => 'Назад';

  @override
  String get next => 'Далее';

  @override
  String get previous => 'Предыдущий';

  @override
  String get search => 'Поиск';

  @override
  String get filter => 'Фильтр';

  @override
  String get sort => 'Сортировка';

  @override
  String get all => 'Все';

  @override
  String get today => 'Сегодня';

  @override
  String get yesterday => 'Вчера';

  @override
  String get thisWeek => 'Эта неделя';

  @override
  String get lastWeek => 'Прошлая неделя';

  @override
  String get currency => 'Валюта';

  @override
  String get rub => 'РУБ';

  @override
  String get usd => 'USD';

  @override
  String get eur => 'EUR';

  @override
  String get amount => 'Сумма';

  @override
  String get description => 'Описание';

  @override
  String get date => 'Дата';

  @override
  String get time => 'Время';

  @override
  String get name => 'Название';

  @override
  String get type => 'Тип';

  @override
  String get status => 'Статус';

  @override
  String get active => 'Активный';

  @override
  String get inactive => 'Неактивный';

  @override
  String get enabled => 'Включено';

  @override
  String get disabled => 'Отключено';

  @override
  String get on => 'Вкл';

  @override
  String get off => 'Выкл';

  @override
  String get biometricNotAvailable =>
      'Биометрическая аутентификация недоступна';

  @override
  String get biometricNotConfigured =>
      'Биометрическая аутентификация не настроена на этом устройстве';

  @override
  String get biometricSetupRequired =>
      'Пожалуйста, настройте биометрическую аутентификацию в настройках устройства';

  @override
  String get usePinCode => 'Использовать PIN-код';

  @override
  String get useBiometrics => 'Использовать биометрию';

  @override
  String get faceId => 'Face ID';

  @override
  String get touchId => 'Touch ID';

  @override
  String get fingerprint => 'Отпечаток пальца';

  @override
  String get authenticationRequired => 'Требуется аутентификация';

  @override
  String get pleaseAuthenticate =>
      'Пожалуйста, пройдите аутентификацию для продолжения';

  @override
  String get authenticationFailed => 'Аутентификация не удалась';

  @override
  String get tryAgain => 'Попробовать снова';

  @override
  String transactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count транзакций',
      many: '$count транзакций',
      few: '$count транзакции',
      one: '1 транзакция',
      zero: 'Нет транзакций',
    );
    return '$_temp0';
  }

  @override
  String accountCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count счетов',
      many: '$count счетов',
      few: '$count счета',
      one: '1 счет',
      zero: 'Нет счетов',
    );
    return '$_temp0';
  }

  @override
  String categoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count категорий',
      many: '$count категорий',
      few: '$count категории',
      one: '1 категория',
      zero: 'Нет категорий',
    );
    return '$_temp0';
  }

  @override
  String get fillAllFields => 'Заполните все поля';

  @override
  String get confirmDelete => 'Подтвердите удаление';

  @override
  String get confirmDeleteTransaction =>
      'Вы уверены, что хотите удалить эту транзакцию?';

  @override
  String get total => 'Всего';

  @override
  String get noDataForPeriod => 'Нет данных за период';

  @override
  String get unlock => 'Разблокировать';

  @override
  String get sortByDate => 'По дате';

  @override
  String get sortByAmount => 'По сумме';

  @override
  String get accountNameUpdated => 'Имя счета обновлено';

  @override
  String get updateError => 'Ошибка при обновлении';

  @override
  String get noCategories => 'Нет категорий';

  @override
  String get periodStart => 'Период: начало';

  @override
  String get periodEnd => 'Период: конец';

  @override
  String get noAccounts => 'Нет счетов';

  @override
  String get deleteConfirmation => 'Подтверждение удаления';

  @override
  String get deleteNotSupported => 'Удаление счета не поддерживается';

  @override
  String get myCategories => 'Мои статьи';

  @override
  String get required => ' *';

  @override
  String get myAccount => 'Мой счёт';

  @override
  String get balance => 'Баланс';

  @override
  String get noDataToDisplay => 'Нет данных для отображения';

  @override
  String get days30 => '30 дней';

  @override
  String get months12 => '12 месяцев';

  @override
  String get dataFromCache => 'Данные из кэша';

  @override
  String get dataFromNetwork => 'Данные из сети';

  @override
  String get incomeToday => 'Доходы сегодня';

  @override
  String get expenseToday => 'Расходы сегодня';

  @override
  String get incomeHistory => 'История доходов';

  @override
  String get expenseHistory => 'История расходов';

  @override
  String get start => 'Начало';

  @override
  String get end => 'Конец';

  @override
  String get selectDate => 'Выберите дату';

  @override
  String get selectStartDate => 'Выберите дату начала';

  @override
  String get selectEndDate => 'Выберите дату конца';

  @override
  String get findArticle => 'Найти статью...';

  @override
  String get articleNotFound => 'Статья не найдена';

  @override
  String get selectCurrency => 'Выберите валюту';

  @override
  String get sorting => 'Сортировка';

  @override
  String get editTransaction => 'Редактировать транзакцию';

  @override
  String get transactionName => 'Название / описание';

  @override
  String get deleteTransaction => 'Удалить транзакцию';

  @override
  String get selectAccount => 'Выберите счёт';

  @override
  String get confirmIdentity => 'Подтвердите вашу личность';

  @override
  String get biometricUnavailable =>
      'Биометрия недоступна или не настроена. Используйте PIN-код.';

  @override
  String get faceIdTouchId => 'Face ID / Touch ID';

  @override
  String get setupPinCode => 'Установите PIN-код';

  @override
  String get pinCodeSaveError => 'Ошибка сохранения PIN-кода';

  @override
  String get pinCodesDontMatch => 'PIN-коды не совпадают';

  @override
  String get incorrectPinCode => 'Неверный PIN-код';
}
