class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);

  static const String baseUrl = "http://localhost:5500/api/";

  // ====================== Auth Routes ======================
  static const String login = "user/login";
  static const String register = "user/register";
}
