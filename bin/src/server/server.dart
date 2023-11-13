import 'dart:io';
import '../lobby/lobby.dart';

class BackendServer {
  InternetAddress ip;
  int port;
  Lobby lobby = Lobby();

  BackendServer({required this.ip, required this.port});

  Future<void> start() async {
    final server = await HttpServer.bind(ip, port);
    print('Listening on ws://${server.address.address}:${server.port}');

    await for (HttpRequest request in server) {
      final endpoints = request.uri.path.split('/');
      if (endpoints.isNotEmpty && endpoints[1] == 'create') {
        print("Es un create");
        WebSocketTransformer.upgrade(request).then((WebSocket socket) {
          lobby.create(socket, 'nombre creador');
        });
      } else if (endpoints.length > 1 && endpoints[1] == 'join') {
        print("Es un join");
        WebSocketTransformer.upgrade(request).then((WebSocket socket) {
          // TODO: recibir nombre. Chequear el parse.
          lobby.join(socket, int.parse(endpoints[2]), 'un nombre');
        });
      } else {
        request.response
          ..statusCode = HttpStatus.forbidden
          ..close();
      }
    }
  }

}
