// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Planificador de Actividades';

  @override
  String get days_PZT => 'LUN';

  @override
  String get days_SAL => 'MAR';

  @override
  String get days_CAR => 'MIÉ';

  @override
  String get days_PER => 'JUE';

  @override
  String get days_CUM => 'VIE';

  @override
  String get days_CMT => 'SÁB';

  @override
  String get days_PAZ => 'DOM';

  @override
  String get addNewActivity => 'Añadir Actividad';

  @override
  String get activityList => 'Lista de actividades';

  @override
  String get noActivityToday => 'Aún no se han añadido actividades para hoy.';

  @override
  String get editActivity => 'Editar actividad';

  @override
  String get activityName => 'Nombre de la actividad';

  @override
  String get activityNameHint =>
      'Por favor, introduzca un nombre de actividad.';

  @override
  String get startTime => 'Hora de inicio';

  @override
  String get endTime => 'Hora de finalización';

  @override
  String get selectTime => 'Seleccionar';

  @override
  String get chooseColor => 'Elegir color';

  @override
  String get add => 'Añadir';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get deleteActivityTitle => 'Eliminar actividad';

  @override
  String get deleteActivityContent =>
      '¿Está seguro de que desea eliminar esta actividad?';

  @override
  String get delete => 'Eliminar';

  @override
  String get overlappingActivityTitle => 'Actividad superpuesta';

  @override
  String get overlappingActivityContent =>
      'Hay otra actividad en este rango de tiempo. ¿Desea continuar de todos modos?';

  @override
  String get continueAction => 'Continuar';

  @override
  String get errorSelectAllTimes => 'Por favor, seleccione todas las horas.';

  @override
  String get timePickerSet => 'ACEPTAR';

  @override
  String get timePickerSelect => 'SELECCIONAR HORA';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get settings => 'Ajustes';

  @override
  String get theme => 'Tema';

  @override
  String get lightTheme => 'Tema claro';

  @override
  String get darkTheme => 'Tema oscuro';

  @override
  String get notes => 'Notas (Opcional)';

  @override
  String get copyDay => 'Copiar día';

  @override
  String get copy => 'Copiar';

  @override
  String copyFromTo(String dayName) {
    return 'Copiar todas las actividades de $dayName a:';
  }

  @override
  String get targetDayNotEmptyTitle => 'Día de destino no vacío';

  @override
  String targetDayNotEmptyContent(String dayName) {
    return 'El día \'$dayName\' ya tiene actividades. ¿Está seguro de que desea agregar las nuevas actividades?';
  }

  @override
  String get deleteAll => 'Eliminar todo';

  @override
  String get deleteAllActivitiesTitle => 'Eliminar todas las actividades';

  @override
  String deleteAllActivitiesContent(String dayName) {
    return '¿Está seguro de que desea eliminar todas las actividades para el $dayName?';
  }

  @override
  String get notificationSettings => 'Ajustes de notificación';

  @override
  String get notificationsOff => 'Notificaciones desactivadas';

  @override
  String get notifyOnTime => 'Notificar a tiempo';

  @override
  String get notify5MinBefore => '5 minutos antes';

  @override
  String get notify15MinBefore => '15 minutos antes';

  @override
  String notificationBody(String activityName, String time) {
    return 'Tu actividad \'$activityName\' está programada para comenzar a las $time.';
  }

  @override
  String dayCopied(Object fromDay, Object toDay) {
    return 'Copiado de $fromDay a $toDay.';
  }

  @override
  String allDeleted(Object dayName) {
    return 'Todas las actividades de $dayName han sido eliminadas.';
  }

  @override
  String get copyMode => 'Modo de copia';

  @override
  String get copyModeMerge => 'Combinar con actividades existentes';

  @override
  String get copyModeOverwrite => 'Sobrescribir actividades existentes';

  @override
  String get overwriteConfirmationTitle => 'Confirmar Sobrescritura';

  @override
  String overwriteConfirmationContent(Object dayName) {
    return 'Esto eliminará todas las actividades existentes en \'$dayName\' y las reemplazará. ¿Está seguro?';
  }

  @override
  String get overwrite => 'Sobrescribir';

  @override
  String get pendingNotificationsTitle => 'Notificaciones Pendientes';

  @override
  String get noPendingNotifications => 'No hay notificaciones pendientes.';

  @override
  String get noTitle => 'Sin Título';

  @override
  String get noBody => 'Sin Cuerpo';

  @override
  String get cancelAll => 'Cancelar Todas';

  @override
  String get close => 'Cerrar';

  @override
  String get allNotificationsCancelled =>
      'Todas las notificaciones pendientes han sido canceladas.';

  @override
  String get viewPendingNotifications => 'Ver Notificaciones Pendientes';

  @override
  String get unknown => 'Desconocido';

  @override
  String get activityTime => 'Hora de la Actividad';

  @override
  String get notificationType => 'Tipo de Notificación';

  @override
  String get scheduledFor => 'Programado para';

  @override
  String get editTemplate => 'Editar Plantilla';

  @override
  String get addTemplate => 'Añadir Nueva Plantilla';

  @override
  String get templateName => 'Nombre de la Plantilla';

  @override
  String get templateNameHint =>
      'Por favor, introduzca un nombre para la plantilla.';

  @override
  String get durationInMinutes => 'Duración (en minutos)';

  @override
  String get durationHint => 'Por favor, introduzca una duración.';

  @override
  String get durationInvalidHint =>
      'Por favor, introduzca un número válido y positivo.';

  @override
  String get templateManagerTitle => 'Gestor de Plantillas';

  @override
  String get noTemplates =>
      'Aún no se han creado plantillas. Toque \'+\' para añadir una.';

  @override
  String durationLabel(Object minutes) {
    return 'Duración: $minutes min';
  }

  @override
  String get manageTemplates => 'Gestionar Plantillas de Actividad';

  @override
  String get deleteTemplateTitle => 'Eliminar Plantilla';

  @override
  String deleteTemplateContent(Object templateName) {
    return '¿Está seguro de que desea eliminar la plantilla \'$templateName\'?';
  }

  @override
  String get durationMaxHint =>
      'La duración no puede exceder los 1440 minutos (24 horas).';

  @override
  String get addFromTemplate => 'Desde Plantilla';

  @override
  String get noTemplatesToUse =>
      'No hay plantillas disponibles. Por favor, cree una en los ajustes.';

  @override
  String get selectTemplate => 'Seleccionar una Plantilla';

  @override
  String get tagsLabel => 'Etiquetas (separadas por comas)';

  @override
  String get tagsHint => 'ej. trabajo, deporte, personal';

  @override
  String get statisticsPageTitle => 'Estadísticas';

  @override
  String get statisticsButtonTooltip => 'Ver estadísticas';

  @override
  String get tagDistributionTitle => 'Distribución del tiempo por etiqueta';

  @override
  String get dailyActivityTitle => 'Tiempo total de actividad por día';

  @override
  String get noDataForStatistics =>
      'No hay datos de actividad para mostrar estadísticas. ¡Empieza a planificar tus días!';

  @override
  String get untagged => 'Sin etiqueta';

  @override
  String todayIs(String dayName) {
    return 'Hoy es $dayName';
  }

  @override
  String get fullDay_monday => 'Lunes';

  @override
  String get fullDay_tuesday => 'Martes';

  @override
  String get fullDay_wednesday => 'Miércoles';

  @override
  String get fullDay_thursday => 'Jueves';

  @override
  String get fullDay_friday => 'Viernes';

  @override
  String get fullDay_saturday => 'Sábado';

  @override
  String get fullDay_sunday => 'Domingo';

  @override
  String get repeatNotificationWeekly => 'Repetir semanalmente';

  @override
  String get recurringNotificationHint => 'Se repite a la hora de la actividad';

  @override
  String get error_appCouldNotStart => 'No se pudo iniciar la aplicación';

  @override
  String get error_unexpectedError =>
      'Ocurrió un error inesperado. Por favor, intente reiniciar la aplicación.';

  @override
  String get error_restart => 'Reiniciar';

  @override
  String get error_detailsForDeveloper =>
      'Detalles del error (para el desarrollador):';

  @override
  String get pomodoro_startFocusSession => 'Iniciar sesión de enfoque';

  @override
  String get pomodoro_sessionStateWork => 'Trabajo';

  @override
  String get pomodoro_sessionStateShortBreak => 'Descanso corto';

  @override
  String get pomodoro_sessionStateLongBreak => 'Descanso largo';

  @override
  String get pomodoro_sessionStatePaused => 'En pausa';

  @override
  String pomodoro_completedSessions(int count) {
    return 'Sesiones completadas: $count';
  }

  @override
  String get pomodoro_endSessionTitle => 'Finalizar sesión';

  @override
  String pomodoro_endSessionContent(
      Object sessionCount, Object minutes, Object activityName) {
    return '¿Añadir $sessionCount sesión(es) de Pomodoro ($minutes minutos) a la actividad \'$activityName\'?';
  }

  @override
  String get pomodoro_dontSave => 'No guardar';

  @override
  String get pomodoro_saveAndExit => 'Sí, añadir';

  @override
  String get tapPlusToStart =>
      'Toque el botón \'+\' para comenzar a planificar.';

  @override
  String get pomodoro_resetProgress => 'Restablecer progreso';

  @override
  String get pomodoro_continueSession => 'Continuar sesión';

  @override
  String get pomodoro_activityCompleted =>
      '¡Esta actividad ya está completada!';

  @override
  String targetReached(Object activityName) {
    return '¡Objetivo alcanzado! Ha completado la actividad \'$activityName\'.';
  }

  @override
  String pomodoro_completedMinutes(Object completed, Object total) {
    return '$completed / $total min completados';
  }

  @override
  String pomodoro_confirmSaveContent(Object activityName, Object minutes) {
    return '¿Añadir los $minutes minutos que completó en esta sesión a la actividad \'$activityName\'?';
  }

  @override
  String get permissionRequired => 'Permiso requerido';

  @override
  String get permissionExplanation =>
      'Para usar las notificaciones y el temporizador Pomodoro, debe habilitar los permisos de notificación en la configuración de la aplicación.';

  @override
  String get openSettings => 'Abrir configuración';

  @override
  String get pomodoroPermissionRequired =>
      'Se requiere permiso de notificación para que el temporizador Pomodoro funcione.';

  @override
  String get themeColor => 'Color del tema';

  @override
  String get today => 'Hoy';

  @override
  String get pomodoro_resetConfirmationTitle => 'Confirmar reinicio';

  @override
  String get pomodoro_resetConfirmationContent =>
      '¿Está seguro de que desea reiniciar el progreso de Pomodoro para esta actividad? Esta acción no se puede deshacer.';
}
