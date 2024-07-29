class ServerException implements Exception {}

class NotFoundException implements Exception {
  final String message;

  NotFoundException(this.message);
}

class CachedException implements Exception {}
class AuthException implements Exception {}

