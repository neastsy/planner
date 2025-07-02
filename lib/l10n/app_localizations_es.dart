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
}
