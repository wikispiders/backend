import 'dart:async';

import '../events/server_events/create_successful.dart';
import '../events/server_events/error.dart';
import '../events/server_events/join_successful.dart';
import '../events/server_events/question.dart';
import '../events/server_events/server_event.dart';
import '../events/server_events/start_game.dart';
import '../player/player.dart';
import 'constants.dart';
import 'questions.dart';

const int creatorId = 0;

class Game {
  int gameid;
  int lastPlayerId = creatorId;
  Map<int, Player> players = {};
  var started = false;
  Completer<void> gameStarted = Completer<void>();
  Completer<void> creatorLeftBeforeStart = Completer<void>(); // TODO: usarlo/
  // TODO: Completer<void> allPlayersLeft = Completer<void>();

  late Questions questions;


  Game(this.gameid, Player player) {
    players[creatorId] = player;
    player.send(CreateSuccessful(gameid));
  }

  bool addPlayer(Player player) {
    if (started) {
      player.send(ErrorEvent('Game already started'));
      return false;
    } else {
      lastPlayerId++;
      players[lastPlayerId] = player;
      player.addId(lastPlayerId);
      broadcast(JoinSuccessful(player.name, playersNames()));
      return true;
    }
  }

// TODO: removePlayer que llame al completer si no hay ningun jugador conectado.

  void removePlayer(int playerId) {
    if (playerId == creatorId && !started) {
      creatorLeftBeforeStart.complete();
    }
    players.remove(playerId);
    // TODO: broadcast remove.
  }


  Future<void> start() async {
    await gameStarted.future; // TODO: await de se va el creador.
    if (started) {
      await gameLoop();
    }
    print('Termina el juego');
  }


  bool startGame() {
    if (started) {
      print('Error: already started');
      return false;
    } else {
      started = true;
      gameStarted.complete();
      return true;
    }
  }

  void broadcast (ServerEvent message) {
    players.forEach((id, player) {
      player.send(message);
    });
  }


 Future<void> gameLoop() async {
    print('Starting Gameloop');
    questions = Questions.fromRandomQuestions(playersNames());

    print('notify players of start...');
    
    broadcast(StartGame(TIME_UNTIL_START_SECONDS));
    await Future.delayed(Duration(seconds: TIME_UNTIL_START_SECONDS));  
    print('Game is about to start');
  
    while (questions.moreToProcess()) {
      final FullQuestion currentQuestion = questions.current();
      broadcast(Question(currentQuestion.question, currentQuestion.options, QUESTION_DURATION_SECONDS));
      await Future.delayed(Duration(seconds: QUESTION_DURATION_SECONDS));
      broadcast(questions.getResults()); 
    }
    // TODO: broadcast Final Stats (el que tuvo mejor racha, el que fue mas lento, el mas rapido).

    print('Terminando..');
  }

  List<String> playersNames() {
    List<String> names = [];
    players.forEach((id, player) { 
      names.add(player.name);
    });
    return names;
  }

}
