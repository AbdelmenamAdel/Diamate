import 'package:diamate/features/auth/domain/entites/user_entity.dart';
import 'package:diamate/features/auth/domain/repos/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authRepo) : super(AuthInitial());
  final AuthRepo authRepo;

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
      (userEntity) => emit(LoginSuccess()),
    );
  }
}
