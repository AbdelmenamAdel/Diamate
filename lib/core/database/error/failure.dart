class Failure {
  final String? errorMessage;
  final int? statusCode;
  Failure({this.errorMessage, this.statusCode});

  factory Failure.fromJson(Map<String, dynamic> json) {
    String errorMessage = json['title'] ?? 'An unexpected error occurred.';
    if (json.containsKey('') && json[''] is List) {
      errorMessage = (json[''] as List).join('\n');
    }
    return Failure(
      errorMessage: errorMessage,
      statusCode: json['status'] ?? 400,
    );
  }
}
