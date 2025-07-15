import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:ui' as ui;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');
  ThemeMode _themeMode = ThemeMode.system;

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Application',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      locale: _locale,
      supportedLocales: const [Locale('en'), Locale('fa')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: JobApplicationScreen(
        onLocaleChange: _setLocale,
        onThemeToggle: _toggleTheme,
        isDark: _themeMode == ThemeMode.dark,
        locale: _locale,
      ),
    );
  }
}

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

// --- Form Model ---
class JobApplication {
  String fullName = '';
  String email = '';
  String phone = '';
  DateTime? dob;
  Address address = Address();
  bool currentlyEmployed = false;
  String currentCompany = '';
  String currentJobTitle = '';
  DateTime? currentStart;
  DateTime? currentEnd;
  List<PreviousJob> previousJobs = [];
  String gender = '';
  List<String> skills = [];
  bool available = false;
  String? resumePath;
}

class Address {
  String street = '';
  String city = '';
  String state = '';
  String zip = '';
}

class PreviousJob {
  String jobTitle = '';
  String company = '';
  DateTime? start;
  DateTime? end;
  String description = '';
}

// --- Main Form Widget ---
class JobApplicationForm extends StatefulWidget {
  const JobApplicationForm({super.key});
  @override
  State<JobApplicationForm> createState() => _JobApplicationFormState();
}

class _JobApplicationFormState extends State<JobApplicationForm> {
  final _formKey = GlobalKey<FormState>();
  final _model = JobApplication();

  // Controllers
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _currentCompanyController = TextEditingController();
  final _currentJobTitleController = TextEditingController();
  final _currentStartController = TextEditingController();
  final _currentEndController = TextEditingController();

  // Address controllers
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();

  // Focus nodes (optional, for advanced UX)
  final _emailFocus = FocusNode();

  // Async email validation
  bool _emailChecking = false;
  String? _emailError;

  // Previous jobs
  List<PreviousJob> _previousJobs = [];

  // Gender
  String _gender = '';

  // Skills
  final List<String> _allSkills = ['Dart', 'Flutter', 'Firebase', 'REST', 'UI/UX', 'Other'];
  List<String> _selectedSkills = [];

  // Availability
  bool _available = false;

  // Resume
  String? _resumePath;
  int? _resumeSize;
  String? _resumeError;

  // Currently employed
  bool _currentlyEmployed = false;

  // Current employment duration
  DateTime? _currentStart;
  DateTime? _currentEnd;

  // Localization
  Locale get _locale => Localizations.localeOf(context);

