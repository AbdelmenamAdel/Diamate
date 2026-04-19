import 'package:dartz/dartz.dart';
import 'package:diamate/features/glucose/data/models/glucose_reading.dart';

abstract class GlucoseRepo {
  Future<Either<String, void>> addRemoteReading({
    required GlucoseReading reading,
    required int patientId,
  });
}
