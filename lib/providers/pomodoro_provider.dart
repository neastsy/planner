import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:audioplayers/audioplayers.dart';

enum PomodoroState { stopped, work, shortBreak, longBreak }

class PomodoroProvider with ChangeNotifier {
  PomodoroState _currentState = PomodoroState.stopped;
  bool _isPaused = true;
  int _remainingTimeInSession = 0;
  int _completedWorkSessions = 0;
  double _totalActivityProgress = 0.0;
  int _currentSessionTotalDuration = 0;
  bool _isServiceListening = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Session yönetimi için
  Completer<void>? _sessionStartedCompleter;
  StreamSubscription? _serviceSubscription;
  StreamSubscription? _soundSubscription;

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

  double get currentSessionProgress => 0.0;

  PomodoroProvider() {
    _initializeServiceConnection();
  }

  void _initializeServiceConnection() {
    if (!_isServiceListening) {
      _listenToService();
      _isServiceListening = true;
    }
    // İlk durum kontrolü
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getStatus();
    });
  }

  void getStatus() {
    try {
      final service = FlutterBackgroundService();
      service.invoke('get_status');
    } catch (e) {
      print("PROVIDER: Error getting status: $e");
    }
  }

  Future<void> start({
    required String activityId,
    required String dayKey,
    required String dbPath,
    required int totalActivityMinutes,
    required int alreadyCompletedMinutes,
  }) async {
    try {
      final service = FlutterBackgroundService();

      // Completer oluştur ve loading durumunu güncelle
      _sessionStartedCompleter = Completer<void>();
      notifyListeners();

      final isRunning = await service.isRunning();
      if (!isRunning) {
        await service.startService();
        // Service başlamasını bekle
        await Future.delayed(const Duration(milliseconds: 500));
      }

      service.invoke('start', {
        'activityId': activityId,
        'dayKey': dayKey,
        'dbPath': dbPath,
        'totalActivityMinutes': totalActivityMinutes,
        'alreadyCompletedMinutes': alreadyCompletedMinutes,
      });

      // İlk update gelene kadar bekle
      return _sessionStartedCompleter!.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Service başlatma timeout');
        },
      );
    } catch (e) {
      // Hata durumunda completer'ı temizle
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
      _resetState();
    } catch (e) {
      print("PROVIDER: Error stopping service: $e");
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
      print("PROVIDER: Error toggling pause: $e");
    }
  }

  void _listenToService() {
    try {
      final service = FlutterBackgroundService();

      // Ses çalma olayını dinle
      _soundSubscription?.cancel();
      _soundSubscription = service.on('play_sound').listen((event) {
        if (event != null && event['sound'] is String) {
          _playSound(event['sound']);
        }
      }, onError: (error) {
        print("PROVIDER: Sound stream error: $error");
      });

      // Service güncellemelerini dinle
      _serviceSubscription?.cancel();
      _serviceSubscription = service.on('update').listen((event) {
        _handleServiceUpdate(event);
      }, onError: (error) {
        print("PROVIDER: Service stream error: $error");
        if (_sessionStartedCompleter != null &&
            !_sessionStartedCompleter!.isCompleted) {
          _sessionStartedCompleter!.completeError(error);
        }
      });

      // İlerleme güncellemelerini dinle
      service.on('progress_updated').listen((event) {
        // Progress güncellendiğinde bir şey yapabilirsiniz
      });
    } catch (e) {
      print("PROVIDER: Error setting up service listeners: $e");
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

      final progressValue = event['totalActivityProgress'];
      _totalActivityProgress =
          (progressValue is num) ? progressValue.toDouble() : 0.0;
      _currentSessionTotalDuration =
          event['currentSessionTotalDuration'] as int? ?? 0;

      // İlk update geldiğinde completer'ı tamamla
      if (_sessionStartedCompleter != null &&
          !_sessionStartedCompleter!.isCompleted) {
        _sessionStartedCompleter!.complete();
      }

      notifyListeners();
    } catch (e) {
      print("PROVIDER: Error parsing service update: $e");
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
      print("PROVIDER: Error playing sound: $e");
    }
  }

  @override
  void dispose() {
    _isServiceListening = false;
    _serviceSubscription?.cancel();
    _soundSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
