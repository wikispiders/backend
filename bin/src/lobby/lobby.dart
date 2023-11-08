import 'dart:convert';
import 'dart:io';

import '../game/game.dart';

class Lobby {
  Map<String, Game> games = {};

  Lobby();

  void hi (webSocket) {
    webSocket.listen((message) {
      webSocket.add('Received: $message');
    });
  }

  // start() async {
  //     await for (HttpRequest request in server) {
  //   try {
  //     if (request.uri.path == '/crearPartida') {
  //       var token = DateTime.now().microsecondsSinceEpoch.toString();
  //       var game = Game(token);
  //       games[token] = game;
  //       request.response
  //         ..statusCode = HttpStatus.ok
  //         ..write(jsonEncode({'token': token}))
  //         ..close();
  //     } else if (request.uri.path == '/unirse') {
  //       var token = request.uri.queryParameters['token'];
  //       if (games.containsKey(token)) {
  //         var game = games[token]!;
  //         WebSocketTransformer.upgrade(request).then((WebSocket socket) {
  //           game.addPlayer(socket);
  //         });
  //       } else {
  //         request.response
  //           ..statusCode = HttpStatus.notFound
  //           ..write('Partida no encontrada')
  //           ..close();
  //       }
  //     }
  //   } catch (e) {
  //     request.response
  //       ..statusCode = HttpStatus.internalServerError
  //       ..write('Error en el servidor: $e')
  //       ..close();
  //   }
  // }
  // }
  
}