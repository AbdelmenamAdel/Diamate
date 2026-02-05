import 'package:hive/hive.dart';

part 'dfu_test_model.g.dart';

@HiveType(typeId: 5)
class DfuTestModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final List<String> imagePaths;

  @HiveField(2)
  final DateTime addDate;

  DfuTestModel({
    required this.name,
    required this.imagePaths,
    required this.addDate,
  });
}
