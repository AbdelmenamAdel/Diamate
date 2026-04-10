import 'package:dartz/dartz.dart';
import 'package:diamate/features/auth/data/models/login_response.dart';
import 'package:diamate/features/auth/domain/entites/user_entity.dart';

abstract class AuthRepo {
  Future<Either<String, LoginResponse>> signinWithEmailAndPassword(
    String userName,
    String password,
  );
  Future<Either<String, String>> signupWithEmailAndPassword({
    required UserEntity user,
  });

  Future<Either<String, UserEntity>> getUserData({required String token});
}
