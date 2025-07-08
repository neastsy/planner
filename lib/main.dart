import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'package:gunluk_planlayici/l10n/app_localizations.dart';
import 'package:gunluk_planlayici/models/activity_model.dart';
import 'package:gunluk_planlayici/models/activity_template_model.dart';
import 'package:gunluk_planlayici/providers/activity_provider.dart';
import 'package:gunluk_planlayici/providers/settings_provider.dart';
import 'package:gunluk_planlayici/providers/template_provider.dart';
import 'package:gunluk_planlayici/providers/statistics_provider.dart';
import 'package:gunluk_planlayici/repositories/activity_repository.dart';
import 'package:gunluk_planlayici/repositories/template_repository.dart'; // YENİ: Repository import edildi
import 'package:gunluk_planlayici/screens/planner_home_page.dart';
import 'package:gunluk_planlayici/services/notification_service.dart';
import 'package:gunluk_planlayici/utils/constants.dart';
import 'adepters/color_adapter.dart';
import 'adepters/time_of_day_adapter.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // 1. Servisleri Başlat (Timezone ve Bildirimler)
    // GÜNCELLENDİ: NotificationService'deki yeni metodumuzu kullanıyoruz.
    await NotificationService().configureLocalTimezone();
    await NotificationService().init();

    // 2. Veritabanını Başlat (Hive)
    await Hive.initFlutter();

    // Adaptörleri Kaydet
    Hive.registerAdapter(ActivityAdapter());
    Hive.registerAdapter(TimeOfDayAdapter());
    Hive.registerAdapter(ColorAdapter());
    Hive.registerAdapter(ActivityTemplateAdapter());

    // Kutuları Aç
    // GÜNCELLENDİ: ActivityRepository'nin yeni yapısına uygun olarak Box<dynamic> kullanıyoruz.
    await Hive.openBox(AppConstants.activitiesBoxName);
    // GÜNCELLENDİ: Sabit kullanarak ve doğru tiple kutuyu açıyoruz.
    await Hive.openBox<ActivityTemplate>(AppConstants.templatesBoxName);
    // YENİ: Ayarlar için yeni kutumuzu açıyoruz.
    await Hive.openBox(AppConstants.settingsBoxName);

    // 3. Repository'leri Oluştur
    // GÜNCELLENDİ: Repository'leri MultiProvider dışında oluşturmak daha temizdir.
    final activityRepository =
        ActivityRepository(Hive.box(AppConstants.activitiesBoxName));
    final templateRepository = TemplateRepository(
        Hive.box<ActivityTemplate>(AppConstants.templatesBoxName));

    runApp(
      MultiProvider(
        providers: [
          // GÜNCELLENDİ: Provider'lar artık doğru bağımlılıklarla oluşturuluyor.
          ChangeNotifierProvider(
            create: (_) => ActivityProvider(activityRepository),
          ),
          ChangeNotifierProvider(
            create: (_) =>
                SettingsProvider(Hive.box(AppConstants.settingsBoxName)),
          ),
          ChangeNotifierProvider(
            create: (_) => TemplateProvider(templateRepository),
          ),
          ChangeNotifierProxyProvider<ActivityProvider, StatisticsProvider>(
            // StatisticsProvider'ın ilk boş örneğini oluşturur.
            create: (_) => StatisticsProvider(),
            update: (_, activityProvider, previousStatisticsProvider) =>
                (previousStatisticsProvider ?? StatisticsProvider())
                  ..update(activityProvider),
          ),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e, stackTrace) {
    debugPrint("Uygulama başlatılırken kritik bir hata oluştu: $e");
    debugPrint("Stack Trace: $stackTrace");
    // Hata durumunda kullanıcıya bir mesaj göstermek için basit bir hata ekranı da çalıştırılabilir.
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();

    // Tema renkleri
    const Color lightBackgroundColor = Color(0xFFFAFAFA);
    const Color lightDialogColor = Color(0xFFFFFFFF);
    const Color lightTextColor = Colors.black87;
    const Color darkBackgroundColor = Color(0xFF222831);
    const Color darkDialogColor = Color(0xFF393E46);
    const Color darkTextColor = Color(0xFFE0E0E0);

    return MaterialApp(
      onGenerateTitle: (context) {
        return AppLocalizations.of(context)!.appTitle;
      },
      themeMode: settingsProvider.themeMode,
      locale: settingsProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('tr', ''),
        Locale('en', ''),
        Locale('de', ''),
        Locale('fr', ''),
        Locale('es', ''),
        Locale('ru', ''),
        Locale('ar', ''),
        Locale('ja', ''),
        Locale('zh', ''),
      ],
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: lightBackgroundColor,
          textTheme: GoogleFonts.notoSansTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: lightTextColor, displayColor: lightTextColor),
          // GÜNCELLENDİ: DialogTheme -> DialogThemeData
          dialogTheme: DialogThemeData(
            backgroundColor: lightDialogColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
          ),
          // GÜNCELLENDİ: CardTheme -> CardThemeData
          cardTheme: CardThemeData(
            color: const Color(0xFFE8E8E8),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.black54),
            titleTextStyle: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.blue))),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: darkBackgroundColor,
          textTheme:
              GoogleFonts.notoSansTextTheme(Theme.of(context).primaryTextTheme)
                  .apply(bodyColor: darkTextColor, displayColor: darkTextColor),
          // GÜNCELLENDİ: DialogTheme -> DialogThemeData
          dialogTheme: DialogThemeData(
            backgroundColor: darkDialogColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
          ),
          // GÜNCELLENDİ: CardTheme -> CardThemeData
          cardTheme: CardThemeData(
            color: Colors.white.withAlpha((255 * 0.1).round()),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.white70))),
      home: const PlannerHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
