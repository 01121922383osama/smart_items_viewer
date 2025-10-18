import 'dart:developer' as developer;

enum LogLevel { debug, info, warning, error }

class Logger {
  static const String _tag = 'SmartItemsViewer';

  static void debug(String message, {String? tag}) {
    _log(LogLevel.debug, message, tag: tag);
  }

  static void info(String message, {String? tag}) {
    _log(LogLevel.info, message, tag: tag);
  }

  static void warning(String message, {String? tag}) {
    _log(LogLevel.warning, message, tag: tag);
  }

  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.error,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final logTag = tag ?? _tag;
    final timestamp = DateTime.now().toIso8601String();
    final levelString = level.name.toUpperCase();

    final logMessage = '[$timestamp] [$levelString] [$logTag] $message';

    switch (level) {
      case LogLevel.debug:
        developer.log(logMessage, name: logTag);
        break;
      case LogLevel.info:
        developer.log(logMessage, name: logTag);
        break;
      case LogLevel.warning:
        developer.log(logMessage, name: logTag, level: 900);
        break;
      case LogLevel.error:
        developer.log(
          logMessage,
          name: logTag,
          level: 1000,
          error: error,
          stackTrace: stackTrace,
        );
        break;
    }
  }
}
