class Failure {
  final String errorMessage;

  Failure({required this.errorMessage});

  factory Failure.fromJson(Map<String, dynamic> json) {
    return Failure(errorMessage: json['detail'] ?? 'User not authenticated.');
  }
}
