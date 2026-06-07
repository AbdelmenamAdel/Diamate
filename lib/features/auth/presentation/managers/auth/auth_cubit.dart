import 'dart:convert';
import 'package:diamate/core/database/secure_storage.dart';
import 'package:diamate/features/auth/domain/entites/user_entity.dart';
import 'package:diamate/features/auth/domain/repos/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authRepo) : super(AuthInitial());
  final AuthRepo authRepo;
  UserEntity? user;

  Future<void> loadUser() async {
    final userData = await SecureStorage.getString(key: 'user_data');
    if (userData != null) {
      user = UserEntity.fromMap(jsonDecode(userData));
      emit(AuthAuthenticated(user: user!));
    }
  }

  Future<void> register({required UserEntity user}) async {
    emit(RegisterLoading());
    var result = await authRepo.signupWithEmailAndPassword(user: user);
    result.fold((failure) => emit(RegisterFailure(message: failure)), (
      success,
    ) async {
      // Automatically login to get the token and user data
      var loginResult = await authRepo.signinWithEmailAndPassword(
        user.userName,
        user.password,
      );
      loginResult.fold(
        (failure) => emit(
          RegisterFailure(
            message: 'Signup successful, but login failed: $failure',
          ),
        ),
        (loginResponse) async {
          // signinWithEmailAndPassword already fetched and saved the user to SecureStorage.
          try {
            final userData = await SecureStorage.getString(key: 'user_data');
            if (userData != null) {
              user = UserEntity.fromMap(jsonDecode(userData));
              emit(AuthAuthenticated(user: user!));
              emit(RegisterSuccess());
            } else {
              emit(RegisterFailure(message: "Failed to load user data locally"));
            }
          } catch (e) {
            emit(RegisterFailure(message: "Error loading user data: $e"));
          }
        },
      );
    });
  }

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());
    var result = await authRepo.signinWithEmailAndPassword(email, password);
    result.fold((failure) => emit(LoginFailure(message: failure)), (
      loginResponse,
    ) async {
      // signinWithEmailAndPassword already fetched and saved the user to SecureStorage.
      // We just need to load it from there instead of making a duplicate network request 
      // which is causing a connection hang.
      try {
        final userData = await SecureStorage.getString(key: 'user_data');
        if (userData != null) {
          user = UserEntity.fromMap(jsonDecode(userData));
          emit(AuthAuthenticated(user: user!));
          emit(LoginSuccess());
        } else {
          emit(LoginFailure(message: "Failed to load user data locally"));
        }
      } catch (e) {
        emit(LoginFailure(message: "Error loading user data: $e"));
      }
    });
  }
}
