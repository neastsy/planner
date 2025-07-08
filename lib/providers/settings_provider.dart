import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsProvider with ChangeNotifier {
  final Box _settingsBox;
  static const String _themeKey = 'themeMode';
  static const String _localeKey = 'locale';

  ThemeMode _themeMode = ThemeMode.dark; // Varsayılan değer
  Locale? _locale;

  SettingsProvider(this._settingsBox) {
    _loadSettings();
  }

  // Dışarıdan erişim için getter'lar
  ThemeMode get themeMode => _themeMode;
  Locale? get locale => _locale;

  void _loadSettings() {
    // Temayı yükle. Kayıtlı değer yoksa, varsayılan olarak dark temanın index'ini kullan.
    final themeIndex =
        _settingsBox.get(_themeKey, defaultValue: ThemeMode.dark.index) as int;
    _themeMode = ThemeMode.values[themeIndex];

    // Dili yükle. Kayıtlı değer olabilir veya olmayabilir.
    final languageCode = _settingsBox.get(_localeKey) as String?;
    if (languageCode != null) {
      _locale = Locale(languageCode);
    }
  }

  Future<void> changeTheme(ThemeMode newMode) async {
    if (_themeMode == newMode) return;
    _themeMode = newMode;
    // Enum'ın index'ini saklamak verimlidir.
    await _settingsBox.put(_themeKey, newMode.index);
    notifyListeners();
  }

  /// GÜNCELLENDİ: Dili değiştirir, Hive'a kaydeder ve dinleyicileri bilgilendirir.
  Future<void> changeLocale(Locale newLocale) async {
    if (_locale == newLocale) return;
    _locale = newLocale;
    // Locale'in dil kodunu (örn: "en", "tr") saklamak yeterlidir.
    await _settingsBox.put(_localeKey, newLocale.languageCode);
    notifyListeners();
  }
}
