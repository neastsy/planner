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
  int _totalSecondsInThisRun = 0;
  int _workSecondsForSaving = 0;
  bool _targetReached = false;

  // --- Getter'lar ---
  PomodoroState get currentState => _currentState;
  bool get isSessionActive => _totalTargetMinutes > 0;
  bool get isPaused => _isPaused;
  int get remainingTimeInSession => _remainingTimeInSession;
  int get currentSessionTotalDuration => _currentSessionTotalDuration;
  int get completedWorkSessions => _completedWorkSessions;
  int get minutesToAdd => _workSecondsForSaving ~/ 60;
  bool get targetReached => _targetReached;
  int get totalTargetMinutes => _totalTargetMinutes;
  int get alreadyCompletedMinutes => _alreadyCompletedMinutes;

  // Toplam aktivite ilerlemesi (work + break sürelerini say)
  double get totalActivityProgress {
    if (_totalTargetMinutes <= 0) return 0.0;

    // Toplam geçen süre = önceki tamamlananlar + bu seanstaki toplam süre
    final totalElapsedSeconds =
        (_alreadyCompletedMinutes * 60) + _totalSecondsInThisRun;
    final totalTargetSeconds = _totalTargetMinutes * 60;

    return (totalElapsedSeconds / totalTargetSeconds).clamp(0.0, 1.0);
  }

  double get currentSessionProgress {
    // Eğer toplam seans süresi 0 veya daha az ise, ilerleme 0'dır.
    if (_currentSessionTotalDuration <= 0) return 0.0;

    // Mevcut seansta geçen süreyi hesapla
    final elapsedSecondsInSession =
        _currentSessionTotalDuration - _remainingTimeInSession;

    // İlerlemeyi (0.0 ile 1.0 arasında bir değer) döndür
    return (elapsedSecondsInSession / _currentSessionTotalDuration)
        .clamp(0.0, 1.0);
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
    _workSecondsForSaving = 0;
    _totalSecondsInThisRun = 0;
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
    _totalSecondsInThisRun = 0;
    _workSecondsForSaving = 0;
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

        // Her saniyede toplam geçen süreyi artır
        _totalSecondsInThisRun++;

        // Eğer çalışma durumundaysak, kaydedilecek süreyi de artır
        if (_currentState == PomodoroState.work) {
          _workSecondsForSaving++;
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

    // 1. ADIM: Önce biten seansın türüne göre GEREKLİ GÜNCELLEMELERİ YAP.
    if (_currentState == PomodoroState.work) {
      _completedWorkSessions++; // Son seans olsa bile, önce bunu say.
    }

    // 2. ADIM: ŞİMDİ HEDEF KONTROLÜNÜ YAP.
    final totalElapsedMinutes =
        ((_alreadyCompletedMinutes * 60) + _totalSecondsInThisRun) ~/ 60;
    if (totalElapsedMinutes >= _totalTargetMinutes && !_targetReached) {
      _targetReached = true;
      _playSound('sounds/target_sound.mp3');
      notifyListeners();
      return;
    }

    // 3. ADIM: Eğer hedefe ulaşılmadıysa, normal seans geçişini yap.
    if (_currentState == PomodoroState.work) {
      _playSound('sounds/end_sound.mp3');

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

  // Work session duration hesaplama
  void _determineNextWorkSessionDuration() {
    // Toplam geçen dakikayı hesapla
    final totalElapsedMinutes =
        ((_alreadyCompletedMinutes * 60) + _totalSecondsInThisRun) ~/ 60;

    // Kalan aktivite süresi (dakika cinsinden)
    final remainingMinutesForActivity =
        _totalTargetMinutes - totalElapsedMinutes;

    if (remainingMinutesForActivity <= 0) {
      _remainingTimeInSession = 0;
      _currentSessionTotalDuration = 0;
      return;
    }

    // Kalan süreyi saniyeye çevir
    final remainingSecondsForActivity = remainingMinutesForActivity * 60;
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
