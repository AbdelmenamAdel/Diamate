import 'package:diamate/core/services/hive/hive_service.dart';
import 'package:diamate/features/lab_tests/data/models/lab_test_model.dart';

class LabTestLocalService {
  static const String _boxName = 'lab_tests_box';

  Future<void> init() async {
    HiveService.registerAdapter(LabTestModelAdapter());
    await HiveService.openBox<LabTestModel>(_boxName);
  }

  Future<void> addLabTest(LabTestModel labTest) async {
    final box = await HiveService.openBox<LabTestModel>(_boxName);
    await box.add(labTest);
  }

  Future<List<LabTestModel>> getLabTests() async {
    final box = await HiveService.openBox<LabTestModel>(_boxName);
    return box.values.toList();
  }

  Future<void> deleteLabTest(int index) async {
    final box = await HiveService.openBox<LabTestModel>(_boxName);
    await box.deleteAt(index);
  }

  Future<void> clearAll() async {
    final box = await HiveService.openBox<LabTestModel>(_boxName);
    await box.clear();
  }
}
