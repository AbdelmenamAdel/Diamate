import 'package:diamate/features/dfu_test/data/models/dfu_test_model.dart';
import 'package:diamate/features/dfu_test/data/services/dfu_test_local_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  Future<void> addDfuTest(String name, List<String> imagePaths) async {
    try {
      final newTest = DfuTestModel(
        name: name,
        imagePaths: imagePaths,
        addDate: DateTime.now(),
      );
      await _localService.addDfuTest(newTest);
      loadDfuTests();
    } catch (e) {
      emit(DfuTestError(e.toString()));
    }
  }
}
