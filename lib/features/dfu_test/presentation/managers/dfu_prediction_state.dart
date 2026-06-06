part of 'dfu_prediction_cubit.dart';

abstract class DfuPredictionState {}

class DfuPredictionInitial extends DfuPredictionState {}

class DfuPredictionLoading extends DfuPredictionState {}

class DfuPredictionSuccess extends DfuPredictionState {
  final DfuPredictionResponse response;

  DfuPredictionSuccess(this.response);
}

class DfuPredictionError extends DfuPredictionState {
  final String message;

  DfuPredictionError(this.message);
}
