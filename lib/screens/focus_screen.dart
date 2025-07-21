import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gunluk_planlayici/l10n/app_localizations.dart';
import '../providers/pomodoro_provider.dart';
import '../providers/activity_provider.dart';

class FocusScreen extends StatelessWidget {
  final String activityId;
  final String activityName;

  const FocusScreen({
    super.key,
    required this.activityId,
    required this.activityName,
  });

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
    }
  }

  Future<void> _showExitConfirmationDialog(
      BuildContext context, PomodoroProvider pomodoroProvider) async {
    final l10n = AppLocalizations.of(context)!;
    final minutesToAdd = pomodoroProvider.minutesToAdd;

    if (minutesToAdd == 0) {
      pomodoroProvider.stop();
      Navigator.of(context).pop();
      return;
    }

    final bool? shouldSave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.pomodoro_endSessionTitle),
        content: Text(l10n.pomodoro_confirmSaveContent(
            activityName, minutesToAdd.toString())),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.pomodoro_dontSave),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.pomodoro_saveAndExit),
          ),
        ],
      ),
    );

    if (context.mounted) {
      if (shouldSave == true) {
        context
            .read<ActivityProvider>()
            .addCompletedDuration(activityId, minutesToAdd);
      }
      // Provider'ı en son sıfırla
      pomodoroProvider.stop();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<PomodoroProvider>(
      builder: (context, provider, child) {
        final remainingTime = provider.remainingTimeInSession;

        // Toplam aktivite ilerlemesini kullan (work + break dahil)
        final progress = provider.totalActivityProgress;

        // Debug için konsola yazdır
        debugPrint(
            'Progress: $progress, Remaining: $remainingTime, State: ${provider.currentState}');

        return Scaffold(
          appBar: AppBar(
            title: Text(activityName),
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
                        value: progress > 0
                            ? progress
                            : null, // null ise animasyonlu progress
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
                        provider.toggleTimer();
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
