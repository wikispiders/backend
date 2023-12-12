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
        if (decodedData.containsKey('category') && decodedData.containsKey('amount_questions') && decodedData.containsKey('type')) {
          return StartGame(playerName, decodedData['category'], decodedData['amount_questions'], decodedData['type']);
        } else {
          throw FormatException('Incomplete data for start_game event: $decodedData');
        }
      case 'submit_answer':
        if (decodedData.containsKey('question') && decodedData.containsKey('answer')) {
          return PlayerAnswer(playerName, decodedData['question'], decodedData['answer']);
        } else {
          throw FormatException('Incomplete data for submit_answer event: $decodedData');
        }
      case 'play_again':
          return PlayAgain(playerName);
      default:
        throw FormatException('Invalid event: $decodedData');
    }
  }

}