import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

enum PomodoroState {
  stopped,
  work,
  shortBreak,
  longBreak,
}

class PomodoroProvider with ChangeNotifier {
  bool _isLoading = true;
  PomodoroState _currentState = PomodoroState.stopped;
  bool _isPaused = true;
  int _remainingTimeInSession = 0;
  int _completedWorkSessions = 0;
  double _totalActivityProgress = 0.0;

  // YENİ: Servis dinleyicisinin sadece bir kez kurulduğundan emin olmak için.
  bool _isServiceListening = false;
  bool get isLoading => _isLoading;
  PomodoroState get currentState => _currentState;
  bool get isSessionActive => _currentState != PomodoroState.stopped;
  bool get isPaused => _isPaused;
  int get remainingTimeInSession => _remainingTimeInSession;
  int get completedWorkSessions => _completedWorkSessions;
  double get totalActivityProgress => _totalActivityProgress;

  // Bu getter'ı daha sonra servisten gelen veriyle daha akıllı hale getirebiliriz.
  double get currentSessionProgress => 0.0;

  PomodoroProvider() {
    // YENİ: Daha sağlam bir başlatma metodu.
    _initializeServiceConnection();
  }

  // YENİ: Servis bağlantısını başlatan ve yöneten metot.
  void _initializeServiceConnection() {
    if (!_isServiceListening) {
      _listenToService();
      _isServiceListening = true;
    }
    getStatus();
  }

  void getStatus() {
    final service = FlutterBackgroundService();
    service.invoke('get_status');
  }

  Future<void> start({
    required String activityId,
    required String dayKey,
    required String dbPath,
    required int totalActivityMinutes,
    required int alreadyCompletedMinutes,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final service = FlutterBackgroundService();
      final isRunning = await service.isRunning();

      if (!isRunning) {
        await service.startService();

        // ✅ DÜZELTME: Servisin tam başlaması için kısa bekleme
        await Future.delayed(const Duration(milliseconds: 500));

        // ✅ DÜZELTME: Servisin gerçekten başladığını kontrol et
        int attempts = 0;
        while (attempts < 5 && !(await service.isRunning())) {
          await Future.delayed(const Duration(milliseconds: 200));
          attempts++;
        }
      }

      // Servis parametrelerini gönder
      service.invoke('start', {
        'activityId': activityId,
        'dayKey': dayKey,
        'dbPath': dbPath,
        'totalActivityMinutes': totalActivityMinutes,
        'alreadyCompletedMinutes': alreadyCompletedMinutes,
      });

      // ✅ DÜZELTME: Servis başladıktan sonra status güncellemesi al
      await Future.delayed(const Duration(milliseconds: 300));
      service.invoke('get_status');
    } catch (e) {
      print("PROVIDER: Error starting service: $e");
      _isLoading = false;
      notifyListeners();
    }
  }

  void stop() {
    final service = FlutterBackgroundService();
    service.invoke('stop');
    _currentState = PomodoroState.stopped;
    notifyListeners();
  }

  void togglePause() {
    final service = FlutterBackgroundService();
    service.invoke('togglePause');
    _isPaused = !_isPaused;
    notifyListeners();
  }

  void _listenToService() {
    final service = FlutterBackgroundService();
    service.on('update').listen((event) {
      // ✅ DÜZELTME: Loading state'i burada güncelle
      if (_isLoading) {
        _isLoading = false;
      }

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

        // ✅ DÜZELTME: Debug için log ekle
        print(
            "PROVIDER: Service update - State: $_currentState, Paused: $_isPaused, Time: $_remainingTimeInSession");

        notifyListeners();
      } catch (e) {
        print("PROVIDER: Error parsing service update: $e");
        _currentState = PomodoroState.stopped;
        _isPaused = true;
        _isLoading = false; // ✅ DÜZELTME: Hata durumunda loading'i kapat
        notifyListeners();
      }
    }, onError: (error) {
      print("PROVIDER: Service stream error: $error");
      _currentState = PomodoroState.stopped;
      _isPaused = true;
      _isLoading = false; // ✅ DÜZELTME: Hata durumunda loading'i kapat
      notifyListeners();
    });
  }

  // YENİ: Dispose metodu artık daha anlamlı.
  @override
  void dispose() {
    // Bu, provider yok edildiğinde dinleyicinin tekrar kurulmasını sağlar.
    _isServiceListening = false;
    super.dispose();
  }
}
