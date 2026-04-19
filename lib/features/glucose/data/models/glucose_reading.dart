import 'package:hive/hive.dart';

part 'glucose_reading.g.dart';

@HiveType(typeId: 6)
class GlucoseReading extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double value; // mg/dL

  @HiveField(2)
  final DateTime timestamp;

  @HiveField(3)
  final String source; // 'manual' or 'camera'

  @HiveField(4)
  final String? imagePath; // If from camera

  @HiveField(5)
  final String? notes;

  @HiveField(6)
  final dynamic measurementType; // Supports transition from String (local Hive) to int

  GlucoseReading({
    required this.id,
    required this.value,
    required this.timestamp,
    required this.source,
    this.imagePath,
    this.notes,
    dynamic measurementType = 3,
  }) : measurementType = measurementType is int
            ? measurementType
            : _mapStringMeasurementTypeToInt(measurementType as String?);

  // Get status based on value and measurement type
  String get status {
    // Critical low
    if (value < 54) return 'Critical Low';

    // Low
    if (value < 70) return 'Low';

    // Normal ranges based on measurement type
    if (measurementType == 0) { // Fasting
      if (value >= 70 && value <= 99) return 'Normal';
      if (value >= 100 && value <= 125) return 'Prediabetes';
      return 'High';
    } else if (measurementType == 1) { // BeforeMeal
      if (value < 100) return 'Normal';
      if (value >= 100 && value < 126) return 'Prediabetes';
      return 'High';
    } else if (measurementType == 2) { // AfterMeal
      if (value < 140) return 'Normal';
      if (value >= 140 && value < 200) return 'High';
      return 'Very High';
    } else { // Random
      if (value >= 70 && value <= 140) return 'Normal';
      if (value > 140 && value <= 200) return 'High';
      return 'Very High';
    }
  }

  // Get color based on status
  String get statusColor {
    if (value < 54) return '#B71C1C'; // Dark Red - Critical
    if (value < 70) return '#F25661'; // Red - Low

    if (measurementType == 0) { // Fasting
      if (value >= 70 && value <= 99) return '#45C588'; // Green
      if (value >= 100 && value <= 125) return '#F2994A'; // Orange
      return '#EB5757'; // Red
    } else if (measurementType == 1) { // BeforeMeal
      if (value < 100) return '#45C588'; // Green
      if (value >= 100 && value < 126) return '#F2994A'; // Orange
      return '#EB5757'; // Red
    } else if (measurementType == 2) { // AfterMeal
      if (value < 140) return '#45C588'; // Green
      if (value >= 140 && value < 200) return '#F2994A'; // Orange
      return '#EB5757'; // Red
    } else { // Random
      if (value >= 70 && value <= 140) return '#45C588'; // Green
      if (value > 140 && value <= 200) return '#F2994A'; // Orange
      return '#EB5757'; // Red
    }
  }

  // Get measurement type display name
  String get measurementTypeDisplay {
    switch (measurementType) {
      case 0:
        return 'Fasting';
      case 1:
        return 'Before Meal';
      case 2:
        return 'After Meal';
      case 3:
      default:
        return 'Random';
    }
  }

  // Get detailed advice based on status
  String get advice {
    if (value < 54) {
      return '🚨 CRITICAL: Very low glucose! Consume 15-20g fast-acting carbs immediately (juice, glucose tablets). Recheck in 15 minutes. Seek medical help if symptoms persist.';
    }

    if (value < 70) {
      return '⚠️ LOW: Glucose is low. Have a snack with 15g carbs (fruit, crackers). Avoid exercise. Recheck in 15 minutes.';
    }

    if (measurementType == 0) { // Fasting
      if (value >= 70 && value <= 99) {
        return '✅ EXCELLENT: Your fasting glucose is in the normal range. Keep up the good work!';
      }
      if (value >= 100 && value <= 125) {
        return '⚠️ PREDIABETES: Fasting glucose is elevated. Consider lifestyle changes: exercise, healthy diet, weight management. Consult your doctor.';
      }
      return '🚨 HIGH: Fasting glucose is too high (≥126 mg/dL). This may indicate diabetes. Consult your doctor immediately for proper diagnosis and treatment.';
    } else if (measurementType == 1) { // BeforeMeal
      if (value < 100) {
        return '✅ GOOD: Your pre-meal glucose is in a healthy range. Enjoy your healthy meal!';
      }
      if (value >= 100 && value < 126) {
        return '⚠️ ELEVATED: Pre-meal glucose is slightly high. Be mindful of carbohydrate portions during your meal.';
      }
      return '🚨 HIGH: Pre-meal glucose is high. Consider a short walk and avoid highly processed carbs.';
    } else if (measurementType == 2) { // AfterMeal
      if (value < 140) {
        return '✅ GREAT: Post-meal glucose is normal. Your body is managing sugar well!';
      }
      if (value >= 140 && value < 200) {
        return '⚠️ ELEVATED: Post-meal glucose is high. Try smaller portions, more fiber, and a short walk after meals.';
      }
      return '🚨 VERY HIGH: Post-meal glucose is too high (≥200 mg/dL). Avoid sugary foods, stay hydrated, and consult your doctor.';
    } else { // Random
      if (value >= 70 && value <= 140) {
        return '✅ NORMAL: Your glucose level is within the healthy range. Keep it up!';
      }
      if (value > 140 && value <= 200) {
        return '⚠️ HIGH: Glucose is elevated. Monitor closely, stay active, and watch your diet.';
      }
      return '🚨 VERY HIGH: Glucose is too high. Drink water, avoid sugary foods, and contact your doctor if it persists.';
    }
  }

  factory GlucoseReading.fromJson(Map<String, dynamic> json) {
    return GlucoseReading(
      id: json['id'] as String,
      value: (json['value'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      source: json['source'] as String,
      imagePath: json['imagePath'] as String?,
      notes: json['notes'] as String?,
      measurementType: json['measurementType'] is int
          ? json['measurementType'] as int
          : _mapStringMeasurementTypeToInt(json['measurementType'] as String?),
    );
  }

  static int _mapStringMeasurementTypeToInt(String? type) {
    switch (type) {
      case 'fasting':
        return 0;
      case 'before_meal':
        return 1;
      case 'after_meal':
        return 2;
      case 'random':
      default:
        return 3;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'timestamp': timestamp.toIso8601String(),
      'source': source,
      'imagePath': imagePath,
      'notes': notes,
      'measurementType': measurementType,
    };
  }
}
