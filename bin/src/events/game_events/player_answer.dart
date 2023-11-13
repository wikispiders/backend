import '../../game/game.dart';
import 'game_event.dart';

class PlayerAnswer extends GameEvent {
  
  @override
  bool execute(Game game) {
    return true;
  }
}
