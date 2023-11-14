import 'dart:io';
import 'package:logging/logging.dart';

import '../lobby/lobby.dart';

class BackendServer {
  final InternetAddress _ip;
  final int _port;
  final Lobby _lobby = Lobby();
  final Logger logger = Logger('Server');


  BackendServer(this._ip, this._port);

  // TODO: ver de cambiar todo esto para usar Router().
  Future<void> start() async {
    final server = await HttpServer.bind(_ip, _port);
    logger.info('Listening on ws://${server.address.address}:${server.port}');
    await for (HttpRequest request in server) {
      final endpoints = request.uri.path.split('/');
      if (endpoints.length == 3 && endpoints[1] == 'create') {
        final playerName = endpoints[2]; // TODO: manejar cuando es un nombre con espacios.
        logger.fine("Create arrived from: $playerName.");
        WebSocketTransformer.upgrade(request).then((WebSocket socket) {
          _lobby.create(socket, playerName);
        });
      } else if (endpoints.length == 4 && endpoints[1] == 'join') {
        final playerName = endpoints[3];
        WebSocketTransformer.upgrade(request).then((WebSocket socket) {
          final int? gameid = int.tryParse(endpoints[2]);
          if (gameid != null) {
            logger.fine("Join to game $gameid arrived from $playerName.");
            _lobby.join(socket, gameid, endpoints[3]);  
          } else {
            // TODO: mandar el error al cliente.
          }
        });
      } else {
        request.response
          ..statusCode = HttpStatus.forbidden
          ..close();
      }
    }
  }

}
