import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fa'),
  ];

  /// No description provided for @jobApplicationForm.
  ///
  /// In en, this message translates to:
  /// **'Job Application Form'**
  String get jobApplicationForm;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @fileMustBeLessThan2MG.
  ///
  /// In en, this message translates to:
  /// **'File must be less than 2MB'**
  String get fileMustBeLessThan2MG;

  /// No description provided for @emailExists.
  ///
  /// In en, this message translates to:
  /// **'This email already exists'**
  String get emailExists;

  /// No description provided for @pleaseUploadYourResume.
  ///
  /// In en, this message translates to:
  /// **'Please upload your resume'**
  String get pleaseUploadYourResume;

  /// No description provided for @formSubmittedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Form submitted successfully!'**
  String get formSubmittedSuccessfully;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @fullNameIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is requried'**
  String get fullNameIsRequired;

  /// No description provided for @atLeast3Characters.
  ///
  /// In en, this message translates to:
  /// **'At least 3 characters'**
  String get atLeast3Characters;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is requried'**
  String get emailIsRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @phoneIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone is required'**
  String get phoneIsRequired;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @dateOfBirthIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Date of birth is required'**
  String get dateOfBirthIsRequired;

  /// No description provided for @currentlyEmployed.
  ///
  /// In en, this message translates to:
  /// **'Currently Employed'**
  String get currentlyEmployed;

  /// No description provided for @currentJobTitle.
  ///
  /// In en, this message translates to:
  /// **'Current Job Title'**
  String get currentJobTitle;

  /// No description provided for @jobTitle.
  ///
  /// In en, this message translates to:
  /// **'Job Title'**
  String get jobTitle;

  /// No description provided for @jobTitleIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Job title is required'**
  String get jobTitleIsRequired;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @startDateIsRequried.
  ///
  /// In en, this message translates to:
  /// **'Start date is requried'**
  String get startDateIsRequried;

  /// No description provided for @endtDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endtDate;

  /// No description provided for @endDateIsRequried.
  ///
  /// In en, this message translates to:
  /// **'End date is requried'**
  String get endDateIsRequried;

  /// No description provided for @previousJobs.
  ///
  /// In en, this message translates to:
  /// **'Previous Jobs'**
  String get previousJobs;

  /// No description provided for @previousJob.
  ///
  /// In en, this message translates to:
  /// **'Previous Job'**
  String get previousJob;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @genderIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Gender is requried'**
  String get genderIsRequired;

  /// No description provided for @skills.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get skills;

  /// No description provided for @selectAtLeastOneSkill.
  ///
  /// In en, this message translates to:
  /// **'Select at least one skill'**
  String get selectAtLeastOneSkill;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available?'**
  String get available;

  /// No description provided for @uploadPDF.
  ///
  /// In en, this message translates to:
  /// **'Upload Resume (PDF, <2MB)'**
  String get uploadPDF;

  /// No description provided for @pickFile.
  ///
  /// In en, this message translates to:
  /// **'Pick File'**
  String get pickFile;

  /// No description provided for @saveAsDraft.
  ///
  /// In en, this message translates to:
  /// **'Save as Draft'**
  String get saveAsDraft;

  /// No description provided for @loadAsDraft.
  ///
  /// In en, this message translates to:
  /// **'Load as Draft'**
  String get loadAsDraft;

  /// No description provided for @resset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resset;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @draftSaved.
  ///
  /// In en, this message translates to:
  /// **'Draft saved'**
  String get draftSaved;

  /// No description provided for @fixErrors.
  ///
  /// In en, this message translates to:
  /// **'Please fix the errors'**
  String get fixErrors;

  /// No description provided for @currentCompany.
  ///
  /// In en, this message translates to:
  /// **'Current Company'**
  String get currentCompany;

  /// No description provided for @companyIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Company is required'**
  String get companyIsRequired;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @street.
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get street;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @zipCode.
  ///
  /// In en, this message translates to:
  /// **'Zip Code'**
  String get zipCode;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
