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

  @override
  String get copyDay => 'نسخ اليوم';

  @override
  String get copy => 'نسخ';

  @override
  String copyFromTo(String dayName) {
    return 'نسخ جميع الأنشطة من يوم $dayName إلى:';
  }

  @override
  String get targetDayNotEmptyTitle => 'اليوم المستهدف ليس فارغًا';

  @override
  String targetDayNotEmptyContent(String dayName) {
    return 'يوم \'$dayName\' يحتوي بالفعل على أنشطة. هل أنت متأكد من أنك تريد إضافة الأنشطة الجديدة؟';
  }

  @override
  String get deleteAll => 'حذف الكل';

  @override
  String get deleteAllActivitiesTitle => 'حذف جميع الأنشطة';

  @override
  String deleteAllActivitiesContent(String dayName) {
    return 'هل أنت متأكد من أنك تريد حذف جميع الأنشطة ليوم $dayName؟';
  }

  @override
  String get notificationSettings => 'إعدادات الإشعار';

  @override
  String get notificationsOff => 'الإشعارات متوقفة';

  @override
  String get notifyOnTime => 'إشعار في الوقت المحدد';

  @override
  String get notify5MinBefore => 'قبل 5 دقائق';

  @override
  String get notify15MinBefore => 'قبل 15 دقيقة';

  @override
  String notificationBody(String activityName, String time) {
    return 'من المقرر أن يبدأ نشاطك \'$activityName\' في الساعة $time.';
  }

  @override
  String dayCopied(Object fromDay, Object toDay) {
    return 'تم النسخ من $fromDay إلى $toDay.';
  }

  @override
  String allDeleted(Object dayName) {
    return 'تم حذف جميع الأنشطة ليوم $dayName.';
  }

  @override
  String get copyMode => 'وضع النسخ';

  @override
  String get copyModeMerge => 'دمج مع الأنشطة الحالية';

  @override
  String get copyModeOverwrite => 'الكتابة فوق الأنشطة الحالية';

  @override
  String get overwriteConfirmationTitle => 'تأكيد الكتابة فوق';

  @override
  String overwriteConfirmationContent(Object dayName) {
    return 'سيؤدي هذا إلى حذف جميع الأنشطة الحالية في \'$dayName\' واستبدالها. هل أنت متأكد؟';
  }

  @override
  String get overwrite => 'الكتابة فوق';

  @override
  String get pendingNotificationsTitle => 'الإشعارات المعلقة';

  @override
  String get noPendingNotifications => 'لا توجد إشعارات معلقة.';

  @override
  String get noTitle => 'بدون عنوان';

  @override
  String get noBody => 'بدون محتوى';

  @override
  String get cancelAll => 'إلغاء الكل';

  @override
  String get close => 'إغلاق';

  @override
  String get allNotificationsCancelled => 'تم إلغاء جميع الإشعارات المعلقة.';

  @override
  String get viewPendingNotifications => 'عرض الإشعارات المعلقة';

  @override
  String get unknown => 'غير معروف';

  @override
  String get activityTime => 'وقت النشاط';

  @override
  String get notificationType => 'نوع الإشعار';

  @override
  String get scheduledFor => 'مجدول لـ';
}
