import 'dart:developer';

import 'package:jwt_decoder/jwt_decoder.dart';

// !! TODo: get the id from the token using

int extractId(String token) {
  final decoded = JwtDecoder.decode(token);

  final patientId = decoded['PatientId'];
  log("decoded: ${decoded.toString()}");
  log("patientId: ${patientId.toString()}");
  
  if (patientId is int) {
    return patientId;
  }
  return int.parse(patientId.toString());
}
