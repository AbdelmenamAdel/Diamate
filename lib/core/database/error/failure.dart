class Failure {
  final String errorMessage;
  final int statusCode;
  Failure({required this.errorMessage, required this.statusCode});

  factory Failure.fromJson(Map<String, dynamic> json) {
    String errorMessage = json['title'] ?? 'User not authenticated.';
    if (json.containsKey('') && json[''] is List) {
      errorMessage = (json[''] as List).join('\n');
    }
    return Failure(
      errorMessage: errorMessage,
      statusCode: json['status'] ?? 400,
    );
  }
}