  // Save as draft
  Future<void> _saveDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('job_form_fullName', _fullNameController.text);
    await prefs.setString('job_form_email', _emailController.text);
    await prefs.setString('job_form_phone', _phoneController.text);
    await prefs.setString('job_form_dob', _dobController.text);
    await prefs.setString('job_form_street', _streetController.text);
    await prefs.setString('job_form_city', _cityController.text);
    await prefs.setString('job_form_state', _stateController.text);
    await prefs.setString('job_form_zip', _zipController.text);
    await prefs.setBool('job_form_currentlyEmployed', _currentlyEmployed);
    await prefs.setString('job_form_currentCompany', _currentCompanyController.text);
    await prefs.setString('job_form_currentJobTitle', _currentJobTitleController.text);
    await prefs.setString('job_form_currentStart', _currentStartController.text);
    await prefs.setString('job_form_currentEnd', _currentEndController.text);
    await prefs.setStringList(
      'job_form_previousJobs',
      _previousJobs
          .map(
            (j) =>
                '${j.jobTitle}|${j.company}|${j.start?.toIso8601String() ?? ''}|${j.end?.toIso8601String() ?? ''}|${j.description}',
          )
          .toList(),
    );
    await prefs.setString('job_form_gender', _gender);
    await prefs.setStringList('job_form_skills', _selectedSkills);
    await prefs.setBool('job_form_available', _available);
    await prefs.setString('job_form_resumePath', _resumePath ?? '');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_locale.languageCode == 'fa' ? 'پیش‌نویس ذخیره شد' : 'Draft saved')),
    );
  }

  // Load draft
  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullNameController.text = prefs.getString('job_form_fullName') ?? '';
      _emailController.text = prefs.getString('job_form_email') ?? '';
      _phoneController.text = prefs.getString('job_form_phone') ?? '';
      _dobController.text = prefs.getString('job_form_dob') ?? '';
      _streetController.text = prefs.getString('job_form_street') ?? '';
      _cityController.text = prefs.getString('job_form_city') ?? '';
      _stateController.text = prefs.getString('job_form_state') ?? '';
      _zipController.text = prefs.getString('job_form_zip') ?? '';
      _currentlyEmployed = prefs.getBool('job_form_currentlyEmployed') ?? false;
      _currentCompanyController.text = prefs.getString('job_form_currentCompany') ?? '';
      _currentJobTitleController.text = prefs.getString('job_form_currentJobTitle') ?? '';
      _currentStartController.text = prefs.getString('job_form_currentStart') ?? '';
      _currentEndController.text = prefs.getString('job_form_currentEnd') ?? '';
      _previousJobs = (prefs.getStringList('job_form_previousJobs') ?? []).map((s) {
        final parts = s.split('|');
        return PreviousJob()
          ..jobTitle = parts[0]
          ..company = parts[1]
          ..start = parts[2].isNotEmpty ? DateTime.tryParse(parts[2]) : null
          ..end = parts[3].isNotEmpty ? DateTime.tryParse(parts[3]) : null
          ..description = parts.length > 4 ? parts[4] : '';
      }).toList();
      _gender = prefs.getString('job_form_gender') ?? '';
      _selectedSkills = prefs.getStringList('job_form_skills') ?? [];
      _available = prefs.getBool('job_form_available') ?? false;
      _resumePath = prefs.getString('job_form_resumePath');
    });
  }

  // Reset form
  void _resetForm() {
    _formKey.currentState?.reset();
    _fullNameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _dobController.clear();
    _streetController.clear();
    _cityController.clear();
    _stateController.clear();
    _zipController.clear();
    _currentlyEmployed = false;
    _currentCompanyController.clear();
    _currentJobTitleController.clear();
    _currentStartController.clear();
    _currentEndController.clear();
    _previousJobs.clear();
    _gender = '';
    _selectedSkills.clear();
    _available = false;
    _resumePath = null;
    _resumeError = null;
    setState(() {});
  }

  // Email async validation simulation
  Future<bool> _checkEmailExists(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    // Simulate: emails ending with "test.com" already exist
    return email.endsWith('test.com');
  }

  // Resume picker
  Future<void> _pickResume() async {
    setState(() {
      _resumeError = null;
    });
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );
    if (result != null && result.files.single.bytes != null) {
      final file = result.files.single;
      if (file.size > 2 * 1024 * 1024) {
        setState(() {
          _resumeError = _locale.languageCode == 'fa'
              ? 'فایل باید کمتر از ۲ مگابایت باشد'
              : 'File must be less than 2MB';
        });
        return;
      }
      setState(() {
        _resumePath = file.path;
        _resumeSize = file.size;
      });
    }
  }

  // Date picker helper
  Future<void> _pickDate(TextEditingController controller, {DateTime? initialDate}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: _locale,
    );
    if (picked != null) {
      controller.text = DateFormat.yMd(_locale.languageCode).format(picked);
    }
  }

  // Form submission
  Future<void> _submit() async {
    setState(() {
      _emailError = null;
    });
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_locale.languageCode == 'fa' ? 'لطفاً خطاها را برطرف کنید' : 'Please fix the errors'),
        ),
      );
      return;
    }
    setState(() {
      _emailChecking = true;
    });
    final emailExists = await _checkEmailExists(_emailController.text);
    setState(() {
      _emailChecking = false;
      _emailError = emailExists
          ? (_locale.languageCode == 'fa' ? 'این ایمیل قبلاً ثبت شده است' : 'This email already exists')
          : null;
    });
    if (emailExists) {
      _formKey.currentState!.validate();
      return;
    }
    if (_resumePath == null) {
      setState(() {
        _resumeError = _locale.languageCode == 'fa'
            ? 'لطفاً رزومه را بارگذاری کنید'
            : 'Please upload your resume';
      });
      return;
    }
    // All good
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _locale.languageCode == 'fa' ? 'فرم با موفقیت ارسال شد!' : 'Form submitted successfully!',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _currentCompanyController.dispose();
    _currentJobTitleController.dispose();
    _currentStartController.dispose();
    _currentEndController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFa = _locale.languageCode == 'fa';
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Full Name
          TextFormField(
            controller: _fullNameController,
            decoration: InputDecoration(labelText: isFa ? 'نام کامل' : 'Full Name'),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return isFa ? 'نام الزامی است' : 'Full name is required';
              }
              if (v.trim().length < 3) {
                return isFa ? 'حداقل ۳ کاراکتر' : 'At least 3 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          // Email
          TextFormField(
            controller: _emailController,
            focusNode: _emailFocus,
            decoration: InputDecoration(
              labelText: isFa ? 'ایمیل' : 'Email',
              suffixIcon: _emailChecking
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : null,
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return isFa ? 'ایمیل الزامی است' : 'Email is required';
              }
              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
              if (!emailRegex.hasMatch(v.trim())) {
                return isFa ? 'ایمیل معتبر نیست' : 'Invalid email';
              }
              if (_emailError != null) return _emailError;
              return null;
            },
          ),
          const SizedBox(height: 12),
          // Phone
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(labelText: isFa ? 'تلفن' : 'Phone'),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          // Date of Birth
          TextFormField(
            controller: _dobController,
            decoration: InputDecoration(
              labelText: isFa ? 'تاریخ تولد' : 'Date of Birth',
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _pickDate(_dobController),
              ),
            ),
            readOnly: true,
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return isFa ? 'تاریخ تولد الزامی است' : 'Date of birth is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Address group
          AddressForm(
            streetController: _streetController,
            cityController: _cityController,
            stateController: _stateController,
            zipController: _zipController,
            locale: _locale,
          ),
          const SizedBox(height: 16),
          // Currently Employed
          CheckboxListTile(
            value: _currentlyEmployed,
            onChanged: (v) => setState(() => _currentlyEmployed = v ?? false),
            title: Text(isFa ? 'در حال حاضر شاغل هستم' : 'Currently Employed'),
          ),
          if (_currentlyEmployed)
            Column(
              children: [
                TextFormField(
                  controller: _currentCompanyController,
                  decoration: InputDecoration(labelText: isFa ? 'شرکت فعلی' : 'Current Company'),
                  validator: (v) {
                    if (_currentlyEmployed && (v == null || v.trim().isEmpty)) {
                      return isFa ? 'شرکت الزامی است' : 'Company required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _currentJobTitleController,
                  decoration: InputDecoration(labelText: isFa ? 'عنوان شغلی فعلی' : 'Current Job Title'),
                  validator: (v) {
                    if (_currentlyEmployed && (v == null || v.trim().isEmpty)) {
                      return isFa ? 'عنوان شغلی الزامی است' : 'Job title required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _currentStartController,
                        decoration: InputDecoration(
                          labelText: isFa ? 'تاریخ شروع' : 'Start Date',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _pickDate(_currentStartController),
                          ),
                        ),
                        readOnly: true,
                        validator: (v) {
                          if (_currentlyEmployed && (v == null || v.trim().isEmpty)) {
                            return isFa ? 'تاریخ شروع الزامی است' : 'Start date required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _currentEndController,
                        decoration: InputDecoration(
                          labelText: isFa ? 'تاریخ پایان' : 'End Date',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _pickDate(_currentEndController),
                          ),
                        ),
                        readOnly: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          const SizedBox(height: 16),
          // Previous Jobs
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isFa ? 'سوابق شغلی قبلی' : 'Previous Jobs',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: Text(isFa ? 'افزودن' : 'Add'),
                onPressed: () {
                  setState(() {
                    _previousJobs.add(PreviousJob());
                  });
                },
              ),
            ],
          ),
          ..._previousJobs.asMap().entries.map((entry) {
            final idx = entry.key;
            final job = entry.value;
            return PreviousJobForm(
              key: ValueKey('prevjob$idx'),
              job: job,
              locale: _locale,
              onRemove: () {
                setState(() {
                  _previousJobs.removeAt(idx);
                });
              },
            );
          }),
          const SizedBox(height: 16),
          // Gender
          Text(isFa ? 'جنسیت' : 'Gender'),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  value: 'male',
                  groupValue: _gender,
                  onChanged: (v) => setState(() => _gender = v ?? ''),
                  title: Text(isFa ? 'مرد' : 'Male'),
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  value: 'female',
                  groupValue: _gender,
                  onChanged: (v) => setState(() => _gender = v ?? ''),
                  title: Text(isFa ? 'زن' : 'Female'),
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  value: 'other',
                  groupValue: _gender,
                  onChanged: (v) => setState(() => _gender = v ?? ''),
                  title: Text(isFa ? 'دیگر' : 'Other'),
                ),
              ),
            ],
          ),
          if (_gender.isEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: Text(
                isFa ? 'جنسیت الزامی است' : 'Gender is required',
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          // Skills
          Text(isFa ? 'مهارت‌ها' : 'Skills'),
          Wrap(
            spacing: 8,
            children: _allSkills.map((skill) {
              final selected = _selectedSkills.contains(skill);
              return FilterChip(
                label: Text(skill),
                selected: selected,
                onSelected: (v) {
                  setState(() {
                    if (v) {
                      _selectedSkills.add(skill);
                    } else {
                      _selectedSkills.remove(skill);
                    }
                  });
                },
              );
            }).toList(),
          ),
          if (_selectedSkills.isEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: Text(
                isFa ? 'حداقل یک مهارت را انتخاب کنید' : 'Select at least one skill',
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          // Availability
          SwitchListTile(
            value: _available,
            onChanged: (v) => setState(() => _available = v),
            title: Text(isFa ? 'آیا در دسترس هستید؟' : 'Available?'),
          ),
          // Resume upload
          ListTile(
            title: Text(isFa ? 'بارگذاری رزومه (PDF, <۲MB)' : 'Upload Resume (PDF, <2MB)'),
            subtitle: _resumePath != null ? Text(_resumePath!) : null,
            trailing: ElevatedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: Text(isFa ? 'انتخاب فایل' : 'Pick File'),
              onPressed: _pickResume,
            ),
          ),
          if (_resumeError != null)
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: Text(_resumeError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
            ),
          const SizedBox(height: 24),
          // Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveDraft,
                  child: Text(isFa ? 'ذخیره پیش‌نویس' : 'Save as Draft'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(onPressed: _resetForm, child: Text(isFa ? 'بازنشانی' : 'Reset')),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(onPressed: _submit, child: Text(isFa ? 'ارسال' : 'Submit')),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Load draft button
          TextButton(onPressed: _loadDraft, child: Text(isFa ? 'بارگذاری پیش‌نویس' : 'Load Draft')),
        ],
      ),
    );
  }
}

