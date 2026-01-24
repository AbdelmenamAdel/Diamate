import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:diamate/core/database/api/api_consumer.dart';
import 'package:diamate/core/database/api/end_points.dart';
import 'package:diamate/core/database/error/failure.dart';
import 'package:diamate/core/database/secure_storage.dart';
import 'package:diamate/features/auth/data/models/login_response.dart';
import 'package:diamate/features/auth/domain/entites/user_entity.dart';
import 'package:diamate/features/auth/domain/repos/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  final ApiConsumer api;
  AuthRepoImpl({required this.api});

  @override
  Future<Either<Failure, String>> signupWithEmailAndPassword({
    required UserEntity user,
  }) async {
    try {
      final response = await api.post(
        EndPoint.signUp,
        data: {
          Apikeys.userName: user.userName,
          Apikeys.password: user.password,
          Apikeys.firstName: user.firstName,
          Apikeys.secondName: user.secondName,
          Apikeys.thirdName: user.thirdName,
          Apikeys.lastName: user.lastName,
          Apikeys.dateOfBirth: user.dateOfBirth,
          Apikeys.gender: user.gender,
          Apikeys.address: user.address,
          Apikeys.phone: user.phone,
          Apikeys.homePhone: user.homePhone,
          Apikeys.email: user.email,
          Apikeys.profileImage: user.profileImage,
          Apikeys.weight: user.weight,
          Apikeys.notes: user.notes,
        },
      );

      if (response == null) {
        return left(
          Failure(errorMessage: 'No response from server', statusCode: 400),
        );
      }
      log(response.toString());
      return right("loginResponse");
    } catch (e) {
      log(
        'Exception in AuthRepoImpl.signupWithEmailAndPassword: ${e.toString()}',
      );
      return left(Failure(errorMessage: e.toString(), statusCode: 400));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signinWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await api.post(
        EndPoint.login,
        data: {Apikeys.userName: email, Apikeys.password: password},
      );
      if (response == null) {
        return left(
          Failure(errorMessage: 'No response from server', statusCode: 400),
        );
      }
      log(response.toString());
      final user = LoginResponse.fromJson(response);
      if (user.accessToken.isEmpty || user.refreshToken.isEmpty) {
        return left(
          Failure(errorMessage: 'Invalid credentials', statusCode: 400),
        );
      }
      log(user.toString());
      await saveUserData(response: user);
      return right(user.toEntity());
    } catch (e) {
      log(
        'Exception in AuthRepoImpl.signinWithEmailAndPassword: ${e.toString()}',
      );
      return left(Failure(errorMessage: e.toString(), statusCode: 400));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserData({
    required String token,
  }) async {
    try {
      final userData = await api.get(
        EndPoint.getUserData,
        data: {'Authorization': token},
      );
      final user = UserEntity.fromMap(userData['data']);
      return right(user);
    } catch (e) {
      log('Exception in AuthRepoImpl.getUserData: ${e.toString()}');
      return left(Failure(errorMessage: e.toString(), statusCode: 400));
    }
  }

  @override
  Future saveUserData({required LoginResponse response}) async {
    await SecureStorage.setString(
      key: 'userData',
      value: jsonEncode(response.toEntity().toMap()),
    );
    await SecureStorage.setString(
      key: Apikeys.accessToken,
      value: response.accessToken,
    );
    await SecureStorage.setString(
      key: Apikeys.refreshToken,
      value: response.refreshToken,
    );
    await SecureStorage.setString(
      key: Apikeys.tokenType,
      value: response.tokenType,
    );
  }
}
