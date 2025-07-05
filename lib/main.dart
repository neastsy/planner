import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:gunluk_planlayici/services/notification_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:gunluk_planlayici/utils/constants.dart';

import 'adepters/color_adapter.dart';
import 'adepters/time_of_day_adapter.dart';
import 'l10n/app_localizations.dart';
import 'models/activity_model.dart';
import 'screens/planner_home_page.dart';
import 'providers/activity_provider.dart';
import 'repositories/activity_repository.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    tz.initializeTimeZones();
    final String localTimezone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimezone));

    await NotificationService().init();

    await Hive.initFlutter();

    Hive.registerAdapter(ActivityAdapter());
    Hive.registerAdapter(TimeOfDayAdapter());
    Hive.registerAdapter(ColorAdapter());

    await Hive.openBox<Map>(AppConstants.activitiesBoxName);

    runApp(
      ChangeNotifierProvider(
        create: (context) => ActivityProvider(
          ActivityRepository(Hive.box<Map>(AppConstants.activitiesBoxName)),
        ),
        child: const MyApp(),
      ),
    );
  } catch (e, stackTrace) {
    debugPrint("Uygulama başlatılırken kritik bir hata oluştu: $e");
    debugPrint("Stack Trace: $stackTrace");
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  static void setThemeMode(BuildContext context, ThemeMode newMode) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setThemeMode(newMode);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  ThemeMode _themeMode = ThemeMode.dark;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Açık Tema Renkleri
    const Color lightBackgroundColor = Color(0xFFFAFAFA);
    const Color lightDialogColor = Color(0xFFFFFFFF);
    const Color lightTextColor = Colors.black87;

    // Koyu Tema Renkleri
    const Color darkBackgroundColor = Color(0xFF222831);
    const Color darkDialogColor = Color(0xFF393E46);
    const Color darkTextColor = Color(0xFFE0E0E0);

    return MaterialApp(
      onGenerateTitle: (context) {
        return AppLocalizations.of(context)!.appTitle;
      },
      themeMode: _themeMode,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('tr', ''), // Türkçe
        Locale('en', ''), // İngilizce
        Locale('de', ''), // Almanca
        Locale('fr', ''), // Fransızca
        Locale('es', ''), // İspanyolca
        Locale('ru', ''), // Rusça
        Locale('ar', ''), // Arapça
        Locale('ja', ''), // Japonca
        Locale('zh', ''), // Çince
      ],
      // Açık Tema Tanımı
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: lightBackgroundColor,
          textTheme: GoogleFonts.notoSansTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: lightTextColor, displayColor: lightTextColor),
          dialogTheme: const DialogThemeData(
            backgroundColor: lightDialogColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
          ),
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
      // Koyu Tema Tanımı
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: darkBackgroundColor,
          textTheme:
              GoogleFonts.notoSansTextTheme(Theme.of(context).primaryTextTheme)
                  .apply(bodyColor: darkTextColor, displayColor: darkTextColor),
          dialogTheme: const DialogThemeData(
            backgroundColor: darkDialogColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
          ),
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
