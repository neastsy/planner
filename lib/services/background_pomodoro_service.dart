import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:gunluk_planlayici/models/activity_model.dart';
import 'package:gunluk_planlayici/repositories/activity_repository.dart';
import 'package:hive/hive.dart';
import 'package:gunluk_planlayici/adepters/color_adapter.dart';
import 'package:gunluk_planlayici/adepters/time_of_day_adapter.dart';

enum PomodoroState { stopped, work, shortBreak, longBreak }

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: false,
      notificationChannelId: 'pomodoro_channel',
      initialNotificationTitle: 'Günlük Planlayıcı',
      initialNotificationContent: 'Pomodoro servisi hazır.',
      foregroundServiceNotificationId: 888,
      autoStartOnBoot: false,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
bool onIosBackground(ServiceInstance service) {
  debugPrint("BACKGROUND_SERVICE: iOS background mode");
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  try {
    Timer? timer;
    ActivityRepository? activityRepository;
    PomodoroState currentState = PomodoroState.stopped;
    bool isPaused = true;
    int remainingTimeInSession = 0;
    int completedWorkSessions = 0;
    int totalTargetMinutes = 0;
    int alreadyCompletedMinutes = 0;
    int totalSecondsInThisRun = 0;
    int workSecondsForSaving = 0;
    String currentActivityId = '';
    String currentDayKey = '';
    int currentSessionTotalDuration = 0;

    const int workDuration = 25 * 60;
    const int shortBreakDuration = 5 * 60;
    const int longBreakDuration = 15 * 60;
    const int sessionsBeforeLongBreak = 4;

    void updateUIAndNotification({bool isFinished = false}) {
      String title;
      switch (currentState) {
        case PomodoroState.work:
          title = "Çalışma";
          break;
        case PomodoroState.shortBreak:
          title = "Kısa Mola";
          break;
        case PomodoroState.longBreak:
          title = "Uzun Mola";
          break;
        case PomodoroState.stopped:
          title = "Durduruldu";
          break;
      }
      final minutes =
          (remainingTimeInSession / 60).floor().toString().padLeft(2, '0');
      final seconds = (remainingTimeInSession % 60).toString().padLeft(2, '0');
      final content = isPaused ? "Duraklatıldı" : "$minutes:$seconds";

      if (service is AndroidServiceInstance) {
        service.setForegroundNotificationInfo(title: title, content: content);
      }

      service.invoke('update', {
        'currentState': currentState.toString(),
        'isPaused': isPaused,
        'remainingTimeInSession': remainingTimeInSession,
        'completedWorkSessions': completedWorkSessions,
        'totalActivityProgress': (totalTargetMinutes > 0)
            ? (((alreadyCompletedMinutes * 60) + totalSecondsInThisRun) /
                    (totalTargetMinutes * 60))
                .clamp(0.0, 1.0)
            : 0.0,
        'currentSessionTotalDuration': currentSessionTotalDuration,
      });
    }

    void determineNextWorkSessionDuration() {
      final totalElapsedMinutes =
          ((alreadyCompletedMinutes * 60) + totalSecondsInThisRun) ~/ 60;
      final remainingMinutesForActivity =
          totalTargetMinutes - totalElapsedMinutes;
      if (remainingMinutesForActivity <= 0) {
        remainingTimeInSession = 0;
        currentSessionTotalDuration = 0;
        return;
      }
      final remainingSecondsForActivity = remainingMinutesForActivity * 60;
      if (remainingSecondsForActivity < workDuration) {
        remainingTimeInSession = remainingSecondsForActivity;
        currentSessionTotalDuration = remainingSecondsForActivity;
      } else {
        remainingTimeInSession = workDuration;
        currentSessionTotalDuration = workDuration;
      }
    }

    Future<void> saveProgress() async {
      if (activityRepository == null) return;
      try {
        final Map<String, List<Activity>> allActivities =
            await activityRepository!.loadActivities();
        final List<Activity> activitiesForDay =
            List<Activity>.from(allActivities[currentDayKey] ?? []);
        final index =
            activitiesForDay.indexWhere((a) => a.id == currentActivityId);
        if (index != -1) {
          final oldActivity = activitiesForDay[index];
          final newCompletedDuration =
              oldActivity.completedDurationInMinutes + 1;
          if (newCompletedDuration > oldActivity.durationInMinutes) return;
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
            completedDurationInMinutes: newCompletedDuration,
          );
          activitiesForDay[index] = updatedActivity;
          await activityRepository!
              .saveActivitiesForDay(currentDayKey, activitiesForDay);
        }
      } catch (e) {
        debugPrint("BACKGROUND_SERVICE: Error saving progress: $e");
      }
    }

    void onSessionEnd() async {
      isPaused = true;
      if (currentState == PomodoroState.work) {
        completedWorkSessions++;
        service.invoke('play_sound', {'sound': 'sounds/end_sound.mp3'});
      }

      final totalElapsedMinutes =
          ((alreadyCompletedMinutes * 60) + totalSecondsInThisRun) ~/ 60;

      if (totalElapsedMinutes >= totalTargetMinutes) {
        await saveProgress();

        currentState = PomodoroState.stopped;
        updateUIAndNotification(isFinished: true);
        service.invoke('task_completed');
        service.stopSelf();
        return;
      }
      if (currentState == PomodoroState.work) {
        if (completedWorkSessions % sessionsBeforeLongBreak == 0) {
          currentState = PomodoroState.longBreak;
          remainingTimeInSession = longBreakDuration;
          currentSessionTotalDuration = longBreakDuration;
        } else {
          currentState = PomodoroState.shortBreak;
          remainingTimeInSession = shortBreakDuration;
          currentSessionTotalDuration = shortBreakDuration;
        }
      } else {
        service.invoke('play_sound', {'sound': 'sounds/start_sound.mp3'});
        currentState = PomodoroState.work;
        determineNextWorkSessionDuration();
      }
      updateUIAndNotification();
    }

    void startTimer() {
      timer?.cancel();
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (isPaused) return;
        if (remainingTimeInSession > 0) {
          remainingTimeInSession--;
          totalSecondsInThisRun++;
          if (currentState == PomodoroState.work) {
            workSecondsForSaving++;
            if (workSecondsForSaving > 0 && workSecondsForSaving % 60 == 0) {
              saveProgress();
            }
          }
        } else {
          onSessionEnd();
        }
        updateUIAndNotification();
      });
    }

    Future<bool> initializeHive(String dbPath) async {
      try {
        Hive.init(dbPath);
        if (!Hive.isAdapterRegistered(1)) {
          Hive.registerAdapter(ActivityAdapter());
        }
        if (!Hive.isAdapterRegistered(2)) {
          Hive.registerAdapter(TimeOfDayAdapter());
        }
        if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(ColorAdapter());

        activityRepository = ActivityRepository();
        return true;
      } catch (e) {
        debugPrint("BACKGROUND_SERVICE: Error initializing Hive: $e");
        return false;
      }
    }

    service.on('start').listen((event) async {
      if (event == null) return;
      String? path = event['dbPath'];
      if (path == null) {
        debugPrint("BACKGROUND_SERVICE: No database path provided");
        return;
      }
      bool hiveInitialized = await initializeHive(path);
      if (!hiveInitialized) {
        debugPrint("BACKGROUND_SERVICE: Failed to initialize Hive");
        return;
      }
      currentState = PomodoroState.work;
      isPaused = false;
      completedWorkSessions = 0;
      totalTargetMinutes = event['totalActivityMinutes'];
      alreadyCompletedMinutes = event['alreadyCompletedMinutes'];
      totalSecondsInThisRun = 0;
      workSecondsForSaving = 0;
      currentActivityId = event['activityId'];
      currentDayKey = event['dayKey'];
      determineNextWorkSessionDuration();
      startTimer();
      updateUIAndNotification();
    });

    service.on('togglePause').listen((event) {
      isPaused = !isPaused;
      updateUIAndNotification();
    });

    service.on('stop').listen((event) async {
      debugPrint("BACKGROUND_SERVICE: Stop command received.");
      timer?.cancel();
      timer = null;

      try {
        // 1. O ana kadar kaç tam dakika geçtiğini hesapla.
        final int minutesCompletedThisRun = totalSecondsInThisRun ~/ 60;

        // 2. Bu seans başlamadan önce zaten tamamlanmış olan süreyle topla.
        final int finalTotalCompletedMinutes =
            alreadyCompletedMinutes + minutesCompletedThisRun;

        // 3. Eğer kaydedilecek yeni bir ilerleme varsa...
        if (finalTotalCompletedMinutes > alreadyCompletedMinutes) {
          debugPrint(
              "Stop command: Final progress to save is $finalTotalCompletedMinutes minutes.");

          // 4. DOĞRUDAN HIVE'A YAZMA MANTIĞI
          // ActivityRepository'ye güvenmek yerine, son kaydı burada kendimiz yapıyoruz.
          if (activityRepository != null) {
            // Önce en güncel aktivite listesini alalım
            final Map<String, List<Activity>> allActivities =
                await activityRepository!.loadActivities();
            final List<Activity> activitiesForDay =
                List<Activity>.from(allActivities[currentDayKey] ?? []);
            final index =
                activitiesForDay.indexWhere((a) => a.id == currentActivityId);

            if (index != -1) {
              final oldActivity = activitiesForDay[index];

              // Sürenin, aktivitenin toplam süresini aşmadığından emin ol.
              final newCompletedDuration = finalTotalCompletedMinutes.clamp(
                  0, oldActivity.durationInMinutes);

              final updatedActivity = Activity(
                id: oldActivity.id,
                name: oldActivity.name,
                startTime: oldActivity.startTime,
                endTime: oldActivity.endTime,
                color: oldActivity.color,
                note: oldActivity.note,
                notificationMinutesBefore:
                    oldActivity.notificationMinutesBefore,
                tags: oldActivity.tags,
                isNotificationRecurring: oldActivity.isNotificationRecurring,
                completedDurationInMinutes: newCompletedDuration,
              );

              activitiesForDay[index] = updatedActivity;
              // Son durumu Hive'a yaz ve bitmesini bekle.
              await activityRepository!
                  .saveActivitiesForDay(currentDayKey, activitiesForDay);
              debugPrint("Final progress saved successfully to Hive.");
            }
          }
        }
      } catch (e) {
        debugPrint("Error during final save on stop: $e");
      }

      // 5. Tüm kayıt işlemleri bittikten sonra servisi durdur.
      currentState = PomodoroState.stopped;
      updateUIAndNotification();
      service.stopSelf();
    });

    service.on('get_status').listen((event) {
      updateUIAndNotification();
    });
  } catch (e) {
    debugPrint("BACKGROUND_SERVICE: Critical error in onStart: $e");
    service.stopSelf();
  }
}
