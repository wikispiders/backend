import 'dart:convert';

import '../../game/game.dart';
import 'play_again.dart';
import 'player_answer.dart';
import 'start_game.dart';

enum TypeEvent {startGame, answer}


abstract class GameEvent {  
  void execute(Game game);

  factory GameEvent.fromEncodedData(String data, String playerName) {
    final decodedData = jsonDecode(data);
    final String? eventType = decodedData['event'];

    switch (eventType) {
      case 'start_game':
        return StartGame.fromJson(playerName, decodedData);
      case 'submit_answer':
        return PlayerAnswer.fromJson(playerName, decodedData);
      case 'play_again':
          return PlayAgain(playerName);
      default:
        throw FormatException('Invalid event: $decodedData');
    }
  }
}
