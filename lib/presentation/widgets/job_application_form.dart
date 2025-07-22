import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:form_handling_app/core/extensions/context_theme_extension.dart';
import 'package:form_handling_app/core/extensions/localization_extension.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/job_application.dart';
import '../../data/previous_job.dart';
import 'address_form.dart';
import 'previuse_job_form.dart';

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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.localization.draftSaved)));
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
          _resumeError = context.localization.fileMustBeLessThan2MG;
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
      locale: context.currentLocale,
    );
    if (picked != null) {
      controller.text = DateFormat.yMd(context.currentLocale).format(picked);
    }
  }

  // Form submission
  Future<void> _submit() async {
    setState(() {
      _emailError = null;
    });
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.localization.fixErrors)));
      return;
    }
    setState(() {
      _emailChecking = true;
    });
    final emailExists = await _checkEmailExists(_emailController.text);
    setState(() {
      _emailChecking = false;
      _emailError = emailExists ? context.localization.emailExists : null;
    });
    if (emailExists) {
      _formKey.currentState!.validate();
      return;
    }
    if (_resumePath == null) {
      setState(() {
        _resumeError = context.localization.pleaseUploadYourResume;
      });
      return;
    }
    // All good
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.localization.formSubmittedSuccessfully)));
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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Full Name
          TextFormField(
            controller: _fullNameController,
            decoration: InputDecoration(labelText: context.localization.fullName),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return context.localization.fullNameIsRequired;
              }
              if (v.trim().length < 3) {
                return context.localization.atLeast3Characters;
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
              labelText: context.localization.email,
              suffixIcon: _emailChecking
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : null,
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return context.localization.emailIsRequired;
              }
              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
              if (!emailRegex.hasMatch(v.trim())) {
                return context.localization.invalidEmail;
              }
              if (_emailError != null) return _emailError;
              return null;
            },
          ),
          const SizedBox(height: 12),
          // Phone
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(labelText: context.localization.phone),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          // Date of Birth
          TextFormField(
            controller: _dobController,
            decoration: InputDecoration(
              labelText: context.localization.dateOfBirth,
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _pickDate(_dobController),
              ),
            ),
            readOnly: true,
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return context.localization.emailIsRequired;
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
          ),
          const SizedBox(height: 16),
          // Currently Employed
          CheckboxListTile(
            value: _currentlyEmployed,
            onChanged: (v) => setState(() => _currentlyEmployed = v ?? false),
            title: Text(context.localization.currentlyEmployed),
          ),
          if (_currentlyEmployed)
            Column(
              children: [
                TextFormField(
                  controller: _currentCompanyController,
                  decoration: InputDecoration(labelText: context.localization.currentCompany),
                  validator: (v) {
                    if (_currentlyEmployed && (v == null || v.trim().isEmpty)) {
                      return context.localization.companyIsRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _currentJobTitleController,
                  decoration: InputDecoration(labelText: context.localization.jobTitle),
                  validator: (v) {
                    if (_currentlyEmployed && (v == null || v.trim().isEmpty)) {
                      return context.localization.jobTitleIsRequired;
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
                          labelText: context.localization.startDate,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _pickDate(_currentStartController),
                          ),
                        ),
                        readOnly: true,
                        validator: (v) {
                          if (_currentlyEmployed && (v == null || v.trim().isEmpty)) {
                            return context.localization.startDateIsRequried;
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
                          labelText: context.localization.endtDate,
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
              Text(context.localization.previousJobs, style: context.textTheme.titleMedium),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: Text(context.localization.add),
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

              onRemove: () {
                setState(() {
                  _previousJobs.removeAt(idx);
                });
              },
            );
          }),
          const SizedBox(height: 16),
          // Gender
          Text(context.localization.gender),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  value: 'male',
                  groupValue: _gender,
                  onChanged: (v) => setState(() => _gender = v ?? ''),
                  title: Text(context.localization.male),
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  value: 'female',
                  groupValue: _gender,
                  onChanged: (v) => setState(() => _gender = v ?? ''),
                  title: Text(context.localization.female),
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  value: 'other',
                  groupValue: _gender,
                  onChanged: (v) => setState(() => _gender = v ?? ''),
                  title: Text(context.localization.other),
                ),
              ),
            ],
          ),
          if (_gender.isEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: Text(context.localization.genderIsRequired, style: context.errorTextStyle),
            ),
          // Skills
          Text(context.localization.skills),
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
              child: Text(context.localization.selectAtLeastOneSkill, style: context.errorTextStyle),
            ),
          // Availability
          SwitchListTile(
            value: _available,
            onChanged: (v) => setState(() => _available = v),
            title: Text(context.localization.available),
          ),
          // Resume upload
          ListTile(
            title: Text(context.localization.uploadPDF),
            subtitle: _resumePath != null ? Text(_resumePath!) : null,
            trailing: ElevatedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: Text(context.localization.pickFile),
              onPressed: _pickResume,
            ),
          ),
          if (_resumeError != null)
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: Text(_resumeError!, style: context.errorTextStyle),
            ),
          const SizedBox(height: 24),
          // Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(onPressed: _saveDraft, child: Text(context.localization.saveAsDraft)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(onPressed: _resetForm, child: Text(context.localization.resset)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(onPressed: _submit, child: Text(context.localization.submit)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Load draft button
          TextButton(onPressed: _loadDraft, child: Text(context.localization.loadAsDraft)),
        ],
      ),
    );
  }
}
