import 'dart:async';

import 'package:logging/logging.dart';

import '../events/server_events/answer_submited.dart';
import '../events/server_events/create_successful.dart';
import '../events/server_events/error.dart';
import '../events/server_events/join_successful.dart';
import '../events/server_events/player_left.dart';
import '../events/server_events/question.dart';
import '../events/server_events/server_event.dart';
import '../events/server_events/start_game.dart';
import '../player/player.dart';
import 'constants.dart';
import 'full_question.dart';
import 'questions.dart';

class Game {
  int gameid;
  String creatorName;
  List<Player> players = [];
  List<Player> waitingPlayAgainPlayers = [];
  var started = false;
  final Logger _logger;
  Completer<void> gameStarted = Completer<void>();
  Completer<void> allPlayersLeft = Completer<void>();
  late String category;
  late int amountQuestions;
  late String type;
  late Questions questions;

  Game(this.gameid, Player player)
      : creatorName = player.name,
        _logger = Logger('Game-$gameid') {
    players = [player];
    player.send(CreateSuccessful(gameid));
  }

  bool addPlayer(Player player) {
    if (started) {
      player.send(ErrorEvent('Game already started'));
      return false;
    } else if (playersNames().contains(player.name)) {
      player.send(ErrorEvent('Name already in use'));
      return false;
    } else {
      players.add(player);
      broadcast(JoinSuccessful(player.name, playersNames(), gameid));
      return true;
    }
  }

  void removePlayer(String playerName) {
    bool truePlayerLeft = players.any((player) => player.name == playerName);
    players.removeWhere((player) => player.name == playerName);
    waitingPlayAgainPlayers.removeWhere((player) => player.name == playerName);
    if (players.isEmpty && waitingPlayAgainPlayers.isEmpty) {
      allPlayersLeft.complete();
    } else if (playerName == creatorName && players.isNotEmpty) {
      creatorName = players[0].name;
    }
    if (truePlayerLeft) {
      broadcast(PlayerLeft(playerName, creatorName));
    }
  }

  Future<void> start() async {
    while (players.isNotEmpty || waitingPlayAgainPlayers.isNotEmpty) {
      await Future.any([gameStarted.future, allPlayersLeft.future]);
      if (started) {
        waitingPlayAgainPlayers.clear();
        await gameLoop();
        gameStarted = Completer<void>();
        started = false;
        waitingPlayAgainPlayers.addAll(players);
        players.clear();
      }
    }
    _logger.info('All players left');
    _logger.info('Game over');
  }

  bool startGame(String player, String category, int amountQuestions, String type) {
    if (player != creatorName) {
      sendToPlayer(ErrorEvent('Only the Creator can start the Game'), player);
      _logger.warning('Error: joiner can not start game');
      return false;
    } else if (started) {
      sendToPlayer(ErrorEvent('Game Already Started'), player);
      _logger.warning('Error: already started');
      return false;
    } else {
      this.category = category;
      this.amountQuestions = amountQuestions;
      this.type = type;
      started = true;
      gameStarted.complete();
      return true;
    }
  }

  void broadcast(ServerEvent message) {
    for (final player in players) {
      player.send(message);
    }
  }

  void sendToPlayer(ServerEvent message, String name) {
    players.firstWhere((player) => player.name == name).send(message);
  }

  Future<void> gameLoop() async {
    _logger.finer('Starting Gameloop');
    questions = await Questions.fromRandomQuestions(playersNames(), category, amountQuestions, type);

    _logger.finest('Notify Players of start...');

    broadcast(StartGame(TIME_UNTIL_START_SECONDS));
    await Future.delayed(Duration(seconds: TIME_UNTIL_START_SECONDS));
    _logger.finer('Game sending Questions in loop');

    while (questions.moreToProcess()) {
      final FullQuestion currentQuestion = questions.current();
      broadcast(Question(currentQuestion.question, currentQuestion.options,
          QUESTION_DURATION_SECONDS, currentQuestion.numberOfQuestion, currentQuestion.totalQuestions));
      await Future.delayed(Duration(seconds: QUESTION_DURATION_SECONDS));
      var results = questions.getResults();
      broadcast(results);
      await Future.delayed(Duration(seconds: TIME_FIRST_RESULT_SCREEN));
      results.next();
      broadcast(results);
      await Future.delayed(Duration(seconds: TIME_PARTIAL_RESULTS_SCREEN));
      if (!questions.moreToProcess()) {
        results.next();
        broadcast(results);
        print("Se broadcastea el result");
      }
    }
  }

  List<String> playersNames() {
    return players.map((e) => e.name).toList();
  }

  void submitAnswer(String question, String answer, String player) {
    if (questions.submitAnswer(question, answer, player)) {
      sendToPlayer(AnswerSubmitted(question, answer), player);
    } else {
      sendToPlayer(
          ErrorEvent('Unable to submit answer $answer to question $question'),
          player);
    }
  }

  void playAgainRequest(String name) {
    Player player = waitingPlayAgainPlayers.firstWhere((player) => player.name == name);
    players.add(player);
    if (players.length == 1) {
      // Es el primero en pedir Play Again -> Es el creador.
      creatorName = name;
      player.send(CreateSuccessful(gameid));
    } else {
      // Se une a la partida.
      broadcast(JoinSuccessful(player.name, playersNames(), gameid));
    }
  }
}
