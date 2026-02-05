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
import 'package:diamate/features/notifications/data/services/notification_local_service.dart';

import 'package:diamate/core/services/hive/hive_service.dart';
import 'package:diamate/core/services/push_notification/firebase_cloud_messaging.dart';
import 'package:diamate/core/services/push_notification/local_notfication_service.dart';
import 'package:diamate/core/services/chat_companion_service.dart';
import 'package:diamate/core/services/permission_service.dart';

import 'package:diamate/features/lab_tests/data/services/lab_test_local_service.dart';
import 'package:diamate/features/lab_tests/presentation/managers/lab_test_cubit.dart';

final sl = GetIt.instance;

Future<void> setupInjector() async {
  await _initCore();
  await _initAuth();
  await _initChat();
  await _initNotifications();
  await _initLabTests();
}

Future<void> _initLabTests() async {
  final labService = LabTestLocalService();
  await labService.init();
  sl.registerLazySingleton<LabTestLocalService>(() => labService);
  sl.registerFactory<LabTestCubit>(
    () => LabTestCubit(sl<LabTestLocalService>()),
  );
}

Future<void> _initNotifications() async {
  sl.registerLazySingleton<LocalNotificationService>(
    () => LocalNotificationService(),
  );
  sl.registerLazySingleton<FirebaseCloudMessaging>(
    () => FirebaseCloudMessaging(),
  );
  sl.registerLazySingleton<NotificationLocalService>(
    () => NotificationLocalService(),
  );

  await sl<LocalNotificationService>().init();
  await sl<NotificationLocalService>().init();
}

Future<void> _initChat() async {
  final chatService = ChatLocalService();
  await chatService.init();
  sl.registerLazySingleton<ChatLocalService>(() => chatService);
  sl.registerFactory<ChatCubit>(
    () => ChatCubit(sl<ChatLocalService>(), sl<ChatCompanionService>()),
  );
}

Future<void> _initCore() async {
  await HiveService.init();
  sl
    ..registerLazySingleton<AppCubit>(() => AppCubit())
    ..registerLazySingleton<Dio>(() => Dio())
    ..registerLazySingleton<SecureStorage>(() => SecureStorage())
    ..registerLazySingleton<ChatCompanionService>(() => ChatCompanionService())
    ..registerLazySingleton<PermissionService>(() => PermissionService());
}

Future<void> _initAuth() async {
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(sl<Dio>()));
  sl.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(api: sl<ApiConsumer>()),
  );
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl<AuthRepo>()));
}
