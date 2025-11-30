class UserEntity {
  final String studentCode;
  final String name;
  final String phone;
  final String email;
  final String parentPhone;
  final String city;
  final String grade;
  final String password;
  const UserEntity({
    required this.studentCode,
    required this.name,
    required this.phone,
    required this.email,
    required this.parentPhone,
    required this.city,
    required this.grade,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
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

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      studentCode: map['student_code'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      parentPhone: map['parent_phone'] ?? '',
      city: map['city'] ?? '',
      grade: map['grade'] ?? '',
      password: map['password'] ?? '',
    );
  }
}
