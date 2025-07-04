// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Aktivitätsplaner';

  @override
  String get days_PZT => 'MO';

  @override
  String get days_SAL => 'DI';

  @override
  String get days_CAR => 'MI';

  @override
  String get days_PER => 'DO';

  @override
  String get days_CUM => 'FR';

  @override
  String get days_CMT => 'SA';

  @override
  String get days_PAZ => 'SO';

  @override
  String get addNewActivity => 'Aktivität hinzufügen';

  @override
  String get activityList => 'Aktivitätsliste';

  @override
  String get noActivityToday =>
      'Für heute wurden noch keine Aktivitäten hinzugefügt.';

  @override
  String get editActivity => 'Aktivität bearbeiten';

  @override
  String get activityName => 'Aktivitätsname';

  @override
  String get activityNameHint => 'Bitte geben Sie einen Aktivitätsnamen ein.';

  @override
  String get startTime => 'Startzeit';

  @override
  String get endTime => 'Endzeit';

  @override
  String get selectTime => 'Wählen';

  @override
  String get chooseColor => 'Farbe wählen';

  @override
  String get add => 'Hinzufügen';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get deleteActivityTitle => 'Aktivität löschen';

  @override
  String get deleteActivityContent =>
      'Sind Sie sicher, dass Sie diese Aktivität löschen möchten?';

  @override
  String get delete => 'Löschen';

  @override
  String get overlappingActivityTitle => 'Überlappende Aktivität';

  @override
  String get overlappingActivityContent =>
      'In diesem Zeitraum gibt es eine andere Aktivität. Möchten Sie trotzdem fortfahren?';

  @override
  String get continueAction => 'Fortfahren';

  @override
  String get errorSelectAllTimes => 'Bitte wählen Sie alle Zeiten aus.';

  @override
  String get errorStartEndTimeSame =>
      'Start- und Endzeit dürfen nicht identisch sein.';

  @override
  String get timePickerSet => 'EINSTELLEN';

  @override
  String get timePickerSelect => 'ZEIT WÄHLEN';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get theme => 'Thema';

  @override
  String get lightTheme => 'Helles Thema';

  @override
  String get darkTheme => 'Dunkles Thema';

  @override
  String get notes => 'Notizen (Optional)';

  @override
  String get copyDay => 'Tag kopieren';

  @override
  String get copy => 'Kopieren';

  @override
  String copyFromTo(String dayName) {
    return 'Alle Aktivitäten von $dayName kopieren nach:';
  }

  @override
  String get targetDayNotEmptyTitle => 'Zieltag nicht leer';

  @override
  String targetDayNotEmptyContent(String dayName) {
    return 'Der Tag \'$dayName\' hat bereits Aktivitäten. Möchten Sie die neuen Aktivitäten trotzdem hinzufügen?';
  }

  @override
  String get deleteAll => 'Alle löschen';

  @override
  String get deleteAllActivitiesTitle => 'Alle Aktivitäten löschen';

  @override
  String deleteAllActivitiesContent(String dayName) {
    return 'Möchten Sie wirklich alle Aktivitäten für $dayName löschen?';
  }

  @override
  String get notificationSettings => 'Benachrichtigungseinstellungen';

  @override
  String get notificationsOff => 'Benachrichtigungen aus';

  @override
  String get notifyOnTime => 'Pünktlich benachrichtigen';

  @override
  String get notify5MinBefore => '5 Minuten vorher';

  @override
  String get notify15MinBefore => '15 Minuten vorher';

  @override
  String notificationBody(String activityName, String time) {
    return 'Ihre Aktivität \'$activityName\' beginnt um $time Uhr.';
  }

  @override
  String dayCopied(Object fromDay, Object toDay) {
    return 'Kopiert von $fromDay nach $toDay.';
  }

  @override
  String allDeleted(Object dayName) {
    return 'Alle Aktivitäten für $dayName wurden gelöscht.';
  }
}
