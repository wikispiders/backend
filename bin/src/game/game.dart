
import 'dart:async';
import 'dart:convert';

import '../events/game_events/game_event.dart';
import '../events/server_events/create_successful.dart';
import '../events/server_events/error.dart';
import '../events/server_events/join_successful.dart';
import '../events/server_events/server_event.dart';
import '../events/server_events/start_game.dart';
import '../player/player.dart';

class Game {
  int gameid;
  List<Player> players = [];
  var started = false;
  late final Future<void> gameLoopEnded;
  final loopsGame = 5; // TODO constante
  final StreamController<GameEvent> _eventsQueue = StreamController<GameEvent>();
  StreamController<GameEvent> get eventsQueue => _eventsQueue;


  Game(this.gameid, Player player) {
    players = [player];
    player.send(CreateSuccessful(gameid));
  }

  bool addPlayer(Player player) {
    if (started) {
      player.send(ErrorEvent('Game already started'));
      return false;
    } else {  
      players.add(player);
      broadcast(JoinSuccessful(player.name, players.map((p) => p.name).toList()));
      return true;
    }
  }

  Future<void> start() async {
    print('arranca la partida');
    await for (GameEvent event in _eventsQueue.stream) {
      if (event.execute(this)) break;
    }
    if (started) {
      await gameLoopEnded;
    }
    print('Termina el juego');
  }


  void startGame() {
    if (started) {
      print('Error: already started');
    } else {
      started = true;
      gameLoopEnded = gameLoop();
    }
  }

  void broadcast (ServerEvent message) {
    for (final player in players) {
      player.send(message);
    }
  }


 Future<void> gameLoop() async {
    print('Starting Gameloop');

    print('notify players of start...');
    
    final timeToStart = 3;
    broadcast(StartGame(timeToStart));
    await Future.delayed(Duration(seconds: timeToStart), () {
      print('Game is about to start');
    });
      
      jsonEncode({
      'event': 'start',
      'time': 10,
    }) as EventDTO);
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
