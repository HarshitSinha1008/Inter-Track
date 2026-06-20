import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class InternshipModel extends HiveObject{
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String companyName;
  @HiveField(2)
  final String role;
  @HiveField(3)
  final String status;
  @HiveField(4)
  final DateTime dateApplied;
  @HiveField(5)
  final String notes;

  InternshipModel({
    required this.id,
    required this.companyName,
    required this.role,
    required this.status,
    required this.dateApplied,
    required this.notes
  });
}

class InternshipAdapter extends TypeAdapter<InternshipModel> {
  @override
  final int typeId = 0;

  @override
  InternshipModel read(BinaryReader reader) {
    return InternshipModel(
      id: reader.readString(),
      companyName: reader.readString(),
      role: reader.readString(),
      status: reader.readString(),
      dateApplied: DateTime.parse(reader.readString()),
      notes: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, InternshipModel obj) {
    writer.write(obj.id);
    writer.write(obj.companyName);
    writer.write(obj.role);
    writer.write(obj.status);
    writer.writeString(obj.dateApplied.toIso8601String());
    writer.write(obj.notes);
  }
}