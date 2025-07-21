import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../l10n/app_localizations.dart';
import '../models/activity_model.dart';
import '../models/language_model.dart';
import '../models/app_theme_model.dart';
import '../models/activity_template_model.dart';
import '../providers/activity_provider.dart';
import '../providers/pomodoro_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/template_provider.dart';
import '../widgets/add_activity_sheet.dart';
import '../widgets/circular_planner_painter.dart';
import '../widgets/theme_switcher.dart';
import '../services/notification_service.dart';
import '../screens/template_manager_page.dart';
import '../screens/statistics_page.dart';
import '../screens/focus_screen.dart';
import '../utils/constants.dart';

class PlannerHomePage extends StatefulWidget {
  const PlannerHomePage({super.key});

  @override
  State<PlannerHomePage> createState() => _PlannerHomePageState();
}

class _PlannerHomePageState extends State<PlannerHomePage>
    with WidgetsBindingObserver {
  final List<String> hiveKeys = AppConstants.dayKeys;
  Timer? _timer;
  String _currentTime = '...';
  late List<String> _days;
  late PageController _pageController;
  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    NotificationService().requestPermissions();
    final todayIndex = DateTime.now().weekday - 1;
    final startingPage = (1000 * 7) + todayIndex;
    _pageController = PageController(initialPage: startingPage);

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
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _pageController.dispose();
    _transformationController.dispose(); // Controller'ı dispose et
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      debugPrint("App resumed. Triggering notification sync.");
      context.read<ActivityProvider>().syncNotificationsOnLoad();
    }
  }

  void _updateTime() {
    if (mounted) {
      setState(() => _currentTime =
          "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}");
    }
  }

  String _getLocalizedTodayName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final weekday = DateTime.now().weekday;

    switch (weekday) {
      case DateTime.monday:
        return l10n.fullDay_monday;
      case DateTime.tuesday:
        return l10n.fullDay_tuesday;
      case DateTime.wednesday:
        return l10n.fullDay_wednesday;
      case DateTime.thursday:
        return l10n.fullDay_thursday;
      case DateTime.friday:
        return l10n.fullDay_friday;
      case DateTime.saturday:
        return l10n.fullDay_saturday;
      case DateTime.sunday:
        return l10n.fullDay_sunday;
      default:
        return '';
    }
  }

  String _formatTime(TimeOfDay time) =>
      "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

  int _timeOfDayToMinutes(TimeOfDay time) => time.hour * 60 + time.minute;

  bool _isOverlapping(Activity newActivity, List<Activity> activities,
      {int? editIndex}) {
    final newStart = _timeOfDayToMinutes(newActivity.startTime);
    int newEnd = _timeOfDayToMinutes(newActivity.endTime);
    if (newEnd <= newStart) newEnd += 24 * 60;
    for (int i = 0; i < activities.length; i++) {
      if (i == editIndex) continue;
      final existingActivity = activities[i];
      final existingStart = _timeOfDayToMinutes(existingActivity.startTime);
      int existingEnd = _timeOfDayToMinutes(existingActivity.endTime);
      if (existingEnd <= existingStart) existingEnd += 24 * 60;
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
    final activityProvider =
        Provider.of<ActivityProvider>(context, listen: false);
    final index = activityProvider.selectedDayActivities
        .indexWhere((a) => a.id == activity.id);

    if (index == -1) return;

    final result = await showModalBottomSheet<Activity>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => AddActivitySheet(activityToEdit: activity));

    if (result != null && context.mounted) {
      _handleActivitySubmission(context, result, editIndex: index);
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
        return Consumer<SettingsProvider>(
          builder: (context, settingsProvider, child) {
            return AlertDialog(
              title: Text(l10n.settings),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.theme,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        ThemeSwitcher(
                          isDarkMode:
                              settingsProvider.themeMode == ThemeMode.dark,
                          onToggle: (isDark) {
                            final newMode =
                                isDark ? ThemeMode.dark : ThemeMode.light;
                            settingsProvider.changeThemeMode(newMode);
                          },
                        ),
                      ],
                    ),
                    const Divider(),
                    Text("Theme Color",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: AppTheme.themeList.map((theme) {
                        final bool isSelected =
                            theme.name == settingsProvider.appTheme.name;
                        return GestureDetector(
                          onTap: () => settingsProvider.changeAppTheme(theme),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 3)
                                  : null,
                              boxShadow: [
                                if (isSelected)
                                  BoxShadow(
                                    color: theme.primaryColor.withAlpha(128),
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                  )
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const Divider(),
                    Text(l10n.selectLanguage,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<Language>(
                      value: Language.languageList().firstWhere(
                        (lang) =>
                            lang.code ==
                            (settingsProvider.locale?.languageCode ??
                                Localizations.localeOf(context).languageCode),
                        orElse: () => Language.languageList().first,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                      items: Language.languageList()
                          .map<DropdownMenuItem<Language>>((Language language) {
                        return DropdownMenuItem<Language>(
                            value: language, child: Text(language.name));
                      }).toList(),
                      onChanged: (Language? newLanguage) {
                        if (newLanguage != null) {
                          settingsProvider
                              .changeLocale(Locale(newLanguage.code, ''));
                        }
                      },
                    ),
                    const Divider(),
                    TextButton.icon(
                      icon: const Icon(Icons.notifications_on_outlined),
                      label: Text(l10n.viewPendingNotifications),
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        _showPendingNotificationsDialog();
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        minimumSize: const Size.fromHeight(40),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    const Divider(),
                    TextButton.icon(
                      icon: const Icon(Icons.file_copy_outlined),
                      label: Text(l10n.manageTemplates),
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const TemplateManagerPage(),
                        ));
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        minimumSize: const Size.fromHeight(40),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(l10n.close.toUpperCase()),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<bool?> _showFinalOverwriteConfirmationDialog(BuildContext context,
      {required String toDay}) async {
    final l10n = AppLocalizations.of(context)!;
    final String targetDayLabel = _days[hiveKeys.indexOf(toDay)];

    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.overwriteConfirmationTitle),
        content: Text(l10n.overwriteConfirmationContent(targetDayLabel)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red.shade400),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.overwrite),
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

    CopyMode selectedMode = CopyMode.merge;

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
                  const SizedBox(height: 20),
                  Text(
                    l10n.copyMode,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  RadioListTile<CopyMode>(
                    title: Text(l10n.copyModeMerge),
                    value: CopyMode.merge,
                    groupValue: selectedMode,
                    onChanged: (CopyMode? value) {
                      setDialogState(() {
                        selectedMode = value!;
                      });
                    },
                  ),
                  RadioListTile<CopyMode>(
                    title: Text(l10n.copyModeOverwrite),
                    value: CopyMode.overwrite,
                    groupValue: selectedMode,
                    onChanged: (CopyMode? value) {
                      setDialogState(() {
                        selectedMode = value!;
                      });
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
                    bool shouldProceed = true;
                    if (selectedMode == CopyMode.overwrite) {
                      if (!activityProvider.isDayEmpty(targetDayKey)) {
                        shouldProceed =
                            await _showFinalOverwriteConfirmationDialog(context,
                                    toDay: targetDayKey) ??
                                false;
                      }
                    }

                    if (!shouldProceed) return;

                    activityProvider.copyDayActivities(
                      fromDay: sourceDayKey,
                      toDay: targetDayKey,
                      mode: selectedMode,
                    );

                    if (dialogContext.mounted) {
                      Navigator.of(dialogContext).pop();
                    }

                    if (context.mounted) {
                      final targetDayLabel =
                          _days[hiveKeys.indexOf(targetDayKey)];
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            l10n.dayCopied(sourceDayLabel, targetDayLabel),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor:
                              Theme.of(context).colorScheme.secondaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                      );
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
                  SnackBar(
                    content: Text(
                      l10n.allDeleted(dayLabel),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
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
    final activityProvider =
        Provider.of<ActivityProvider>(context, listen: false);
    final index = activityProvider.selectedDayActivities
        .indexWhere((a) => a.id == activity.id);

    if (index == -1) return;

    final updatedActivity = Activity(
      id: activity.id,
      name: activity.name,
      startTime: activity.startTime,
      endTime: activity.endTime,
      color: activity.color,
      note: activity.note,
      notificationMinutesBefore: minutes,
      tags: activity.tags,
      isNotificationRecurring: activity.isNotificationRecurring,
    );

    activityProvider.updateActivity(updatedActivity, index);
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

  void _handlePlannerTap(
      TapDownDetails details, List<Activity> activities, Size size) {
    if (activities.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final tapPosition = details.localPosition;

    final distance = (tapPosition - center).distance;
    const tolerance = 4.0;
    final outerRadius = (size.width / 2) - 18.4 + (35.0 / 2) + tolerance;
    final innerRadius = (size.width / 2) - 18.4 - (35.0 / 2) - tolerance;

    if (distance < innerRadius || distance > outerRadius) {
      return;
    }

    var tapAngle =
        atan2(tapPosition.dy - center.dy, tapPosition.dx - center.dx) +
            (pi / 2);
    if (tapAngle < 0) {
      tapAngle += 2 * pi;
    }

    final List<Activity> tappedCandidates = [];

    for (final activity in activities) {
      final startAngle =
          ((activity.startTime.hour + activity.startTime.minute / 60) / 24) *
              2 *
              pi;
      final endAngle =
          ((activity.endTime.hour + activity.endTime.minute / 60) / 24) *
              2 *
              pi;

      bool isTapped = false;

      if (startAngle <= endAngle) {
        if (tapAngle >= startAngle && tapAngle <= endAngle) {
          isTapped = true;
        }
      } else {
        if (tapAngle >= startAngle || tapAngle <= endAngle) {
          isTapped = true;
        }
      }

      if (activity.durationInMinutes >= 24 * 60) {
        isTapped = true;
      }

      if (isTapped) {
        tappedCandidates.add(activity);
      }
    }

    if (tappedCandidates.isNotEmpty) {
      tappedCandidates.sort((a, b) {
        final durationComparison =
            a.durationInMinutes.compareTo(b.durationInMinutes);
        if (durationComparison != 0) {
          return durationComparison;
        }
        final aStartMinutes = a.startTime.hour * 60 + a.startTime.minute;
        final bStartMinutes = b.startTime.hour * 60 + b.startTime.minute;
        return bStartMinutes.compareTo(aStartMinutes);
      });

      final Activity topmostActivity = tappedCandidates.first;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            topmostActivity.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: topmostActivity.color.withAlpha((255 * 0.9).round()),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      );
    }
  }

  void _showPendingNotificationsDialog() async {
    final notificationService = NotificationService();
    final activityProvider = context.read<ActivityProvider>();

    await activityProvider.syncNotificationsOnLoad();

    final List<PendingNotificationRequest> pendingNotifications =
        await notificationService.getPendingNotifications();

    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;

    final List<Map<String, dynamic>> sortedNotifications = [];

    for (var request in pendingNotifications) {
      Activity? foundActivity;
      String? foundDayKey;

      for (var dayKey in activityProvider.dailyActivities.keys) {
        final activity = activityProvider.dailyActivities[dayKey]?.firstWhere(
          (act) => act.id.hashCode == request.id,
          orElse: () => Activity(
              name: '',
              startTime: const TimeOfDay(hour: 0, minute: 0),
              endTime: const TimeOfDay(hour: 0, minute: 0),
              color: Colors.transparent),
        );
        if (activity != null && activity.name.isNotEmpty) {
          foundActivity = activity;
          foundDayKey = dayKey;
          break;
        }
      }

      DateTime? scheduledDateTime;
      if (foundActivity != null && foundDayKey != null) {
        scheduledDateTime = activityProvider.calculateNextNotificationTime(
            foundActivity, foundDayKey);
      }

      sortedNotifications.add({
        'request': request,
        'scheduledTime': scheduledDateTime,
        'activity': foundActivity,
        'dayKey': foundDayKey,
      });
    }

    sortedNotifications.sort((a, b) {
      final aTime = a['scheduledTime'] as DateTime?;
      final bTime = b['scheduledTime'] as DateTime?;
      if (aTime == null && bTime == null) return 0;
      if (aTime == null) return 1;
      if (bTime == null) return -1;
      return aTime.compareTo(bTime);
    });

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.pendingNotificationsTitle),
          content: SizedBox(
            width: double.maxFinite,
            child: sortedNotifications.isEmpty
                ? Center(child: Text(l10n.noPendingNotifications))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: sortedNotifications.length,
                    itemBuilder: (context, index) {
                      final item = sortedNotifications[index];
                      final request =
                          item['request'] as PendingNotificationRequest;
                      final foundActivity = item['activity'] as Activity?;
                      final foundDayKey = item['dayKey'] as String?;
                      final scheduledDateTime =
                          item['scheduledTime'] as DateTime?;

                      final String title =
                          foundActivity?.name ?? request.title ?? l10n.noTitle;
                      final String dayLabel = foundDayKey != null
                          ? _days[hiveKeys.indexOf(foundDayKey)]
                          : '??';

                      String notificationType;
                      if (foundActivity != null &&
                          foundActivity.notificationMinutesBefore != null) {
                        switch (foundActivity.notificationMinutesBefore) {
                          case 0:
                            notificationType = l10n.notifyOnTime;
                            break;
                          case 5:
                            notificationType = l10n.notify5MinBefore;
                            break;
                          case 15:
                            notificationType = l10n.notify15MinBefore;
                            break;
                          default:
                            notificationType = '';
                        }
                      } else {
                        notificationType = l10n.unknown;
                      }

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today,
                                      size: 16, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  if (foundActivity != null)
                                    Expanded(
                                      child: Text(
                                          '$dayLabel - ${l10n.activityTime}: ${_formatTime(foundActivity.startTime)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                      Icons.notifications_active_outlined,
                                      size: 16,
                                      color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                        '${l10n.notificationType}: $notificationType',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                  ),
                                ],
                              ),
                              if (scheduledDateTime != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.alarm,
                                          size: 16, color: Colors.grey),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                            '${l10n.scheduledFor}: ${MaterialLocalizations.of(context).formatFullDate(scheduledDateTime)} - ${_formatTime(TimeOfDay.fromDateTime(scheduledDateTime))}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          actions: <Widget>[
            if (pendingNotifications.isNotEmpty)
              TextButton(
                style:
                    TextButton.styleFrom(foregroundColor: Colors.red.shade400),
                child: Text(l10n.cancelAll),
                onPressed: () {
                  Provider.of<ActivityProvider>(context, listen: false)
                      .clearAllNotificationsAndUpdateActivities();
                  Navigator.of(dialogContext).pop();
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.allNotificationsCancelled)),
                  );
                },
              ),
            TextButton(
              child: Text(l10n.close),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showUseTemplateDialog() async {
    final templateProvider = context.read<TemplateProvider>();
    final l10n = AppLocalizations.of(context)!;

    if (templateProvider.templates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noTemplatesToUse)),
      );
      return;
    }

    final selectedTemplate = await showDialog<ActivityTemplate>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectTemplate),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: templateProvider.templates.length,
            itemBuilder: (context, index) {
              final template = templateProvider.templates[index];
              return ListTile(
                leading: Icon(Icons.circle, color: template.color),
                title: Text(template.name),
                onTap: () {
                  Navigator.of(context).pop(template);
                },
              );
            },
          ),
        ),
      ),
    );

    if (selectedTemplate == null || !mounted) return;

    final startTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      cancelText: l10n.cancel.toUpperCase(),
      confirmText: l10n.timePickerSet.toUpperCase(),
      helpText: l10n.timePickerSelect.toUpperCase(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (startTime == null || !mounted) return;

    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endTotalMinutes = startMinutes + selectedTemplate.durationInMinutes;
    final endHour = (endTotalMinutes ~/ 60) % 24;
    final endMinute = endTotalMinutes % 60;
    final endTime = TimeOfDay(hour: endHour, minute: endMinute);

    final newActivity = Activity(
      name: selectedTemplate.name,
      startTime: startTime,
      endTime: endTime,
      color: selectedTemplate.color,
      note: selectedTemplate.note,
      notificationMinutesBefore: selectedTemplate.notificationMinutesBefore,
      tags: selectedTemplate.tags,
      isNotificationRecurring: selectedTemplate.isNotificationRecurring,
    );

    _handleActivitySubmission(context, newActivity);
  }

  Widget _buildPomodoroStartButton(
      BuildContext context, Activity activity, String dayKey) {
    final todayKey = AppConstants.dayKeys[DateTime.now().weekday - 1];
    if (dayKey != todayKey) {
      return const SizedBox.shrink();
    }

    final now = TimeOfDay.now();
    final nowInMinutes = now.hour * 60 + now.minute;
    final startInMinutes =
        activity.startTime.hour * 60 + activity.startTime.minute;
    final endInMinutes = activity.endTime.hour * 60 + activity.endTime.minute;

    final bool isCurrentActivity = (startInMinutes <= endInMinutes)
        ? (nowInMinutes >= startInMinutes && nowInMinutes < endInMinutes)
        : (nowInMinutes >= startInMinutes || nowInMinutes < endInMinutes);

    if (isCurrentActivity) {
      final l10n = AppLocalizations.of(context)!;
      final isCompleted = activity.durationInMinutes > 0 &&
          activity.completedDurationInMinutes >= activity.durationInMinutes;

      return IconButton(
        icon: Icon(
          isCompleted
              ? Icons.check_circle_rounded
              : Icons.play_circle_fill_rounded,
          color: isCompleted
              ? Colors.green
              : Theme.of(context).colorScheme.primary,
        ),
        tooltip: activity.completedDurationInMinutes > 0
            ? l10n.pomodoro_continueSession
            : l10n.pomodoro_startFocusSession,
        onPressed: () {
          _startPomodoroSession(context, activity);
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  void _startPomodoroSession(BuildContext context, Activity activity) async {
    final l10n = AppLocalizations.of(context)!;
    final pomodoroProvider = context.read<PomodoroProvider>();

    final totalDuration = activity.durationInMinutes;
    final completedDuration = activity.completedDurationInMinutes;

    if (completedDuration >= totalDuration && totalDuration > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pomodoro_activityCompleted)),
      );
      return;
    }

    // 1. Provider'ı HAZIRLA (callback OLMADAN)
    pomodoroProvider.startSession(
      totalActivityMinutes: totalDuration,
      alreadyCompletedMinutes: completedDuration,
    );

    // 2. FocusScreen'e git ve kapanmasını bekle
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => FocusScreen(
        activityId: activity.id,
        activityName: activity.name,
      ),
    ));

    // 3. FocusScreen kapandıktan SONRA bu kod çalışacak
    if (context.mounted) {
      // Provider'daki bayrağı kontrol et
      if (pomodoroProvider.targetReached) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("🏆 ${l10n.targetReached(activity.name)}"),
            backgroundColor: Colors.green,
          ),
        );
      }
      pomodoroProvider.stop();
    }
  }

  void _showPomodoroActionsMenu(BuildContext context, Activity activity) {
    final l10n = AppLocalizations.of(context)!;
    final activityProvider = context.read<ActivityProvider>();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              title: Text(
                activity.name,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.hourglass_bottom_rounded),
              title: Text(l10n.pomodoro_completedMinutes(
                  activity.completedDurationInMinutes.toString(),
                  activity.durationInMinutes.toString())),
            ),
            ListTile(
              leading: Icon(Icons.refresh_rounded,
                  color: Theme.of(context).colorScheme.error),
              title: Text(
                l10n.pomodoro_resetProgress,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onTap: () {
                activityProvider.resetCompletedDuration(activity.id);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final clockColor = Theme.of(context).colorScheme.onSurface;
    final activityProvider = context.watch<ActivityProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(l10n.appTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_outlined),
            tooltip: l10n.statisticsButtonTooltip,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const StatisticsPage(),
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _showSettingsDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: List.generate(7, (index) {
                final dayLabel = _days[index];
                final dayKey = hiveKeys[index];
                final isSelected = dayKey == activityProvider.selectedDay;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: isSelected
                              ? BorderSide.none
                              : BorderSide(
                                  color: Theme.of(context).dividerColor),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                      ),
                      onPressed: () {
                        const middleCycle = 1000;
                        final targetPage = (middleCycle * 7) + index;

                        activityProvider.changeDay(hiveKeys[index]);

                        _transformationController.value = Matrix4.identity();

                        if (_pageController.page?.round() != targetPage) {
                          _pageController.jumpToPage(targetPage);
                        }
                      },
                      child: Text(
                        dayLabel,
                        style: TextStyle(
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).textTheme.bodySmall?.color,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: null,
              onPageChanged: (pageIndex) {
                final dayIndex = pageIndex % 7;
                context.read<ActivityProvider>().changeDay(hiveKeys[dayIndex]);
                _transformationController.value = Matrix4.identity();
              },
              itemBuilder: (context, pageIndex) {
                final dayKey = hiveKeys[pageIndex % 7];
                final activities =
                    activityProvider.dailyActivities[dayKey] ?? [];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      SizedBox(
                        width: 300,
                        height: 300,
                        child: InteractiveViewer(
                          transformationController: _transformationController,
                          clipBehavior: Clip.none,
                          minScale: 1.0,
                          maxScale: 3.0,
                          child: GestureDetector(
                            onTapDown: (details) {
                              const size = Size(300, 300);
                              _handlePlannerTap(details, activities, size);
                            },
                            child: CustomPaint(
                              size: const Size(300, 300),
                              painter: CircularPlannerPainter(
                                activities: activities,
                                textColor: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .color!,
                                circleColor: Theme.of(context).dividerColor,
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(_currentTime,
                                        style: TextStyle(
                                            color: clockColor,
                                            fontSize: 48,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: -1.0)),
                                    Text(
                                        _getLocalizedTodayName(context)
                                            .toUpperCase(),
                                        style: TextStyle(
                                            color: clockColor.withAlpha(180),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 2.0)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 16.0,
                        runSpacing: 8.0,
                        children: [
                          ElevatedButton.icon(
                              onPressed: () => _addActivity(context),
                              icon: const Icon(Icons.add),
                              label: Text(l10n.addNewActivity)),
                          ElevatedButton.icon(
                              onPressed: () => _showUseTemplateDialog(),
                              icon: const Icon(Icons.file_copy_rounded),
                              label: Text(l10n.addFromTemplate),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  foregroundColor: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(l10n.activityList,
                              style: Theme.of(context).textTheme.headlineSmall),
                          if (activities.isNotEmpty)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    icon: const Icon(Icons.copy_all_outlined),
                                    tooltip: l10n.copyDay,
                                    onPressed: () =>
                                        _showCopyDayDialog(context)),
                                IconButton(
                                    icon: Icon(Icons.delete_sweep_outlined,
                                        color: Colors.red.shade400),
                                    tooltip: l10n.deleteAll,
                                    onPressed: () =>
                                        _showClearAllConfirmationDialog(
                                            context)),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: activities.isEmpty
                            ? Center(
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_task_rounded,
                                      size: 60,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color
                                          ?.withAlpha((255 * 0.5).round())),
                                  const SizedBox(height: 16),
                                  Text(
                                    l10n.noActivityToday,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    l10n.tapPlusToStart,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color
                                          ?.withAlpha((255 * 0.7).round()),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ))
                            : ListView.builder(
                                key: ValueKey<String>(dayKey),
                                itemCount: activities.length,
                                itemBuilder: (context, index) {
                                  final activity = activities[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: ListTile(
                                      leading: Container(
                                          width: 10, color: activity.color),
                                      title: Text(activity.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              )),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Builder(builder: (context) {
                                            final baseSubtitleColor =
                                                Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.color;
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${_formatTime(activity.startTime)} - ${_formatTime(activity.endTime)}',
                                                  style: TextStyle(
                                                    color: baseSubtitleColor
                                                        ?.withAlpha((255 * 0.7)
                                                            .round()),
                                                  ),
                                                ),
                                                if (activity.note != null &&
                                                    activity.note!.isNotEmpty)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 4.0),
                                                    child: Text(
                                                      activity.note!,
                                                      style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color: baseSubtitleColor
                                                            ?.withAlpha(
                                                                (255 * 0.6)
                                                                    .round()),
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                              ],
                                            );
                                          }),
                                          if (activity.tags.isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 6.0),
                                              child: Wrap(
                                                spacing: 6.0,
                                                runSpacing: 4.0,
                                                children: [
                                                  ...activity.tags
                                                      .take(2)
                                                      .map((tag) => Chip(
                                                            label: Text(tag),
                                                            labelStyle:
                                                                TextStyle(
                                                              fontSize: 12,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .onSecondaryContainer,
                                                            ),
                                                            backgroundColor: Theme
                                                                    .of(context)
                                                                .colorScheme
                                                                .secondaryContainer,
                                                            materialTapTargetSize:
                                                                MaterialTapTargetSize
                                                                    .shrinkWrap,
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        6,
                                                                    vertical:
                                                                        0),
                                                          )),
                                                  if (activity.tags.length > 2)
                                                    Chip(
                                                      label: Text(
                                                          '+${activity.tags.length - 2}'),
                                                      labelStyle: TextStyle(
                                                        fontSize: 12,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurfaceVariant,
                                                      ),
                                                      backgroundColor: Theme.of(
                                                              context)
                                                          .colorScheme
                                                          .surfaceContainerHighest,
                                                      materialTapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 6,
                                                          vertical: 0),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          if (activity
                                                  .completedDurationInMinutes >
                                              0)
                                            GestureDetector(
                                              onTap: () {
                                                _showPomodoroActionsMenu(
                                                    context, activity);
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    top: 8.0),
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surfaceContainer,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    LinearProgressIndicator(
                                                      value: activity
                                                                  .durationInMinutes >
                                                              0
                                                          ? activity
                                                                  .completedDurationInMinutes /
                                                              activity
                                                                  .durationInMinutes
                                                          : 0,
                                                      backgroundColor: Theme.of(
                                                              context)
                                                          .colorScheme
                                                          .surfaceContainerHighest,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              activity.color
                                                                  .withAlpha((255 *
                                                                          0.7)
                                                                      .round())),
                                                      minHeight: 6,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Builder(builder: (context) {
                                                      final baseTextColor =
                                                          Theme.of(context)
                                                              .textTheme
                                                              .bodySmall
                                                              ?.color;
                                                      return Text(
                                                        l10n.pomodoro_completedMinutes(
                                                            activity
                                                                .completedDurationInMinutes
                                                                .toString(),
                                                            activity
                                                                .durationInMinutes
                                                                .toString()),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: baseTextColor
                                                              ?.withAlpha(
                                                                  (255 * 0.8)
                                                                      .round()),
                                                        ),
                                                      );
                                                    }),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _buildPomodoroStartButton(
                                              context, activity, dayKey),
                                          IconButton(
                                              icon: Icon(Icons.edit,
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color
                                                      ?.withAlpha(
                                                          (255 * 0.6).round())),
                                              onPressed: () => _editActivity(
                                                  context, activity)),
                                          IconButton(
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.redAccent),
                                              onPressed: () => _deleteActivity(
                                                  context, activity)),
                                          PopupMenuButton<int>(
                                            tooltip: l10n.notificationSettings,
                                            onSelected: (int value) {
                                              _setNotification(activity,
                                                  value == -1 ? null : value);
                                            },
                                            itemBuilder:
                                                (BuildContext context) =>
                                                    <PopupMenuEntry<int>>[
                                              PopupMenuItem<int>(
                                                value: -1,
                                                child:
                                                    Text(l10n.notificationsOff),
                                              ),
                                              PopupMenuItem<int>(
                                                value: 0,
                                                child: Text(l10n.notifyOnTime),
                                              ),
                                              PopupMenuItem<int>(
                                                value: 5,
                                                child:
                                                    Text(l10n.notify5MinBefore),
                                              ),
                                              PopupMenuItem<int>(
                                                value: 15,
                                                child: Text(
                                                    l10n.notify15MinBefore),
                                              ),
                                            ],
                                            icon:
                                                _getNotificationIcon(activity),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
