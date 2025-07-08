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

  @override
  String dayCopied(Object fromDay, Object toDay) {
    return 'Copié de $fromDay à $toDay.';
  }

  @override
  String allDeleted(Object dayName) {
    return 'Toutes les activités pour $dayName ont été supprimées.';
  }

  @override
  String get copyMode => 'Mode de copie';

  @override
  String get copyModeMerge => 'Fusionner avec les activités existantes';

  @override
  String get copyModeOverwrite => 'Écraser les activités existantes';

  @override
  String get overwriteConfirmationTitle => 'Confirmer l\'écrasement';

  @override
  String overwriteConfirmationContent(Object dayName) {
    return 'Ceci supprimera toutes les activités existantes le \'$dayName\' et les remplacera. Êtes-vous sûr ?';
  }

  @override
  String get overwrite => 'Écraser';

  @override
  String get pendingNotificationsTitle => 'Notifications en attente';

  @override
  String get noPendingNotifications =>
      'Il n\'y a aucune notification en attente.';

  @override
  String get noTitle => 'Sans Titre';

  @override
  String get noBody => 'Sans Corps';

  @override
  String get cancelAll => 'Tout annuler';

  @override
  String get close => 'Fermer';

  @override
  String get allNotificationsCancelled =>
      'Toutes les notifications en attente ont été annulées.';

  @override
  String get viewPendingNotifications => 'Voir les notifications en attente';

  @override
  String get unknown => 'Inconnu';

  @override
  String get activityTime => 'Heure de l\'activité';

  @override
  String get notificationType => 'Type de notification';

  @override
  String get scheduledFor => 'Prévu pour';

  @override
  String get editTemplate => 'Modifier le Modèle';

  @override
  String get addTemplate => 'Ajouter un Nouveau Modèle';

  @override
  String get templateName => 'Nom du Modèle';

  @override
  String get templateNameHint => 'Veuillez entrer un nom de modèle.';

  @override
  String get durationInMinutes => 'Durée (en minutes)';

  @override
  String get durationHint => 'Veuillez entrer une durée.';

  @override
  String get durationInvalidHint =>
      'Veuillez entrer un nombre valide et positif.';

  @override
  String get templateManagerTitle => 'Gestionnaire de Modèles';

  @override
  String get noTemplates =>
      'Aucun modèle créé pour l\'instant. Appuyez sur \'+\' pour en ajouter un.';

  @override
  String durationLabel(Object minutes) {
    return 'Durée : $minutes min';
  }

  @override
  String get manageTemplates => 'Gérer les Modèles d\'Activité';

  @override
  String get deleteTemplateTitle => 'Supprimer le Modèle';

  @override
  String deleteTemplateContent(Object templateName) {
    return 'Êtes-vous sûr de vouloir supprimer le modèle \'$templateName\' ?';
  }

  @override
  String get durationMaxHint =>
      'La durée ne peut pas dépasser 1440 minutes (24 heures).';

  @override
  String get addFromTemplate => 'Depuis Modèle';

  @override
  String get noTemplatesToUse =>
      'Aucun modèle disponible. Veuillez en créer un dans les paramètres.';

  @override
  String get selectTemplate => 'Sélectionner un Modèle';

  @override
  String get tagsLabel => 'Étiquettes (séparées par des virgules)';

  @override
  String get tagsHint => 'ex. travail, sport, personnel';

  @override
  String get statisticsPageTitle => 'Statistiques';

  @override
  String get statisticsButtonTooltip => 'Voir les statistiques';

  @override
  String get tagDistributionTitle => 'Répartition du temps par étiquette';

  @override
  String get dailyActivityTitle => 'Temps total d\'activité par jour';

  @override
  String get noDataForStatistics =>
      'Aucune donnée d\'activité pour afficher les statistiques. Commencez à planifier vos journées !';

  @override
  String get untagged => 'Non étiqueté';

  @override
  String todayIs(String dayName) {
    return 'Aujourd\'hui, c\'est $dayName';
  }

  @override
  String get fullDay_monday => 'Lundi';

  @override
  String get fullDay_tuesday => 'Mardi';

  @override
  String get fullDay_wednesday => 'Mercredi';

  @override
  String get fullDay_thursday => 'Jeudi';

  @override
  String get fullDay_friday => 'Vendredi';

  @override
  String get fullDay_saturday => 'Samedi';

  @override
  String get fullDay_sunday => 'Dimanche';

  @override
  String get repeatNotificationWeekly => 'Répéter chaque semaine';
}
