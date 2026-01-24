class Failure {
  final String errorMessage;
  final int statusCode;
  Failure({required this.errorMessage, required this.statusCode});

  factory Failure.fromJson(Map<String, dynamic> json) {
    return Failure(
      errorMessage: json['title'] ?? 'User not authenticated.',
      statusCode: json['status'],
    );
  }
}
