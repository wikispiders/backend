import 'dart:io';
import 'package:http/http.dart';
import 'package:test/test.dart';

void main() {
  final httpPort = '8080';
  final webSocketPort = '8081';
  final httpHost = 'http://0.0.0.0:$httpPort';
  final webSocketpHost = 'ws://127.0.0.1:$httpPort';

  late Process p;

  setUp(() async {
    p = await Process.start(
      'dart',
      ['run', 'bin/main.dart'],
      environment: {'HTTPPORT': httpPort, 'WEBSOCKETPORT': webSocketPort},
    );
    // Wait for server to start and print to stdout.
    await p.stdout.first;
  });

  tearDown(() => p.kill());

  test('Root', () async {
    final response = await get(Uri.parse('$httpHost/'));
    expect(response.statusCode, 200);
    expect(response.body, 'Hello, World!\n');
  });

  test('Echo', () async {
    final response = await get(Uri.parse('$httpHost/echo/hello'));
    expect(response.statusCode, 200);
    expect(response.body, 'hello');
  });

  test('404', () async {
    final response = await get(Uri.parse('$httpHost/foobar'));
    expect(response.statusCode, 404);
  });

  test('websocket', () async {
    final socket = await WebSocket.connect('$webSocketpHost/ws');
    socket.add('hola');
    socket.listen((msg) {
      expect(msg, 'hola');
    });
  });
}
