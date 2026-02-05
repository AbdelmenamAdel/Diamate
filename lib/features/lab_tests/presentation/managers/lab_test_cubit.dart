import 'package:diamate/features/lab_tests/data/models/lab_test_model.dart';
import 'package:diamate/features/lab_tests/data/services/lab_test_local_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'lab_test_state.dart';

class LabTestCubit extends Cubit<LabTestState> {
  final LabTestLocalService _localService;

  LabTestCubit(this._localService) : super(LabTestInitial());

  Future<void> loadLabTests() async {
    emit(LabTestLoading());
    try {
      final tests = await _localService.getLabTests();
      tests.sort(
        (a, b) => b.addDate.compareTo(a.addDate),
      ); // Default sort by date desc
      emit(LabTestLoaded(tests));
    } catch (e) {
      emit(LabTestError(e.toString()));
    }
  }

  Future<void> addLabTest(String name, String pdfPath) async {
    try {
      final newTest = LabTestModel(
        name: name,
        pdfPath: pdfPath,
        addDate: DateTime.now(),
      );
      await _localService.addLabTest(newTest);
      loadLabTests();
    } catch (e) {
      emit(LabTestError(e.toString()));
    }
  }

  void sortTests(bool descending) {
    if (state is LabTestLoaded) {
      final currentTests = List<LabTestModel>.from(
        (state as LabTestLoaded).labTests,
      );
      if (descending) {
        currentTests.sort((a, b) => b.addDate.compareTo(a.addDate));
      } else {
        currentTests.sort((a, b) => a.addDate.compareTo(b.addDate));
      }
      emit(LabTestLoaded(currentTests, isDescending: descending));
    }
  }

  void sortByName(bool ascending) {
    if (state is LabTestLoaded) {
      final currentTests = List<LabTestModel>.from(
        (state as LabTestLoaded).labTests,
      );
      if (ascending) {
        currentTests.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
      } else {
        currentTests.sort(
          (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()),
        );
      }
      emit(LabTestLoaded(currentTests, isDescending: ascending));
    }
  }
}
