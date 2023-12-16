import '../../game/game.dart';
import 'game_event.dart';

class PlayAgain implements GameEvent {
  final String playerName;

  PlayAgain(this.playerName);

  @override
  void execute(Game game) {
    game.playAgainRequest(playerName);
  }
}
