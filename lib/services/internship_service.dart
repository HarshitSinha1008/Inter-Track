import 'package:hive/hive.dart';
import 'package:interntrack/models/internship_models.dart';

List<InternshipModel> getAllInternships() {
  final box = Hive.box<InternshipModel>('internships');
  final list = box.values.toList(); // box.value gives you all stored object, .toList() converts it to list
  list.sort((a, b) => b.dateApplied.compareTo(a.dateApplied)); // sort by dateApplied newest first
  return list;
}
