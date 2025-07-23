import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gunluk_planlayici/l10n/app_localizations.dart';
import '../providers/pomodoro_provider.dart';

class FocusScreen extends StatefulWidget {
  final String activityId;
  final String activityName;

  const FocusScreen({
    super.key,
    required this.activityId,
    required this.activityName,
  });

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PomodoroProvider>().getStatus();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // App foreground'a döndüğünde status'u güncelle
        if (mounted) {
          context.read<PomodoroProvider>().getStatus();
        }
        break;
      case AppLifecycleState.paused:
        // App background'a giderken bir şey yapmanız gerekiyorsa
        break;
      default:
        break;
    }
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds / 60).floor().toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String _getLocalizedStateText(BuildContext context, PomodoroState state) {
    final l10n = AppLocalizations.of(context)!;
    switch (state) {
      case PomodoroState.work:
        return l10n.pomodoro_sessionStateWork;
      case PomodoroState.shortBreak:
        return l10n.pomodoro_sessionStateShortBreak;
      case PomodoroState.longBreak:
        return l10n.pomodoro_sessionStateLongBreak;
      case PomodoroState.stopped:
        return "Durduruldu";
    }
  }

  Future<void> _showExitConfirmationDialog(
      BuildContext context, PomodoroProvider pomodoroProvider) async {
    final l10n = AppLocalizations.of(context)!;

    // Servis zaten durmuşsa (örneğin görev tamamlandığı için), sormadan çık.
    if (!pomodoroProvider.isSessionActive) {
      if (mounted) Navigator.of(context).pop();
      return;
    }

    final bool? shouldExit = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.pomodoro_endSessionTitle),
        content: Text(
            "Odaklanma seansını bitirmek istediğinize emin misiniz? Arka planda kaydedilen ilerleme korunacaktır."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text("Evet, Bitir"),
          ),
        ],
      ),
    );

    if (shouldExit == true && context.mounted) {
      pomodoroProvider.stop();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<PomodoroProvider>(
      builder: (context, provider, child) {
        // YENİ VE DAHA TEMİZ KONTROL
        if (provider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // ===================================================================

        final remainingTime = provider.remainingTimeInSession;
        final progress = provider.totalActivityProgress;

        return Scaffold(
          appBar: AppBar(
            // DÜZELTME: widget.activityName kullanılıyor.
            title: Text(widget.activityName),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => _showExitConfirmationDialog(context, provider),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  height: 250,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        // DÜZELTME: Seans ilerlemesini daha doğru hesaplayalım.
                        // Bu, servisten gelen toplam ilerlemedir.
                        value: progress,
                        strokeWidth: 12,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary),
                      ),
                      Center(
                        child: Text(
                          _formatTime(remainingTime),
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  _getLocalizedStateText(context, provider.currentState),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.pomodoro_completedSessions(
                      provider.completedWorkSessions),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 80,
                      icon: Icon(
                        provider.isPaused
                            ? Icons.play_arrow_rounded
                            : Icons.pause_rounded,
                      ),
                      onPressed: () {
                        provider.togglePause();
                      },
                    ),
                    const SizedBox(width: 40),
                    IconButton(
                      iconSize: 50,
                      icon: const Icon(Icons.stop_rounded),
                      onPressed: () {
                        _showExitConfirmationDialog(context, provider);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
