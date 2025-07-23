import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:gunluk_planlayici/services/background_pomodoro_service.dart';

class PomodoroProvider with ChangeNotifier {
  PomodoroState _currentState = PomodoroState.stopped;
  bool _isPaused = true;
  int _remainingTimeInSession = 0;
  int _completedWorkSessions = 0;
  double _totalActivityProgress = 0.0;
  int _currentSessionTotalDuration = 0;
  bool _isServiceListening = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isTaskCompleted = false;

  Completer<void>? _sessionStartedCompleter;
  StreamSubscription? _serviceSubscription;
  StreamSubscription? _soundSubscription;
  StreamSubscription? _taskCompletedSubscription;

  bool get isLoading =>
      _sessionStartedCompleter != null &&
      !_sessionStartedCompleter!.isCompleted;

  PomodoroState get currentState => _currentState;
  bool get isSessionActive => _currentState != PomodoroState.stopped;
  bool get isPaused => _isPaused;
  int get remainingTimeInSession => _remainingTimeInSession;
  int get completedWorkSessions => _completedWorkSessions;
  double get totalActivityProgress => _totalActivityProgress;
  int get currentSessionTotalDuration => _currentSessionTotalDuration;
  bool get isTaskCompleted => _isTaskCompleted;

  PomodoroProvider() {
    _initializeServiceConnection();
  }

  void _initializeServiceConnection() {
    if (!_isServiceListening) {
      _listenToService();
      _isServiceListening = true;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getStatus();
    });
  }

  void getStatus() {
    try {
      final service = FlutterBackgroundService();
      service.invoke('get_status');
    } catch (e) {
      debugPrint("PROVIDER: Error getting status: $e");
    }
  }

  Future<void> start({
    required String activityId,
    required String dayKey,
    required String dbPath,
    required int totalActivityMinutes,
    required int alreadyCompletedMinutes,
  }) async {
    _isTaskCompleted = false;
    try {
      final service = FlutterBackgroundService();
      _sessionStartedCompleter = Completer<void>();
      notifyListeners();

      final isRunning = await service.isRunning();
      if (!isRunning) {
        await service.startService();
        await Future.delayed(const Duration(milliseconds: 500));
      }

      service.invoke('start', {
        'activityId': activityId,
        'dayKey': dayKey,
        'dbPath': dbPath,
        'totalActivityMinutes': totalActivityMinutes,
        'alreadyCompletedMinutes': alreadyCompletedMinutes,
      });

      return _sessionStartedCompleter!.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Service başlatma timeout');
        },
      );
    } catch (e) {
      if (_sessionStartedCompleter != null &&
          !_sessionStartedCompleter!.isCompleted) {
        _sessionStartedCompleter!.completeError(e);
      }
      _sessionStartedCompleter = null;
      notifyListeners();
      rethrow;
    }
  }

  void stop() {
    try {
      final service = FlutterBackgroundService();
      service.invoke('stop');
      _isTaskCompleted = false;
      _resetState();
    } catch (e) {
      debugPrint("PROVIDER: Error stopping service: $e");
      _resetState();
    }
  }

  void _resetState() {
    _currentState = PomodoroState.stopped;
    _isPaused = true;
    _remainingTimeInSession = 0;
    _completedWorkSessions = 0;
    _totalActivityProgress = 0.0;
    _currentSessionTotalDuration = 0;
    _sessionStartedCompleter = null;
    notifyListeners();
  }

  void togglePause() {
    try {
      final service = FlutterBackgroundService();
      service.invoke('togglePause');
      _isPaused = !_isPaused;
      notifyListeners();
    } catch (e) {
      debugPrint("PROVIDER: Error toggling pause: $e");
    }
  }

  void _listenToService() {
    try {
      final service = FlutterBackgroundService();

      _soundSubscription?.cancel();
      _soundSubscription = service.on('play_sound').listen((event) {
        if (event != null && event['sound'] is String) {
          _playSound(event['sound']);
        }
      }, onError: (error) {
        debugPrint("PROVIDER: Sound stream error: $error");
      });

      _serviceSubscription?.cancel();
      _serviceSubscription = service.on('update').listen((event) {
        _handleServiceUpdate(event);
      }, onError: (error) {
        debugPrint("PROVIDER: Service stream error: $error");
        if (_sessionStartedCompleter != null &&
            !_sessionStartedCompleter!.isCompleted) {
          _sessionStartedCompleter!.completeError(error);
        }
      });

      _taskCompletedSubscription?.cancel();
      _taskCompletedSubscription = service.on('task_completed').listen((event) {
        debugPrint("PROVIDER: Task completed event received!");
        _isTaskCompleted = true;
        notifyListeners();
      }, onError: (error) {
        debugPrint("PROVIDER: Task completed stream error: $error");
      });

      service.on('progress_updated').listen((event) {
        // Bu dinleyici artık kullanılmıyor.
      });
    } catch (e) {
      debugPrint("PROVIDER: Error setting up service listeners: $e");
    }
  }

  void _handleServiceUpdate(Map<String, dynamic>? event) {
    if (event == null) return;
    try {
      final stateString = event['currentState'] as String?;
      if (stateString != null) {
        _currentState = PomodoroState.values.firstWhere(
          (e) => e.toString() == stateString,
          orElse: () => PomodoroState.stopped,
        );
      }
      _isPaused = event['isPaused'] as bool? ?? true;
      _remainingTimeInSession = event['remainingTimeInSession'] as int? ?? 0;
      _completedWorkSessions = event['completedWorkSessions'] as int? ?? 0;
      _totalActivityProgress =
          (event['totalActivityProgress'] as num?)?.toDouble() ?? 0.0;
      _currentSessionTotalDuration =
          event['currentSessionTotalDuration'] as int? ?? 0;

      if (_sessionStartedCompleter != null &&
          !_sessionStartedCompleter!.isCompleted) {
        _sessionStartedCompleter!.complete();
      }
      notifyListeners();
    } catch (e) {
      debugPrint("PROVIDER: Error parsing service update: $e");
      if (_sessionStartedCompleter != null &&
          !_sessionStartedCompleter!.isCompleted) {
        _sessionStartedCompleter!.completeError(e);
      }
    }
  }

  Future<void> _playSound(String soundPath) async {
    try {
      await _audioPlayer.play(AssetSource(soundPath));
    } catch (e) {
      debugPrint("PROVIDER: Error playing sound: $e");
    }
  }

  @override
  void dispose() {
    _isServiceListening = false;
    _serviceSubscription?.cancel();
    _soundSubscription?.cancel();
    _taskCompletedSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
