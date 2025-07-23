import 'dart:async';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:gunluk_planlayici/models/activity_model.dart';
import 'package:gunluk_planlayici/repositories/activity_repository.dart';
import 'package:hive/hive.dart';
import 'package:gunluk_planlayici/utils/constants.dart';
import 'package:gunluk_planlayici/adepters/color_adapter.dart';
import 'package:gunluk_planlayici/adepters/time_of_day_adapter.dart';
import 'package:audioplayers/audioplayers.dart';

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
  WidgetsFlutterBinding.ensureInitialized(); // iOS için de gerekli.
  print("BACKGROUND_SERVICE: iOS background mode");
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // YENİ: En üste genel bir try-catch bloğu ekliyoruz.
  try {
    // KRİTİK: Bu iki satır, eklentilerin çalışması için zorunludur.
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    final audioPlayer = AudioPlayer();
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

    const int workDuration = 25 * 60;
    const int shortBreakDuration = 5 * 60;
    const int longBreakDuration = 15 * 60;
    const int sessionsBeforeLongBreak = 4;

    Future<void> playSound(String soundPath) async {
      try {
        await audioPlayer.play(AssetSource(soundPath));
      } catch (e) {
        print("BACKGROUND_SERVICE: Error playing sound: $e");
      }
    }

    void updateUIAndNotification({bool isFinished = false}) {
      print(
          "BACKGROUND_SERVICE: Update - State: $currentState, Paused: $isPaused, Time: $remainingTimeInSession");

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
      });
    }

    Future<void> saveProgress() async {
      if (activityRepository == null) return;
      try {
        final List<Activity> activitiesForDay = List<Activity>.from(
            activityRepository!.loadActivities()[currentDayKey] ?? []);
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
        print("BACKGROUND_SERVICE: Error saving progress: $e");
      }
    }

    void determineNextWorkSessionDuration() {
      final totalElapsedMinutes =
          ((alreadyCompletedMinutes * 60) + totalSecondsInThisRun) ~/ 60;
      final remainingMinutesForActivity =
          totalTargetMinutes - totalElapsedMinutes;
      if (remainingMinutesForActivity <= 0) {
        remainingTimeInSession = 0;
        return;
      }
      final remainingSecondsForActivity = remainingMinutesForActivity * 60;
      remainingTimeInSession = (remainingSecondsForActivity < workDuration)
          ? remainingSecondsForActivity
          : workDuration;
    }

    void onSessionEnd() {
      isPaused = true;
      if (currentState == PomodoroState.work) {
        completedWorkSessions++;
        playSound('sounds/end_sound.mp3');
      }
      final totalElapsedMinutes =
          ((alreadyCompletedMinutes * 60) + totalSecondsInThisRun) ~/ 60;
      if (totalElapsedMinutes >= totalTargetMinutes) {
        currentState = PomodoroState.stopped;
        updateUIAndNotification(isFinished: true);
        service.stopSelf();
        return;
      }
      if (currentState == PomodoroState.work) {
        if (completedWorkSessions % sessionsBeforeLongBreak == 0) {
          currentState = PomodoroState.longBreak;
          remainingTimeInSession = longBreakDuration;
        } else {
          currentState = PomodoroState.shortBreak;
          remainingTimeInSession = shortBreakDuration;
        }
      } else {
        playSound('sounds/start_sound.mp3');
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

    service.on('start').listen((event) async {
      if (event == null) return;
      if (activityRepository == null) {
        try {
          String? path = event['dbPath'];
          if (path != null) {
            Hive.init(path);
            if (!Hive.isAdapterRegistered(1)) {
              Hive.registerAdapter(ActivityAdapter());
            }
            if (!Hive.isAdapterRegistered(2)) {
              Hive.registerAdapter(TimeOfDayAdapter());
            }
            if (!Hive.isAdapterRegistered(3)) {
              Hive.registerAdapter(ColorAdapter());
            }
            final activitiesBox =
                await Hive.openBox(AppConstants.activitiesBoxName);
            activityRepository = ActivityRepository(activitiesBox);
          } else {
            return;
          }
        } catch (e) {
          print("BACKGROUND_SERVICE: Error initializing repository: $e");
          return;
        }
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

    service.on('stop').listen((event) {
      timer?.cancel();
      timer = null; // YENİ: Timer referansını temizle
      currentState = PomodoroState.stopped;
      updateUIAndNotification();
      audioPlayer.dispose();
      service.stopSelf();
    });

    service.on('get_status').listen((event) {
      updateUIAndNotification();
    });
  } catch (e) {
    print("BACKGROUND_SERVICE: Critical error in onStart: $e");
    service.stopSelf();
  }
}
