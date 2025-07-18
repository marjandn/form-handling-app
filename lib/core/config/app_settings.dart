import 'package:flutter/material.dart';

class AppSettings extends ChangeNotifier {
  var _locale = Locale('en');

  Locale get locale => _locale;

  var _theme = ThemeMode.system;
  ThemeMode get theme => _theme;

  void toggleTheme() {
    _theme = _theme == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
