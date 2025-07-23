import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gunluk_planlayici/l10n/app_localizations.dart';

Future<bool> checkAndRequestNotificationPermission(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;

  var status = await Permission.notification.status;
  if (status.isGranted) {
    return true;
  }

  if (status.isDenied) {
    final result = await Permission.notification.request();
    return result.isGranted;
  }

  if (status.isPermanentlyDenied) {
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.permissionRequired),
          content: Text(l10n.permissionExplanation),
          actions: [
            TextButton(
              child: Text(l10n.cancel),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            TextButton(
              child: Text(l10n.openSettings),
              onPressed: () {
                openAppSettings();
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    }
    return false;
  }

  return false;
}
