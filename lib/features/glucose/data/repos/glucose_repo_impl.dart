import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:diamate/core/database/api/api_consumer.dart';
import 'package:diamate/core/database/api/end_points.dart';
import 'package:diamate/core/database/error/exception.dart';
import 'package:diamate/features/glucose/data/models/glucose_reading.dart';
import 'package:diamate/features/glucose/domain/repos/glucose_repo.dart';

class GlucoseRepoImpl implements GlucoseRepo {
  final ApiConsumer api;

  GlucoseRepoImpl({required this.api});

  @override
  Future<Either<String, void>> addRemoteReading({
    required GlucoseReading reading,
    required int patientId,
  }) async {
    try {
      final data = {
        "measurementType": reading.measurementType,
        "patientId": patientId,
        "reading_value": reading.value,
        "measurementTime": reading.timestamp.toIso8601String(),
        "notes": reading.notes ?? "",
      };
      
      log("Sending glucose reading to server: $data");

      final response = await api.post(
        EndPoint.addGlucoseReading,
        data: data,
      );

      if (response != null) {
        return const Right(null);
      } else {
        return const Left("Failed to add reading to server");
      }
    } on ServerFailure catch (e) {
      log("ServerFailure in GlucoseRepoImpl.addRemoteReading: ${e.errorModel.errorMessage}");
      return Left(e.errorModel.errorMessage ?? "Server error occurred");
    } catch (e) {
      log("Exception in GlucoseRepoImpl.addRemoteReading: ${e.toString()}");
      return Left(e.toString());
    }
  }
}
