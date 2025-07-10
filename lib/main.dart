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
import 'package:gunluk_planlayici/repositories/template_repository.dart';
import 'package:gunluk_planlayici/screens/planner_home_page.dart';
import 'package:gunluk_planlayici/services/notification_service.dart';
import 'package:gunluk_planlayici/utils/constants.dart';
import 'adepters/color_adapter.dart';
import 'adepters/time_of_day_adapter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 1. Servisleri başlat
    await NotificationService().configureLocalTimezone();
    await NotificationService().init();

    // 2. Hive'ı başlat
    await Hive.initFlutter();

    // 3. TÜM ADAPTÖRLERİ KAYDET
    Hive.registerAdapter(ActivityAdapter());
    Hive.registerAdapter(ActivityTemplateAdapter());
    Hive.registerAdapter(TimeOfDayAdapter());
    Hive.registerAdapter(ColorAdapter());

    // 4. Geçiş işlemini ÇALIŞTIR
    await _runMigrations();

    // 5. Kutuları aç
    final activitiesBox = await Hive.openBox(AppConstants.activitiesBoxName);
    final templatesBox =
        await Hive.openBox<ActivityTemplate>(AppConstants.templatesBoxName);
    final settingsBox = await Hive.openBox(AppConstants.settingsBoxName);

    // 6. Repository'leri oluştur
    final activityRepository = ActivityRepository(activitiesBox);
    final templateRepository = TemplateRepository(templatesBox);

    // 7. Uygulamayı çalıştır
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ActivityProvider(activityRepository),
          ),
          ChangeNotifierProvider(
            create: (_) => SettingsProvider(settingsBox),
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
    runApp(ErrorApp(error: e.toString()));
  }
}

// DÜZELTME 1: 'uture' -> 'Future'
Future<void> _runMigrations() async {
  final prefs = await SharedPreferences.getInstance();
  int currentVersion = prefs.getInt('db_version') ?? 0;

  if (currentVersion < 1) {
    debugPrint("Database is at version 0. Migrating to version 1...");
    Box? box;
    try {
      box = await Hive.openBox<List<dynamic>>(AppConstants.activitiesBoxName);

      if (box.isNotEmpty) {
        // DÜZELTME 2: toMap() doğru tipi döndürür, cast etmeye gerek yok.
        final Map<dynamic, dynamic> oldDataMap = box.toMap();
        final Map<dynamic, List<Activity>> newActivitiesMap = {};

        for (var entry in oldDataMap.entries) {
          final dayKey = entry.key;
          try {
            final oldActivityList = List<dynamic>.from(entry.value);
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
          } catch (e, s) {
            debugPrint(
                "Migration error for day $dayKey: $e. Skipping this day.");
            debugPrint("Stack trace: $s");
            // DÜZELTME 3: Hata durumunda eski veriyi korumaya çalışırken doğru cast yap.
            if (entry.value is List) {
              newActivitiesMap[dayKey] = entry.value.cast<Activity>().toList();
            } else {
              newActivitiesMap[dayKey] = [];
            }
          }
        }
        await box.clear();
        await box.putAll(newActivitiesMap);
      }
    } catch (e, s) {
      debugPrint(
          "A critical error occurred during migration: $e. Migration aborted.");
      debugPrint("Stack trace: $s");
      await box?.close();
      // DÜZELTME 4: Hata durumunda fonksiyondan çık.
      return;
    } finally {
      await box?.close();
    }

    await prefs.setInt('db_version', 1);
    debugPrint("Database migration to version 1 completed successfully.");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final selectedTheme = settingsProvider.appTheme;

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
                  seedColor: primaryColor, brightness: Brightness.light)
              .copyWith(
            primary:
                primaryColor, // Butonlar için kullanılacak ana rengin, bizim orijinal rengimiz olmasını sağla.
            onPrimary: Colors
                .white, // Ana rengin üzerindeki metin her zaman beyaz olsun.
            secondary: primaryColor
                .withAlpha(204), // İkincil renkler için bir varyasyon
          ),
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
                  seedColor: primaryColor, brightness: Brightness.dark)
              .copyWith(
            primary: primaryColor,
            onPrimary: Colors.white,
            secondary: primaryColor.withAlpha(204),
          ),
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

class ErrorApp extends StatelessWidget {
  final String error;
  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Uygulama başlatılamadı.\nLütfen yeniden deneyin.\n\nHata Detayı (Geliştirici için):\n$error",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
