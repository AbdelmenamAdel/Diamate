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
  Future<Either<Failure, UserEntity>> signinWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await api.post(
        EndPoint.login,
        data: {Apikeys.identifier: email, Apikeys.password: password},
      );
      if (response == null) {
        return left(Failure(errorMessage: 'No response from server'));
      }
      final user = LoginResponse.fromJson(response);
      if (user.accessToken.isEmpty || user.refreshToken.isEmpty) {
        return left(Failure(errorMessage: 'Invalid credentials'));
      }
      await saveUserData(response: user);
      return right(user.toEntity());
    } catch (e) {
      log(
        'Exception in AuthRepoImpl.signinWithEmailAndPassword: ${e.toString()}',
      );
      return left(Failure(errorMessage: e.toString()));
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
      final user = LoginResponse.fromJson(userData).toEntity();
      return right(user);
    } catch (e) {
      log('Exception in AuthRepoImpl.getUserData: ${e.toString()}');
      return left(Failure(errorMessage: e.toString()));
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
