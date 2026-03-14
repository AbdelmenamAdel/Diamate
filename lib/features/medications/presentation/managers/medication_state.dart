part of 'medication_cubit.dart';

abstract class MedicationState extends Equatable {
  const MedicationState();

  @override
  List<Object?> get props => [];
}

class MedicationInitial extends MedicationState {}

class MedicationLoading extends MedicationState {}

class MedicationLoaded extends MedicationState {
  final List<MedicationModel> medications;

  const MedicationLoaded({required this.medications});

  @override
  List<Object?> get props => [medications];
}

class MedicationAdded extends MedicationState {}

class MedicationError extends MedicationState {
  final String message;

  const MedicationError({required this.message});

  @override
  List<Object?> get props => [message];
}
