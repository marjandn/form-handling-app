import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_handling_app/core/config/app_settings.dart';
import 'package:form_handling_app/l10n/app_localizations.dart';
import 'presentation/screen/job_application_form_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final appSettings = AppSettings();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appSettings,
      builder: (context, widget) {
        return MaterialApp(
          title: 'Job Application',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber, brightness: Brightness.light),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.amberAccent, brightness: Brightness.dark),
          ),
          themeMode: appSettings.theme,
          locale: appSettings.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          debugShowCheckedModeBanner: false,
          home: JobApplicationScreen(
            onLocaleChange: appSettings.setLocale,
            onThemeToggle: appSettings.toggleTheme,
          ),
        );
      },
    );
  }
}
