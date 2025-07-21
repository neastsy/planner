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
  final int _workDuration = 2 * 60;
  final int _shortBreakDuration = 1 * 60;
  final int _longBreakDuration = 15 * 60;
  final int _sessionsBeforeLongBreak = 4;

  // --- Durum Değişkenleri ---
  PomodoroState _currentState = PomodoroState.work;
  bool _isPaused = true;
  int _remainingTimeInSession = 0;
  int _currentSessionTotalDuration = 0;
  int _completedWorkSessions = 0;
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  int _totalTargetMinutes = 0;
  int _alreadyCompletedMinutes = 0;
  int _workSecondsInThisRun = 0;
  bool _targetReached = false;

  // --- Getter'lar ---
  PomodoroState get currentState => _currentState;
  bool get isSessionActive => _totalTargetMinutes > 0;
  bool get isPaused => _isPaused;
  int get remainingTimeInSession => _remainingTimeInSession;
  int get currentSessionTotalDuration => _currentSessionTotalDuration;
  int get completedWorkSessions => _completedWorkSessions;
  int get minutesToAdd => _workSecondsInThisRun ~/ 60;
  bool get targetReached => _targetReached;

  // --- Ana Kontrol Metotları ---

  void startSession({
    required int totalActivityMinutes,
    required int alreadyCompletedMinutes,
  }) {
    if (isSessionActive) return;

    _totalTargetMinutes = totalActivityMinutes;
    _alreadyCompletedMinutes = alreadyCompletedMinutes;
    _completedWorkSessions = 0;
    _workSecondsInThisRun = 0;
    _currentState = PomodoroState.work;
    _targetReached = false;

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
      if (!isSessionActive) return;
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
    _workSecondsInThisRun = 0;
    _remainingTimeInSession = 0;
    _currentSessionTotalDuration = 0;
    _currentState = PomodoroState.work;
    _targetReached = false; // Stop'ta da sıfırla
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTimeInSession > 0) {
        _remainingTimeInSession--;
        if (_currentState == PomodoroState.work) {
          _workSecondsInThisRun++;
        }
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

      final currentTotalCompleted = _alreadyCompletedMinutes + minutesToAdd;
      if (currentTotalCompleted >= _totalTargetMinutes && !_targetReached) {
        _targetReached = true;
        _playSound('sounds/target_sound.mp3'); // Sesi doğrudan çal
        notifyListeners();
        return;
      }

      _playSound('sounds/end_sound.mp3');
      if (_completedWorkSessions % _sessionsBeforeLongBreak == 0) {
        _currentState = PomodoroState.longBreak;
        _remainingTimeInSession = _longBreakDuration;
      } else {
        _currentState = PomodoroState.shortBreak;
        _remainingTimeInSession = _shortBreakDuration;
      }
    } else {
      _playSound('sounds/start_sound.mp3');
      _currentState = PomodoroState.work;
      _determineNextWorkSessionDuration();
    }
    _currentSessionTotalDuration = _remainingTimeInSession;
    notifyListeners();
  }

  void _determineNextWorkSessionDuration() {
    final currentTotalCompleted = _alreadyCompletedMinutes + minutesToAdd;
    final remainingMinutesForActivity =
        _totalTargetMinutes - currentTotalCompleted;

    if (remainingMinutesForActivity <= 0) {
      _remainingTimeInSession = 0;
      _currentSessionTotalDuration = 0;
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
