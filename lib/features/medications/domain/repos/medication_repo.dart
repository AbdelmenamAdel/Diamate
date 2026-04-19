import 'package:dartz/dartz.dart';
import 'package:diamate/features/medications/data/models/add_medicine_request.dart';

abstract class MedicationRepo {
  Future<Either<String, void>> addRemoteMedication({
    required AddMedicineRequest request,
  });
}
