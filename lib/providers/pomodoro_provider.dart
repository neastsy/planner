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
  int _completedBreakSeconds = 0;
  bool _targetReached = false;

  // --- Getter'lar ---
  PomodoroState get currentState => _currentState;
  bool get isSessionActive => _totalTargetMinutes > 0;
  bool get isPaused => _isPaused;
  int get remainingTimeInSession => _remainingTimeInSession;
  int get currentSessionTotalDuration => _currentSessionTotalDuration;
  int get completedWorkSessions => _completedWorkSessions;
  int get minutesToAdd =>
      _workSecondsInThisRun ~/ 60; // Sadece work süresi kaydedilir
  bool get targetReached => _targetReached;

  // Toplam aktivite ilerlemesi (work + break sürelerini say)
  double get totalActivityProgress {
    if (_totalTargetMinutes <= 0) return 0.0;

    // Toplam geçen süre = önceki tamamlanan + bu run'daki work + tamamlanan break'ler
    final totalElapsedSeconds = (_alreadyCompletedMinutes * 60) +
        _workSecondsInThisRun +
        _completedBreakSeconds;

    // Eğer şu anda break'teyse, o anki break süresini de ekle
    int currentBreakSeconds = 0;
    if (!_isPaused && _currentState != PomodoroState.work) {
      int breakDuration = _currentState == PomodoroState.shortBreak
          ? _shortBreakDuration
          : _longBreakDuration;
      currentBreakSeconds = breakDuration - _remainingTimeInSession;
    }

    final totalElapsedWithCurrent = totalElapsedSeconds + currentBreakSeconds;
    final totalTargetSeconds = _totalTargetMinutes * 60;

    return (totalElapsedWithCurrent / totalTargetSeconds).clamp(0.0, 1.0);
  }

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
    _completedBreakSeconds = 0;
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
    _completedBreakSeconds = 0;
    _remainingTimeInSession = 0;
    _currentSessionTotalDuration = 0;
    _currentState = PomodoroState.work;
    _targetReached = false;
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTimeInSession > 0) {
        _remainingTimeInSession--;
        // Sadece work durumunda work saniyelerini artır
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

      // Hedef kontrolü - work + break dahil toplam süreyi kontrol et
      final totalElapsedSeconds = (_alreadyCompletedMinutes * 60) +
          _workSecondsInThisRun +
          _completedBreakSeconds;
      final totalElapsedMinutes = totalElapsedSeconds ~/ 60;

      if (totalElapsedMinutes >= _totalTargetMinutes && !_targetReached) {
        _targetReached = true;
        _playSound('sounds/target_sound.mp3');
        notifyListeners();
        return;
      }

      _playSound('sounds/end_sound.mp3');

      // Break durumu belirleme
      if (_completedWorkSessions % _sessionsBeforeLongBreak == 0) {
        _currentState = PomodoroState.longBreak;
        _remainingTimeInSession = _longBreakDuration;
      } else {
        _currentState = PomodoroState.shortBreak;
        _remainingTimeInSession = _shortBreakDuration;
      }
      _currentSessionTotalDuration = _remainingTimeInSession;
    } else {
      // Break bitiyor, work'e geçiyoruz
      // Tamamlanan break süresini kaydet
      if (_currentState == PomodoroState.shortBreak) {
        _completedBreakSeconds += _shortBreakDuration;
      } else if (_currentState == PomodoroState.longBreak) {
        _completedBreakSeconds += _longBreakDuration;
      }

      _playSound('sounds/start_sound.mp3');
      _currentState = PomodoroState.work;
      _determineNextWorkSessionDuration();
    }

    notifyListeners();
  }

  // Work session duration hesaplama
  void _determineNextWorkSessionDuration() {
    // Toplam geçen süreyi hesapla (work + break dahil)
    final totalElapsedSeconds = (_alreadyCompletedMinutes * 60) +
        _workSecondsInThisRun +
        _completedBreakSeconds;
    final totalElapsedMinutes = totalElapsedSeconds ~/ 60;

    // Kalan aktivite süresi (dakika cinsinden)
    final remainingMinutesForActivity =
        _totalTargetMinutes - totalElapsedMinutes;

    if (remainingMinutesForActivity <= 0) {
      _remainingTimeInSession = 0;
      _currentSessionTotalDuration = 0;
      return;
    }

    // Kalan süreyi saniye cinsinden hesapla
    final remainingSecondsForActivity = remainingMinutesForActivity * 60;

    // Eğer kalan aktivite süresi work süresinden az ise, kalan süre kadar çalış
    // Aksi halde normal work süresi kadar çalış
    if (remainingSecondsForActivity < _workDuration) {
      _remainingTimeInSession = remainingSecondsForActivity;
    } else {
      _remainingTimeInSession = _workDuration;
    }

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
