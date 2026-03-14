import 'package:hive/hive.dart';

part 'medication_model.g.dart';

@HiveType(typeId: 7)
class MedicationModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String type; // Tablet, Capsule, etc.

  @HiveField(3)
  final String strength;

  @HiveField(4)
  final int dosage;

  @HiveField(5)
  final String foodRelation;

  @HiveField(6)
  final String frequency;

  @HiveField(7)
  final List<String> reminderTimes; // Format: "HH:mm"

  @HiveField(8)
  final List<String> images;

  @HiveField(9)
  final DateTime createdAt;

  MedicationModel({
    required this.id,
    required this.name,
    required this.type,
    required this.strength,
    required this.dosage,
    required this.foodRelation,
    required this.frequency,
    required this.reminderTimes,
    required this.images,
    required this.createdAt,
  });
}
