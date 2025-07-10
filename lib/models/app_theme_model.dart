// lib/models/app_theme_model.dart

import 'package:flutter/material.dart';

class AppTheme {
  final String name;
  final Color primaryColor; // Ana vurgu rengi
  final Color lightBackgroundColor;
  final Color lightCardColor;
  final Color darkBackgroundColor;
  final Color darkCardColor;

  const AppTheme({
    required this.name,
    required this.primaryColor,
    required this.lightBackgroundColor,
    required this.lightCardColor,
    required this.darkBackgroundColor,
    required this.darkCardColor,
  });

  // Uygulamamızda sunacağımız temaların listesi
  static List<AppTheme> themeList = [
    // Varsayılan Mavi Tema
    const AppTheme(
      name: 'Default Blue',
      primaryColor: Colors.blueAccent,
      lightBackgroundColor: Color(0xFFFAFAFA),
      lightCardColor: Color(0xFFE8E8E8),
      darkBackgroundColor: Color(0xFF222831),
      darkCardColor: Color(0xFF393E46),
    ),
    // Yeşil Tema
    const AppTheme(
      name: 'Emerald Green',
      primaryColor: Colors.teal,
      lightBackgroundColor: Color.fromARGB(255, 247, 255, 248),
      lightCardColor: Color(0xFFDCFCE7),
      darkBackgroundColor: Color(0xFF042f2e),
      darkCardColor: Color(0xFF024c48),
    ),
    // Kırmızı/Pembe Tema
    const AppTheme(
      name: 'Rose Pink',
      primaryColor: Colors.pinkAccent,
      lightBackgroundColor: Color.fromARGB(255, 255, 248, 248),
      lightCardColor: Color(0xFFFCE7F3),
      darkBackgroundColor: Color.fromARGB(255, 116, 14, 45),
      darkCardColor: Color(0xFF831843),
    ),
    // Mor Tema
    const AppTheme(
      name: 'Deep Purple',
      primaryColor: Colors.deepPurple,
      lightBackgroundColor: Color.fromARGB(255, 250, 249, 255),
      lightCardColor: Color(0xFFEDE9FE),
      darkBackgroundColor: Color(0xFF2a224a),
      darkCardColor: Color(0xFF3c316e),
    ),
  ];
}
