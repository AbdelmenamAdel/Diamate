import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:diamate/core/database/api/api_consumer.dart';
import 'package:diamate/core/database/api/end_points.dart';
import 'package:diamate/core/database/error/exception.dart';
import 'package:diamate/features/auth/data/models/login_response.dart';
import 'package:diamate/features/auth/domain/entites/user_entity.dart';
import 'package:diamate/features/auth/domain/repos/auth_repo.dart';
import 'package:diamate/core/utils/id_extraction.dart';
import 'package:diamate/core/database/secure_storage.dart';
import 'dart:convert';

class AuthRepoImpl extends AuthRepo {
  final ApiConsumer api;
  AuthRepoImpl({required this.api});

  @override
  Future<Either<String, String>> signupWithEmailAndPassword({
    required UserEntity user,
  }) async {
    try {
      final response = await api.post(EndPoint.signUp, data: user.toMap());
      log(response.toString());
      if (response == null) {
        return left('No response from server');
      }
      // log(response.toString());
      return right("loginResponse");
    } on ServerFailure catch (e) {
      log(
        'ServerFailure in AuthRepoImpl.signupWithEmailAndPassword: ${e.errorModel.errorMessage}',
      );
      return left(e.errorModel.errorMessage ?? "Error message is null");
    } catch (e) {
      log(
        'Exception in AuthRepoImpl.signupWithEmailAndPassword: ${e.toString()}',
      );
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, LoginResponse>> signinWithEmailAndPassword(
    String userName,
    String password,
  ) async {
    try {
      final response = await api.post(
        EndPoint.login,
        data: {Apikeys.userName: userName, Apikeys.password: password},
      );
      if (response == null) {
        return left("No response from server");
      }
      final res = LoginResponse.fromJson(response);
      if (res.token.isEmpty) {
        return left("Invalid credentials");
      }
      // Convert response to UserEntity and add id locally
      final userResult = await getUserData(token: res.token);

      return userResult.fold((error) => left(error), (user) => right(res));
    } catch (e) {
      log(
        'Exception in AuthRepoImpl.signinWithEmailAndPassword: ${e.toString()}',
      );
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, UserEntity>> getUserData({
    required String token,
  }) async {
    try {
      // Save token to SecureStorage
      await SecureStorage.setString(key: Apikeys.accessToken, value: token);
      // Extract PatientId from token
      final patientId = extractId(token);
      // Fetch patient details
      final patientResponse = await api.get('${EndPoint.getPatient}$patientId');
      if (patientResponse == null) {
        return left("Failed to fetch patient data");
      }

      // Convert response to UserEntity and add id locally
      final userMap = Map<String, dynamic>.from(patientResponse);
      userMap[Apikeys.id] = patientId.toInt();
      log("userMap before fromMap: ${userMap.toString()}");
      
      final userEntity = UserEntity.fromMap(userMap);
      log("userEntity created: ${userEntity.firstName} ${userEntity.lastName}, id: ${userEntity.id}");
      
      // Save full UserEntity to SecureStorage
      await SecureStorage.setString(
        key: 'user_data',
        value: jsonEncode(userEntity.toMap()),
      );
      log("user_data saved to SecureStorage");

      return right(userEntity);
    } catch (e) {
      log('Exception in AuthRepoImpl.getUserData: ${e.toString()}');
      return left(e.toString());
    }
  }
}
