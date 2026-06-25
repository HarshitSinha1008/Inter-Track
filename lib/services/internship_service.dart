import 'package:hive/hive.dart';
import 'package:interntrack/models/internship_models.dart';

class InternshipService {

List<InternshipModel> getAllInternships() {
  final box = Hive.box<InternshipModel>('internships');
  final list = box.values.toList(); // box.value gives you all stored object, .toList() converts it to list
  list.sort((a, b) => b.dateApplied.compareTo(a.dateApplied)); // sort by dateApplied newest first
  return list;
}

Future<void> addInternship(InternshipModel internship) async {
  final box = Hive.box<InternshipModel>('internships');
  return box.put(internship.id, internship);
}

Future<void> updateInternship(InternshipModel internship) async {
  final box = Hive.box<InternshipModel>('internships');
  return box.put(internship.id, internship);
}

Future<void> deleteInternship(String id) async {
    final box = Hive.box<InternshipModel>('internships');
    await box.delete(id);
  }
}