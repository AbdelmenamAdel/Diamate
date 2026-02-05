part of 'dfu_test_cubit.dart';

abstract class DfuTestState {}

class DfuTestInitial extends DfuTestState {}

class DfuTestLoading extends DfuTestState {}

class DfuTestLoaded extends DfuTestState {
  final List<DfuTestModel> dfuTests;
  DfuTestLoaded(this.dfuTests);
}

class DfuTestError extends DfuTestState {
  final String message;
  DfuTestError(this.message);
}
