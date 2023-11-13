import '../../game/game.dart';
import 'game_event.dart';

class StartGame extends GameEvent {
  
  @override
  bool execute(Game game) {
    game.startGame();
    return true;
  }
}
