import 'dart:async';

import 'package:logging/logging.dart';

import '../events/server_events/create_successful.dart';
import '../events/server_events/error.dart';
import '../events/server_events/join_successful.dart';
import '../events/server_events/question.dart';
import '../events/server_events/server_event.dart';
import '../events/server_events/start_game.dart';
import '../player/player.dart';
import 'constants.dart';
import 'questions.dart';


class Game {
  int gameid;
  String creatorName;
  List<Player> players = [];
  var started = false;
  final Logger _logger;
  Completer<void> gameStarted = Completer<void>();
  Completer<void> creatorLeftBeforeStart = Completer<void>(); // TODO: usarlo/
  // TODO: Completer<void> allPlayersLeft = Completer<void>();

  late Questions questions;


  Game(this.gameid, Player player): creatorName = player.name, _logger = Logger('Game-$gameid') {
    players = [player];
    player.send(CreateSuccessful(gameid));
  }

  bool addPlayer(Player player) {
    if (started) {
      player.send(ErrorEvent('Game already started'));
      return false;
    } else if (playersNames().contains(player.name)){
      player.send(ErrorEvent('Name already in use'));
      return false;
    } else {
      players.add(player);
      broadcast(JoinSuccessful(player.name, playersNames()));
      return true;
    }
  }

// TODO: removePlayer que llame al completer si no hay ningun jugador conectado.
  void removePlayer(String playerName) {
    if (playerName == creatorName && !started) {
      creatorLeftBeforeStart.complete();
    }

    players.removeWhere((player) => player.name == playerName);
    // TODO: broadcast remove.
  }


  Future<void> start() async {
    await gameStarted.future; // TODO: await de se va el creador y de si se van todos.
    if (started) {
      await gameLoop();
    }
    _logger.info('Game over');
  }


  bool startGame() {
    if (started) {
      _logger.warning('Error: already started');
      return false;
    } else {
      started = true;
      gameStarted.complete();
      return true;
    }
  }

  void broadcast (ServerEvent message) {
    for (final player in players) {
      player.send(message);
    }
  }


 Future<void> gameLoop() async {
    _logger.finer('Starting Gameloop');
    questions = Questions.fromRandomQuestions(playersNames());

    _logger.finest('Notify Players of start...');
    
    broadcast(StartGame(TIME_UNTIL_START_SECONDS));
    await Future.delayed(Duration(seconds: TIME_UNTIL_START_SECONDS));  
    _logger.finer('Game sending Questions in loop');
  
    while (questions.moreToProcess()) {
      final FullQuestion currentQuestion = questions.current();
      broadcast(Question(currentQuestion.question, currentQuestion.options, QUESTION_DURATION_SECONDS));
      await Future.delayed(Duration(seconds: QUESTION_DURATION_SECONDS));
      broadcast(questions.getResults()); 
    }
    // TODO: broadcast Final Stats (el que tuvo mejor racha, el que fue mas lento, el mas rapido).
  }

  List<String> playersNames() {
    return players.map((e) => e.name).toList();
  }

  void submitAnswer(String question, String answer, String player) {
    questions.submitAnswer(question, answer, player);
    // TODO: mandarle al player en particular a quien presiono el.
  }

}
