import 'dart:io';
import 'src/server/server.dart';
import 'package:logging/logging.dart';

void main(List<String> args) async {
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '4040');
  
  Logger.root.level = getLogLevel();
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name} | ${rec.time} | ${rec.message}');
    if (rec.error != null) {
      print('Error: ${rec.error}');
      print('Stack trace:\n${rec.stackTrace}');
    }
  });

  final server = BackendServer(ip, port);
  await server.start();
}


Level getLogLevel() {
  String logLevel = Platform.environment['LOG_LEVEL'] ?? 'DEBUG';
  switch (logLevel) {
    case 'DEBUG':
      return Level.FINEST;
    case 'INFO':
      return Level.INFO;
    case 'ERROR':
      return Level.SEVERE;
    default:
      return Level.INFO;
  }
}