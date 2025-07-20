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
  final int _workDuration = 25 * 60;
  final int _shortBreakDuration = 5 * 60;
  final int _longBreakDuration = 15 * 60;
  final int _sessionsBeforeLongBreak = 4;

  // --- Anlık Durum Değişkenleri ---
  PomodoroState _currentState = PomodoroState.work;
  bool _isPaused = true;
  int _remainingTimeInSession = 0;
  int _completedWorkSessions = 0;
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  int _totalTargetMinutes = 0;
  int _alreadyCompletedMinutes = 0;
  // YENİ: Sadece bu oturumda tamamlanan gerçek çalışma süresini saniye cinsinden tutar.
  int _elapsedWorkSecondsInSession = 0;
  VoidCallback? onTargetReached;

  // --- Getter'lar ---
  PomodoroState get currentState => _currentState;
  bool get isSessionActive => _totalTargetMinutes > 0;
  bool get isPaused => _isPaused;
  int get remainingTimeInSession => _remainingTimeInSession;
  int get completedWorkSessions => _completedWorkSessions;

  // DÜZELTME: Kaydedilecek olan, SADECE BU OTURUMDA tamamlanan süreyi verir.
  int get newCompletedWorkMinutes => _elapsedWorkSecondsInSession ~/ 60;

  // --- Ana Kontrol Metotları ---

  void startSession({
    required int totalActivityMinutes,
    required int alreadyCompletedMinutes,
    required VoidCallback onTargetReachedCallback,
  }) {
    if (isSessionActive) return; // Zaten aktif bir seans varsa başlatma

    _totalTargetMinutes = totalActivityMinutes;
    _alreadyCompletedMinutes = alreadyCompletedMinutes;
    _completedWorkSessions = 0;
    _elapsedWorkSecondsInSession = 0;
    _currentState = PomodoroState.work;
    onTargetReached = onTargetReachedCallback;

    _determineNextWorkSessionDuration();
    // Seansı başlatmıyoruz, sadece hazırlıyoruz. Kullanıcı play'e basınca başlayacak.
    notifyListeners();
  }

  void toggleTimer() {
    _isPaused = !_isPaused;
    if (_isPaused) {
      _timer?.cancel();
    } else {
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
    _elapsedWorkSecondsInSession = 0;
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
        // Sadece çalışma seanslarında geçen süreyi say
        if (_currentState == PomodoroState.work) {
          _elapsedWorkSecondsInSession++;
        }
      } else {
        _onSessionEnd();
      }
      notifyListeners();
    });
  }

  void _onSessionEnd() {
    if (_currentState == PomodoroState.work) {
      _completedWorkSessions++;
      _playSound('sounds/end_sound.mp3');

      final currentTotalCompleted =
          _alreadyCompletedMinutes + newCompletedWorkMinutes;
      if (currentTotalCompleted >= _totalTargetMinutes) {
        onTargetReached?.call(); // Hedefe ulaşıldı sinyalini gönder
        stop();
        return;
      }

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
  }

  void _determineNextWorkSessionDuration() {
    final currentTotalCompleted =
        _alreadyCompletedMinutes + newCompletedWorkMinutes;
    final remainingMinutesForActivity =
        _totalTargetMinutes - currentTotalCompleted;

    if (remainingMinutesForActivity <= 0) {
      stop();
      return;
    }

    _remainingTimeInSession = (remainingMinutesForActivity * 60) < _workDuration
        ? remainingMinutesForActivity * 60
        : _workDuration;
  }

  void playTargetReachedSound() {
    _playSound('sounds/target_sound.mp3');
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
