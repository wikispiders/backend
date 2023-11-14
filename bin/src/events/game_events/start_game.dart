import '../../game/game.dart';
import 'game_event.dart';

class StartGame extends GameEvent {
  String playerName;

  StartGame(this.playerName);

  @override
  bool execute(Game game) {
    game.startGame(playerName);
    return true;
  }
}
