import '../../game/game.dart';
import 'game_event.dart';

class PlayerAnswer extends GameEvent {
  final String question;
  final String answer;
  final String playerName;

  PlayerAnswer(this.playerName, this.question, this.answer);

  @override
  bool execute(Game game) {
    game.submitAnswer(question, answer, playerName);
    return true;
  }
}
