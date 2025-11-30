import 'package:diamate/core/app/app_cubit/app_cubit.dart';
import 'package:diamate/core/database/api/api_consumer.dart';
import 'package:diamate/core/database/api/dio_consumer.dart';
import 'package:diamate/core/database/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> setupInjector() async {
  await _initCore();
  await _initAuth();
  // await _initHome();
}

Future<void> _initCore() async {
  sl
    ..registerLazySingleton<AppCubit>(() => AppCubit())
    ..registerLazySingleton<Dio>(() => Dio())
    ..registerLazySingleton<SecureStorage>(() => SecureStorage());
}

Future<void> _initAuth() async {
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(sl<Dio>()));
  // ..registerLazySingleton<AuthRepo>(
  //   () => AuthRepoImpl(api: sl<ApiConsumer>()),
  // )
  // ..registerFactory<LoginCubit>(() => LoginCubit(sl<AuthRepo>()));
}
