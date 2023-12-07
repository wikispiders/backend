import 'dart:async';

import 'package:logging/logging.dart';

import '../events/server_events/answer_submited.dart';
import '../events/server_events/create_successful.dart';
import '../events/server_events/error.dart';
import '../events/server_events/join_successful.dart';
import '../events/server_events/play_again_request.dart';
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
  var started = false;
  final Logger _logger;
  bool playAgainSended = false;
  Completer<void> gameStarted = Completer<void>();
  Completer<void> allPlayersLeft = Completer<void>();

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
    players.removeWhere((player) => player.name == playerName);
    if (players.isEmpty) {
      allPlayersLeft.complete();
    } else if (playerName == creatorName) {
      creatorName = players[0].name;
    }
    broadcast(PlayerLeft(playerName, creatorName));
  }

  Future<void> start() async {
    await Future.any([gameStarted.future, allPlayersLeft.future]);
    if (players.isEmpty) {
      _logger.info('All players left');
      return;
    } else if (started) {
      await gameLoop();
    }
    _logger.info('Game over');
  }

  bool startGame(String player) {
    if (player != creatorName) {
      sendToPlayer(ErrorEvent('Only the Creator can start the Game'), player);
      _logger.warning('Error: joiner can not start game');
      return false;
    } else if (started) {
      sendToPlayer(ErrorEvent('Game Already Started'), player);
      _logger.warning('Error: already started');
      return false;
    } else {
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
    questions = await Questions.fromRandomQuestions(playersNames());

    _logger.finest('Notify Players of start...');

    broadcast(StartGame(TIME_UNTIL_START_SECONDS));
    await Future.delayed(Duration(seconds: TIME_UNTIL_START_SECONDS));
    _logger.finer('Game sending Questions in loop');

    while (questions.moreToProcess()) {
      final FullQuestion currentQuestion = questions.current();
      broadcast(Question(currentQuestion.question, currentQuestion.options,
          QUESTION_DURATION_SECONDS));
      await Future.delayed(Duration(seconds: QUESTION_DURATION_SECONDS));
      broadcast(questions.getResults());
      await Future.delayed(Duration(seconds: TIME_STATS_SECONDS));
    }
    // TODO: broadcast Final Stats (el que tuvo mejor racha, el que fue mas lento, el mas rapido).
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

  void playAgainRequest(String name, int newGameId) {
    if (playAgainSended) {
      sendToPlayer(ErrorEvent('Play Again Already Sended'), name);
    } else {
      playAgainSended = true;
      broadcast(PlayAgainRequest(newGameId, name));
    }
  }
}
