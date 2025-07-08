class AppConstants {
  // Gün anahtarları (Hive ve Provider'da kullanılıyor)
  static const List<String> dayKeys = [
    'PZT',
    'SAL',
    'ÇAR',
    'PER',
    'CUM',
    'CMT',
    'PAZ'
  ];

  // Karakter sınırları (AddActivitySheet'te kullanılıyor)
  static const int activityNameMaxLength = 30;
  static const int activityNoteMaxLength = 200;
  static const int activityTagsMaxLength = 100;

  // Veritabanı sabitleri (main.dart ve ActivityRepository'de kullanılıyor)
  static const String activitiesBoxName = 'activitiesBox';
  static const String templatesBoxName = 'templatesBox';
  static const String settingsBoxName = 'settingsBox';
  static const String dailyActivitiesKey = 'daily_activities';
}
