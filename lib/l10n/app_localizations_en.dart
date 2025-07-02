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
}
