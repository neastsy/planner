// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Aktivite Planlayıcı';

  @override
  String get days_PZT => 'PZT';

  @override
  String get days_SAL => 'SAL';

  @override
  String get days_CAR => 'ÇAR';

  @override
  String get days_PER => 'PER';

  @override
  String get days_CUM => 'CUM';

  @override
  String get days_CMT => 'CMT';

  @override
  String get days_PAZ => 'PAZ';

  @override
  String get addNewActivity => 'Aktivite Ekle';

  @override
  String get activityList => 'Aktivite Listesi';

  @override
  String get noActivityToday => 'Bugün için henüz bir aktivite eklenmedi.';

  @override
  String get editActivity => 'Aktiviteyi Düzenle';

  @override
  String get activityName => 'Aktivite Adı';

  @override
  String get activityNameHint => 'Lütfen bir aktivite adı girin.';

  @override
  String get startTime => 'Başlangıç';

  @override
  String get endTime => 'Bitiş';

  @override
  String get selectTime => 'Seçiniz';

  @override
  String get chooseColor => 'Renk Seçin';

  @override
  String get add => 'Ekle';

  @override
  String get save => 'Kaydet';

  @override
  String get cancel => 'İptal';

  @override
  String get deleteActivityTitle => 'Aktiviteyi Sil';

  @override
  String get deleteActivityContent =>
      'Bu aktiviteyi silmek istediğinizden emin misiniz?';

  @override
  String get delete => 'Sil';

  @override
  String get overlappingActivityTitle => 'Çakışan Aktivite';

  @override
  String get overlappingActivityContent =>
      'Bu saat aralığında başka bir aktivite var. Yine de devam edilsin mi?';

  @override
  String get continueAction => 'Devam Et';

  @override
  String get errorSelectAllTimes => 'Lütfen tüm saatleri seçin.';

  @override
  String get timePickerSet => 'AYARLA';

  @override
  String get timePickerSelect => 'SAATİ SEÇİN';

  @override
  String get selectLanguage => 'Dili Seçin';

  @override
  String get settings => 'Ayarlar';

  @override
  String get theme => 'Tema';

  @override
  String get lightTheme => 'Açık Tema';

  @override
  String get darkTheme => 'Karanlık Tema';

  @override
  String get notes => 'Notlar (İsteğe Bağlı)';

  @override
  String get copyDay => 'Günü Kopyala';

  @override
  String get copy => 'Kopyala';

  @override
  String copyFromTo(String dayName) {
    return '$dayName günündeki tüm aktiviteleri şuraya kopyala:';
  }

  @override
  String get targetDayNotEmptyTitle => 'Hedef Gün Boş Değil';

  @override
  String targetDayNotEmptyContent(String dayName) {
    return '\'$dayName\' gününde zaten aktiviteler mevcut. Yeni aktiviteleri yine de eklemek istediğinize emin misiniz?';
  }

  @override
  String get deleteAll => 'Tümünü Sil';

  @override
  String get deleteAllActivitiesTitle => 'Tüm Aktiviteleri Sil';

  @override
  String deleteAllActivitiesContent(String dayName) {
    return '$dayName gününe ait tüm aktiviteleri silmek istediğinize emin misiniz?';
  }

  @override
  String get notificationSettings => 'Bildirim Ayarları';

  @override
  String get notificationsOff => 'Bildirimler kapalı';

  @override
  String get notifyOnTime => 'Tam zamanında bildir';

  @override
  String get notify5MinBefore => '5 dakika önce';

  @override
  String get notify15MinBefore => '15 dakika önce';

  @override
  String notificationBody(String activityName, String time) {
    return '\'$activityName\' aktiviteniz saat $time\'da başlayacak.';
  }

  @override
  String dayCopied(Object fromDay, Object toDay) {
    return '$fromDay gününden $toDay gününe kopyalandı.';
  }

  @override
  String allDeleted(Object dayName) {
    return '$dayName gününe ait tüm aktiviteler silindi.';
  }

  @override
  String get copyMode => 'Kopyalama Modu';

  @override
  String get copyModeMerge => 'Mevcut aktivitelere ekle (Birleştir)';

  @override
  String get copyModeOverwrite => 'Mevcut aktivitelerin üzerine yaz (Değiştir)';

  @override
  String get overwriteConfirmationTitle => 'Üzerine Yazmayı Onayla';

  @override
  String overwriteConfirmationContent(Object dayName) {
    return 'Bu işlem, \'$dayName\' günündeki tüm mevcut aktiviteleri silecek ve yenileriyle değiştirecektir. Emin misiniz?';
  }

  @override
  String get overwrite => 'Üzerine Yaz';

  @override
  String get pendingNotificationsTitle => 'Bekleyen Bildirimler';

  @override
  String get noPendingNotifications => 'Bekleyen bildirim bulunmuyor.';

  @override
  String get noTitle => 'Başlık Yok';

  @override
  String get noBody => 'İçerik Yok';

  @override
  String get cancelAll => 'Tümünü İptal Et';

  @override
  String get close => 'Kapat';

  @override
  String get allNotificationsCancelled =>
      'Tüm bekleyen bildirimler iptal edildi.';

  @override
  String get viewPendingNotifications => 'Bekleyen Bildirimleri Görüntüle';

  @override
  String get unknown => 'Bilinmiyor';

  @override
  String get activityTime => 'Aktivite Saati';

  @override
  String get notificationType => 'Bildirim Türü';

  @override
  String get scheduledFor => 'Zamanlandı';

  @override
  String get editTemplate => 'Şablonu Düzenle';

  @override
  String get addTemplate => 'Yeni Şablon Ekle';

  @override
  String get templateName => 'Şablon Adı';

  @override
  String get templateNameHint => 'Lütfen bir şablon adı girin.';

  @override
  String get durationInMinutes => 'Süre (dakika cinsinden)';

  @override
  String get durationHint => 'Lütfen bir süre girin.';

  @override
  String get durationInvalidHint => 'Lütfen geçerli, pozitif bir sayı girin.';

  @override
  String get templateManagerTitle => 'Şablon Yöneticisi';

  @override
  String get noTemplates =>
      'Henüz şablon oluşturulmadı. Eklemek için \'+\' tuşuna dokunun.';

  @override
  String durationLabel(Object minutes) {
    return 'Süre: $minutes dk';
  }

  @override
  String get manageTemplates => 'Aktivite Şablonlarını Yönet';

  @override
  String get deleteTemplateTitle => 'Şablonu Sil';

  @override
  String deleteTemplateContent(Object templateName) {
    return '\'$templateName\' şablonunu silmek istediğinizden emin misiniz?';
  }

  @override
  String get durationMaxHint => 'Süre 1440 dakikayı (24 saat) geçemez.';

  @override
  String get addFromTemplate => 'Şablondan Ekle';

  @override
  String get noTemplatesToUse =>
      'Kullanılacak şablon yok. Lütfen ayarlardan bir tane oluşturun.';

  @override
  String get selectTemplate => 'Bir Şablon Seçin';

  @override
  String get tagsLabel => 'Etiketler (virgülle ayrılmış)';

  @override
  String get tagsHint => 'örn. iş, spor, kişisel';

  @override
  String get statisticsPageTitle => 'İstatistikler';

  @override
  String get statisticsButtonTooltip => 'İstatistikleri Görüntüle';

  @override
  String get tagDistributionTitle => 'Etikete Göre Zaman Dağılımı';

  @override
  String get dailyActivityTitle => 'Güne Göre Toplam Aktivite Süresi';

  @override
  String get noDataForStatistics =>
      'İstatistik gösterecek aktivite verisi bulunmuyor. Günlerinizi planlamaya başlayın!';

  @override
  String get untagged => 'Etiketsiz';

  @override
  String todayIs(String dayName) {
    return 'Bugün $dayName';
  }

  @override
  String get fullDay_monday => 'Pazartesi';

  @override
  String get fullDay_tuesday => 'Salı';

  @override
  String get fullDay_wednesday => 'Çarşamba';

  @override
  String get fullDay_thursday => 'Perşembe';

  @override
  String get fullDay_friday => 'Cuma';

  @override
  String get fullDay_saturday => 'Cumartesi';

  @override
  String get fullDay_sunday => 'Pazar';

  @override
  String get repeatNotificationWeekly => 'Haftalık tekrarla';

  @override
  String get recurringNotificationHint => 'Aktivite saatinde tekrarlanır';

  @override
  String get error_appCouldNotStart => 'Uygulama Başlatılamadı';

  @override
  String get error_unexpectedError =>
      'Beklenmedik bir hata oluştu. Lütfen yeniden başlatmayı deneyin.';

  @override
  String get error_restart => 'Yeniden Başlat';

  @override
  String get error_detailsForDeveloper => 'Hata Detayı (Geliştirici için):';

  @override
  String get pomodoro_startFocusSession => 'Odaklanma Seansını Başlat';

  @override
  String get pomodoro_sessionStateWork => 'Çalışma';

  @override
  String get pomodoro_sessionStateShortBreak => 'Kısa Mola';

  @override
  String get pomodoro_sessionStateLongBreak => 'Uzun Mola';

  @override
  String get pomodoro_sessionStatePaused => 'Duraklatıldı';

  @override
  String pomodoro_completedSessions(int count) {
    return 'Tamamlanan Seans: $count';
  }

  @override
  String get pomodoro_endSessionTitle => 'Seansı Bitir';

  @override
  String pomodoro_endSessionContent(
      Object sessionCount, Object minutes, Object activityName) {
    return '$sessionCount pomodoro seansını ($minutes dakika) \'$activityName\' aktivitesine eklemek ister misiniz?';
  }

  @override
  String get pomodoro_dontSave => 'Kaydetme';

  @override
  String get pomodoro_saveAndExit => 'Evet, Ekle';

  @override
  String get tapPlusToStart =>
      'Planlamaya başlamak için \'+\' butonuna dokunun.';

  @override
  String get pomodoro_resetProgress => 'İlerlemeyi Sıfırla';

  @override
  String get pomodoro_continueSession => 'Seansa Devam Et';

  @override
  String get pomodoro_activityCompleted => 'Bu aktivite zaten tamamlandı!';

  @override
  String targetReached(Object activityName) {
    return 'Hedefe Ulaşıldı! \'$activityName\' aktivitesini tamamladınız.';
  }
}
