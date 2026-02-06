import 'package:diamate/core/services/hive/hive_service.dart';
import 'package:diamate/features/glucose/data/models/glucose_reading.dart';
import 'package:hive_flutter/hive_flutter.dart';

class GlucoseLocalService {
  static const String _boxName = 'glucose_readings_box';
  Box<GlucoseReading>? _box;

  Future<void> init() async {
    HiveService.registerAdapter(GlucoseReadingAdapter());
    _box = await HiveService.openBox<GlucoseReading>(_boxName);
  }

  Future<Box<GlucoseReading>> _getBox() async {
    return _box ??= await HiveService.openBox<GlucoseReading>(_boxName);
  }

  Future<void> addReading(GlucoseReading reading) async {
    final box = await _getBox();
    await box.add(reading);
  }

  Future<List<GlucoseReading>> getReadings() async {
    final box = await _getBox();
    return box.values.cast<GlucoseReading>().toList();
  }

  Future<void> deleteReading(int index) async {
    final box = await _getBox();
    await box.deleteAt(index);
  }

  Future<void> deleteMultipleReadings(List<dynamic> keys) async {
    final box = await _getBox();
    await box.deleteAll(keys);
  }
}
