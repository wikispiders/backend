import '../../game/game.dart';
import 'game_event.dart';

class PlayAgain extends GameEvent {
  final String playerName;

  PlayAgain(this.playerName);

  @override
  bool execute(Game game) {
    game.playAgainRequest(playerName);
    return true;
  }
}
