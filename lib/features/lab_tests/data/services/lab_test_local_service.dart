import 'package:diamate/core/services/hive/hive_service.dart';
import 'package:diamate/features/lab_tests/data/models/lab_test_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LabTestLocalService {
  static const String _boxName = 'lab_tests_box';
  Box<LabTestModel>? _box;

  Future<void> init() async {
    HiveService.registerAdapter(LabTestModelAdapter());
    _box = await HiveService.openBox<LabTestModel>(_boxName);
  }

  Future<Box<LabTestModel>> _getBox() async {
    return _box ??= await HiveService.openBox<LabTestModel>(_boxName);
  }

  Future<void> addLabTest(LabTestModel labTest) async {
    final box = await _getBox();
    await box.add(labTest);
  }

  Future<List<LabTestModel>> getLabTests() async {
    final box = await _getBox();
    return box.values.cast<LabTestModel>().toList();
  }

  Future<void> deleteLabTest(int index) async {
    final box = await HiveService.openBox<LabTestModel>(_boxName);
    await box.deleteAt(index);
  }

  Future<void> deleteMultipleTests(List<dynamic> keys) async {
    final box = await _getBox();
    await box.deleteAll(keys);
  }

  Future<void> clearAll() async {
    final box = await HiveService.openBox<LabTestModel>(_boxName);
    await box.clear();
  }
}
