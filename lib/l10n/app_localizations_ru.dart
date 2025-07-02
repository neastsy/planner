// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Планировщик активностей';

  @override
  String get days_PZT => 'ПН';

  @override
  String get days_SAL => 'ВТ';

  @override
  String get days_CAR => 'СР';

  @override
  String get days_PER => 'ЧТ';

  @override
  String get days_CUM => 'ПТ';

  @override
  String get days_CMT => 'СБ';

  @override
  String get days_PAZ => 'ВС';

  @override
  String get addNewActivity => 'Добавить активность';

  @override
  String get activityList => 'Список активностей';

  @override
  String get noActivityToday => 'На сегодня еще не добавлено активностей.';

  @override
  String get editActivity => 'Редактировать активность';

  @override
  String get activityName => 'Название активности';

  @override
  String get activityNameHint => 'Пожалуйста, введите название активности.';

  @override
  String get startTime => 'Время начала';

  @override
  String get endTime => 'Время окончания';

  @override
  String get selectTime => 'Выбрать';

  @override
  String get chooseColor => 'Выбрать цвет';

  @override
  String get add => 'Добавить';

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String get deleteActivityTitle => 'Удалить активность';

  @override
  String get deleteActivityContent =>
      'Вы уверены, что хотите удалить эту активность?';

  @override
  String get delete => 'Удалить';

  @override
  String get overlappingActivityTitle => 'Пересекающаяся активность';

  @override
  String get overlappingActivityContent =>
      'В этом временном промежутке есть другая активность. Все равно продолжить?';

  @override
  String get continueAction => 'Продолжить';

  @override
  String get errorSelectAllTimes => 'Пожалуйста, выберите все временные рамки.';

  @override
  String get errorStartEndTimeSame =>
      'Время начала и окончания не могут совпадать.';

  @override
  String get timePickerSet => 'УСТАНОВИТЬ';

  @override
  String get timePickerSelect => 'ВЫБЕРИТЕ ВРЕМЯ';

  @override
  String get selectLanguage => 'Выберите язык';

  @override
  String get settings => 'Настройки';

  @override
  String get theme => 'Тема';

  @override
  String get lightTheme => 'Светлая тема';

  @override
  String get darkTheme => 'Темная тема';

  @override
  String get notes => 'Заметки (необязательно)';

  @override
  String get copyDay => 'Копировать день';

  @override
  String get copy => 'Копировать';

  @override
  String copyFromTo(String dayName) {
    return 'Копировать все занятия с $dayName на:';
  }

  @override
  String get targetDayNotEmptyTitle => 'Целевой день не пуст';

  @override
  String targetDayNotEmptyContent(String dayName) {
    return 'В дне \'$dayName\' уже есть занятия. Вы уверены, что хотите добавить новые занятия?';
  }
}
