import 'package:diamate/core/app/app_cubit/app_cubit.dart';
import 'package:diamate/core/database/api/api_consumer.dart';
import 'package:diamate/core/database/api/dio_consumer.dart';
import 'package:diamate/core/database/secure_storage.dart';
import 'package:diamate/core/services/remote_config_service.dart';
import 'package:diamate/features/auth/data/repos/auth_repo_impl.dart';
import 'package:diamate/features/auth/domain/repos/auth_repo.dart';
import 'package:diamate/features/auth/presentation/managers/auth/auth_cubit.dart';
import 'package:diamate/features/chat/data/repo/chatbot_repo_implementation.dart';
import 'package:diamate/features/chat/domain/repo/chatbot_repo.dart';
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
import 'package:diamate/features/dfu_test/data/services/dfu_test_local_service.dart';
import 'package:diamate/features/dfu_test/presentation/managers/dfu_test_cubit.dart';
import 'package:diamate/features/glucose/data/services/glucose_local_service.dart';
import 'package:diamate/features/glucose/domain/repos/glucose_repo.dart';
import 'package:diamate/features/glucose/data/repos/glucose_repo_impl.dart';
import 'package:diamate/features/glucose/presentation/managers/glucose_cubit.dart';
import 'package:diamate/features/medications/data/services/medication_local_service.dart';
import 'package:diamate/features/medications/presentation/managers/medication_cubit.dart';

final sl = GetIt.instance;

Future<void> setupInjector() async {
  await _initCore();
  await _initAuth();
  await _initChat();
  await _initNotifications();
  await _initLabTests();
  await _initDfuTests();
  await _initGlucose();
  await _initMedications();
}

Future<void> _initMedications() async {
  final medicationService = MedicationLocalService();
  await medicationService.init();
  sl.registerLazySingleton<MedicationLocalService>(() => medicationService);
  sl.registerLazySingleton<MedicationCubit>(
    () => MedicationCubit(sl<MedicationLocalService>()),
  );
}

Future<void> _initGlucose() async {
  final glucoseService = GlucoseLocalService();
  await glucoseService.init();
  sl.registerLazySingleton<GlucoseLocalService>(() => glucoseService);
  sl.registerLazySingleton<GlucoseRepo>(
    () => GlucoseRepoImpl(api: sl<ApiConsumer>()),
  );
  sl.registerLazySingleton<GlucoseCubit>(
    () => GlucoseCubit(
      sl<GlucoseLocalService>(),
      sl<GlucoseRepo>(),
      sl<AuthCubit>(),
    ),
  );
}

Future<void> _initDfuTests() async {
  final dfuService = DfuTestLocalService();
  await dfuService.init();
  sl.registerLazySingleton<DfuTestLocalService>(() => dfuService);
  sl.registerFactory<DfuTestCubit>(
    () => DfuTestCubit(sl<DfuTestLocalService>()),
  );
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
  sl.registerSingleton<ChatbotRepo>(
    ChatbotRepoImplementation(api: sl<ApiConsumer>()),
  );
  sl.registerFactory<ChatCubit>(
    () => ChatCubit(
      sl<ChatLocalService>(),
      sl<ChatCompanionService>(),
      sl<ChatbotRepo>(),
    ),
  );
}

Future<void> _initCore() async {
  await HiveService.init();
  sl
    ..registerLazySingleton<AppCubit>(() => AppCubit())
    ..registerLazySingleton<Dio>(() => Dio())
    ..registerLazySingleton<SecureStorage>(() => SecureStorage())
    ..registerLazySingleton<ChatCompanionService>(() => ChatCompanionService())
    ..registerLazySingleton<PermissionService>(() => PermissionService())
    ..registerLazySingleton<RemoteConfigService>(() => RemoteConfigService());

  await sl<RemoteConfigService>().init();
}

Future<void> _initAuth() async {
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(sl<Dio>()));
  sl.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(api: sl<ApiConsumer>()),
  );
  sl.registerLazySingleton<AuthCubit>(() => AuthCubit(sl<AuthRepo>()));
}
