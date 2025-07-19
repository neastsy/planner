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
  final int _workDuration = 25 * 60;
  final int _shortBreakDuration = 5 * 60;
  final int _longBreakDuration = 15 * 60;
  final int _sessionsBeforeLongBreak = 4;

  PomodoroState _currentState = PomodoroState.initial;
  bool _isPaused = true;
  int _remainingTime = 25 * 60;
  int _completedSessions = 0;
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  PomodoroState get currentState => _currentState;
  bool get isPaused => _isPaused;
  int get remainingTime => _remainingTime;
  int get completedSessions => _completedSessions;
  int get workDuration => _workDuration;

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
    _remainingTime = _workDuration;
    _completedSessions = 0;
    notifyListeners();
  }

  void _startWorkSession() {
    _currentState = PomodoroState.work;
    _remainingTime = _workDuration;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
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
