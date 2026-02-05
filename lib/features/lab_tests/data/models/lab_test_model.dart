import 'package:hive/hive.dart';

part 'lab_test_model.g.dart';

@HiveType(typeId: 3)
class LabTestModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String pdfPath;

  @HiveField(2)
  final DateTime addDate;

  LabTestModel({
    required this.name,
    required this.pdfPath,
    required this.addDate,
  });
}