// --- Address Form Widget ---
class AddressForm extends StatelessWidget {
  final TextEditingController streetController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController zipController;
  final Locale locale;
  const AddressForm({
    super.key,
    required this.streetController,
    required this.cityController,
    required this.stateController,
    required this.zipController,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final isFa = locale.languageCode == 'fa';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(isFa ? 'آدرس' : 'Address', style: Theme.of(context).textTheme.titleMedium),
        TextFormField(
          controller: streetController,
          decoration: InputDecoration(labelText: isFa ? 'خیابان' : 'Street'),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: cityController,
                decoration: InputDecoration(labelText: isFa ? 'شهر' : 'City'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: stateController,
                decoration: InputDecoration(labelText: isFa ? 'استان' : 'State'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: zipController,
                decoration: InputDecoration(labelText: isFa ? 'کد پستی' : 'ZIP Code'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// --- Previous Job Form Widget ---
class PreviousJobForm extends StatefulWidget {
  final PreviousJob job;
  final Locale locale;
  final VoidCallback onRemove;
  const PreviousJobForm({super.key, required this.job, required this.locale, required this.onRemove});

  @override
  State<PreviousJobForm> createState() => _PreviousJobFormState();
}

class _PreviousJobFormState extends State<PreviousJobForm> {
  late TextEditingController _jobTitleController;
  late TextEditingController _companyController;
  late TextEditingController _startController;
  late TextEditingController _endController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _jobTitleController = TextEditingController(text: widget.job.jobTitle);
    _companyController = TextEditingController(text: widget.job.company);
    _startController = TextEditingController(
      text: widget.job.start != null
          ? DateFormat.yMd(widget.locale.languageCode).format(widget.job.start!)
          : '',
    );
    _endController = TextEditingController(
      text: widget.job.end != null ? DateFormat.yMd(widget.locale.languageCode).format(widget.job.end!) : '',
    );
    _descController = TextEditingController(text: widget.job.description);
  }

  @override
  void dispose() {
    _jobTitleController.dispose();
    _companyController.dispose();
    _startController.dispose();
    _endController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2015),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: widget.locale,
    );
    if (picked != null) {
      controller.text = DateFormat.yMd(widget.locale.languageCode).format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFa = widget.locale.languageCode == 'fa';
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text(isFa ? 'شغل قبلی' : 'Previous Job')),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: widget.onRemove,
                  tooltip: isFa ? 'حذف' : 'Remove',
                ),
              ],
            ),
            TextFormField(
              controller: _jobTitleController,
              decoration: InputDecoration(labelText: isFa ? 'عنوان شغلی' : 'Job Title'),
              onChanged: (v) => widget.job.jobTitle = v,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _companyController,
              decoration: InputDecoration(labelText: isFa ? 'شرکت' : 'Company'),
              onChanged: (v) => widget.job.company = v,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _startController,
                    decoration: InputDecoration(
                      labelText: isFa ? 'تاریخ شروع' : 'Start Date',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _pickDate(_startController),
                      ),
                    ),
                    readOnly: true,
                    onChanged: (v) {
                      widget.job.start = DateFormat.yMd(widget.locale.languageCode).parse(v);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _endController,
                    decoration: InputDecoration(
                      labelText: isFa ? 'تاریخ پایان' : 'End Date',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _pickDate(_endController),
                      ),
                    ),
                    readOnly: true,
                    onChanged: (v) {
                      widget.job.end = DateFormat.yMd(widget.locale.languageCode).parse(v);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descController,
              decoration: InputDecoration(labelText: isFa ? 'توضیحات' : 'Description'),
              onChanged: (v) => widget.job.description = v,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
