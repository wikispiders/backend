import 'dart:io';
import 'src/server/server.dart';

void main(List<String> args) async {
  final ip = InternetAddress.anyIPv4;
  final httpPort = int.parse(Platform.environment['HTTPPORT'] ?? '8080');
  final webSocketPort = int.parse(Platform.environment['HTTPPORT'] ?? '8081');
  final server = BackendServer(ip: ip, httpPort: httpPort, webSocketPort: webSocketPort);
  await server.start();
}
