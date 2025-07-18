import 'package:flutter/material.dart';
import 'package:form_handling_app/core/extensions/context_theme_extension.dart';

import '../widgets/job_application_form.dart';

class JobApplicationScreen extends StatelessWidget {
  final void Function(Locale) onLocaleChange;
  final VoidCallback onThemeToggle;
  final Locale locale = const Locale('en');

  const JobApplicationScreen({super.key, required this.onLocaleChange, required this.onThemeToggle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(locale.languageCode == 'fa' ? 'فرم درخواست شغل' : 'Job Application Form'),
        actions: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {
              onLocaleChange(locale.languageCode == 'en' ? const Locale('fa') : const Locale('en'));
            },
            tooltip: locale.languageCode == 'en' ? 'فارسی' : 'English',
          ),
          IconButton(
            icon: Icon(context.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: onThemeToggle,
            tooltip: locale.languageCode == 'fa'
                ? (context.isDark ? 'حالت روشن' : 'حالت تاریک')
                : (context.isDark ? 'Light Mode' : 'Dark Mode'),
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
