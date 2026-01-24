import 'package:diamate/features/auth/domain/entites/user_entity.dart';

class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final UserEntity user;
  const LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.user,
  });
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      tokenType: json['token_type'],
      user: UserEntity.fromMap(json['data']),
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      userName: user.userName,
      password: user.password,
      firstName: user.firstName,
      secondName: user.secondName,
      thirdName: user.thirdName,
      lastName: user.lastName,
      dateOfBirth: user.dateOfBirth,
      gender: user.gender,
      address: user.address,
      phone: user.phone,
      homePhone: user.homePhone,
      email: user.email,
      profileImage: user.profileImage,
      weight: user.weight,
      notes: user.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'tokenType': tokenType,
      'user': user.toMap(),
    };
  }
}
