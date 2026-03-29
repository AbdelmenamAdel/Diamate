import 'package:jwt_decoder/jwt_decoder.dart';

// !! TODo: get the id from the token using

int extractId(String token) {
  final decoded = JwtDecoder.decode(token);

  final patientId = decoded['PatientId'];

  return patientId;
}
