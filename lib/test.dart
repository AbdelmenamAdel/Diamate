// import 'dart:developer';

// import 'package:diamate/core/database/api/api_consumer.dart';
// import 'package:diamate/core/services/services_locator.dart';
// import 'package:diamate/features/auth/domain/entites/user_entity.dart';
// import 'package:dio/dio.dart';

// Future createAccount() async {
//   final user = UserEntity(
//     userName: "joooo21",
//     password: "1234yY@",
//     firstName: "joo",
//     lastName: "joo",
//     dateOfBirth: "2000-01-01",
//     gender: 0,
//     address: "rew12",
//     phone: "01000000000",
//     homePhone: "01000000000",
//     email: "joooo123@gmail.com",
//     profileImage: "",
//     weight: 70,
//     height: 170,
//     diabetesType: 1,
//     diagnosisDate: "2010-01-01",
//     notes: "",
//   );
//   try {
//     var response = await sl<ApiConsumer>().post(
//       "https://diamate-production.up.railway.app/api/Account/RegisterNewUser",
//       data: user.toMap(),
//       // options: Options(responseType: ResponseType.plain),
//     );
//     log(response.toString());
//   } catch (e) {
//     log(e.toString());
//   }
// }
