import 'package:diamate/core/services/hive/hive_service.dart';
import 'package:diamate/features/dfu_test/data/models/dfu_test_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DfuTestLocalService {
  static const String _boxName = 'dfu_tests_box';
  Box<DfuTestModel>? _box;

  Future<void> init() async {
    HiveService.registerAdapter(DfuTestModelAdapter());
    _box = await HiveService.openBox<DfuTestModel>(_boxName);
  }

  Future<Box<DfuTestModel>> _getBox() async {
    return _box ??= await HiveService.openBox<DfuTestModel>(_boxName);
  }

  Future<void> addDfuTest(DfuTestModel dfuTest) async {
    final box = await _getBox();
    await box.add(dfuTest);
  }

  Future<List<DfuTestModel>> getDfuTests() async {
    final box = await _getBox();
    return box.values.cast<DfuTestModel>().toList();
  }

  Future<void> deleteDfuTest(int index) async {
    final box = await _getBox();
    await box.deleteAt(index);
  }
}
