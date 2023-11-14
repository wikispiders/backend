import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:logging/logging.dart';

import '../events/server_events/error.dart';
import '../player/player.dart';
import '../game/game.dart';

class Lobby {
  final Map<int, Game> _games = {};
  final _logger = Logger('Lobby') ;

  Lobby();

  Future<void> create (WebSocket socket, String playerName) async {
    final gameid = _generateGameId();
    final player = Player(playerName, socket);
    final game = Game(gameid, player);
    _games[gameid] = game;
    _logger.info('Game $gameid created. Number of Games: ${_games.length}');

    await Future.wait([game.start(), player.receiveEvents(game)]);

    _games.remove(gameid);
    _logger.fine('Creator $playerName finishes');
  }


  Future<void> join (WebSocket socket, int gameid, String playerName) async {
    final player = Player(playerName, socket);
    
    if (!_games.containsKey(gameid)) {
      player.send(ErrorEvent('Game $gameid does not exist'));
      return;
    }
    final game = _games[gameid]; 

    if (game!.addPlayer(player)) {
      await player.receiveEvents(game);
    }
  }

  int _generateGameId() {
    var posibleGameid = Random().nextInt(900000) + 100000; // numero de 6 digitos.
    while (_games.containsKey(posibleGameid)) {
      posibleGameid = Random().nextInt(900000) + 100000;
    }
    return posibleGameid;
  }
}
