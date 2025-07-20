import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

enum PomodoroState {
  initial,
  work,
  shortBreak,
  longBreak,
}

class PomodoroProvider with ChangeNotifier {
  final int _workDuration = 2 * 60;
  final int _shortBreakDuration = 1 * 60;
  final int _longBreakDuration = 15 * 60;
  final int _sessionsBeforeLongBreak = 4;

  PomodoroState _currentState = PomodoroState.initial;
  bool _isPaused = true;
  int _remainingTime = 25 * 60;
  int _completedSessions = 0;
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  int _currentWorkDuration = 25 * 60;

  PomodoroState get currentState => _currentState;
  bool get isPaused => _isPaused;
  int get remainingTime => _remainingTime;
  int get completedSessions => _completedSessions;
  int get workDuration => _workDuration;
  int get currentWorkDuration => _currentWorkDuration;

  VoidCallback? onTargetReached;

  void playTargetReachedSound() {
    _playSound('sounds/end_sound.mp3');
  }

  void startCustomSession({
    required int durationInSeconds,
    required int totalActivityDuration,
    required int alreadyCompletedDuration,
    required VoidCallback onTargetReachedCallback,
  }) {
    _isPaused = false;
    _currentState = PomodoroState.work;
    _currentWorkDuration = durationInSeconds;
    _remainingTime = durationInSeconds;
    onTargetReached = onTargetReachedCallback;
    _startTimer(
      totalActivityDuration: totalActivityDuration,
      alreadyCompletedDuration: alreadyCompletedDuration,
    );
    notifyListeners();
  }

  void toggleTimer() {
    _isPaused = !_isPaused;
    if (_isPaused) {
      _timer?.cancel();
    } else {
      if (_currentState == PomodoroState.initial) {
        _startWorkSession();
      } else {
        _startTimer();
      }
    }
    notifyListeners();
  }

  void stop() {
    _timer?.cancel();
    _currentState = PomodoroState.initial;
    _isPaused = true;
    _currentWorkDuration = _workDuration;
    _remainingTime = _workDuration;
    _completedSessions = 0;
    notifyListeners();
  }

  void _startWorkSession() {
    _currentState = PomodoroState.work;
    _currentWorkDuration = _workDuration;
    _remainingTime = _workDuration;
    _startTimer();
  }

  void _startTimer(
      {int? totalActivityDuration, int? alreadyCompletedDuration}) {
    bool targetReachedNotified = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
        if (totalActivityDuration != null &&
            alreadyCompletedDuration != null &&
            !targetReachedNotified) {
          final elapsedSeconds = _currentWorkDuration - _remainingTime;
          final currentTotalCompleted =
              (alreadyCompletedDuration * 60) + elapsedSeconds;

          if (currentTotalCompleted >= (totalActivityDuration * 60)) {
            onTargetReached?.call();
            targetReachedNotified = true;
          }
        }
      } else {
        _timer?.cancel();
        _isPaused = true;
        _onSessionEnd();
      }
      notifyListeners();
    });
  }

  void _onSessionEnd() {
    if (_currentState == PomodoroState.work) {
      _completedSessions++;
      _playSound('sounds/end_sound.mp3');
      if (_completedSessions % _sessionsBeforeLongBreak == 0) {
        _currentState = PomodoroState.longBreak;
        _remainingTime = _longBreakDuration;
      } else {
        _currentState = PomodoroState.shortBreak;
        _remainingTime = _shortBreakDuration;
      }
    } else {
      _playSound('sounds/start_sound.mp3');
      _currentState = PomodoroState.initial;
      _remainingTime = _workDuration;
    }
    notifyListeners();
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
