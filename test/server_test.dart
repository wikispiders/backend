import 'dart:io';
import 'package:http/http.dart';
import 'package:test/test.dart';
import 'package:web_socket_channel/io.dart';

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

  // test('Echo', () async {
  //   final response = await get(Uri.parse('$httpHost/echo/hello'));
  //   expect(response.statusCode, 200);
  //   expect(response.body, 'hello');
  // });

  // test('404', () async {
  //   final response = await get(Uri.parse('$httpHost/foobar'));
  //   expect(response.statusCode, 404);
  // });

  // test('websocket', () async {
  //   final socket = IOWebSocketChannel.connect('$webSocketpHost/ws');
  //   socket.sink.add('hola');
  //   var msg = await socket.stream.first;
  //   expect(msg, 'hola');
 
  // });

  test('websocket', () async {
    final socket = await WebSocket.connect('$webSocketpHost/ws');
    socket.add('hola');
    await socket.listen((message) {
      expect(message, equals('hola'));
    }).asFuture<void>();

  });


  // test('create & join', () async {
  //   final creator = IOWebSocketChannel.connect('$webSocketpHost/create');
    
    // late String gameid;
    // creator.listen(
    //   (msg) {
    //     print(msg);
    //     expect("ayy", "hola");
    //   },
    //   onDone: () {
    //     print('Connection closed');
    //   },
    //   onError: (error) {
    //     throw 'Se cerro la conexión del creador';
    //   },
    // );
    // socket.add('hola');
    // socket.listen((msg) {
    //   expect(msg, 'hola');
    // });
  // });



}
