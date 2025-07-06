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
  String get errorStartEndTimeSame => 'Start and end time cannot be the same.';

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
}
