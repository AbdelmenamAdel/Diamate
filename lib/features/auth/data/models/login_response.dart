class LoginResponse {
  final String token;
  final String expirationDate;
  const LoginResponse({required this.token, required this.expirationDate});
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      expirationDate: json['expiration'],
    );
  }
}
