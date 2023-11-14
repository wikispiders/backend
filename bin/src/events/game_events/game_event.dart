import 'dart:convert';

import '../../game/game.dart';
import 'play_again.dart';
import 'player_answer.dart';
import 'start_game.dart';

enum TypeEvent {startGame, answer}


abstract class GameEvent {  
  bool execute(Game game);

  static GameEvent fromEncodedData(String data, String playerName) {
    final decodedData = jsonDecode(data);
    final String? eventType = decodedData['event'];
    
    switch (eventType) {
      case 'start_game': 
        return StartGame(playerName);
      case 'submit_answer':
        if (decodedData.containsKey('question') && decodedData.containsKey('answer')) {
          return PlayerAnswer(playerName, decodedData['question'], decodedData['answer']);
        } else {
          throw FormatException('Incomplete data for submit_answer event: $decodedData');
        }
      case 'play_again':
        if (decodedData.containsKey('new_game_id')) {
          return PlayAgain(playerName, decodedData['new_game_id']);
        } else {
          throw FormatException('Incomplete data for play_again event: $decodedData');
        }
      default:
        throw FormatException('Invalid event: $decodedData');
    }
  }

}