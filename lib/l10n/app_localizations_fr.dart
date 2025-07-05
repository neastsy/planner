// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Planificateur d\'Activités';

  @override
  String get days_PZT => 'LUN';

  @override
  String get days_SAL => 'MAR';

  @override
  String get days_CAR => 'MER';

  @override
  String get days_PER => 'JEU';

  @override
  String get days_CUM => 'VEN';

  @override
  String get days_CMT => 'SAM';

  @override
  String get days_PAZ => 'DIM';

  @override
  String get addNewActivity => 'Ajouter une activité';

  @override
  String get activityList => 'Liste d\'activités';

  @override
  String get noActivityToday => 'Aucune activité ajoutée pour aujourd\'hui.';

  @override
  String get editActivity => 'Modifier l\'activité';

  @override
  String get activityName => 'Nom de l\'activité';

  @override
  String get activityNameHint => 'Veuillez entrer un nom d\'activité.';

  @override
  String get startTime => 'Heure de début';

  @override
  String get endTime => 'Heure de fin';

  @override
  String get selectTime => 'Sélectionner';

  @override
  String get chooseColor => 'Choisir une couleur';

  @override
  String get add => 'Ajouter';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get deleteActivityTitle => 'Supprimer l\'activité';

  @override
  String get deleteActivityContent =>
      'Êtes-vous sûr de vouloir supprimer cette activité ?';

  @override
  String get delete => 'Supprimer';

  @override
  String get overlappingActivityTitle => 'Activité en conflit';

  @override
  String get overlappingActivityContent =>
      'Il y a une autre activité dans cette plage horaire. Voulez-vous continuer quand même ?';

  @override
  String get continueAction => 'Continuer';

  @override
  String get errorSelectAllTimes => 'Veuillez sélectionner toutes les heures.';

  @override
  String get errorStartEndTimeSame =>
      'L\'heure de début et de fin ne peuvent pas être identiques.';

  @override
  String get timePickerSet => 'DÉFINIR';

  @override
  String get timePickerSelect => 'SÉLECTIONNER L\'HEURE';

  @override
  String get selectLanguage => 'Choisir la langue';

  @override
  String get settings => 'Paramètres';

  @override
  String get theme => 'Thème';

  @override
  String get lightTheme => 'Thème clair';

  @override
  String get darkTheme => 'Thème sombre';

  @override
  String get notes => 'Notes (Facultatif)';

  @override
  String get copyDay => 'Copier le jour';

  @override
  String get copy => 'Copier';

  @override
  String copyFromTo(String dayName) {
    return 'Copier toutes les activités de $dayName vers :';
  }

  @override
  String get targetDayNotEmptyTitle => 'Jour cible non vide';

  @override
  String targetDayNotEmptyContent(String dayName) {
    return 'Le jour \'$dayName\' a déjà des activités. Êtes-vous sûr de vouloir ajouter les nouvelles activités ?';
  }

  @override
  String get deleteAll => 'Tout supprimer';

  @override
  String get deleteAllActivitiesTitle => 'Supprimer toutes les activités';

  @override
  String deleteAllActivitiesContent(String dayName) {
    return 'Êtes-vous sûr de vouloir supprimer toutes les activités pour $dayName ?';
  }

  @override
  String get notificationSettings => 'Paramètres de notification';

  @override
  String get notificationsOff => 'Notifications désactivées';

  @override
  String get notifyOnTime => 'Notifier à l\'heure';

  @override
  String get notify5MinBefore => '5 minutes avant';

  @override
  String get notify15MinBefore => '15 minutes avant';

  @override
  String notificationBody(String activityName, String time) {
    return 'Votre activité \'$activityName\' doit commencer à $time.';
  }
}
