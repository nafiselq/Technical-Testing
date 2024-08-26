class Failure {
  final int statusCode;
  final String message;

  Failure({required this.statusCode, required this.message});

  factory Failure.fromJson(Map<String, dynamic> json) {
    return Failure(
      statusCode: json['statusCode'],
      message: json['message'],
    );
  }
}
