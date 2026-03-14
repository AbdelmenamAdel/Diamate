import 'package:diamate/core/services/hive/hive_service.dart';
import 'package:diamate/features/medications/data/models/medication_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MedicationLocalService {
  static const String _boxName = 'medications_box';
  Box<MedicationModel>? _box;

  Future<void> init() async {
    HiveService.registerAdapter(MedicationModelAdapter());
    _box = await HiveService.openBox<MedicationModel>(_boxName);
  }

  Future<Box<MedicationModel>> _getBox() async {
    return _box ??= await HiveService.openBox<MedicationModel>(_boxName);
  }

  Future<void> addMedication(MedicationModel medication) async {
    final box = await _getBox();
    await box.add(medication);
  }

  Future<List<MedicationModel>> getMedications() async {
    final box = await _getBox();
    return box.values.cast<MedicationModel>().toList();
  }

  Future<void> deleteMedication(int index) async {
    final box = await _getBox();
    await box.deleteAt(index);
  }

  Future<void> updateMedication(int index, MedicationModel medication) async {
    final box = await _getBox();
    await box.putAt(index, medication);
  }

  Future<void> clearAll() async {
    final box = await _getBox();
    await box.clear();
  }
}
