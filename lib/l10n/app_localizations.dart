import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ja'),
    Locale('ru'),
    Locale('tr'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In tr, this message translates to:
  /// **'Aktivite Planlayıcı'**
  String get appTitle;

  /// No description provided for @days_PZT.
  ///
  /// In tr, this message translates to:
  /// **'PZT'**
  String get days_PZT;

  /// No description provided for @days_SAL.
  ///
  /// In tr, this message translates to:
  /// **'SAL'**
  String get days_SAL;

  /// No description provided for @days_CAR.
  ///
  /// In tr, this message translates to:
  /// **'ÇAR'**
  String get days_CAR;

  /// No description provided for @days_PER.
  ///
  /// In tr, this message translates to:
  /// **'PER'**
  String get days_PER;

  /// No description provided for @days_CUM.
  ///
  /// In tr, this message translates to:
  /// **'CUM'**
  String get days_CUM;

  /// No description provided for @days_CMT.
  ///
  /// In tr, this message translates to:
  /// **'CMT'**
  String get days_CMT;

  /// No description provided for @days_PAZ.
  ///
  /// In tr, this message translates to:
  /// **'PAZ'**
  String get days_PAZ;

  /// No description provided for @addNewActivity.
  ///
  /// In tr, this message translates to:
  /// **'Aktivite Ekle'**
  String get addNewActivity;

  /// No description provided for @activityList.
  ///
  /// In tr, this message translates to:
  /// **'Aktivite Listesi'**
  String get activityList;

  /// No description provided for @noActivityToday.
  ///
  /// In tr, this message translates to:
  /// **'Bugün için henüz bir aktivite eklenmedi.'**
  String get noActivityToday;

  /// No description provided for @editActivity.
  ///
  /// In tr, this message translates to:
  /// **'Aktiviteyi Düzenle'**
  String get editActivity;

  /// No description provided for @activityName.
  ///
  /// In tr, this message translates to:
  /// **'Aktivite Adı'**
  String get activityName;

  /// No description provided for @activityNameHint.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen bir aktivite adı girin.'**
  String get activityNameHint;

  /// No description provided for @startTime.
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In tr, this message translates to:
  /// **'Bitiş'**
  String get endTime;

  /// No description provided for @selectTime.
  ///
  /// In tr, this message translates to:
  /// **'Seçiniz'**
  String get selectTime;

  /// No description provided for @chooseColor.
  ///
  /// In tr, this message translates to:
  /// **'Renk Seçin'**
  String get chooseColor;

  /// No description provided for @add.
  ///
  /// In tr, this message translates to:
  /// **'Ekle'**
  String get add;

  /// No description provided for @save.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get cancel;

  /// No description provided for @deleteActivityTitle.
  ///
  /// In tr, this message translates to:
  /// **'Aktiviteyi Sil'**
  String get deleteActivityTitle;

  /// No description provided for @deleteActivityContent.
  ///
  /// In tr, this message translates to:
  /// **'Bu aktiviteyi silmek istediğinizden emin misiniz?'**
  String get deleteActivityContent;

  /// No description provided for @delete.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get delete;

  /// No description provided for @overlappingActivityTitle.
  ///
  /// In tr, this message translates to:
  /// **'Çakışan Aktivite'**
  String get overlappingActivityTitle;

  /// No description provided for @overlappingActivityContent.
  ///
  /// In tr, this message translates to:
  /// **'Bu saat aralığında başka bir aktivite var. Yine de devam edilsin mi?'**
  String get overlappingActivityContent;

  /// No description provided for @continueAction.
  ///
  /// In tr, this message translates to:
  /// **'Devam Et'**
  String get continueAction;

  /// No description provided for @errorSelectAllTimes.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen tüm saatleri seçin.'**
  String get errorSelectAllTimes;

  /// No description provided for @timePickerSet.
  ///
  /// In tr, this message translates to:
  /// **'AYARLA'**
  String get timePickerSet;

  /// No description provided for @timePickerSelect.
  ///
  /// In tr, this message translates to:
  /// **'SAATİ SEÇİN'**
  String get timePickerSelect;

  /// No description provided for @selectLanguage.
  ///
  /// In tr, this message translates to:
  /// **'Dili Seçin'**
  String get selectLanguage;

  /// No description provided for @settings.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settings;

  /// No description provided for @theme.
  ///
  /// In tr, this message translates to:
  /// **'Tema'**
  String get theme;

  /// No description provided for @lightTheme.
  ///
  /// In tr, this message translates to:
  /// **'Açık Tema'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In tr, this message translates to:
  /// **'Karanlık Tema'**
  String get darkTheme;

  /// No description provided for @notes.
  ///
  /// In tr, this message translates to:
  /// **'Notlar (İsteğe Bağlı)'**
  String get notes;

  /// No description provided for @copyDay.
  ///
  /// In tr, this message translates to:
  /// **'Günü Kopyala'**
  String get copyDay;

  /// No description provided for @copy.
  ///
  /// In tr, this message translates to:
  /// **'Kopyala'**
  String get copy;

  /// Aktiviteleri bir günden diğerine kopyalamak için diyalog metni.
  ///
  /// In tr, this message translates to:
  /// **'{dayName} günündeki tüm aktiviteleri şuraya kopyala:'**
  String copyFromTo(String dayName);

  /// No description provided for @targetDayNotEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hedef Gün Boş Değil'**
  String get targetDayNotEmptyTitle;

  /// Boş olmayan bir güne aktivite kopyalarken çıkan onay diyaloğu.
  ///
  /// In tr, this message translates to:
  /// **'\'{dayName}\' gününde zaten aktiviteler mevcut. Yeni aktiviteleri yine de eklemek istediğinize emin misiniz?'**
  String targetDayNotEmptyContent(String dayName);

  /// No description provided for @deleteAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümünü Sil'**
  String get deleteAll;

  /// No description provided for @deleteAllActivitiesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Tüm Aktiviteleri Sil'**
  String get deleteAllActivitiesTitle;

  /// Belirli bir günün tüm aktivitelerini silmek için onay diyaloğu.
  ///
  /// In tr, this message translates to:
  /// **'{dayName} gününe ait tüm aktiviteleri silmek istediğinize emin misiniz?'**
  String deleteAllActivitiesContent(String dayName);

  /// No description provided for @notificationSettings.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim Ayarları'**
  String get notificationSettings;

  /// No description provided for @notificationsOff.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler kapalı'**
  String get notificationsOff;

  /// No description provided for @notifyOnTime.
  ///
  /// In tr, this message translates to:
  /// **'Tam zamanında bildir'**
  String get notifyOnTime;

  /// No description provided for @notify5MinBefore.
  ///
  /// In tr, this message translates to:
  /// **'5 dakika önce'**
  String get notify5MinBefore;

  /// No description provided for @notify15MinBefore.
  ///
  /// In tr, this message translates to:
  /// **'15 dakika önce'**
  String get notify15MinBefore;

  /// No description provided for @notificationBody.
  ///
  /// In tr, this message translates to:
  /// **'\'{activityName}\' aktiviteniz saat {time}\'da başlayacak.'**
  String notificationBody(String activityName, String time);

  /// No description provided for @dayCopied.
  ///
  /// In tr, this message translates to:
  /// **'{fromDay} gününden {toDay} gününe kopyalandı.'**
  String dayCopied(Object fromDay, Object toDay);

  /// No description provided for @allDeleted.
  ///
  /// In tr, this message translates to:
  /// **'{dayName} gününe ait tüm aktiviteler silindi.'**
  String allDeleted(Object dayName);

  /// No description provided for @copyMode.
  ///
  /// In tr, this message translates to:
  /// **'Kopyalama Modu'**
  String get copyMode;

  /// No description provided for @copyModeMerge.
  ///
  /// In tr, this message translates to:
  /// **'Mevcut aktivitelere ekle (Birleştir)'**
  String get copyModeMerge;

  /// No description provided for @copyModeOverwrite.
  ///
  /// In tr, this message translates to:
  /// **'Mevcut aktivitelerin üzerine yaz (Değiştir)'**
  String get copyModeOverwrite;

  /// No description provided for @overwriteConfirmationTitle.
  ///
  /// In tr, this message translates to:
  /// **'Üzerine Yazmayı Onayla'**
  String get overwriteConfirmationTitle;

  /// No description provided for @overwriteConfirmationContent.
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem, \'{dayName}\' günündeki tüm mevcut aktiviteleri silecek ve yenileriyle değiştirecektir. Emin misiniz?'**
  String overwriteConfirmationContent(Object dayName);

  /// No description provided for @overwrite.
  ///
  /// In tr, this message translates to:
  /// **'Üzerine Yaz'**
  String get overwrite;

  /// No description provided for @pendingNotificationsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bekleyen Bildirimler'**
  String get pendingNotificationsTitle;

  /// No description provided for @noPendingNotifications.
  ///
  /// In tr, this message translates to:
  /// **'Bekleyen bildirim bulunmuyor.'**
  String get noPendingNotifications;

  /// No description provided for @noTitle.
  ///
  /// In tr, this message translates to:
  /// **'Başlık Yok'**
  String get noTitle;

  /// No description provided for @noBody.
  ///
  /// In tr, this message translates to:
  /// **'İçerik Yok'**
  String get noBody;

  /// No description provided for @cancelAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümünü İptal Et'**
  String get cancelAll;

  /// No description provided for @close.
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get close;

  /// No description provided for @allNotificationsCancelled.
  ///
  /// In tr, this message translates to:
  /// **'Tüm bekleyen bildirimler iptal edildi.'**
  String get allNotificationsCancelled;

  /// No description provided for @viewPendingNotifications.
  ///
  /// In tr, this message translates to:
  /// **'Bekleyen Bildirimleri Görüntüle'**
  String get viewPendingNotifications;

  /// No description provided for @unknown.
  ///
  /// In tr, this message translates to:
  /// **'Bilinmiyor'**
  String get unknown;

  /// No description provided for @activityTime.
  ///
  /// In tr, this message translates to:
  /// **'Aktivite Saati'**
  String get activityTime;

  /// No description provided for @notificationType.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim Türü'**
  String get notificationType;

  /// No description provided for @scheduledFor.
  ///
  /// In tr, this message translates to:
  /// **'Zamanlandı'**
  String get scheduledFor;

  /// No description provided for @editTemplate.
  ///
  /// In tr, this message translates to:
  /// **'Şablonu Düzenle'**
  String get editTemplate;

  /// No description provided for @addTemplate.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Şablon Ekle'**
  String get addTemplate;

  /// No description provided for @templateName.
  ///
  /// In tr, this message translates to:
  /// **'Şablon Adı'**
  String get templateName;

  /// No description provided for @templateNameHint.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen bir şablon adı girin.'**
  String get templateNameHint;

  /// No description provided for @durationInMinutes.
  ///
  /// In tr, this message translates to:
  /// **'Süre (dakika cinsinden)'**
  String get durationInMinutes;

  /// No description provided for @durationHint.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen bir süre girin.'**
  String get durationHint;

  /// No description provided for @durationInvalidHint.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen geçerli, pozitif bir sayı girin.'**
  String get durationInvalidHint;

  /// No description provided for @templateManagerTitle.
  ///
  /// In tr, this message translates to:
  /// **'Şablon Yöneticisi'**
  String get templateManagerTitle;

  /// No description provided for @noTemplates.
  ///
  /// In tr, this message translates to:
  /// **'Henüz şablon oluşturulmadı. Eklemek için \'+\' tuşuna dokunun.'**
  String get noTemplates;

  /// No description provided for @durationLabel.
  ///
  /// In tr, this message translates to:
  /// **'Süre: {minutes} dk'**
  String durationLabel(Object minutes);

  /// No description provided for @manageTemplates.
  ///
  /// In tr, this message translates to:
  /// **'Aktivite Şablonlarını Yönet'**
  String get manageTemplates;

  /// No description provided for @deleteTemplateTitle.
  ///
  /// In tr, this message translates to:
  /// **'Şablonu Sil'**
  String get deleteTemplateTitle;

  /// No description provided for @deleteTemplateContent.
  ///
  /// In tr, this message translates to:
  /// **'\'{templateName}\' şablonunu silmek istediğinizden emin misiniz?'**
  String deleteTemplateContent(Object templateName);

  /// No description provided for @durationMaxHint.
  ///
  /// In tr, this message translates to:
  /// **'Süre 1440 dakikayı (24 saat) geçemez.'**
  String get durationMaxHint;

  /// No description provided for @addFromTemplate.
  ///
  /// In tr, this message translates to:
  /// **'Şablondan Ekle'**
  String get addFromTemplate;

  /// No description provided for @noTemplatesToUse.
  ///
  /// In tr, this message translates to:
  /// **'Kullanılacak şablon yok. Lütfen ayarlardan bir tane oluşturun.'**
  String get noTemplatesToUse;

  /// No description provided for @selectTemplate.
  ///
  /// In tr, this message translates to:
  /// **'Bir Şablon Seçin'**
  String get selectTemplate;

  /// No description provided for @tagsLabel.
  ///
  /// In tr, this message translates to:
  /// **'Etiketler (virgülle ayrılmış)'**
  String get tagsLabel;

  /// No description provided for @tagsHint.
  ///
  /// In tr, this message translates to:
  /// **'örn. iş, spor, kişisel'**
  String get tagsHint;

  /// No description provided for @statisticsPageTitle.
  ///
  /// In tr, this message translates to:
  /// **'İstatistikler'**
  String get statisticsPageTitle;

  /// No description provided for @statisticsButtonTooltip.
  ///
  /// In tr, this message translates to:
  /// **'İstatistikleri Görüntüle'**
  String get statisticsButtonTooltip;

  /// No description provided for @tagDistributionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Etikete Göre Zaman Dağılımı'**
  String get tagDistributionTitle;

  /// No description provided for @dailyActivityTitle.
  ///
  /// In tr, this message translates to:
  /// **'Güne Göre Toplam Aktivite Süresi'**
  String get dailyActivityTitle;

  /// No description provided for @noDataForStatistics.
  ///
  /// In tr, this message translates to:
  /// **'İstatistik gösterecek aktivite verisi bulunmuyor. Günlerinizi planlamaya başlayın!'**
  String get noDataForStatistics;

  /// No description provided for @untagged.
  ///
  /// In tr, this message translates to:
  /// **'Etiketsiz'**
  String get untagged;

  /// No description provided for @todayIs.
  ///
  /// In tr, this message translates to:
  /// **'Bugün {dayName}'**
  String todayIs(String dayName);

  /// No description provided for @fullDay_monday.
  ///
  /// In tr, this message translates to:
  /// **'Pazartesi'**
  String get fullDay_monday;

  /// No description provided for @fullDay_tuesday.
  ///
  /// In tr, this message translates to:
  /// **'Salı'**
  String get fullDay_tuesday;

  /// No description provided for @fullDay_wednesday.
  ///
  /// In tr, this message translates to:
  /// **'Çarşamba'**
  String get fullDay_wednesday;

  /// No description provided for @fullDay_thursday.
  ///
  /// In tr, this message translates to:
  /// **'Perşembe'**
  String get fullDay_thursday;

  /// No description provided for @fullDay_friday.
  ///
  /// In tr, this message translates to:
  /// **'Cuma'**
  String get fullDay_friday;

  /// No description provided for @fullDay_saturday.
  ///
  /// In tr, this message translates to:
  /// **'Cumartesi'**
  String get fullDay_saturday;

  /// No description provided for @fullDay_sunday.
  ///
  /// In tr, this message translates to:
  /// **'Pazar'**
  String get fullDay_sunday;

  /// No description provided for @repeatNotificationWeekly.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık tekrarla'**
  String get repeatNotificationWeekly;

  /// No description provided for @recurringNotificationHint.
  ///
  /// In tr, this message translates to:
  /// **'Aktivite saatinde tekrarlanır'**
  String get recurringNotificationHint;

  /// No description provided for @error_appCouldNotStart.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama Başlatılamadı'**
  String get error_appCouldNotStart;

  /// No description provided for @error_unexpectedError.
  ///
  /// In tr, this message translates to:
  /// **'Beklenmedik bir hata oluştu. Lütfen yeniden başlatmayı deneyin.'**
  String get error_unexpectedError;

  /// No description provided for @error_restart.
  ///
  /// In tr, this message translates to:
  /// **'Yeniden Başlat'**
  String get error_restart;

  /// No description provided for @error_detailsForDeveloper.
  ///
  /// In tr, this message translates to:
  /// **'Hata Detayı (Geliştirici için):'**
  String get error_detailsForDeveloper;

  /// No description provided for @pomodoro_startFocusSession.
  ///
  /// In tr, this message translates to:
  /// **'Odaklanma Seansını Başlat'**
  String get pomodoro_startFocusSession;

  /// No description provided for @pomodoro_sessionStateWork.
  ///
  /// In tr, this message translates to:
  /// **'Çalışma'**
  String get pomodoro_sessionStateWork;

  /// No description provided for @pomodoro_sessionStateShortBreak.
  ///
  /// In tr, this message translates to:
  /// **'Kısa Mola'**
  String get pomodoro_sessionStateShortBreak;

  /// No description provided for @pomodoro_sessionStateLongBreak.
  ///
  /// In tr, this message translates to:
  /// **'Uzun Mola'**
  String get pomodoro_sessionStateLongBreak;

  /// No description provided for @pomodoro_sessionStatePaused.
  ///
  /// In tr, this message translates to:
  /// **'Duraklatıldı'**
  String get pomodoro_sessionStatePaused;

  /// No description provided for @pomodoro_completedSessions.
  ///
  /// In tr, this message translates to:
  /// **'Tamamlanan Seans: {count}'**
  String pomodoro_completedSessions(int count);

  /// No description provided for @pomodoro_endSessionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Seansı Bitir'**
  String get pomodoro_endSessionTitle;

  /// No description provided for @pomodoro_endSessionContent.
  ///
  /// In tr, this message translates to:
  /// **'{sessionCount} pomodoro seansını ({minutes} dakika) \'{activityName}\' aktivitesine eklemek ister misiniz?'**
  String pomodoro_endSessionContent(
      Object sessionCount, Object minutes, Object activityName);

  /// No description provided for @pomodoro_dontSave.
  ///
  /// In tr, this message translates to:
  /// **'Kaydetme'**
  String get pomodoro_dontSave;

  /// No description provided for @pomodoro_saveAndExit.
  ///
  /// In tr, this message translates to:
  /// **'Evet, Ekle'**
  String get pomodoro_saveAndExit;

  /// No description provided for @tapPlusToStart.
  ///
  /// In tr, this message translates to:
  /// **'Planlamaya başlamak için \'+\' butonuna dokunun.'**
  String get tapPlusToStart;

  /// No description provided for @pomodoro_resetProgress.
  ///
  /// In tr, this message translates to:
  /// **'İlerlemeyi Sıfırla'**
  String get pomodoro_resetProgress;

  /// No description provided for @pomodoro_continueSession.
  ///
  /// In tr, this message translates to:
  /// **'Seansa Devam Et'**
  String get pomodoro_continueSession;

  /// No description provided for @pomodoro_activityCompleted.
  ///
  /// In tr, this message translates to:
  /// **'Bu aktivite zaten tamamlandı!'**
  String get pomodoro_activityCompleted;

  /// No description provided for @targetReached.
  ///
  /// In tr, this message translates to:
  /// **'Hedefe Ulaşıldı! \'{activityName}\' aktivitesini tamamladınız.'**
  String targetReached(Object activityName);

  /// No description provided for @pomodoro_completedMinutes.
  ///
  /// In tr, this message translates to:
  /// **'{completed} / {total} dk tamamlandı'**
  String pomodoro_completedMinutes(Object completed, Object total);

  /// No description provided for @pomodoro_confirmSaveContent.
  ///
  /// In tr, this message translates to:
  /// **'Bu oturumda tamamladığınız {minutes} dakikayı \'{activityName}\' aktivitesine eklemek ister misiniz?'**
  String pomodoro_confirmSaveContent(Object activityName, Object minutes);

  /// No description provided for @permissionRequired.
  ///
  /// In tr, this message translates to:
  /// **'İzin Gerekli'**
  String get permissionRequired;

  /// No description provided for @permissionExplanation.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimleri ve Pomodoro zamanlayıcıyı kullanmak için uygulama ayarlarından bildirim iznini etkinleştirmeniz gerekmektedir.'**
  String get permissionExplanation;

  /// No description provided for @openSettings.
  ///
  /// In tr, this message translates to:
  /// **'Ayarları Aç'**
  String get openSettings;

  /// No description provided for @pomodoroPermissionRequired.
  ///
  /// In tr, this message translates to:
  /// **'Pomodoro zamanlayıcısının çalışması için bildirim izni gereklidir.'**
  String get pomodoroPermissionRequired;

  /// No description provided for @themeColor.
  ///
  /// In tr, this message translates to:
  /// **'Tema Rengi'**
  String get themeColor;

  /// No description provided for @today.
  ///
  /// In tr, this message translates to:
  /// **'Bugün'**
  String get today;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'de',
        'en',
        'es',
        'fr',
        'ja',
        'ru',
        'tr',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ja':
      return AppLocalizationsJa();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
