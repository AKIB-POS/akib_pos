class ServerException implements Exception {}
class CacheException implements Exception {}
class GeneralException implements Exception {
  final String message;

  GeneralException(this.message);

  @override
  String toString() => message;
}