import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../main.dart';
import '../models/activity_model.dart';
import '../models/language_model.dart';
import '../providers/activity_provider.dart';
import '../widgets/add_activity_sheet.dart';
import '../widgets/circular_planner_painter.dart';
import '../widgets/theme_switcher.dart';
import '../services/notification_service.dart';

class PlannerHomePage extends StatefulWidget {
  const PlannerHomePage({super.key});

  @override
  State<PlannerHomePage> createState() => _PlannerHomePageState();
}

class _PlannerHomePageState extends State<PlannerHomePage> {
  final List<String> hiveKeys = const [
    'PZT',
    'SAL',
    'ÇAR',
    'PER',
    'CUM',
    'CMT',
    'PAZ'
  ];
  Timer? _timer;
  String _currentTime = '...';
  late List<String> _days;

  @override
  void initState() {
    super.initState();
    NotificationService().requestPermissions();
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

  String _formatTime(TimeOfDay time) =>
      "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

  int _timeOfDayToMinutes(TimeOfDay time) => time.hour * 60 + time.minute;

  bool _isOverlapping(Activity newActivity, List<Activity> activities,
      {int? editIndex}) {
    final newStart = _timeOfDayToMinutes(newActivity.startTime);
    int newEnd = _timeOfDayToMinutes(newActivity.endTime);
    if (newEnd < newStart) newEnd += 24 * 60;
    for (int i = 0; i < activities.length; i++) {
      if (i == editIndex) continue;
      final existingActivity = activities[i];
      final existingStart = _timeOfDayToMinutes(existingActivity.startTime);
      int existingEnd = _timeOfDayToMinutes(existingActivity.endTime);
      if (existingEnd < existingStart) existingEnd += 24 * 60;
      if (newStart < existingEnd && newEnd > existingStart) return true;
    }
    return false;
  }

  void _handleActivitySubmission(BuildContext context, Activity activity,
      {int? editIndex}) {
    final activityProvider =
        Provider.of<ActivityProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;
    if (_isOverlapping(activity, activityProvider.selectedDayActivities,
        editIndex: editIndex)) {
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
                  _performSave(context, activity, editIndex: editIndex);
                },
                child: Text(l10n.continueAction)),
          ],
        ),
      );
    } else {
      _performSave(context, activity, editIndex: editIndex);
    }
  }

  void _performSave(BuildContext context, Activity activity, {int? editIndex}) {
    final activityProvider =
        Provider.of<ActivityProvider>(context, listen: false);
    if (editIndex != null) {
      activityProvider.updateActivity(activity, editIndex);
    } else {
      activityProvider.addActivity(activity);
    }
  }

  void _deleteActivity(BuildContext context, Activity activity) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteActivityTitle),
        content: Text(l10n.deleteActivityContent),
        actions: <Widget>[
          TextButton(
              child: Text(l10n.cancel),
              onPressed: () => Navigator.of(ctx).pop()),
          TextButton(
            child: Text(l10n.delete,
                style: const TextStyle(color: Colors.redAccent)),
            onPressed: () {
              Provider.of<ActivityProvider>(context, listen: false)
                  .deleteActivity(activity);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  void _editActivity(BuildContext context, Activity activity) async {
    final result = await showModalBottomSheet<Activity>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => AddActivitySheet(activityToEdit: activity));

    if (result != null && context.mounted) {
      final activityProvider =
          Provider.of<ActivityProvider>(context, listen: false);
      final index = activityProvider.selectedDayActivities
          .indexWhere((a) => a.id == activity.id);
      if (index != -1) {
        _handleActivitySubmission(context, result, editIndex: index);
      }
    }
  }

  void _addActivity(BuildContext context) async {
    final result = await showModalBottomSheet<Activity>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const AddActivitySheet());
    if (result != null && context.mounted) {
      _handleActivitySubmission(context, result);
    }
  }

  void _showSettingsDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final currentThemeMode = Theme.of(context).brightness == Brightness.dark
            ? ThemeMode.dark
            : ThemeMode.light;
        return AlertDialog(
          title: Text(l10n.settings),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                items: Language.languageList()
                    .map<DropdownMenuItem<Language>>((Language language) {
                  return DropdownMenuItem<Language>(
                      value: language, child: Text(language.name));
                }).toList(),
                onChanged: (Language? newLanguage) {
                  if (newLanguage != null) {
                    MyApp.setLocale(context, Locale(newLanguage.code, ''));
                    Navigator.of(dialogContext).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool?> _showOverwriteConfirmationDialog(BuildContext context,
      {required String toDay}) async {
    final l10n = AppLocalizations.of(context)!;

    final String targetDayLabel = _days[hiveKeys.indexOf(toDay)];

    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.targetDayNotEmptyTitle),
        content: Text(l10n.targetDayNotEmptyContent(targetDayLabel)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red.shade400),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.copy),
          ),
        ],
      ),
    );
  }

  void _showCopyDayDialog(BuildContext context) {
    final activityProvider =
        Provider.of<ActivityProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    final String sourceDayKey = activityProvider.selectedDay;
    final String sourceDayLabel = _days[hiveKeys.indexOf(sourceDayKey)];

    final List<String> availableDays = List.from(hiveKeys)
      ..remove(sourceDayKey);
    String targetDayKey = availableDays.first;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(l10n.copyDay),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.copyFromTo(sourceDayLabel),
                  ),
                  const SizedBox(height: 20),
                  DropdownButton<String>(
                    value: targetDayKey,
                    isExpanded: true,
                    items: availableDays.map((dayKey) {
                      final dayLabel = _days[hiveKeys.indexOf(dayKey)];
                      return DropdownMenuItem(
                        value: dayKey,
                        child: Text(dayLabel),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setDialogState(() {
                          targetDayKey = newValue;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(l10n.cancel),
                ),
                TextButton(
                  onPressed: () async {
                    bool? shouldCopy;
                    if (activityProvider.isDayEmpty(targetDayKey)) {
                      shouldCopy = true;
                    } else {
                      shouldCopy = await _showOverwriteConfirmationDialog(
                          context,
                          toDay: targetDayKey);
                    }
                    if (shouldCopy ?? false) {
                      activityProvider.forceCopyDayActivities(
                        fromDay: sourceDayKey,
                        toDay: targetDayKey,
                      );

                      if (context.mounted) {
                        final targetDayLabel =
                            _days[hiveKeys.indexOf(targetDayKey)];
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(l10n.dayCopied(
                                  sourceDayLabel, targetDayLabel))),
                        );
                      }
                    }
                    if (dialogContext.mounted) {
                      Navigator.of(dialogContext).pop();
                    }
                  },
                  child: Text(l10n.copy),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showClearAllConfirmationDialog(BuildContext context) {
    final activityProvider =
        Provider.of<ActivityProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;
    final String dayLabel =
        _days[hiveKeys.indexOf(activityProvider.selectedDay)];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteAllActivitiesTitle),
        content: Text(l10n.deleteAllActivitiesContent(dayLabel)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red.shade400),
            onPressed: () {
              activityProvider
                  .clearAllActivitiesForDay(activityProvider.selectedDay);
              Navigator.of(ctx).pop();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.allDeleted(dayLabel))),
                );
              }
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _setNotification(Activity activity, int? minutes) {
    final updatedActivity = Activity(
      id: activity.id,
      name: activity.name,
      startTime: activity.startTime,
      endTime: activity.endTime,
      color: activity.color,
      note: activity.note,
      notificationMinutesBefore: minutes, // Yeni değeri ata
    );

    final activityProvider =
        Provider.of<ActivityProvider>(context, listen: false);
    final index = activityProvider.selectedDayActivities
        .indexWhere((a) => a.id == activity.id);
    if (index != -1) {
      activityProvider.updateActivity(updatedActivity, index);
    }
  }

  Widget _getNotificationIcon(Activity activity) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    IconData icon;
    Color color;

    switch (activity.notificationMinutesBefore) {
      case null:
        icon = Icons.notifications_off_outlined;
        color = Colors.grey;
        break;
      case 0:
        icon = Icons.notifications_active;
        color = Colors.blue;
        break;
      case 5:
        icon = Icons.notifications;
        color = isDarkMode ? Colors.amber.shade300 : Colors.amber.shade700;
        break;
      case 15:
        icon = Icons.notification_add_outlined;
        color = isDarkMode ? Colors.orange.shade300 : Colors.orange.shade700;
        break;
      default:
        icon = Icons.notifications_none;
        color = Colors.grey;
    }
    return Icon(icon, color: color);
  }

  @override
  Widget build(BuildContext context) {
    final activityProvider = Provider.of<ActivityProvider>(context);

    final l10n = AppLocalizations.of(context)!;
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
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _showSettingsDialog(context),
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
                  final isSelected = dayKey == activityProvider.selectedDay;
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
                      onPressed: () =>
                          Provider.of<ActivityProvider>(context, listen: false)
                              .changeDay(dayKey),
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
                activities: activityProvider.selectedDayActivities,
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
              onPressed: () => _addActivity(context),
              icon: const Icon(Icons.add),
              label: Text(l10n.addNewActivity)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(l10n.activityList,
                  style: Theme.of(context).textTheme.headlineSmall),
              if (activityProvider.selectedDayActivities.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.copy_all_outlined),
                      tooltip: l10n.copyDay,
                      onPressed: () {
                        _showCopyDayDialog(context);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_sweep_outlined,
                          color: Colors.red.shade400),
                      tooltip: l10n.deleteAll,
                      onPressed: () {
                        _showClearAllConfirmationDialog(context);
                      },
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: activityProvider.selectedDayActivities.isEmpty
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
                    key: ValueKey<String>(activityProvider.selectedDay),
                    itemCount: activityProvider.selectedDayActivities.length,
                    itemBuilder: (context, index) {
                      final activity =
                          activityProvider.selectedDayActivities[index];
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
                                  onPressed: () =>
                                      _editActivity(context, activity)),
                              IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.redAccent),
                                  onPressed: () =>
                                      _deleteActivity(context, activity)),
                              PopupMenuButton<int>(
                                tooltip: l10n.notificationSettings,
                                onSelected: (int value) {
                                  _setNotification(
                                      activity, value == -1 ? null : value);
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<int>>[
                                  PopupMenuItem<int>(
                                    value: -1,
                                    child: Text(l10n.notificationsOff),
                                  ),
                                  PopupMenuItem<int>(
                                    value: 0,
                                    child: Text(l10n.notifyOnTime),
                                  ),
                                  PopupMenuItem<int>(
                                    value: 5,
                                    child: Text(l10n.notify5MinBefore),
                                  ),
                                  PopupMenuItem<int>(
                                    value: 15,
                                    child: Text(l10n.notify15MinBefore),
                                  ),
                                ],
                                icon: _getNotificationIcon(activity),
                              ),
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
