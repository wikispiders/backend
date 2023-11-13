import 'dart:async';
import 'dart:io';
import 'dart:math';

import '../events/server_events/error.dart';
import '../player/player.dart';
import '../game/game.dart';

class Lobby {
  Map<int, Game> games = {};

  Lobby();

  Future<void> create (WebSocket socket, String playerName) async {
    final gameid = _generateGameId(); 
    final player = Player(playerName, socket);
    var game = Game(gameid, player);
    games[gameid] = game; 

    final finished =  game.start();
    player.receiveEvents(game.eventsQueue);
    
    await finished;
    games.remove(gameid);
    print('termina el creador');
  }


  void join (WebSocket socket, int gameid, String playerName) {
    final player = Player('un nombre', socket);
    
    if (!games.containsKey(gameid)) {
      player.send(ErrorEvent('Game doesnt exist'));
      return;
    }
    var game = games[gameid]; 

    if (game!.addPlayer(player)) {
      player.receiveEvents(game.eventsQueue);
    }
  }
  

  int _generateGameId() {
    var posibleGameid = Random().nextInt(900000) + 100000; // numero de 6 digitos.
    while (games.containsKey(posibleGameid)) {
      posibleGameid = Random().nextInt(900000) + 100000;
    }
    return posibleGameid;
  }
}
