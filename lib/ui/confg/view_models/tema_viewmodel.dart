import 'package:climtech/data/services/stored_theme.dart';
import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  final StoreThemePreferences prefs;

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeController(this.prefs);

  Future<void> loadTheme() async {
    await prefs.loadTheme();
    _themeMode = prefs.savedTheme;
    notifyListeners();
  }

  Future<void> setTheme(String theme) async {
    await prefs.saveTheme(theme);
    _themeMode = prefs.savedTheme;
    notifyListeners();
  }

  bool isDark(BuildContext context) {
    if (_themeMode == ThemeMode.system) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }
}
