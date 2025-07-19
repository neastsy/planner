// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Activity Planner';

  @override
  String get days_PZT => 'MON';

  @override
  String get days_SAL => 'TUE';

  @override
  String get days_CAR => 'WED';

  @override
  String get days_PER => 'THU';

  @override
  String get days_CUM => 'FRI';

  @override
  String get days_CMT => 'SAT';

  @override
  String get days_PAZ => 'SUN';

  @override
  String get addNewActivity => 'Add Activity';

  @override
  String get activityList => 'Activity List';

  @override
  String get noActivityToday => 'No activities added for today yet.';

  @override
  String get editActivity => 'Edit Activity';

  @override
  String get activityName => 'Activity Name';

  @override
  String get activityNameHint => 'Please enter an activity name.';

  @override
  String get startTime => 'Start Time';

  @override
  String get endTime => 'End Time';

  @override
  String get selectTime => 'Select';

  @override
  String get chooseColor => 'Choose Color';

  @override
  String get add => 'Add';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get deleteActivityTitle => 'Delete Activity';

  @override
  String get deleteActivityContent =>
      'Are you sure you want to delete this activity?';

  @override
  String get delete => 'Delete';

  @override
  String get overlappingActivityTitle => 'Overlapping Activity';

  @override
  String get overlappingActivityContent =>
      'There is another activity in this time range. Do you want to proceed anyway?';

  @override
  String get continueAction => 'Continue';

  @override
  String get errorSelectAllTimes => 'Please select all times.';

  @override
  String get timePickerSet => 'SET';

  @override
  String get timePickerSelect => 'SELECT TIME';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get lightTheme => 'Light Theme';

  @override
  String get darkTheme => 'Dark Theme';

  @override
  String get notes => 'Notes (Optional)';

  @override
  String get copyDay => 'Copy Day';

  @override
  String get copy => 'Copy';

  @override
  String copyFromTo(String dayName) {
    return 'Copy all activities from $dayName to:';
  }

  @override
  String get targetDayNotEmptyTitle => 'Target Day Not Empty';

  @override
  String targetDayNotEmptyContent(String dayName) {
    return 'The day \'$dayName\' already has activities. Are you sure you want to add the new activities?';
  }

  @override
  String get deleteAll => 'Delete All';

  @override
  String get deleteAllActivitiesTitle => 'Delete All Activities';

  @override
  String deleteAllActivitiesContent(String dayName) {
    return 'Are you sure you want to delete all activities for $dayName?';
  }

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get notificationsOff => 'Notifications off';

  @override
  String get notifyOnTime => 'Notify on time';

  @override
  String get notify5MinBefore => '5 minutes before';

  @override
  String get notify15MinBefore => '15 minutes before';

  @override
  String notificationBody(String activityName, String time) {
    return 'Your activity \'$activityName\' is scheduled to start at $time.';
  }

  @override
  String dayCopied(Object fromDay, Object toDay) {
    return 'Copied from $fromDay to $toDay.';
  }

  @override
  String allDeleted(Object dayName) {
    return 'All activities for $dayName have been deleted.';
  }

  @override
  String get copyMode => 'Copy Mode';

  @override
  String get copyModeMerge => 'Merge with existing activities';

  @override
  String get copyModeOverwrite => 'Overwrite existing activities';

  @override
  String get overwriteConfirmationTitle => 'Confirm Overwrite';

  @override
  String overwriteConfirmationContent(Object dayName) {
    return 'This will delete all existing activities on \'$dayName\' and replace them. Are you sure?';
  }

  @override
  String get overwrite => 'Overwrite';

  @override
  String get pendingNotificationsTitle => 'Pending Notifications';

  @override
  String get noPendingNotifications => 'There are no pending notifications.';

  @override
  String get noTitle => 'No Title';

  @override
  String get noBody => 'No Body';

  @override
  String get cancelAll => 'Cancel All';

  @override
  String get close => 'Close';

  @override
  String get allNotificationsCancelled =>
      'All pending notifications have been cancelled.';

  @override
  String get viewPendingNotifications => 'View Pending Notifications';

  @override
  String get unknown => 'Unknown';

  @override
  String get activityTime => 'Activity Time';

  @override
  String get notificationType => 'Notification Type';

  @override
  String get scheduledFor => 'Scheduled for';

  @override
  String get editTemplate => 'Edit Template';

  @override
  String get addTemplate => 'Add New Template';

  @override
  String get templateName => 'Template Name';

  @override
  String get templateNameHint => 'Please enter a template name.';

  @override
  String get durationInMinutes => 'Duration (in minutes)';

  @override
  String get durationHint => 'Please enter a duration.';

  @override
  String get durationInvalidHint => 'Please enter a valid, positive number.';

  @override
  String get templateManagerTitle => 'Template Manager';

  @override
  String get noTemplates => 'No templates created yet. Tap \'+\' to add one.';

  @override
  String durationLabel(Object minutes) {
    return 'Duration: $minutes min';
  }

  @override
  String get manageTemplates => 'Manage Activity Templates';

  @override
  String get deleteTemplateTitle => 'Delete Template';

  @override
  String deleteTemplateContent(Object templateName) {
    return 'Are you sure you want to delete the \'$templateName\' template?';
  }

  @override
  String get durationMaxHint =>
      'Duration cannot exceed 1440 minutes (24 hours).';

  @override
  String get addFromTemplate => 'From Template';

  @override
  String get noTemplatesToUse =>
      'No templates available. Please create one in the settings.';

  @override
  String get selectTemplate => 'Select a Template';

  @override
  String get tagsLabel => 'Tags (comma-separated)';

  @override
  String get tagsHint => 'e.g. work, sport, personal';

  @override
  String get statisticsPageTitle => 'Statistics';

  @override
  String get statisticsButtonTooltip => 'View Statistics';

  @override
  String get tagDistributionTitle => 'Time Distribution by Tag';

  @override
  String get dailyActivityTitle => 'Total Activity Time by Day';

  @override
  String get noDataForStatistics =>
      'There is no activity data to display statistics. Start planning your days!';

  @override
  String get untagged => 'Untagged';

  @override
  String todayIs(String dayName) {
    return 'Today is $dayName';
  }

  @override
  String get fullDay_monday => 'Monday';

  @override
  String get fullDay_tuesday => 'Tuesday';

  @override
  String get fullDay_wednesday => 'Wednesday';

  @override
  String get fullDay_thursday => 'Thursday';

  @override
  String get fullDay_friday => 'Friday';

  @override
  String get fullDay_saturday => 'Saturday';

  @override
  String get fullDay_sunday => 'Sunday';

  @override
  String get repeatNotificationWeekly => 'Repeat weekly';

  @override
  String get recurringNotificationHint => 'Repeats at activity time';

  @override
  String get error_appCouldNotStart => 'Application Could Not Start';

  @override
  String get error_unexpectedError =>
      'An unexpected error occurred. Please try restarting the application.';

  @override
  String get error_restart => 'Restart';

  @override
  String get error_detailsForDeveloper => 'Error Details (for developer):';

  @override
  String get pomodoro_startFocusSession => 'Start Focus Session';

  @override
  String get pomodoro_sessionStateWork => 'Work';

  @override
  String get pomodoro_sessionStateShortBreak => 'Short Break';

  @override
  String get pomodoro_sessionStateLongBreak => 'Long Break';

  @override
  String get pomodoro_sessionStatePaused => 'Paused';

  @override
  String pomodoro_completedSessions(int count) {
    return 'Completed Sessions: $count';
  }

  @override
  String get pomodoro_endSessionTitle => 'End Session';

  @override
  String pomodoro_endSessionContent(
      Object sessionCount, Object minutes, Object activityName) {
    return 'Add $sessionCount pomodoro session(s) ($minutes minutes) to the \'$activityName\' activity?';
  }

  @override
  String get pomodoro_dontSave => 'Don\'t Save';

  @override
  String get pomodoro_saveAndExit => 'Yes, Add';

  @override
  String get tapPlusToStart => 'Tap the \'+\' button to start planning.';
}
