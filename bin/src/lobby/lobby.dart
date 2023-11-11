import 'dart:async';
import 'dart:io';

import '../player/player.dart';
import '../game/game.dart';

class Lobby {
  Map<String, Game> games = {};

  Lobby();


  Future<void> create (WebSocket socket) async {
    var gameid = DateTime.now().microsecondsSinceEpoch.toString(); // TODO: crear gameid con algo mas aleatorio.
    final player = Player('creador nombre', socket);
    var game = Game(gameid, player); // TODO: cambiar socket por clase Player.
    games[gameid] = game; // TODO: chequear si existe
    final finished =  game.start();
    player.receiveEvents(game.eventsQueue);
    await finished; // TODO: Eliminar al juego del diccionario.
    print('termina el creador');
  }


  void join (WebSocket socket, String gameid) {
    var game = games[gameid]; // TODO: chequear error.
    if (game == null) {
      socket.add({
        'status': 'error',
        'msg': 'Game doesnt exist'
      });
      return;
    }
    final player = Player('un nombre', socket);

    if (game.addPlayer(player)) {
      player.receiveEvents(game.eventsQueue);
    }
  }
  
}