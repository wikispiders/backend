import 'dart:io';
import 'src/server/server.dart';

void main(List<String> args) async {
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '4040');
  final server = BackendServer(ip: ip, port: port);
  await server.start();
}
