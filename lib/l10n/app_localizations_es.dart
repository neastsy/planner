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
  String get errorStartEndTimeSame =>
      'La hora de inicio y fin no pueden ser la misma.';

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
}
