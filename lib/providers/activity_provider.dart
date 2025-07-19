import 'dart:async'; // Timer için bu import gerekli
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/activity_model.dart';
import '../repositories/activity_repository.dart';
import '../services/notification_service.dart';
// ignore: unused_import
import 'package:timezone/timezone.dart' as tz;
import 'package:gunluk_planlayici/l10n/app_localizations.dart';
import '../utils/constants.dart';

enum CopyMode {
  merge,
  overwrite,
}

class ActivityProvider with ChangeNotifier {
  final ActivityRepository _activityRepository;
  final NotificationService _notificationService = NotificationService();

  Map<String, List<Activity>> _dailyActivities = {};
  late String _selectedDay;
  Timer? _syncTimer;

  ActivityProvider(this._activityRepository) {
    _initialize();
    _startPeriodicSync();
  }

  DateTime? calculateNextNotificationTime(Activity activity, String dayKey) {
    if (activity.notificationMinutesBefore == null) {
      return null;
    }

    final now = DateTime.now();
    final dayIndex = AppConstants.dayKeys.indexOf(dayKey);
    int daysToAdd = (dayIndex - (now.weekday - 1) + 7) % 7;

    var activityDate = DateTime(now.year, now.month, now.day + daysToAdd,
        activity.startTime.hour, activity.startTime.minute);

    var scheduledTime = activityDate
        .subtract(Duration(minutes: activity.notificationMinutesBefore!));

    while (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 7));
    }
    return scheduledTime;
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    super.dispose();
  }

  void _startPeriodicSync() {
    _syncTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
        syncNotificationsOnLoad();
        debugPrint("Periodic notification sync completed.");
      }
    });
  }

  Map<String, List<Activity>> get dailyActivities => _dailyActivities;
  String get selectedDay => _selectedDay;
  List<Activity> get selectedDayActivities =>
      _dailyActivities[_selectedDay] ?? [];

  void _initialize() {
    final List<String> hiveKeys = AppConstants.dayKeys;
    _selectedDay = hiveKeys[DateTime.now().weekday - 1];
    _loadActivities();
  }

  void changeDay(String newDay) {
    _selectedDay = newDay;
    notifyListeners();
  }

  void _loadActivities() {
    _dailyActivities = _activityRepository.loadActivities();
    _dailyActivities.forEach((_, list) => _sortList(list));
    syncNotificationsOnLoad();
    notifyListeners();
  }

  Future<void> _saveActivitiesForDay(String dayKey) async {
    final activitiesToSave = _dailyActivities[dayKey] ?? [];
    await _activityRepository.saveActivitiesForDay(dayKey, activitiesToSave);
  }

  void addActivity(Activity activity) {
    final activitiesForDay = List<Activity>.from(selectedDayActivities);
    activitiesForDay.add(activity);
    _dailyActivities[_selectedDay] = activitiesForDay;

    _sortList(activitiesForDay);
    _saveActivitiesForDay(_selectedDay);
    _scheduleNotificationForActivity(activity, _selectedDay);
    notifyListeners();
  }

  void updateActivity(Activity activity, int editIndex) {
    final oldActivity = selectedDayActivities[editIndex];
    _cancelNotificationForActivity(oldActivity);

    final activitiesForDay = List<Activity>.from(selectedDayActivities);
    activitiesForDay[editIndex] = activity;
    _dailyActivities[_selectedDay] = activitiesForDay;

    _sortList(activitiesForDay);
    _saveActivitiesForDay(_selectedDay);
    _scheduleNotificationForActivity(activity, _selectedDay);
    notifyListeners();
  }

  void addCompletedDuration(String activityId, int minutesToAdd) {
    String? dayKeyOfActivity;
    int? indexInList;

    for (var dayKey in _dailyActivities.keys) {
      final activities = _dailyActivities[dayKey]!;
      final index = activities.indexWhere((a) => a.id == activityId);
      if (index != -1) {
        dayKeyOfActivity = dayKey;
        indexInList = index;
        break;
      }
    }

    if (dayKeyOfActivity != null && indexInList != null) {
      final activitiesForDay = _dailyActivities[dayKeyOfActivity]!;
      final oldActivity = activitiesForDay[indexInList];
      final updatedActivity = Activity(
        id: oldActivity.id,
        name: oldActivity.name,
        startTime: oldActivity.startTime,
        endTime: oldActivity.endTime,
        color: oldActivity.color,
        note: oldActivity.note,
        notificationMinutesBefore: oldActivity.notificationMinutesBefore,
        tags: oldActivity.tags,
        isNotificationRecurring: oldActivity.isNotificationRecurring,
        completedDurationInMinutes:
            oldActivity.completedDurationInMinutes + minutesToAdd,
      );

      activitiesForDay[indexInList] = updatedActivity;
      _dailyActivities[dayKeyOfActivity] = activitiesForDay;
      _saveActivitiesForDay(dayKeyOfActivity);
      notifyListeners();
      debugPrint(
          "Added $minutesToAdd minutes to '${updatedActivity.name}'. New total: ${updatedActivity.completedDurationInMinutes}");
    }
  }

  void deleteActivity(Activity activity) {
    _cancelNotificationForActivity(activity);
    final activitiesForDay = List<Activity>.from(selectedDayActivities);
    activitiesForDay.removeWhere((a) => a.id == activity.id);
    _dailyActivities[_selectedDay] = activitiesForDay;

    _saveActivitiesForDay(_selectedDay);
    notifyListeners();
  }

  void _sortList(List<Activity> list) {
    list.sort((a, b) {
      final startTimeComparison = _timeOfDayToMinutes(a.startTime)
          .compareTo(_timeOfDayToMinutes(b.startTime));
      if (startTimeComparison != 0) return startTimeComparison;
      return _timeOfDayToMinutes(a.endTime)
          .compareTo(_timeOfDayToMinutes(b.endTime));
    });
  }

  bool isDayEmpty(String dayKey) {
    return _dailyActivities[dayKey]?.isEmpty ?? true;
  }

  void copyDayActivities({
    required String fromDay,
    required String toDay,
    required CopyMode mode,
  }) {
    final List<Activity> sourceActivities =
        List.from(_dailyActivities[fromDay] ?? []);
    if (sourceActivities.isEmpty) return;

    final List<Activity> targetActivities = mode == CopyMode.overwrite
        ? []
        : List.from(_dailyActivities[toDay] ?? []);

    if (mode == CopyMode.overwrite) {
      final activitiesToClear = _dailyActivities[toDay] ?? [];
      for (final activity in activitiesToClear) {
        _cancelNotificationForActivity(activity);
      }
    }

    final List<Activity> copiedActivities = sourceActivities.map((activity) {
      final newActivity = Activity(
        name: activity.name,
        startTime: activity.startTime,
        endTime: activity.endTime,
        color: activity.color,
        note: activity.note,
        tags: List<String>.from(activity.tags),
        notificationMinutesBefore: activity.notificationMinutesBefore,
        isNotificationRecurring: activity.isNotificationRecurring,
      );
      _scheduleNotificationForActivity(newActivity, toDay);
      return newActivity;
    }).toList();

    targetActivities.addAll(copiedActivities);
    _dailyActivities[toDay] = targetActivities;

    _sortList(targetActivities);
    _saveActivitiesForDay(toDay);
    notifyListeners();
  }

  void clearAllActivitiesForDay(String dayKey) {
    final activitiesToClear = _dailyActivities[dayKey] ?? [];
    for (final activity in activitiesToClear) {
      _cancelNotificationForActivity(activity);
    }
    _dailyActivities[dayKey] = [];

    _saveActivitiesForDay(dayKey);
    notifyListeners();
  }

  Future<void> syncNotificationsOnLoad() async {
    final pendingNotifications =
        await _notificationService.getPendingNotifications();
    final pendingMap = {for (var p in pendingNotifications) p.id: p.payload};

    bool needsSave = false;

    for (var dayKey in AppConstants.dayKeys) {
      final activities = _dailyActivities[dayKey] ?? [];
      if (activities.isEmpty) continue;

      bool dayNeedsSave = false;
      final List<Activity> updatedActivities = [];
      for (var activity in activities) {
        final notificationId = activity.id.hashCode;
        final payload = pendingMap[notificationId];
        int? realNotificationMinutes =
            payload != null ? int.tryParse(payload) : null;

        if (activity.notificationMinutesBefore != realNotificationMinutes) {
          updatedActivities.add(Activity(
            id: activity.id,
            name: activity.name,
            startTime: activity.startTime,
            endTime: activity.endTime,
            color: activity.color,
            note: activity.note,
            tags: activity.tags,
            notificationMinutesBefore: realNotificationMinutes,
            isNotificationRecurring: activity.isNotificationRecurring,
          ));
          dayNeedsSave = true;
        } else {
          updatedActivities.add(activity);
        }
      }

      if (dayNeedsSave) {
        _dailyActivities[dayKey] = updatedActivities;
        await _saveActivitiesForDay(dayKey);
        needsSave = true;
      }
    }

    if (needsSave) {
      notifyListeners();
    }
  }

  Future<void> clearAllNotificationsAndUpdateActivities() async {
    await _notificationService.cancelAllNotifications();

    for (var dayKey in AppConstants.dayKeys) {
      final activities = _dailyActivities[dayKey] ?? [];
      if (activities.isEmpty) continue;

      bool dayNeedsSave = false;
      final List<Activity> updatedActivities = [];
      for (var activity in activities) {
        if (activity.notificationMinutesBefore != null) {
          updatedActivities.add(Activity(
            id: activity.id,
            name: activity.name,
            startTime: activity.startTime,
            endTime: activity.endTime,
            color: activity.color,
            note: activity.note,
            tags: activity.tags,
            notificationMinutesBefore: null,
            isNotificationRecurring: false,
          ));
          dayNeedsSave = true;
        } else {
          updatedActivities.add(activity);
        }
      }

      if (dayNeedsSave) {
        _dailyActivities[dayKey] = updatedActivities;
        await _saveActivitiesForDay(dayKey);
      }
    }
    notifyListeners();
  }

  // DÜZELTİLMİŞ VE NİHAİ METOT
  Future<void> _scheduleNotificationForActivity(
      Activity activity, String dayKey) async {
    final finalScheduledTime = calculateNextNotificationTime(activity, dayKey);

    if (finalScheduledTime == null) {
      _cancelNotificationForActivity(activity);
      return;
    }

    final String defaultLocale = Platform.localeName;
    final languageCode = defaultLocale.split('_').first;
    final locale = Locale(languageCode);
    final l10n = await AppLocalizations.delegate.load(locale);

    _notificationService.scheduleNotification(
      id: activity.id.hashCode,
      title: activity.name,
      body:
          l10n.notificationBody(activity.name, _formatTime(activity.startTime)),
      scheduledTime: finalScheduledTime,
      payload: activity.notificationMinutesBefore.toString(),
      isRecurring: activity.isNotificationRecurring,
    );
  }

  void _cancelNotificationForActivity(Activity activity) {
    _notificationService.cancelNotification(activity.id.hashCode);
  }

  String _formatTime(TimeOfDay time) =>
      "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  int _timeOfDayToMinutes(TimeOfDay time) => time.hour * 60 + time.minute;
}
