// {
//   "userName": "abdo",
//   "password": "password123",
//   "firstName": "Abdelmoneim",
//   "secondName": "adel",
//   "thirdName": "Abdelmoneim",
//   "lastName": "Abdelmoneim",
//   "dateOfBirth": "2026-01-24T21:33:46.771Z",
//   "gender": 0,
//   "address": "adlfafjadslfkjad",
//   "phone": "01556878109",
//   "homePhone": "0133881090",
//   "email": "abdelmoneim.adel5@gmail.com",
//   "profileImage": "https://www.ewlrjkaslk",
//   "weight": 80,
//   "notes": "note"
// }
// Updated to match the API
// {
//   "userName": "yassinm",
//   "password": "Yassin@05",
//   "firstName": "Yassin",
//   "lastName": "Mahmoud",
//   "dateOfBirth": "2005-01-08T11:20:35.339Z",
//   "gender": 1,
//   "address": "momomomo",
//   "phone": "01015621498",
//   "homePhone": "01015621498",
//   "email": "yassinmahmoudmostafa@gmail.com",
//   "profileImage": "",
//   "dateOfDiagnosis": "2026-03-15T11:20:35.339Z",
//   "diabetesType": 5,
//   "weight": 200,
//   "height": 230,
//   "notes": "string"
// }
import 'package:diamate/core/database/api/end_points.dart';

class UserEntity {
  final String userName;
  final String password;
  final String firstName;
  final String lastName;
  final String dateOfBirth;
  final int gender;
  final String address;
  final String phone;
  final String? homePhone;
  final String email;
  final String profileImage;
  final int weight;
  final String? notes;
  final int height;
  final int diabetesType;
  final String diagnosisDate;
  const UserEntity({
    required this.height,
    required this.diabetesType,
    required this.diagnosisDate,
    required this.userName,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    required this.phone,
    this.homePhone,
    required this.email,
    required this.profileImage,
    required this.weight,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      Apikeys.userName: userName,
      Apikeys.password: password,
      Apikeys.firstName: firstName,
      Apikeys.lastName: lastName,
      Apikeys.dateOfBirth: dateOfBirth,
      Apikeys.gender: gender,
      Apikeys.address: address,
      Apikeys.phone: phone,
      Apikeys.homePhone: homePhone,
      Apikeys.email: email,
      Apikeys.profileImage: profileImage,
      Apikeys.weight: weight,
      Apikeys.notes: notes,
    };
  }

  factory UserEntity.fromMap(Map<String, dynamic> json) {
    return UserEntity(
      userName: json[Apikeys.userName] ?? '',
      password: json[Apikeys.password] ?? '',
      firstName: json[Apikeys.firstName] ?? '',
      lastName: json[Apikeys.lastName] ?? '',
      dateOfBirth: json[Apikeys.dateOfBirth] ?? '',
      gender: json[Apikeys.gender] ?? 0,
      address: json[Apikeys.address] ?? '',
      phone: json[Apikeys.phone] ?? '',
      homePhone: json[Apikeys.homePhone] ?? '',
      email: json[Apikeys.email] ?? '',
      profileImage: json[Apikeys.profileImage] ?? '',
      weight: json[Apikeys.weight] ?? 0,
      notes: json[Apikeys.notes] ?? '',
      height: json[Apikeys.height] ?? 0,
      diabetesType: json[Apikeys.diabetesType] ?? 0,
      diagnosisDate: json[Apikeys.diagnosisDate] ?? '',
    );
  }
}
