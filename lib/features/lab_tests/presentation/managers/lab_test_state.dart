part of 'lab_test_cubit.dart';

abstract class LabTestState {}

class LabTestInitial extends LabTestState {}

class LabTestLoading extends LabTestState {}

class LabTestLoaded extends LabTestState {
  final List<LabTestModel> labTests;
  final bool isDescending;

  LabTestLoaded(this.labTests, {this.isDescending = true});
}

class LabTestError extends LabTestState {
  final String message;

  LabTestError(this.message);
}
