/// 自定义异常

class ApiException implements Exception {
  int statusCode;
  ApiException(this.statusCode);
}

class AuthException implements Exception {
}