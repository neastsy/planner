import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../l10n/app_localizations.dart';
import '../models/activity_model.dart';
import '../models/language_model.dart';
import '../models/activity_template_model.dart';
import '../providers/activity_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/template_provider.dart';
import '../widgets/add_activity_sheet.dart';
import '../widgets/circular_planner_painter.dart';
import '../widgets/theme_switcher.dart';
import '../services/notification_service.dart';
import '../screens/template_manager_page.dart';
import '../utils/constants.dart';

class PlannerHomePage extends StatefulWidget {
  const PlannerHomePage({super.key});

  @override
  State<PlannerHomePage> createState() => _PlannerHomePageState();
}

class _PlannerHomePageState extends State<PlannerHomePage> {
  final List<String> hiveKeys = AppConstants.dayKeys;
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
        // YENİ: Provider'ı burada sadece okuyoruz, dinlemiyoruz.
        final settingsProvider =
            Provider.of<SettingsProvider>(context, listen: false);

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
                    // YENİ: Mevcut tema bilgisi provider'dan alınıyor.
                    isDarkMode: settingsProvider.themeMode == ThemeMode.dark,
                    onToggle: (isDark) {
                      final newMode = isDark ? ThemeMode.dark : ThemeMode.light;
                      // YENİ: Ayarı değiştirmek için provider metodu çağırılıyor.
                      settingsProvider.changeTheme(newMode);
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
                      // YENİ: Mevcut dil bilgisi provider'dan veya Localizations'dan alınıyor.
                      lang.code ==
                      (settingsProvider.locale?.languageCode ??
                          Localizations.localeOf(context).languageCode),
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
                    // YENİ: Dili değiştirmek için provider metodu çağırılıyor.
                    settingsProvider.changeLocale(Locale(newLanguage.code, ''));
                    Navigator.of(dialogContext).pop();
                  }
                },
              ),
              const Divider(),
              TextButton.icon(
                icon: const Icon(Icons.notifications_on_outlined),
                label: Text(l10n.viewPendingNotifications),
                onPressed: () {
                  // Önce Ayarlar diyaloğunu kapat
                  Navigator.of(dialogContext).pop();
                  // Sonra bekleyen bildirimler diyaloğunu aç (Artık context göndermiyoruz)
                  _showPendingNotificationsDialog();
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  // Bu satırı ekleyerek düğmenin tüm genişliği kaplamasını sağlayabiliriz
                  minimumSize: const Size.fromHeight(40),
                  // Hizalamayı sola yaslamak için
                  alignment: Alignment.centerLeft,
                ),
              ),
              const Divider(),
              TextButton.icon(
                icon: const Icon(Icons.file_copy_outlined),
                label: Text(l10n.manageTemplates), // Yeni metin
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Ayarlar diyaloğunu kapat
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
        title: Text(l10n.overwriteConfirmationTitle), // Yeni metin
        content: Text(
            l10n.overwriteConfirmationContent(targetDayLabel)), // Yeni metin
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red.shade400),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.overwrite), // Yeni metin
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
                  // YENİ: Kopyalama modu seçenekleri
                  Text(
                    l10n.copyMode, // Bu metni .arb dosyalarına ekleyeceğiz
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  RadioListTile<CopyMode>(
                    title: Text(l10n
                        .copyModeMerge), // Bu metni .arb dosyalarına ekleyeceğiz
                    value: CopyMode.merge,
                    groupValue: selectedMode,
                    onChanged: (CopyMode? value) {
                      setDialogState(() {
                        selectedMode = value!;
                      });
                    },
                  ),
                  RadioListTile<CopyMode>(
                    title: Text(l10n
                        .copyModeOverwrite), // Bu metni .arb dosyalarına ekleyeceğiz
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
                  // YENİ VE BASİTLEŞTİRİLMİŞ MANTIK
                  onPressed: () async {
                    // Eğer mod "Birleştir" ise, direkt kopyala.
                    if (selectedMode == CopyMode.merge) {
                      activityProvider.copyDayActivities(
                        fromDay: sourceDayKey,
                        toDay: targetDayKey,
                        mode: CopyMode.merge,
                      );
                    }
                    // Eğer mod "Üzerine Yaz" ise...
                    else if (selectedMode == CopyMode.overwrite) {
                      bool canOverwrite = true;
                      // ...ve hedef gün boş değilse, son onayı iste.
                      if (!activityProvider.isDayEmpty(targetDayKey)) {
                        canOverwrite =
                            await _showFinalOverwriteConfirmationDialog(context,
                                    toDay: targetDayKey) ??
                                false;
                      }
                      // Onay verildiyse veya hedef gün zaten boşsa kopyala.
                      if (canOverwrite) {
                        activityProvider.copyDayActivities(
                          fromDay: sourceDayKey,
                          toDay: targetDayKey,
                          mode: CopyMode.overwrite,
                        );
                      } else {
                        // Onay verilmediyse hiçbir şey yapma ve diyaloğu kapatma.
                        return;
                      }
                    }

                    // Kopyalama işlemi yapıldıysa (veya yapılmadıysa bile) diyaloğu kapat.
                    if (dialogContext.mounted) {
                      Navigator.of(dialogContext).pop();
                    }

                    // Başarılı kopyalama sonrası SnackBar gösterimi
                    // (Bu kısım isteğe bağlı olarak sadece başarılı kopyalama sonrası gösterilebilir
                    // ancak şimdilik basit tutalım)
                    if (context.mounted) {
                      final targetDayLabel =
                          _days[hiveKeys.indexOf(targetDayKey)];
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(l10n.dayCopied(
                                sourceDayLabel, targetDayLabel))),
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

  void _showPendingNotificationsDialog() async {
    final notificationService = NotificationService();
    final activityProvider = context.read<ActivityProvider>();

    final List<PendingNotificationRequest> pendingNotifications =
        await notificationService.getPendingNotifications();

    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;

    // YENİ: Sıralama için bildirimleri ve hesaplanan zamanlarını tutacak bir liste oluşturalım.
    final List<Map<String, dynamic>> sortedNotifications = [];

    for (var request in pendingNotifications) {
      Activity? foundActivity;
      String? foundDayKey;

      // İlgili aktiviteyi bulma mantığı (değişiklik yok)
      for (var dayKey in activityProvider.dailyActivities.keys) {
        final activity = activityProvider.dailyActivities[dayKey]?.firstWhere(
            (act) => act.id.hashCode == request.id,
            orElse: () => Activity(
                name: '',
                startTime: TimeOfDay(hour: 0, minute: 0),
                endTime: TimeOfDay(hour: 0, minute: 0),
                color: Colors.transparent));
        if (activity != null && activity.name.isNotEmpty) {
          foundActivity = activity;
          foundDayKey = dayKey;
          break;
        }
      }

      DateTime? scheduledDateTime;
      if (foundActivity != null &&
          foundActivity.notificationMinutesBefore != null &&
          foundDayKey != null) {
        // Zaman hesaplama mantığı (değişiklik yok)
        final now = DateTime.now();
        final dayIndex = AppConstants.dayKeys.indexOf(foundDayKey);
        int daysToAdd = (dayIndex - (now.weekday - 1) + 7) % 7;
        var activityDate = DateTime(now.year, now.month, now.day + daysToAdd,
            foundActivity.startTime.hour, foundActivity.startTime.minute);
        if (activityDate.isBefore(now)) {
          activityDate = activityDate.add(const Duration(days: 7));
        }
        scheduledDateTime = activityDate.subtract(
            Duration(minutes: foundActivity.notificationMinutesBefore!));
      }

      // YENİ: Orijinal request'i ve hesaplanan zamanı bir haritaya ekleyelim.
      sortedNotifications.add({
        'request': request,
        'scheduledTime': scheduledDateTime,
        'activity': foundActivity,
        'dayKey': foundDayKey,
      });
    }

    // YENİ: Listeyi 'scheduledTime'a göre sıralayalım (en yakından en uzağa).
    // Null zamanlar en sona gitsin.
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
                    // YENİ: Sıralanmış listeyi kullanıyoruz.
                    itemCount: sortedNotifications.length,
                    itemBuilder: (context, index) {
                      // YENİ: Sıralanmış listeden verileri alıyoruz.
                      final item = sortedNotifications[index];
                      final request =
                          item['request'] as PendingNotificationRequest;
                      final foundActivity = item['activity'] as Activity?;
                      final foundDayKey = item['dayKey'] as String?;
                      final scheduledDateTime =
                          item['scheduledTime'] as DateTime?;

                      // Geri kalan UI mantığı büyük ölçüde aynı kalıyor, sadece verileri
                      // 'item' haritasından alıyor.
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
                        // ... (Card'ın içeriği ve UI'ı öncekiyle aynı)
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
                                  Expanded(
                                    child: Text(
                                        '$dayLabel - ${l10n.activityTime}: ${_formatTime(foundActivity!.startTime)}',
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
                  // YENİ: Provider üzerinden işlemi yapıyoruz
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
        SnackBar(content: Text(l10n.noTemplatesToUse)), // Yeni metin
      );
      return;
    }

    final selectedTemplate = await showDialog<ActivityTemplate>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectTemplate), // Yeni metin
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

    // Şablon seçildikten sonra başlangıç saatini sor
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

    // Bitiş saatini hesapla
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endTotalMinutes = startMinutes + selectedTemplate.durationInMinutes;
    final endHour = (endTotalMinutes ~/ 60) % 24;
    final endMinute = endTotalMinutes % 60;
    final endTime = TimeOfDay(hour: endHour, minute: endMinute);

    // Yeni aktiviteyi oluştur
    final newActivity = Activity(
      name: selectedTemplate.name,
      startTime: startTime,
      endTime: endTime,
      color: selectedTemplate.color,
      note: selectedTemplate.note,
      notificationMinutesBefore: selectedTemplate.notificationMinutesBefore,
      tags: selectedTemplate.tags,
    );

    // Aktiviteyi ekle (çakışma kontrolüyle birlikte)
    _handleActivitySubmission(context, newActivity);
  }

  @override
  Widget build(BuildContext context) {
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
          Consumer<ActivityProvider>(
            builder: (context, provider, child) {
              return SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _days.length,
                  itemBuilder: (context, index) {
                    final dayLabel = _days[index];
                    final dayKey = hiveKeys[index];
                    final isSelected = dayKey == provider.selectedDay;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: isSelected
                              ? Colors.blueAccent
                              : Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: isSelected
                                  ? BorderSide.none
                                  : BorderSide(
                                      color: Theme.of(context).dividerColor)),
                        ),
                        onPressed: () => provider.changeDay(dayKey),
                        child: Text(
                          dayLabel,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Theme.of(context).textTheme.bodySmall?.color,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 30),
          Consumer<ActivityProvider>(
            builder: (context, provider, child) {
              return SizedBox(
                width: 300,
                height: 300,
                child: CustomPaint(
                  painter: CircularPlannerPainter(
                    activities: provider.selectedDayActivities,
                    textColor: Theme.of(context).textTheme.bodySmall!.color!,
                    circleColor: Theme.of(context).dividerColor,
                  ),
                  child: child,
                ),
              );
            },
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
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                  onPressed: () => _addActivity(context),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.addNewActivity)),
              const SizedBox(width: 16),
              // YENİ: Şablondan ekle düğmesi
              ElevatedButton.icon(
                onPressed: () => _showUseTemplateDialog(),
                icon: const Icon(Icons.file_copy_rounded),
                label: Text(l10n.addFromTemplate), // Yeni metin
                style: ElevatedButton.styleFrom(
                  // İsteğe bağlı: Farklı bir renk vererek ayırt edici olmasını sağlayabiliriz.
                  backgroundColor:
                      Theme.of(context).colorScheme.secondaryContainer,
                  foregroundColor:
                      Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(l10n.activityList,
                  style: Theme.of(context).textTheme.headlineSmall),
              Consumer<ActivityProvider>(
                builder: (context, provider, child) {
                  if (provider.selectedDayActivities.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Row(
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
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Consumer<ActivityProvider>(
              builder: (context, provider, child) {
                final activities = provider.selectedDayActivities;
                if (activities.isEmpty) {
                  return Center(
                    child: Text(
                      l10n.noActivityToday,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: 16,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  key: ValueKey<String>(provider.selectedDay),
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    final activity = activities[index];
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
                            if (activity.tags.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Wrap(
                                  spacing: 6.0,
                                  runSpacing: 4.0,
                                  children: [
                                    // YENİ: Listenin sadece ilk 2 elemanını alıp Chip'e dönüştür
                                    ...activity.tags.take(2).map((tag) => Chip(
                                          label: Text('#$tag'),
                                          labelStyle: TextStyle(
                                              fontSize: 12,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondaryContainer),
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .secondaryContainer,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 0),
                                        )),
                                    // YENİ: Eğer 2'den fazla etiket varsa, bir "daha fazla" göstergesi ekle
                                    if (activity.tags.length > 2)
                                      Chip(
                                        label: Text(
                                            '+${activity.tags.length - 2}'),
                                        labelStyle: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant),
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .surfaceContainerHighest,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 0),
                                      ),
                                  ],
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
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
