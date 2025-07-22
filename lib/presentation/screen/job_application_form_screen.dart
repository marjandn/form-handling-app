import 'package:flutter/material.dart';
import 'package:form_handling_app/core/extensions/context_theme_extension.dart';
import 'package:form_handling_app/core/extensions/localization_extension.dart';

import '../widgets/job_application_form.dart';

class JobApplicationScreen extends StatelessWidget {
  final void Function(Locale) onLocaleChange;
  final VoidCallback onThemeToggle;

  const JobApplicationScreen({super.key, required this.onLocaleChange, required this.onThemeToggle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.localization.jobApplicationForm),
        actions: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {
              onLocaleChange(
                context.localization.localeName == 'en' ? const Locale('fa') : const Locale('en'),
              );
            },
            tooltip: context.localization.localeName,
          ),
          IconButton(
            icon: Icon(context.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: onThemeToggle,
            tooltip: context.isDark ? context.localization.lightMode : context.localization.darkMode,
          ),
        ],
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.all(16), child: JobApplicationForm()),
        ),
      ),
    );
  }
}
