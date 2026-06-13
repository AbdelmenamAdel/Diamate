import 'dart:io';

class EndPoint {
  static const String iphoneIp = '127.0.0.1';
  static const String androidIp = '10.0.2.2';
  static String get baseUrl => Platform.isAndroid
      ? 'http://$androidIp:8080/api/'
      : 'http://$iphoneIp:8080/api/';
  static const String login = 'Account/LogIn';
  static const String signUp = 'Account/RegisterNewUser';
  static const String getUserData = 'student/profile';
  static const String getLectures = 'dashboard/my-chapters';
  static const String deleteStudent = 'student/account/confirm-delete';
  static const String refreshToken = 'token/refresh';
  static const String chatBotSendMessage = 'api/v1/chat';
  static const String getPatient = 'Patients/GetPatient/';
  static const String addGlucoseReading =
      'BloodGlucoseReading/AddReadingForPatient';
  static const String addMedicine = 'Medicine/AddNewMedicine';
  static const String analyzeFood = 'Food/AnalyzeImage';
  static String get detectFood => Platform.isAndroid
      ? 'http://$androidIp:8001/detect-food'
      : 'http://$iphoneIp:8001/detect-food';
  static const String addFoodMeal = 'Meal/AddNewMeal';
  static String getFoodMeals(int patientId) =>
      'Meal/GetAllMealsForPatient/$patientId';
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
  static const String sessionId = "session_id";
  static const String question = "question";
  static const String height = "height";
  static const String diabetesType = "diabetesType";
  static const String diagnosisDate = "dateOfDiagnosis";
  static const String id = "id";
}
