import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  Locale? _locale;

  // Dışarıdan erişim için getter'lar
  ThemeMode get themeMode => _themeMode;
  Locale? get locale => _locale;

  /// Temayı değiştiren ve dinleyicileri bilgilendiren metot.
  void changeTheme(ThemeMode newMode) {
    if (_themeMode == newMode) return; // Değişiklik yoksa bir şey yapma
    _themeMode = newMode;
    notifyListeners();
  }

  /// Dili değiştiren ve dinleyicileri bilgilendiren metot.
  void changeLocale(Locale newLocale) {
    if (_locale == newLocale) return; // Değişiklik yoksa bir şey yapma
    _locale = newLocale;
    notifyListeners();
  }
}
