class ServerException implements Exception {
  final String message;
  final String? code;

  const ServerException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'ServerException: $message';
}

class NetworkException implements Exception {
  final String message;
  final String? code;

  const NetworkException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  final String message;
  final String? code;

  const CacheException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'CacheException: $message';
}

class ConnectivityException implements Exception {
  final String message;
  final String? code;

  const ConnectivityException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'ConnectivityException: $message';
}
