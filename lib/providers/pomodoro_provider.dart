import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

enum PomodoroState {
  work,
  shortBreak,
  longBreak,
}

class PomodoroProvider with ChangeNotifier {
  // --- Ayarlar ---
  final int _workDuration = 2 * 60; // Test için 2 dakika
  final int _shortBreakDuration = 1 * 60; // Test için 1 dakika
  final int _longBreakDuration = 15 * 60;
  final int _sessionsBeforeLongBreak = 4;

  // --- Anlık Durum Değişkenleri ---
  PomodoroState _currentState = PomodoroState.work;
  bool _isPaused = true;
  int _remainingTimeInSession = 0;
  int _currentSessionTotalDuration = 0;
  int _completedWorkSessions = 0;
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  int _totalTargetMinutes = 0;
  int _alreadyCompletedMinutes = 0;
  VoidCallback? onTargetReached;

  // --- Getter'lar ---
  PomodoroState get currentState => _currentState;
  bool get isSessionActive => _totalTargetMinutes > 0;
  bool get isPaused => _isPaused;
  int get remainingTimeInSession => _remainingTimeInSession;
  int get currentSessionTotalDuration => _currentSessionTotalDuration;
  int get completedWorkSessions => _completedWorkSessions;

  // Kaydedilecek süre, molaları da içerir.
  int get newCompletedWorkMinutes {
    if (_completedWorkSessions == 0) return 0;

    final longBreaks = _completedWorkSessions ~/ _sessionsBeforeLongBreak;
    final shortBreaks = _completedWorkSessions - 1 - longBreaks;

    final workMinutes = _completedWorkSessions * (_workDuration ~/ 60);
    final shortBreakMinutes = shortBreaks * (_shortBreakDuration ~/ 60);
    final longBreakMinutes = longBreaks * (_longBreakDuration ~/ 60);

    // Not: Bu, sadece TAMAMLANMIŞ seansları sayar.
    return workMinutes + shortBreakMinutes + longBreakMinutes;
  }

  // --- Ana Kontrol Metotları ---

  void startSession({
    required int totalActivityMinutes,
    required int alreadyCompletedMinutes,
    required VoidCallback onTargetReachedCallback,
  }) {
    if (isSessionActive) return;

    _totalTargetMinutes = totalActivityMinutes;
    _alreadyCompletedMinutes = alreadyCompletedMinutes;
    _completedWorkSessions = 0;
    _currentState = PomodoroState.work;
    onTargetReached = onTargetReachedCallback;

    _determineNextWorkSessionDuration();
    notifyListeners();
  }

  void toggleTimer() {
    if (_isPaused && _remainingTimeInSession <= 0 && isSessionActive) {
      return;
    }
    _isPaused = !_isPaused;
    if (_isPaused) {
      _timer?.cancel();
    } else {
      if (!isSessionActive) {
        // Eğer seans bitmişse ve play'e basılırsa
        return;
      }
      _startTimer();
    }
    notifyListeners();
  }

  void stop() {
    _timer?.cancel();
    _isPaused = true;
    _totalTargetMinutes = 0;
    _alreadyCompletedMinutes = 0;
    _completedWorkSessions = 0;
    _remainingTimeInSession = 0;
    _currentState = PomodoroState.work;
    notifyListeners();
  }

  // --- İç Mantık Metotları ---

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTimeInSession > 0) {
        _remainingTimeInSession--;
      } else {
        _onSessionEnd();
      }
      notifyListeners();
    });
  }

  void _onSessionEnd() {
    _timer?.cancel();
    _isPaused = true;

    if (_currentState == PomodoroState.work) {
      _completedWorkSessions++;
      _playSound('sounds/end_sound.mp3');
      _alreadyCompletedMinutes += _workDuration ~/ 60;
      if (_completedWorkSessions % _sessionsBeforeLongBreak != 0) {
        _alreadyCompletedMinutes += _shortBreakDuration ~/ 60;
      } else {
        _alreadyCompletedMinutes += _longBreakDuration ~/ 60;
      }

      if (_alreadyCompletedMinutes >= _totalTargetMinutes) {
        onTargetReached?.call();
        notifyListeners();
        return;
      }

      if (_completedWorkSessions % _sessionsBeforeLongBreak == 0) {
        _currentState = PomodoroState.longBreak;
        _remainingTimeInSession = _longBreakDuration;
      } else {
        _currentState = PomodoroState.shortBreak;
        _remainingTimeInSession = _shortBreakDuration;
      }
      _currentSessionTotalDuration = _remainingTimeInSession;
    } else {
      _playSound('sounds/start_sound.mp3');
      _currentState = PomodoroState.work;
      _determineNextWorkSessionDuration();
    }
    notifyListeners();
  }

  void _determineNextWorkSessionDuration() {
    final remainingMinutesForActivity =
        _totalTargetMinutes - _alreadyCompletedMinutes;

    if (remainingMinutesForActivity <= 0) {
      _remainingTimeInSession = 0;
      return;
    }

    _remainingTimeInSession = (remainingMinutesForActivity * 60) < _workDuration
        ? remainingMinutesForActivity * 60
        : _workDuration;

    _currentSessionTotalDuration = _remainingTimeInSession;
  }

  Future<void> _playSound(String soundPath) async {
    try {
      await _audioPlayer.play(AssetSource(soundPath));
    } catch (e) {
      debugPrint("Error playing sound: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
