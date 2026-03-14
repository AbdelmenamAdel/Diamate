import 'package:diamate/features/medications/data/models/medication_model.dart';
import 'package:diamate/features/medications/data/services/medication_local_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

part 'medication_state.dart';

class MedicationCubit extends Cubit<MedicationState> {
  final MedicationLocalService _localService;

  MedicationCubit(this._localService) : super(MedicationInitial()) {
    loadMedications();
  }

  final _uuid = const Uuid();
  List<MedicationModel> _medications = [];

  Future<void> loadMedications() async {
    try {
      if (!isClosed) emit(MedicationLoading());
      _medications = await _localService.getMedications();
      _medications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      if (!isClosed) emit(MedicationLoaded(medications: _medications));
    } catch (e) {
      if (!isClosed)
        emit(MedicationError(message: 'Failed to load medications: $e'));
    }
  }

  Future<void> addMedication({
    required String name,
    required String type,
    required String strength,
    required int dosage,
    required String foodRelation,
    required String frequency,
    required List<String> reminderTimes,
    required List<String> images,
  }) async {
    try {
      final medication = MedicationModel(
        id: _uuid.v4(),
        name: name,
        type: type,
        strength: strength,
        dosage: dosage,
        foodRelation: foodRelation,
        frequency: frequency,
        reminderTimes: reminderTimes,
        images: images,
        createdAt: DateTime.now(),
      );

      await _localService.addMedication(medication);
      if (!isClosed) emit(MedicationAdded());
      await loadMedications();
    } catch (e) {
      if (!isClosed)
        emit(MedicationError(message: 'Failed to add medication: $e'));
    }
  }

  Future<void> deleteMedication(int index) async {
    try {
      await _localService.deleteMedication(index);
      await loadMedications();
    } catch (e) {
      if (!isClosed)
        emit(MedicationError(message: 'Failed to delete medication: $e'));
    }
  }
}
