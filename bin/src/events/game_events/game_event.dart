import 'dart:convert';

import '../../game/game.dart';
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
        return StartGame();
      case 'submit_answer':
        return PlayerAnswer(playerName, decodedData['question'], decodedData['answer']);
      default:
        throw FormatException('Invalid event: $decodedData');
    }
  }
}