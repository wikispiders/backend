import 'dart:convert';

import '../../game/game.dart';
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
      default:
        throw FormatException('Invalid event: $decodedData');
    }
  }
}