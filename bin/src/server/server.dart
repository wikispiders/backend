import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import '../../routes/routes.dart';
import '../lobby/lobby.dart';

class BackendServer {
  InternetAddress ip;
  int httpPort;
  int webSocketPort;
  Lobby lobby = Lobby();

  BackendServer({required this.ip, required this.httpPort, required this.webSocketPort});

  Future<void> start() async {
    final services = Service(); 
    final httpHandler = Pipeline().addMiddleware(logRequests()).addHandler(services.httpHandler(lobby));
    final httpServer = await serve(httpHandler, ip, httpPort);

    //final webSocketHandler = Pipeline().addMiddleware(logRequests()).addHandler(services.webSocketHandler(lobby));
    //final webSocketServer = await serve(webSocketHandler, ip, webSocketPort);

    print('HTTP Server listening on port ${httpServer.port}');
    // print('WebSocket Server listening on port ${webSocketServer.port}');

  }

}
