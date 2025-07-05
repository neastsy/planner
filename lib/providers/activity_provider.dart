import 'dart:io';
import 'package:flutter/material.dart';
import '../models/activity_model.dart';
import '../repositories/activity_repository.dart';
import '../services/notification_service.dart';
// ignore: unused_import
import 'package:timezone/timezone.dart' as tz;
import 'package:gunluk_planlayici/l10n/app_localizations.dart';

class ActivityProvider with ChangeNotifier {
  final ActivityRepository _activityRepository;
  final NotificationService _notificationService = NotificationService();

  Map<String, List<Activity>> _dailyActivities = {};
  late String _selectedDay;

  ActivityProvider(this._activityRepository) {
    _initialize();
  }

  Map<String, List<Activity>> get dailyActivities => _dailyActivities;
  String get selectedDay => _selectedDay;
  List<Activity> get selectedDayActivities =>
      _dailyActivities[_selectedDay] ?? [];

  void _initialize() {
    final List<String> hiveKeys = [
      'PZT',
      'SAL',
      'ÇAR',
      'PER',
      'CUM',
      'CMT',
      'PAZ'
    ];
    _selectedDay = hiveKeys[DateTime.now().weekday - 1];
    _loadActivities();
  }

  void changeDay(String newDay) {
    _selectedDay = newDay;
    notifyListeners();
  }

  void _loadActivities() {
    _dailyActivities = _activityRepository.loadActivities();
    _sortAllActivities();
    notifyListeners();
  }

  Future<void> _saveActivities() async {
    await _activityRepository.saveActivities(_dailyActivities);
  }

  void addActivity(Activity activity) {
    final activitiesForDay = List<Activity>.from(selectedDayActivities);
    activitiesForDay.add(activity);
    _dailyActivities[_selectedDay] = activitiesForDay;

    _sortAllActivities();
    _saveActivities();
    _scheduleNotificationForActivity(activity, _selectedDay);
    notifyListeners();
  }

  void updateActivity(Activity activity, int editIndex) {
    final oldActivity = selectedDayActivities[editIndex];
    _cancelNotificationForActivity(oldActivity);
    final activitiesForDay = List<Activity>.from(selectedDayActivities);
    activitiesForDay[editIndex] = activity;
    _dailyActivities[_selectedDay] = activitiesForDay;

    _sortAllActivities();
    _saveActivities();
    _scheduleNotificationForActivity(activity, _selectedDay);
    notifyListeners();
  }

  void deleteActivity(Activity activity) {
    _cancelNotificationForActivity(activity);
    final activitiesForDay = List<Activity>.from(selectedDayActivities);
    activitiesForDay.removeWhere((a) => a.id == activity.id);
    _dailyActivities[_selectedDay] = activitiesForDay;

    _saveActivities();
    notifyListeners();
  }

  void _sortAllActivities() {
    _dailyActivities.forEach((_, list) {
      list.sort((a, b) {
        final startTimeComparison = _timeOfDayToMinutes(a.startTime)
            .compareTo(_timeOfDayToMinutes(b.startTime));
        if (startTimeComparison != 0) return startTimeComparison;
        return _timeOfDayToMinutes(a.endTime)
            .compareTo(_timeOfDayToMinutes(b.endTime));
      });
    });
  }

  bool isDayEmpty(String dayKey) {
    return _dailyActivities[dayKey]?.isEmpty ?? true;
  }

  void forceCopyDayActivities(
      {required String fromDay, required String toDay}) {
    final List<Activity> sourceActivities =
        List.from(_dailyActivities[fromDay] ?? []);
    if (sourceActivities.isEmpty) return;
    final List<Activity> targetActivities =
        List.from(_dailyActivities[toDay] ?? []);

    final List<Activity> copiedActivities = sourceActivities.map((activity) {
      final newActivity = Activity(
        name: activity.name,
        startTime: activity.startTime,
        endTime: activity.endTime,
        color: activity.color,
        note: activity.note,
        notificationMinutesBefore: activity.notificationMinutesBefore,
      );
      _scheduleNotificationForActivity(newActivity, toDay);
      return newActivity;
    }).toList();

    targetActivities.addAll(copiedActivities);
    _dailyActivities[toDay] = targetActivities;

    _sortAllActivities();
    _saveActivities();
    notifyListeners();
  }

  void clearAllActivitiesForDay(String dayKey) {
    final activitiesToClear = _dailyActivities[dayKey] ?? [];
    for (final activity in activitiesToClear) {
      _cancelNotificationForActivity(activity);
    }
    _dailyActivities[dayKey] = [];

    _saveActivities();
    notifyListeners();
  }

  Future<void> _scheduleNotificationForActivity(
      Activity activity, String dayKey) async {
    if (activity.notificationMinutesBefore == null) {
      return;
    }

    final String defaultLocale = Platform.localeName;
    final languageCode = defaultLocale.split('_').first;
    final locale = Locale(languageCode);
    final l10n = await AppLocalizations.delegate.load(locale);

    final now = DateTime.now();
    final dayIndex =
        ['PZT', 'SAL', 'ÇAR', 'PER', 'CUM', 'CMT', 'PAZ'].indexOf(dayKey);
    int daysToAdd = (dayIndex - (now.weekday - 1) + 7) % 7;
    var activityDate = DateTime(now.year, now.month, now.day + daysToAdd,
        activity.startTime.hour, activity.startTime.minute);
    if (activityDate.isBefore(now) && daysToAdd > 0) {
      activityDate = activityDate.add(const Duration(days: 7));
    }
    final scheduledTime = activityDate
        .subtract(Duration(minutes: activity.notificationMinutesBefore!));
    if (scheduledTime.isBefore(now)) {
      return;
    }

    // 3. Bildirimi YENİ, ÇEVRİLMİŞ metinlerle planla
    _notificationService.scheduleNotification(
      id: activity.id.hashCode,
      title: activity.name,
      body: l10n.notificationBody(
        activity.name,
        _formatTime(activity.startTime),
      ),
      scheduledTime: scheduledTime,
    );
  }

  void _cancelNotificationForActivity(Activity activity) {
    _notificationService.cancelNotification(activity.id.hashCode);
  }

  String _formatTime(TimeOfDay time) =>
      "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

  int _timeOfDayToMinutes(TimeOfDay time) => time.hour * 60 + time.minute;
}
