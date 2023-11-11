
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../player/player.dart';

class Game {
  String gameid;
  List<Player> players = [];
  var started = false;
  final loopsGame = 5;
  final StreamController<String> _eventsQueue = StreamController<String>();
  StreamController<String> get eventsQueue => _eventsQueue;


  Game(this.gameid, Player player) {
    players = [player];
    player.createSuccessful(gameid);
  }

  bool addPlayer(Player player) {
    if (started) {
      player.add({
        'status': 'error',
        'msg': 'Game already started'
      });
      return false;
    } else {  
      players.add(player);
      player.add(jsonEncode({'join': 'success'}));
      eventsQueue.add(jsonEncode({'event': 'newplayer'}));
      return true;
    }
  }
  

  Future<void> start() async {
    late Future<void> gameLoopEnded;
    print('arranca la partida');
    await for (String event in  _eventsQueue.stream) {
      print("El juego recibe el evento $event");
      Map<String, dynamic> received = jsonDecode(event);
      final typeEvent = received['event']; 
      if (typeEvent == 'newplayer') {
        print('llega un nuevo jugador. Aviso a todos los demas!');
        broadcast(jsonEncode({
          'event': 'newplayer',
          'players': 
        }))
        gameLoopEnded = gameLoop();
      } else if (typeEvent == 'end') {
        break;
      }
    } 
    await gameLoopEnded;
    print('Termina el juego');
  }


  Future<void> gameLoop() async {
    started = true;
    print('Starting Gameloop');

    print('notify players of start...');
    broadcast(jsonEncode({
      'event': 'start',
      'time': 10,
    }));
    await Future.delayed(Duration(seconds: 10), () {
      print('Game is about to start');
    });
    for (int i = 0; i < loopsGame; ++i) {
      await Future.delayed(Duration(seconds: 10), () {
        print('Jugando..');
        // update game state results
        // send answers
        // send next question
        // 
      });
    }
    print('Terminando..');
    _eventsQueue.add(jsonEncode({'event': 'end'}));
    


  }



  void broadcast (String message) async {
    for (var player in players) {
      player.add(message);
    }
  }


  



















  void sendQuestionToPlayers() {
    // Lógica para enviar la pregunta y opciones a los jugadores
    var question = '¿Ejemplo de pregunta?';
    var options = ['Opción 1', 'Opción 2', 'Opción 3'];

    for (var player in players) {
      player.add(jsonEncode({'question': question, 'options': options}));
    }

    Timer(Duration(seconds: 10), () {
      sendResultsToPlayers();
    });
  }

  void sendResultsToPlayers() {
    // Lógica para enviar los resultados a los jugadores
    var results = {'player1': 'resultado', 'player2': 'resultado'};
    for (var player in players) {
      player.add(jsonEncode({'results': results}));
    }
  }
}
