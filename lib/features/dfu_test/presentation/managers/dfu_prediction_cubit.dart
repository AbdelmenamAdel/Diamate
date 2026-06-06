import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diamate/features/dfu_test/data/models/dfu_prediction_response.dart';
import 'package:diamate/features/dfu_test/data/services/dfu_remote_service.dart';

part 'dfu_prediction_state.dart';

class DfuPredictionCubit extends Cubit<DfuPredictionState> {
  final DfuRemoteService _remoteService;

  DfuPredictionCubit(this._remoteService) : super(DfuPredictionInitial());

  Future<void> predictImage(File imageFile) async {
    emit(DfuPredictionLoading());
    try {
      final result = await _remoteService.predictDfu(imageFile);
      emit(DfuPredictionSuccess(result));
    } catch (e) {
      emit(DfuPredictionError(e.toString()));
    }
  }

  void reset() {
    emit(DfuPredictionInitial());
  }
}
