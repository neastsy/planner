import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:gunluk_planlayici/models/app_theme_model.dart';

class SettingsProvider with ChangeNotifier {
  final Box _settingsBox;
  static const String _themeModeKey = 'themeMode';
  static const String _localeKey = 'locale';
  static const String _themeNameKey = 'themeName';
  static const String _useAmoledThemeKey = 'useAmoledTheme';

  ThemeMode _themeMode = ThemeMode.dark;
  Locale? _locale;
  AppTheme _appTheme = AppTheme.themeList.first;
  bool _useAmoledTheme = false;

  SettingsProvider(this._settingsBox) {
    _loadSettings();
  }

  // Dışarıdan erişim için getter'lar
  ThemeMode get themeMode => _themeMode;
  Locale? get locale => _locale;
  AppTheme get appTheme => _appTheme;
  bool get useAmoledTheme => _useAmoledTheme;

  void _loadSettings() {
    // Açık/Koyu modunu yükle
    final themeIndex = _settingsBox.get(_themeModeKey,
        defaultValue: ThemeMode.dark.index) as int;
    _themeMode = ThemeMode.values[themeIndex];

    // Dili yükle. Kayıtlı değer olabilir veya olmayabilir.
    final languageCode = _settingsBox.get(_localeKey) as String?;
    if (languageCode != null) {
      _locale = Locale(languageCode);
    }

    final themeName = _settingsBox.get(_themeNameKey,
        defaultValue: AppTheme.themeList.first.name) as String;
    _appTheme = AppTheme.themeList.firstWhere((t) => t.name == themeName,
        orElse: () => AppTheme.themeList.first);

    _useAmoledTheme =
        _settingsBox.get(_useAmoledThemeKey, defaultValue: false) as bool;
  }

  Future<void> changeThemeMode(ThemeMode newMode) async {
    if (_themeMode == newMode) return;
    _themeMode = newMode;
    // DÜZELTME: Doğru değişken adını kullanıyoruz
    await _settingsBox.put(_themeModeKey, newMode.index);
    notifyListeners();
  }

  // Renk temasını değiştirir
  Future<void> changeAppTheme(AppTheme newTheme) async {
    if (_appTheme.name == newTheme.name) return;
    _appTheme = newTheme;
    await _settingsBox.put(_themeNameKey, newTheme.name);
    notifyListeners();
  }

  // Dili değiştirir
  Future<void> changeLocale(Locale newLocale) async {
    if (_locale == newLocale) return;
    _locale = newLocale;
    await _settingsBox.put(_localeKey, newLocale.languageCode);
    notifyListeners();
  }

  Future<void> changeAmoledTheme(bool newValue) async {
    if (_useAmoledTheme == newValue) return;
    _useAmoledTheme = newValue;
    await _settingsBox.put(_useAmoledThemeKey, newValue);
    notifyListeners();
  }
}
