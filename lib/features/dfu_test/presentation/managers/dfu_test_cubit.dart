import 'package:diamate/features/dfu_test/data/models/dfu_test_model.dart';
import 'package:diamate/features/dfu_test/data/services/dfu_test_local_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diamate/core/utils/file_helper.dart';

part 'dfu_test_state.dart';

class DfuTestCubit extends Cubit<DfuTestState> {
  final DfuTestLocalService _localService;

  DfuTestCubit(this._localService) : super(DfuTestInitial());

  Future<void> loadDfuTests() async {
    emit(DfuTestLoading());
    try {
      final tests = await _localService.getDfuTests();
      tests.sort((a, b) => b.addDate.compareTo(a.addDate));
      emit(DfuTestLoaded(tests));
    } catch (e) {
      emit(DfuTestError(e.toString()));
    }
  }

  Future<void> addDfuTest({
    required String name,
    required List<String> imagePaths,
    bool? ulcerDetected,
    double? ulcerCoverage,
    int? ulcerPixels,
    String? overlayImagePath,
    int? inferenceMs,
  }) async {
    try {
      final persistentPaths = await FileHelper.saveFilesToAppDir(imagePaths);
      final newTest = DfuTestModel(
        name: name,
        imagePaths: persistentPaths,
        addDate: DateTime.now(),
        ulcerDetected: ulcerDetected,
        ulcerCoverage: ulcerCoverage,
        ulcerPixels: ulcerPixels,
        overlayImagePath: overlayImagePath,
        inferenceMs: inferenceMs,
      );
      await _localService.addDfuTest(newTest);
      loadDfuTests();
    } catch (e) {
      emit(DfuTestError(e.toString()));
    }
  }

  Future<void> deleteMultipleDfuTests(List<dynamic> keys) async {
    try {
      await _localService.deleteMultipleDfuTests(keys);
      loadDfuTests();
    } catch (e) {
      emit(DfuTestError(e.toString()));
    }
  }
}
