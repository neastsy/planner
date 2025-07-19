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

  @override
  String get copyMode => 'Kopiermodus';

  @override
  String get copyModeMerge => 'Mit vorhandenen Aktivitäten zusammenführen';

  @override
  String get copyModeOverwrite => 'Vorhandene Aktivitäten überschreiben';

  @override
  String get overwriteConfirmationTitle => 'Überschreiben bestätigen';

  @override
  String overwriteConfirmationContent(Object dayName) {
    return 'Dadurch werden alle vorhandenen Aktivitäten am \'$dayName\' gelöscht und ersetzt. Sind Sie sicher?';
  }

  @override
  String get overwrite => 'Überschreiben';

  @override
  String get pendingNotificationsTitle => 'Ausstehende Benachrichtigungen';

  @override
  String get noPendingNotifications =>
      'Es gibt keine ausstehenden Benachrichtigungen.';

  @override
  String get noTitle => 'Kein Titel';

  @override
  String get noBody => 'Kein Inhalt';

  @override
  String get cancelAll => 'Alle abbrechen';

  @override
  String get close => 'Schließen';

  @override
  String get allNotificationsCancelled =>
      'Alle ausstehenden Benachrichtigungen wurden abgebrochen.';

  @override
  String get viewPendingNotifications =>
      'Ausstehende Benachrichtigungen anzeigen';

  @override
  String get unknown => 'Unbekannt';

  @override
  String get activityTime => 'Aktivitätszeit';

  @override
  String get notificationType => 'Benachrichtigungstyp';

  @override
  String get scheduledFor => 'Geplant für';

  @override
  String get editTemplate => 'Vorlage bearbeiten';

  @override
  String get addTemplate => 'Neue Vorlage hinzufügen';

  @override
  String get templateName => 'Vorlagenname';

  @override
  String get templateNameHint => 'Bitte geben Sie einen Vorlagennamen ein.';

  @override
  String get durationInMinutes => 'Dauer (in Minuten)';

  @override
  String get durationHint => 'Bitte geben Sie eine Dauer ein.';

  @override
  String get durationInvalidHint =>
      'Bitte geben Sie eine gültige, positive Zahl ein.';

  @override
  String get templateManagerTitle => 'Vorlagen-Manager';

  @override
  String get noTemplates =>
      'Noch keine Vorlagen erstellt. Tippen Sie auf \'+\', um eine hinzuzufügen.';

  @override
  String durationLabel(Object minutes) {
    return 'Dauer: $minutes Min.';
  }

  @override
  String get manageTemplates => 'Aktivitätsvorlagen verwalten';

  @override
  String get deleteTemplateTitle => 'Vorlage löschen';

  @override
  String deleteTemplateContent(Object templateName) {
    return 'Möchten Sie die Vorlage \'$templateName\' wirklich löschen?';
  }

  @override
  String get durationMaxHint =>
      'Die Dauer darf 1440 Minuten (24 Stunden) nicht überschreiten.';

  @override
  String get addFromTemplate => 'Aus Vorlage';

  @override
  String get noTemplatesToUse =>
      'Keine Vorlagen verfügbar. Bitte erstellen Sie eine in den Einstellungen.';

  @override
  String get selectTemplate => 'Vorlage auswählen';

  @override
  String get tagsLabel => 'Tags (kommagetrennt)';

  @override
  String get tagsHint => 'z.B. Arbeit, Sport, Persönliches';

  @override
  String get statisticsPageTitle => 'Statistiken';

  @override
  String get statisticsButtonTooltip => 'Statistiken anzeigen';

  @override
  String get tagDistributionTitle => 'Zeitverteilung nach Tag';

  @override
  String get dailyActivityTitle => 'Gesamte Aktivitätszeit nach Tag';

  @override
  String get noDataForStatistics =>
      'Es liegen keine Aktivitätsdaten zur Anzeige von Statistiken vor. Fang an, deine Tage zu planen!';

  @override
  String get untagged => 'Ohne Tag';

  @override
  String todayIs(String dayName) {
    return 'Heute ist $dayName';
  }

  @override
  String get fullDay_monday => 'Montag';

  @override
  String get fullDay_tuesday => 'Dienstag';

  @override
  String get fullDay_wednesday => 'Mittwoch';

  @override
  String get fullDay_thursday => 'Donnerstag';

  @override
  String get fullDay_friday => 'Freitag';

  @override
  String get fullDay_saturday => 'Samstag';

  @override
  String get fullDay_sunday => 'Sonntag';

  @override
  String get repeatNotificationWeekly => 'Wöchentlich wiederholen';

  @override
  String get recurringNotificationHint => 'Wird zur Aktivitätszeit wiederholt';

  @override
  String get error_appCouldNotStart =>
      'Anwendung konnte nicht gestartet werden';

  @override
  String get error_unexpectedError =>
      'Ein unerwarteter Fehler ist aufgetreten. Bitte versuchen Sie, die Anwendung neu zu starten.';

  @override
  String get error_restart => 'Neu starten';

  @override
  String get error_detailsForDeveloper => 'Fehlerdetails (für Entwickler):';

  @override
  String get pomodoro_startFocusSession => 'Fokus-Sitzung starten';

  @override
  String get pomodoro_sessionStateWork => 'Arbeit';

  @override
  String get pomodoro_sessionStateShortBreak => 'Kurze Pause';

  @override
  String get pomodoro_sessionStateLongBreak => 'Lange Pause';

  @override
  String get pomodoro_sessionStatePaused => 'Pausiert';

  @override
  String pomodoro_completedSessions(int count) {
    return 'Abgeschlossene Sitzungen: $count';
  }

  @override
  String get pomodoro_endSessionTitle => 'Sitzung beenden';

  @override
  String pomodoro_endSessionContent(
      Object sessionCount, Object minutes, Object activityName) {
    return '$sessionCount Pomodoro-Sitzung(en) ($minutes Minuten) zur Aktivität \'$activityName\' hinzufügen?';
  }

  @override
  String get pomodoro_dontSave => 'Nicht speichern';

  @override
  String get pomodoro_saveAndExit => 'Ja, hinzufügen';

  @override
  String get tapPlusToStart =>
      'Tippen Sie auf die \'+\'-Schaltfläche, um mit der Planung zu beginnen.';
}
