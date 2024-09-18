class AppException implements Exception {
  final _prefix;
  final _message;

  AppException([this._prefix, this._message]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class NoInternetConnection extends AppException {
  NoInternetConnection([String? message])
      : super(message, "No internet connection");
}

class RequestTimeOutException extends AppException {
  RequestTimeOutException([String? message])
      : super(message, "Request time out");
}

class InternalServerException extends AppException {
  InternalServerException([String? message])
      : super(message, "Internal  server error");
}
