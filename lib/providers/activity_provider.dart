import 'package:flutter/material.dart';
import '../models/activity_model.dart';
import '../repositories/activity_repository.dart';

class ActivityProvider with ChangeNotifier {
  final ActivityRepository _activityRepository;

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
    notifyListeners();
  }

  void updateActivity(Activity activity, int editIndex) {
    final activitiesForDay = List<Activity>.from(selectedDayActivities);
    activitiesForDay[editIndex] = activity;
    _dailyActivities[_selectedDay] = activitiesForDay;

    _sortAllActivities();
    _saveActivities();
    notifyListeners();
  }

  void deleteActivity(Activity activity) {
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

  int _timeOfDayToMinutes(TimeOfDay time) => time.hour * 60 + time.minute;
}
