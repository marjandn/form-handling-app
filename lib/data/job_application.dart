import 'address.dart';
import 'previous_job.dart';

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
