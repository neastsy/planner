// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'مخطط الأنشطة';

  @override
  String get days_PZT => 'إثن';

  @override
  String get days_SAL => 'ثلا';

  @override
  String get days_CAR => 'أرب';

  @override
  String get days_PER => 'خمي';

  @override
  String get days_CUM => 'جمع';

  @override
  String get days_CMT => 'سبت';

  @override
  String get days_PAZ => 'أحد';

  @override
  String get addNewActivity => 'إضافة نشاط';

  @override
  String get activityList => 'قائمة الأنشطة';

  @override
  String get noActivityToday => 'لم تتم إضافة أي أنشطة لهذا اليوم بعد.';

  @override
  String get editActivity => 'تعديل النشاط';

  @override
  String get activityName => 'اسم النشاط';

  @override
  String get activityNameHint => 'الرجاء إدخال اسم النشاط.';

  @override
  String get startTime => 'وقت البدء';

  @override
  String get endTime => 'وقت الانتهاء';

  @override
  String get selectTime => 'تحديد';

  @override
  String get chooseColor => 'اختر لونًا';

  @override
  String get add => 'إضافة';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get deleteActivityTitle => 'حذف النشاط';

  @override
  String get deleteActivityContent => 'هل أنت متأكد أنك تريد حذف هذا النشاط؟';

  @override
  String get delete => 'حذف';

  @override
  String get overlappingActivityTitle => 'نشاط متداخل';

  @override
  String get overlappingActivityContent =>
      'يوجد نشاط آخر في هذا النطاق الزمني. هل تريد المتابعة على أي حال؟';

  @override
  String get continueAction => 'متابعة';

  @override
  String get errorSelectAllTimes => 'الرجاء تحديد جميع الأوقات.';

  @override
  String get errorStartEndTimeSame =>
      'لا يمكن أن يكون وقت البدء والانتهاء متماثلين.';

  @override
  String get timePickerSet => 'تعيين';

  @override
  String get timePickerSelect => 'حدد الوقت';

  @override
  String get selectLanguage => 'اختار اللغة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get theme => 'المظهر';

  @override
  String get lightTheme => 'مظهر فاتح';

  @override
  String get darkTheme => 'مظهر داكن';

  @override
  String get notes => 'ملاحظات (اختياري)';
}
