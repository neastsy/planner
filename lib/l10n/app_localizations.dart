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

  /// No description provided for @errorStartEndTimeSame.
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç ve bitiş saati aynı olamaz.'**
  String get errorStartEndTimeSame;

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
