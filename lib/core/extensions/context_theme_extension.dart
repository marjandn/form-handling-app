import 'package:flutter/material.dart';

extension ContextThemeExtension on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  ThemeMode get theme => Theme.of(this).brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
  bool get isDark => theme == ThemeMode.dark;
}

extension TextThemeExtension on BuildContext {
  TextStyle get errorTextStyle => textTheme.bodyMedium!.copyWith(color: colorScheme.error);
}
