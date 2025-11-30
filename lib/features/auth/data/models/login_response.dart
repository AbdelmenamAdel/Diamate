import 'package:diamate/features/auth/domain/entites/user_entity.dart';

class LoginResponse extends UserEntity {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  const LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required super.studentCode,
    required super.name,
    required super.phone,
    required super.email,
    required super.parentPhone,
    required super.city,
    required super.grade,
    required super.password,
  });
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      tokenType: json['token_type'],
      studentCode: json['data']['student_code'],
      name: json['data']['name'],
      phone: json['data']['phone'],
      email: json['data']['email'],
      parentPhone: json['data']['parent_phone'],
      city: json['data']['city'],
      grade: json['data']['grade'],
      password: json['data']['password'],
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      studentCode: studentCode,
      name: name,
      phone: phone,
      email: email,
      parentPhone: parentPhone,
      city: city,
      grade: grade,
      password: password,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'student_code': studentCode,
      'name': name,
      'phone': phone,
      'email': email,
      'parent_phone': parentPhone,
      'city': city,
      'grade': grade,
      'password': password,
    };
  }
}
