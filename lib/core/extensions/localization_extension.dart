import 'package:flutter/material.dart';
import 'package:form_handling_app/l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get localization => AppLocalizations.of(this)!;

  Locale get currentLocale => Localizations.localeOf(this);
}
