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

  @HiveField(3)
  final bool? ulcerDetected;

  @HiveField(4)
  final double? ulcerCoverage;

  @HiveField(5)
  final int? ulcerPixels;

  @HiveField(6)
  final String? overlayImagePath;

  @HiveField(7)
  final int? inferenceMs;

  DfuTestModel({
    required this.name,
    required this.imagePaths,
    required this.addDate,
    this.ulcerDetected,
    this.ulcerCoverage,
    this.ulcerPixels,
    this.overlayImagePath,
    this.inferenceMs,
  });
}
