import 'dart:io';
import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:shelf_router/shelf_router.dart';

import '../lobby/lobby.dart';

class BackendServer {
  final InternetAddress _ip;
  final int _port;
  final Lobby _lobby = Lobby();
  final Router _router = Router();
  final Logger logger = Logger('Server');

  BackendServer(this._ip, this._port) {
    _setupRouter();
  }

  void _setupRouter() {
    _router.get('/create/<playerName>', (shelf.Request request, String playerName) {
      playerName = Uri.decodeComponent(playerName);
      logger.fine("Create arrived from: $playerName.");
      return webSocketHandler((webSocket) {
        _lobby.create(webSocket, playerName);
      })(request);
    });

    _router.get('/join/<gameId>/<playerName>', (shelf.Request request, String gameId, String playerName) {
      playerName = Uri.decodeComponent(playerName);
      final int? parsedGameId = int.tryParse(gameId);
      if (parsedGameId != null) {
        logger.fine("Join to game $parsedGameId arrived from $playerName.");
        return webSocketHandler((webSocket) {
          _lobby.join(webSocket, parsedGameId, playerName);
        })(request);
      } else {
        return shelf.Response.forbidden('Invalid game ID');
      }
    });

    _router.all('/<ignored|.*>', (shelf.Request request) {
      return shelf.Response.forbidden('Forbidden');
    });
  }

  Future<void> start() async {
    final handler = shelf.Pipeline()
        .addMiddleware(shelf.logRequests())
        .addHandler(_router);

    final server = await shelf_io.serve(handler, _ip, _port);
    logger.info('Listening on ws://${server.address.host}:${server.port}');
  }
}
