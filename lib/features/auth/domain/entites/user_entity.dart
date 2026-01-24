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
import 'package:diamate/core/database/api/end_points.dart';

class UserEntity {
  final String userName;
  final String password;
  final String firstName;
  final String secondName;
  final String thirdName;
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
  const UserEntity({
    required this.userName,
    required this.password,
    required this.firstName,
    required this.secondName,
    required this.thirdName,
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
      Apikeys.secondName: secondName,
      Apikeys.thirdName: thirdName,
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

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      userName: map[Apikeys.userName] ?? '',
      password: map[Apikeys.password] ?? '',
      firstName: map[Apikeys.firstName] ?? '',
      secondName: map[Apikeys.secondName] ?? '',
      thirdName: map[Apikeys.thirdName] ?? '',
      lastName: map[Apikeys.lastName] ?? '',
      dateOfBirth: map[Apikeys.dateOfBirth] ?? '',
      gender: map[Apikeys.gender] ?? 0,
      address: map[Apikeys.address] ?? '',
      phone: map[Apikeys.phone] ?? '',
      homePhone: map[Apikeys.homePhone] ?? '',
      email: map[Apikeys.email] ?? '',
      profileImage: map[Apikeys.profileImage] ?? '',
      weight: map[Apikeys.weight] ?? 0,
      notes: map[Apikeys.notes] ?? '',
    );
  }
}
