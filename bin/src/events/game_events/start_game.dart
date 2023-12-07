import '../../game/game.dart';
import 'game_event.dart';

class StartGame extends GameEvent {
  String playerName;
  String category;
  int amountQuestions;
  String type;

  StartGame(this.playerName, this.category, this.amountQuestions, this.type);

  @override
  bool execute(Game game) {
    game.startGame(playerName, category, amountQuestions, type);
    return true;
  }
}
