import 'package:flutter/material.dart';

extension ContextThemeExtension on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
}

extension TextThemeExtension on BuildContext {
  TextStyle get errorTextStyle => textTheme.bodyMedium!.copyWith(color: colorScheme.error);
}
