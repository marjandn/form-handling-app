import 'package:flutter/material.dart';

import '../widgets/job_application_form.dart';

class JobApplicationScreen extends StatelessWidget {
  final void Function(Locale) onLocaleChange;
  final VoidCallback onThemeToggle;
  final bool isDark;
  final Locale locale;
  const JobApplicationScreen({
    super.key,
    required this.onLocaleChange,
    required this.onThemeToggle,
    required this.isDark,
    required this.locale,
  });

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
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: onThemeToggle,
            tooltip: locale.languageCode == 'fa'
                ? (isDark ? 'حالت روشن' : 'حالت تاریک')
                : (isDark ? 'Light Mode' : 'Dark Mode'),
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
