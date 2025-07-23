import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:gunluk_planlayici/services/background_pomodoro_service.dart';
import 'package:path_provider/path_provider.dart';

import 'package:gunluk_planlayici/l10n/app_localizations.dart';
import 'package:gunluk_planlayici/models/activity_model.dart';
import 'package:gunluk_planlayici/models/activity_template_model.dart';
import 'package:gunluk_planlayici/providers/activity_provider.dart';
import 'package:gunluk_planlayici/providers/settings_provider.dart';
import 'package:gunluk_planlayici/providers/template_provider.dart';
import 'package:gunluk_planlayici/providers/statistics_provider.dart';
import 'package:gunluk_planlayici/providers/pomodoro_provider.dart';
import 'package:gunluk_planlayici/repositories/activity_repository.dart';
import 'package:gunluk_planlayici/repositories/template_repository.dart';
import 'package:gunluk_planlayici/screens/planner_home_page.dart';
import 'package:gunluk_planlayici/services/notification_service.dart';
import 'package:gunluk_planlayici/utils/constants.dart';
import 'adepters/color_adapter.dart';
import 'adepters/time_of_day_adapter.dart';

String dbPath = '';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // KRITIK DÜZELTME: Uygulama dizini yerine sistem cache dizinini kullan
    final directory = await getApplicationDocumentsDirectory();
    dbPath = directory.path;

    debugPrint("Database path initialized: $dbPath");

    // KRITIK DÜZELTME: Background service initialization'ı sadece main isolate'te
    // ve hata yakalama ile
    bool serviceInitialized = false;
    try {
      await initializeService();
      serviceInitialized = true;
      debugPrint("Background service initialized successfully");
    } catch (e, stackTrace) {
      debugPrint("Background service initialization failed: $e");
      debugPrint("Stack trace: $stackTrace");
      // Service başlatılamazsa da uygulamayı çalıştır
    }

    // Ekran yönlendirmesini ayarla
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // KRITIK DÜZELTME: Bildirim servisini başlat ve hataları yakala
    bool notificationInitialized = false;
    try {
      await NotificationService().configureLocalTimezone();
      await NotificationService().init();
      await NotificationService().createPomodoroChannel();
      // KRITIK: Android 13+ için bildirim izinlerini iste
      await NotificationService().requestPermissions();
      notificationInitialized = true;
      debugPrint("Notification service initialized successfully");
    } catch (e, stackTrace) {
      debugPrint("Notification service initialization failed: $e");
      debugPrint("Stack trace: $stackTrace");
    }

    // Hive veritabanını başlat
    await Hive.initFlutter(dbPath);

    // KRITIK DÜZELTME: Adapter kayıt kontrolü
    try {
      Hive.registerAdapter(ActivityAdapter());
      Hive.registerAdapter(ActivityTemplateAdapter());
      Hive.registerAdapter(TimeOfDayAdapter());
      Hive.registerAdapter(ColorAdapter());
    } catch (e) {
      debugPrint("Adapter registration warning: $e");
    }

    // Box'ları aç
    final activitiesBox = await Hive.openBox(AppConstants.activitiesBoxName);
    final templatesBox =
        await Hive.openBox<ActivityTemplate>(AppConstants.templatesBoxName);
    final settingsBox = await Hive.openBox(AppConstants.settingsBoxName);

    // Repository'leri oluştur
    final activityRepository = ActivityRepository(activitiesBox);
    final templateRepository = TemplateRepository(templatesBox);

    debugPrint("Application initialization completed successfully");
    debugPrint(
        "Service initialized: $serviceInitialized, Notifications: $notificationInitialized");

    runApp(
      Phoenix(
        child: MultiProvider(
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
            ChangeNotifierProvider(
              create: (_) => PomodoroProvider(),
            ),
          ],
          child: const MyApp(),
        ),
      ),
    );
  } catch (e, stackTrace) {
    debugPrint("Uygulama başlatılırken kritik bir hata oluştu: $e");
    debugPrint("Stack Trace: $stackTrace");

    // Hata durumunda basit bir hata uygulaması çalıştır
    runApp(
      Phoenix(
        child: MaterialApp(
          home: ErrorApp(error: e.toString()),
        ),
      ),
    );
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
            primary: primaryColor,
            onPrimary: Colors.white,
            secondary: primaryColor.withAlpha(204),
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
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.error_appCouldNotStart,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.error_unexpectedError,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n.error_restart),
                      onPressed: () {
                        Phoenix.rebirth(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      "${l10n.error_detailsForDeveloper}\n$error",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
