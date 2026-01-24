class EndPoint {
  static const String baseUrl =
      'https://diamate-edh9dcadbffdfack.francecentral-01.azurewebsites.net/api/';
  static const String login = 'Account/LogIn';
  static const String signUp = 'Account/RegisterNewUser';
  static const String getUserData = 'student/profile';
  static const String getLectures = 'dashboard/my-chapters';
  static const String deleteStudent = 'student/account/confirm-delete';
  static const String refreshToken = '/token/refresh';
  // deleteUser + id method in AuthRepoImpl to delete account from server side
}

class Apikeys {
  static const String userName = 'userName';
  static const String password = 'password';
  static const String accessToken = 'accessToken';
  static const String refreshToken = 'refreshToken';
  static const String tokenType = 'tokenType';
  static const String email = 'email';
  static const String name = 'name';
  static const String phone = 'phone';
  static const String city = 'city';
  static const String firstName = 'firstName';
  static const String secondName = 'secondName';
  static const String thirdName = 'thirdName';
  static const String lastName = 'lastName';
  static const String dateOfBirth = 'dateOfBirth';
  static const String gender = 'gender';
  static const String address = 'address';
  static const String homePhone = 'homePhone';
  static const String profileImage = 'profileImage';
  static const String weight = 'weight';
  static const String notes = 'notes';
}
