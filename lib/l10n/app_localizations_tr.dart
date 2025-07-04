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
  String get errorStartEndTimeSame => 'Başlangıç ve bitiş saati aynı olamaz.';

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
}
