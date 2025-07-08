import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    await _runMigrations();

    // Kutuları Aç
    await Hive.openBox(AppConstants.activitiesBoxName);
    await Hive.openBox<ActivityTemplate>(AppConstants.templatesBoxName);
    await Hive.openBox(AppConstants.settingsBoxName);

    // 3. Repository'leri Oluştur
    final activityRepository =
        ActivityRepository(Hive.box(AppConstants.activitiesBoxName));
    final templateRepository = TemplateRepository(
        Hive.box<ActivityTemplate>(AppConstants.templatesBoxName));

    runApp(
      MultiProvider(
        providers: [
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
  }
}

Future<void> _runMigrations() async {
  final prefs = await SharedPreferences.getInstance();
  int currentVersion = prefs.getInt('db_version') ?? 0;

  if (currentVersion < 1) {
    debugPrint("Database is at version 0. Migrating to version 1...");
    try {
      final box =
          await Hive.openBox<List<dynamic>>(AppConstants.activitiesBoxName);

      if (box.isNotEmpty) {
        final Map<dynamic, List<dynamic>> oldDataMap = box.toMap();
        final Map<dynamic, List<Activity>> newActivitiesMap = {};

        for (var entry in oldDataMap.entries) {
          final dayKey = entry.key;
          final oldActivityList = entry.value;

          List<Activity> newActivityList = [];
          for (var oldActivityData in oldActivityList) {
            newActivityList.add(Activity(
              id: oldActivityData.id,
              name: oldActivityData.name,
              startTime: oldActivityData.startTime,
              endTime: oldActivityData.endTime,
              color: oldActivityData.color,
              note: oldActivityData.note,
              notificationMinutesBefore:
                  oldActivityData.notificationMinutesBefore,
              tags: List<String>.from(oldActivityData.tags ?? []),
              isNotificationRecurring: false,
            ));
          }
          newActivitiesMap[dayKey] = newActivityList;
        }

        await box.clear();
        await box.putAll(newActivitiesMap);
      }

      await prefs.setInt('db_version', 1);
      debugPrint("Database migration to version 1 completed successfully.");
    } catch (e, s) {
      debugPrint("A critical error occurred during migration to v1: $e\n$s");
    }
  }

  // Gelecekteki bir güncelleme için örnek:
  // if (currentVersion < 2) {
  //   // Versiyon 1'den 2'ye geçiş kodları buraya gelecek.
  //   await prefs.setInt('db_version', 2);
  // }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final selectedTheme = settingsProvider.appTheme;

    // Tema renkleri
    final Color lightBackgroundColor = selectedTheme.lightBackgroundColor;
    final Color lightCardColor = selectedTheme.lightCardColor;
    final Color darkBackgroundColor = selectedTheme.darkBackgroundColor;
    final Color darkCardColor = selectedTheme.darkCardColor;
    final Color primaryColor = selectedTheme.primaryColor;

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
          colorScheme: ColorScheme.fromSeed(
              seedColor: primaryColor, brightness: Brightness.light),
          textTheme: GoogleFonts.notoSansTextTheme(
            Theme.of(context).textTheme,
          ).apply(bodyColor: const Color(0xFF1f2937)),
          scaffoldBackgroundColor: lightBackgroundColor,
          cardTheme: CardThemeData(
            color: lightCardColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
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
              style: TextButton.styleFrom(foregroundColor: primaryColor))),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSeed(
              seedColor: primaryColor, brightness: Brightness.dark),
          textTheme: GoogleFonts.notoSansTextTheme(
            Theme.of(context).primaryTextTheme,
          ).apply(bodyColor: const Color(0xFFe5e7eb)),
          scaffoldBackgroundColor: darkBackgroundColor,
          cardTheme: CardThemeData(
            color: darkCardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
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
