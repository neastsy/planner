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

  @override
  String get editTemplate => 'تعديل القالب';

  @override
  String get addTemplate => 'إضافة قالب جديد';

  @override
  String get templateName => 'اسم القالب';

  @override
  String get templateNameHint => 'الرجاء إدخال اسم للقالب.';

  @override
  String get durationInMinutes => 'المدة (بالدقائق)';

  @override
  String get durationHint => 'الرجاء إدخال مدة.';

  @override
  String get durationInvalidHint => 'الرجاء إدخال رقم موجب صالح.';

  @override
  String get templateManagerTitle => 'مدير القوالب';

  @override
  String get noTemplates =>
      'لم يتم إنشاء أي قوالب بعد. انقر على \'+\' للإضافة.';

  @override
  String durationLabel(Object minutes) {
    return 'المدة: $minutes دقيقة';
  }

  @override
  String get manageTemplates => 'إدارة قوالب الأنشطة';

  @override
  String get deleteTemplateTitle => 'حذف القالب';

  @override
  String deleteTemplateContent(Object templateName) {
    return 'هل أنت متأكد من أنك تريد حذف القالب \'$templateName\'؟';
  }

  @override
  String get durationMaxHint => 'لا يمكن أن تتجاوز المدة 1440 دقيقة (24 ساعة).';

  @override
  String get addFromTemplate => 'من قالب';

  @override
  String get noTemplatesToUse =>
      'لا توجد قوالب متاحة. الرجاء إنشاء واحد في الإعدادات.';

  @override
  String get selectTemplate => 'اختر قالبًا';

  @override
  String get tagsLabel => 'العلامات (مفصولة بفاصلة)';

  @override
  String get tagsHint => 'مثال: عمل، رياضة، شخصي';

  @override
  String get statisticsPageTitle => 'الإحصائيات';

  @override
  String get statisticsButtonTooltip => 'عرض الإحصائيات';

  @override
  String get tagDistributionTitle => 'توزيع الوقت حسب الوسم';

  @override
  String get dailyActivityTitle => 'إجمالي وقت النشاط حسب اليوم';

  @override
  String get noDataForStatistics =>
      'لا توجد بيانات نشاط لعرض الإحصائيات. ابدأ بتخطيط أيامك!';

  @override
  String get untagged => 'غير موسوم';

  @override
  String todayIs(String dayName) {
    return 'اليوم هو $dayName';
  }

  @override
  String get fullDay_monday => 'الاثنين';

  @override
  String get fullDay_tuesday => 'الثلاثاء';

  @override
  String get fullDay_wednesday => 'الأربعاء';

  @override
  String get fullDay_thursday => 'الخميس';

  @override
  String get fullDay_friday => 'الجمعة';

  @override
  String get fullDay_saturday => 'السبت';

  @override
  String get fullDay_sunday => 'الأحد';

  @override
  String get repeatNotificationWeekly => 'التكرار أسبوعيًا';

  @override
  String get recurringNotificationHint => 'يتكرر في وقت النشاط';

  @override
  String get error_appCouldNotStart => 'تعذر بدء التطبيق';

  @override
  String get error_unexpectedError =>
      'حدث خطأ غير متوقع. يرجى محاولة إعادة تشغيل التطبيق.';

  @override
  String get error_restart => 'إعادة التشغيل';

  @override
  String get error_detailsForDeveloper => 'تفاصيل الخطأ (للمطور):';

  @override
  String get pomodoro_startFocusSession => 'بدء جلسة التركيز';

  @override
  String get pomodoro_sessionStateWork => 'عمل';

  @override
  String get pomodoro_sessionStateShortBreak => 'استراحة قصيرة';

  @override
  String get pomodoro_sessionStateLongBreak => 'استراحة طويلة';

  @override
  String get pomodoro_sessionStatePaused => 'متوقف مؤقتاً';

  @override
  String pomodoro_completedSessions(int count) {
    return 'الجلسات المكتملة: $count';
  }

  @override
  String get pomodoro_endSessionTitle => 'إنهاء الجلسة';

  @override
  String pomodoro_endSessionContent(
      Object sessionCount, Object minutes, Object activityName) {
    return 'هل تريد إضافة $sessionCount جلسة (جلسات) بومودورو ($minutes دقيقة) إلى نشاط \'$activityName\'؟';
  }

  @override
  String get pomodoro_dontSave => 'عدم الحفظ';

  @override
  String get pomodoro_saveAndExit => 'نعم، أضف';

  @override
  String get tapPlusToStart => 'اضغط على زر \'+\' لبدء التخطيط.';

  @override
  String get pomodoro_resetProgress => 'إعادة ضبط التقدم';

  @override
  String get pomodoro_continueSession => 'متابعة الجلسة';

  @override
  String get pomodoro_activityCompleted => 'هذا النشاط مكتمل بالفعل!';

  @override
  String targetReached(Object activityName) {
    return 'تم الوصول إلى الهدف! لقد أكملت نشاط \'$activityName\'.';
  }

  @override
  String pomodoro_completedMinutes(Object completed, Object total) {
    return 'اكتمل $completed / $total دقيقة';
  }

  @override
  String pomodoro_confirmSaveContent(Object activityName, Object minutes) {
    return 'هل تريد إضافة $minutes دقيقة التي أكملتها في هذه الجلسة إلى نشاط \'$activityName\'؟';
  }

  @override
  String get permissionRequired => 'الإذن مطلوب';

  @override
  String get permissionExplanation =>
      'لاستخدام الإشعارات ومؤقت بومودورو، تحتاج إلى تمكين أذونات الإشعارات في إعدادات التطبيق.';

  @override
  String get openSettings => 'فتح الإعدادات';

  @override
  String get pomodoroPermissionRequired =>
      'إذن الإشعارات مطلوب لكي يعمل مؤقت بومودورو.';

  @override
  String get themeColor => 'لون السمة';

  @override
  String get today => 'اليوم';

  @override
  String get pomodoro_resetConfirmationTitle => 'تأكيد إعادة التعيين';

  @override
  String get pomodoro_resetConfirmationContent =>
      'هل أنت متأكد من أنك تريد إعادة تعيين تقدم بومودورو لهذا النشاط؟ لا يمكن التراجع عن هذا الإجراء.';
}
