// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Планировщик дня';

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

  @override
  String get deleteAll => 'Удалить все';

  @override
  String get deleteAllActivitiesTitle => 'Удалить все занятия';

  @override
  String deleteAllActivitiesContent(String dayName) {
    return 'Вы уверены, что хотите удалить все занятия для $dayName?';
  }

  @override
  String get notificationSettings => 'Настройки уведомлений';

  @override
  String get notificationsOff => 'Уведомления выключены';

  @override
  String get notifyOnTime => 'Уведомить вовремя';

  @override
  String get notify5MinBefore => 'За 5 минут';

  @override
  String get notify15MinBefore => 'За 15 минут';

  @override
  String notificationBody(String activityName, String time) {
    return 'Ваше занятие \'$activityName\' запланировано на $time.';
  }

  @override
  String dayCopied(Object fromDay, Object toDay) {
    return 'Скопировано с $fromDay на $toDay.';
  }

  @override
  String allDeleted(Object dayName) {
    return 'Все занятия на $dayName были удалены.';
  }

  @override
  String get copyMode => 'Режим копирования';

  @override
  String get copyModeMerge => 'Объединить с существующими активностями';

  @override
  String get copyModeOverwrite => 'Перезаписать существующие активности';

  @override
  String get overwriteConfirmationTitle => 'Подтвердите перезапись';

  @override
  String overwriteConfirmationContent(Object dayName) {
    return 'Это удалит все существующие активности в \'$dayName\' и заменит их. Вы уверены?';
  }

  @override
  String get overwrite => 'Перезаписать';

  @override
  String get pendingNotificationsTitle => 'Ожидающие уведомления';

  @override
  String get noPendingNotifications => 'Нет ожидающих уведомлений.';

  @override
  String get noTitle => 'Без названия';

  @override
  String get noBody => 'Нет содержимого';

  @override
  String get cancelAll => 'Отменить все';

  @override
  String get close => 'Закрыть';

  @override
  String get allNotificationsCancelled =>
      'Все ожидающие уведомления были отменены.';

  @override
  String get viewPendingNotifications => 'Просмотреть ожидающие уведомления';

  @override
  String get unknown => 'Неизвестно';

  @override
  String get activityTime => 'Время активности';

  @override
  String get notificationType => 'Тип уведомления';

  @override
  String get scheduledFor => 'Запланировано на';

  @override
  String get editTemplate => 'Редактировать шаблон';

  @override
  String get addTemplate => 'Добавить новый шаблон';

  @override
  String get templateName => 'Название шаблона';

  @override
  String get templateNameHint => 'Пожалуйста, введите название шаблона.';

  @override
  String get durationInMinutes => 'Длительность (в минутах)';

  @override
  String get durationHint => 'Пожалуйста, введите длительность.';

  @override
  String get durationInvalidHint =>
      'Пожалуйста, введите действительное положительное число.';

  @override
  String get templateManagerTitle => 'Менеджер шаблонов';

  @override
  String get noTemplates =>
      'Шаблоны еще не созданы. Нажмите \'+\', чтобы добавить.';

  @override
  String durationLabel(Object minutes) {
    return 'Длительность: $minutes мин.';
  }

  @override
  String get manageTemplates => 'Управление шаблонами активностей';

  @override
  String get deleteTemplateTitle => 'Удалить шаблон';

  @override
  String deleteTemplateContent(Object templateName) {
    return 'Вы уверены, что хотите удалить шаблон \'$templateName\'?';
  }

  @override
  String get durationMaxHint =>
      'Длительность не может превышать 1440 минут (24 часа).';

  @override
  String get addFromTemplate => 'Из шаблона';

  @override
  String get noTemplatesToUse =>
      'Нет доступных шаблонов. Пожалуйста, создайте один в настройках.';

  @override
  String get selectTemplate => 'Выберите шаблон';

  @override
  String get tagsLabel => 'Теги (через запятую)';

  @override
  String get tagsHint => 'напр. работа, спорт, личное';

  @override
  String get statisticsPageTitle => 'Статистика';

  @override
  String get statisticsButtonTooltip => 'Посмотреть статистику';

  @override
  String get tagDistributionTitle => 'Распределение времени по тегам';

  @override
  String get dailyActivityTitle => 'Общее время активности по дням';

  @override
  String get noDataForStatistics =>
      'Нет данных об активности для отображения статистики. Начните планировать свои дни!';

  @override
  String get untagged => 'Без тега';

  @override
  String todayIs(String dayName) {
    return 'Сегодня $dayName';
  }

  @override
  String get fullDay_monday => 'Понедельник';

  @override
  String get fullDay_tuesday => 'Вторник';

  @override
  String get fullDay_wednesday => 'Среда';

  @override
  String get fullDay_thursday => 'Четверг';

  @override
  String get fullDay_friday => 'Пятница';

  @override
  String get fullDay_saturday => 'Суббота';

  @override
  String get fullDay_sunday => 'Воскресенье';

  @override
  String get repeatNotificationWeekly => 'Повторять еженедельно';

  @override
  String get recurringNotificationHint => 'Повторяется во время активности';

  @override
  String get error_appCouldNotStart => 'Не удалось запустить приложение';

  @override
  String get error_unexpectedError =>
      'Произошла непредвиденная ошибка. Пожалуйста, попробуйте перезапустить приложение.';

  @override
  String get error_restart => 'Перезапустить';

  @override
  String get error_detailsForDeveloper => 'Детали ошибки (для разработчика):';

  @override
  String get pomodoro_startFocusSession => 'Начать сеанс фокусировки';

  @override
  String get pomodoro_sessionStateWork => 'Работа';

  @override
  String get pomodoro_sessionStateShortBreak => 'Короткий перерыв';

  @override
  String get pomodoro_sessionStateLongBreak => 'Длинный перерыв';

  @override
  String get pomodoro_sessionStatePaused => 'Пауза';

  @override
  String pomodoro_completedSessions(int count) {
    return 'Завершено сеансов: $count';
  }

  @override
  String get pomodoro_endSessionTitle => 'Завершить сеанс';

  @override
  String pomodoro_endSessionContent(
      Object sessionCount, Object minutes, Object activityName) {
    return 'Добавить $sessionCount сеанс(ов) Pomodoro ($minutes минут) к задаче \'$activityName\'?';
  }

  @override
  String get pomodoro_dontSave => 'Не сохранять';

  @override
  String get pomodoro_saveAndExit => 'Да, добавить';

  @override
  String get tapPlusToStart =>
      'Нажмите кнопку \'+\', чтобы начать планирование.';

  @override
  String get pomodoro_resetProgress => 'Сбросить прогресс';

  @override
  String get pomodoro_continueSession => 'Продолжить сеанс';

  @override
  String get pomodoro_activityCompleted => 'Это задание уже выполнено!';

  @override
  String targetReached(Object activityName) {
    return 'Цель достигнута! Вы завершили задачу \'$activityName\'.';
  }

  @override
  String pomodoro_completedMinutes(Object completed, Object total) {
    return '$completed / $total мин завершено';
  }

  @override
  String pomodoro_confirmSaveContent(Object activityName, Object minutes) {
    return 'Добавить $minutes минут, завершенных в этом сеансе, к задаче \'$activityName\'?';
  }

  @override
  String get permissionRequired => 'Требуется разрешение';

  @override
  String get permissionExplanation =>
      'Чтобы использовать уведомления и таймер Pomodoro, вам необходимо включить разрешения на уведомления в настройках приложения.';

  @override
  String get openSettings => 'Открыть настройки';

  @override
  String get pomodoroPermissionRequired =>
      'Для работы таймера Pomodoro требуется разрешение на уведомления.';

  @override
  String get themeColor => 'Цвет темы';

  @override
  String get today => 'Сегодня';

  @override
  String get pomodoro_resetConfirmationTitle => 'Подтвердите сброс';

  @override
  String get pomodoro_resetConfirmationContent =>
      'Вы уверены, что хотите сбросить прогресс Pomodoro для этого занятия? Это действие необратимо.';

  @override
  String get useAmoledTheme => 'Черная тема AMOLED';

  @override
  String get useAmoledThemeSubtitle =>
      'Использует чисто черный фон для экономии заряда батареи на OLED-экранах.';
}
