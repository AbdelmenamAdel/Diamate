import 'package:diamate/core/app/app_cubit/app_cubit.dart';
import 'package:diamate/core/database/api/api_consumer.dart';
import 'package:diamate/core/database/api/dio_consumer.dart';
import 'package:diamate/core/database/secure_storage.dart';
import 'package:diamate/features/auth/data/repos/auth_repo_impl.dart';
import 'package:diamate/features/auth/domain/repos/auth_repo.dart';
import 'package:diamate/features/auth/presentation/managers/auth/auth_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:diamate/features/chat/data/services/chat_local_service.dart';

import 'package:diamate/features/chat/presentation/managers/chat_cubit.dart';

final sl = GetIt.instance;

Future<void> setupInjector() async {
  await _initCore();
  await _initAuth();
  await _initChat();
}

Future<void> _initChat() async {
  final chatService = ChatLocalService();
  await chatService.init();
  sl.registerLazySingleton<ChatLocalService>(() => chatService);
  sl.registerFactory<ChatCubit>(() => ChatCubit(sl<ChatLocalService>()));
}

Future<void> _initCore() async {
  sl
    ..registerLazySingleton<AppCubit>(() => AppCubit())
    ..registerLazySingleton<Dio>(() => Dio())
    ..registerLazySingleton<SecureStorage>(() => SecureStorage());
}

Future<void> _initAuth() async {
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(sl<Dio>()));
  sl.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(api: sl<ApiConsumer>()),
  );
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl<AuthRepo>()));
}
