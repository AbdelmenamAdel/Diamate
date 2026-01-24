import 'package:dartz/dartz.dart';
import 'package:diamate/core/database/error/failure.dart';
import 'package:diamate/features/auth/data/models/login_response.dart';
import 'package:diamate/features/auth/domain/entites/user_entity.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserEntity>> signinWithEmailAndPassword(
    String email,
    String password,
  );
  Future<Either<Failure, String>> signupWithEmailAndPassword({
    required UserEntity user,
  });

  Future saveUserData({required LoginResponse response});
  Future<Either<Failure, UserEntity>> getUserData({required String token});
}
