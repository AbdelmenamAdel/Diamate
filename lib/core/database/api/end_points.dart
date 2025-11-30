class EndPoint {
  static const String baseUrl =
      'https://ordinary-buzzard-pplo-4acc2de9.koyeb.app/';
  static const String login = 'login';
  static const String getUserData = 'student/profile';
  static const String getLectures = 'dashboard/my-chapters';
  static const String deleteStudent = 'student/account/confirm-delete';
  static const String refreshToken = '/token/refresh';
  // deleteUser + id method in AuthRepoImpl to delete account from server side
}

class Apikeys {
  static const String identifier = 'identifier';
  static const String password = 'password';
  static const String accessToken = 'accessToken';
  static const String refreshToken = 'refreshToken';
  static const String tokenType = 'tokenType';
  static const String email = 'email';
  static const String studentCode = 'student_code';
  static const String name = 'name';
  static const String phone = 'phone';
  static const String parentPhone = 'parent_phone';
  static const String city = 'city';
  static const String grade = 'grade';
}
