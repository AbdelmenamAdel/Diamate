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
    result.fold(
      (failure) => emit(RegisterFailure(message: failure)),
      (text) => emit(RegisterSuccess()),
    );
  }

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());
    var result = await authRepo.signinWithEmailAndPassword(email, password);
    result.fold(
      (failure) => emit(LoginFailure(message: failure)),
      (loginResponse) async {
        final userResult = await authRepo.getUserData(
          token: loginResponse.token,
        );
        userResult.fold(
          (failure) => emit(LoginFailure(message: failure)),
          (userEntity) {
            user = userEntity;
            emit(AuthAuthenticated(user: user!));
            emit(LoginSuccess());
          },
        );
      },
    );
  }
}
