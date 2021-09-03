/// 自定义异常

class ApiException implements Exception {
  int statusCode;
  ApiException(this.statusCode);
}

class AuthException implements Exception {
}

class FileNotFound implements Exception {
  String message;
  FileNotFound(this.message);
}

class Md5Error implements Exception {
  String message;
  Md5Error(this.message);
}