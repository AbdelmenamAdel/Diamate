import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:diamate/core/database/api/api_consumer.dart';
import 'package:diamate/core/database/api/end_points.dart';
import 'package:diamate/core/database/error/exception.dart';
import 'package:diamate/features/medications/data/models/add_medicine_request.dart';
import 'package:diamate/features/medications/domain/repos/medication_repo.dart';

class MedicationRepoImpl implements MedicationRepo {
  final ApiConsumer api;

  MedicationRepoImpl({required this.api});

  @override
  Future<Either<String, void>> addRemoteMedication({
    required AddMedicineRequest request,
  }) async {
    try {
      final data = request.toJson();
      log("Sending medication to server: $data");

      final response = await api.post(
        EndPoint.addMedicine,
        data: data,
      );

      if (response != null) {
        return const Right(null);
      } else {
        return const Left("Failed to add medication to server");
      }
    } on ServerFailure catch (e) {
      log("ServerFailure in MedicationRepoImpl.addRemoteMedication: ${e.errorModel.errorMessage}");
      return Left(e.errorModel.errorMessage ?? "Server error occurred");
    } catch (e) {
      log("Exception in MedicationRepoImpl.addRemoteMedication: ${e.toString()}");
      return Left(e.toString());
    }
  }
}
