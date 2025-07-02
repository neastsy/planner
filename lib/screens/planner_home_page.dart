import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../main.dart';
import '../models/activity_model.dart';
import '../l10n/app_localizations.dart';
import '../widgets/add_activity_sheet.dart';
import '../widgets/circular_planner_painter.dart';
import '../models/language_model.dart';
import '../widgets/theme_switcher.dart';

class PlannerHomePage extends StatefulWidget {
  const PlannerHomePage({super.key});

  @override
  State<PlannerHomePage> createState() => _PlannerHomePageState();
}

class _PlannerHomePageState extends State<PlannerHomePage> {
  late List<String> _days;
  late String _selectedDay;
  final Map<String, List<Activity>> _dailyActivities = {};
  Timer? _timer;
  String _currentTime = '...';
  bool _isFirstLoad = true;

  String _formatTime(TimeOfDay time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  int _timeOfDayToMinutes(TimeOfDay time) => time.hour * 60 + time.minute;

  List<Activity> get _selectedDayActivities =>
      _dailyActivities[_selectedDay] ?? [];

  @override
  void initState() {
    super.initState();
    final List<String> hiveKeys = [
      'PZT',
      'SAL',
      'ÇAR',
      'PER',
      'CUM',
      'CMT',
      'PAZ'
    ];
    for (var day in hiveKeys) {
      _dailyActivities[day] = [];
    }
    _loadActivities();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context)!;
    _days = [
      l10n.days_PZT,
      l10n.days_SAL,
      l10n.days_CAR,
      l10n.days_PER,
      l10n.days_CUM,
      l10n.days_CMT,
      l10n.days_PAZ
    ];
    if (_isFirstLoad) {
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
      _isFirstLoad = false;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    if (mounted) {
      setState(() => _currentTime =
          "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}");
    }
  }

  void _loadActivities() {
    final box = Hive.box<Map>('activitiesBox');
    final dynamic savedData = box.get('daily_activities');
    if (savedData != null && savedData is Map) {
      savedData.forEach((key, value) {
        if (_dailyActivities.containsKey(key) && value is List) {
          _dailyActivities[key] = value.cast<Activity>().toList();
        }
      });
      _dailyActivities.forEach((_, list) {
        list.sort((a, b) {
          final startTimeComparison = _timeOfDayToMinutes(a.startTime)
              .compareTo(_timeOfDayToMinutes(b.startTime));
          if (startTimeComparison != 0) return startTimeComparison;
          return _timeOfDayToMinutes(a.endTime)
              .compareTo(_timeOfDayToMinutes(b.endTime));
        });
      });

      setState(() {});
    }
  }

  Future<void> _saveActivities() async => await Hive.box<Map>('activitiesBox')
      .put('daily_activities', _dailyActivities);

  void _updateAndSortDayActivities(List<Activity> updatedList) {
    updatedList.sort((a, b) {
      final startTimeComparison = _timeOfDayToMinutes(a.startTime)
          .compareTo(_timeOfDayToMinutes(b.startTime));
      if (startTimeComparison != 0) return startTimeComparison;
      return _timeOfDayToMinutes(a.endTime)
          .compareTo(_timeOfDayToMinutes(b.endTime));
    });
    setState(() => _dailyActivities[_selectedDay] = updatedList);
    _saveActivities();
  }

  bool _isOverlapping(Activity newActivity, {int? editIndex}) {
    final newStart = _timeOfDayToMinutes(newActivity.startTime);
    int newEnd = _timeOfDayToMinutes(newActivity.endTime);
    if (newEnd < newStart) newEnd += 24 * 60;
    for (int i = 0; i < _selectedDayActivities.length; i++) {
      if (i == editIndex) {
        continue;
      }
      final existingActivity = _selectedDayActivities[i];
      final existingStart = _timeOfDayToMinutes(existingActivity.startTime);
      int existingEnd = _timeOfDayToMinutes(existingActivity.endTime);
      if (existingEnd < existingStart) existingEnd += 24 * 60;
      if (newStart < existingEnd && newEnd > existingStart) return true;
    }
    return false;
  }

  void _handleActivitySubmission(Activity activity, {int? editIndex}) {
    final l10n = AppLocalizations.of(context)!;
    if (_isOverlapping(activity, editIndex: editIndex)) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.overlappingActivityTitle),
          content: Text(l10n.overlappingActivityContent),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(l10n.cancel)),
            TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _performSave(activity, editIndex: editIndex);
                },
                child: Text(l10n.continueAction)),
          ],
        ),
      );
    } else {
      _performSave(activity, editIndex: editIndex);
    }
  }

  void _performSave(Activity activity, {int? editIndex}) {
    List<Activity> currentActivities = List.from(_selectedDayActivities);
    if (editIndex != null) {
      currentActivities[editIndex] = activity;
    } else {
      currentActivities.add(activity);
    }
    _updateAndSortDayActivities(currentActivities);
  }

  void _deleteActivity(Activity activity) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteActivityTitle),
        content: Text(l10n.deleteActivityContent),
        actions: <Widget>[
          TextButton(
            child: Text(l10n.delete,
                style: const TextStyle(color: Colors.redAccent)),
            onPressed: () {
              _updateAndSortDayActivities(_selectedDayActivities
                  .where((a) => a.id != activity.id)
                  .toList());
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
              child: Text(l10n.cancel),
              onPressed: () => Navigator.of(ctx).pop()),
        ],
      ),
    );
  }

  void _editActivity(Activity activity) async {
    final index = _selectedDayActivities.indexWhere((a) => a.id == activity.id);
    if (index == -1) return;
    final result = await showModalBottomSheet<Activity>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => AddActivitySheet(activityToEdit: activity));
    if (result != null) _handleActivitySubmission(result, editIndex: index);
  }

  void _addActivity() async {
    final result = await showModalBottomSheet<Activity>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const AddActivitySheet());
    if (result != null) _handleActivitySubmission(result);
  }

  void _showSettingsDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final currentThemeMode = Theme.of(context).brightness == Brightness.dark
            ? ThemeMode.dark
            : ThemeMode.light;
        return AlertDialog(
          title: Text(l10n.settings),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- TEMA SEÇENEKLERİ ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.theme,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  ThemeSwitcher(
                    isDarkMode: currentThemeMode == ThemeMode.dark,
                    onToggle: (isDark) {
                      final newMode = isDark ? ThemeMode.dark : ThemeMode.light;
                      MyApp.setThemeMode(context, newMode);
                    },
                  ),
                ],
              ),
              const Divider(),
              // --- DİL SEÇENEKLERİ ---
              Text(l10n.selectLanguage,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<Language>(
                value: Language.languageList().firstWhere(
                  (lang) =>
                      lang.code ==
                      (Localizations.localeOf(context).languageCode),
                  orElse: () => Language.languageList().first,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                items: Language.languageList()
                    .map<DropdownMenuItem<Language>>((Language language) {
                  return DropdownMenuItem<Language>(
                    value: language,
                    child: Text(language.name),
                  );
                }).toList(),
                onChanged: (Language? newLanguage) {
                  if (newLanguage != null) {
                    MyApp.setLocale(context, Locale(newLanguage.code, ''));
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<String> hiveKeys = [
      'PZT',
      'SAL',
      'ÇAR',
      'PER',
      'CUM',
      'CMT',
      'PAZ'
    ];
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final clockColor = isDarkMode
        ? Theme.of(context)
            .textTheme
            .displayLarge
            ?.color
            ?.withAlpha((255 * 0.8).round())
        : Colors.black.withAlpha(185);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              _showSettingsDialog();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _days.length,
                itemBuilder: (context, index) {
                  final dayLabel = _days[index];
                  final dayKey = hiveKeys[index];
                  final isSelected = dayKey == _selectedDay;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor:
                            isSelected ? Colors.blueAccent : Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: isSelected
                                ? BorderSide.none
                                : BorderSide(
                                    color: Theme.of(context).dividerColor)),
                      ),
                      onPressed: () => setState(() => _selectedDay = dayKey),
                      child: Text(
                        dayLabel,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : Theme.of(context).textTheme.bodySmall?.color,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              )),
          const SizedBox(height: 30),
          SizedBox(
            width: 300,
            height: 300,
            child: CustomPaint(
              painter: CircularPlannerPainter(
                activities: _selectedDayActivities,
                textColor: Theme.of(context).textTheme.bodySmall!.color!,
                circleColor: Theme.of(context).dividerColor,
              ),
              child: Center(
                child: Text(
                  _currentTime,
                  style: TextStyle(
                    color: clockColor,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
              onPressed: _addActivity,
              icon: const Icon(Icons.add),
              label: Text(l10n.addNewActivity)),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(l10n.activityList,
                style: Theme.of(context).textTheme.headlineSmall),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _selectedDayActivities.isEmpty
                ? Center(
                    child: Text(
                      l10n.noActivityToday,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _selectedDayActivities.length,
                    itemBuilder: (context, index) {
                      final activity = _selectedDayActivities[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: Container(width: 10, color: activity.color),
                          title: Text(activity.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color
                                        ?.withAlpha((255 * 0.8).round()),
                                  )),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_formatTime(activity.startTime)} - ${_formatTime(activity.endTime)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color
                                          ?.withAlpha((255 * 0.6).round()),
                                    ),
                              ),
                              if (activity.note != null &&
                                  activity.note!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    activity.note!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          fontStyle: FontStyle.italic,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.color
                                              ?.withAlpha((255 * 0.5).round()),
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  icon: Icon(Icons.edit,
                                      color: Theme.of(context)
                                          .iconTheme
                                          .color
                                          ?.withAlpha((255 * 0.6).round())),
                                  onPressed: () => _editActivity(activity)),
                              IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.redAccent),
                                  onPressed: () => _deleteActivity(activity)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ]),
      ),
    );
  }
}
