import '../../game/game.dart';
import 'game_event.dart';

class PlayerAnswer implements GameEvent {
  final String question;
  final String answer;
  final String playerName;

  PlayerAnswer(this.playerName, this.question, this.answer);

  @override
  void execute(Game game) {
    game.submitAnswer(question, answer, playerName);
  }

  factory PlayerAnswer.fromJson(String playerName, Map<String, dynamic> json) {
    if (!json.containsKey('question') ||
        !json.containsKey('answer')) {
      throw FormatException("Incomplete data for start_game event: $json");
    }
    return PlayerAnswer(playerName, json['question'], json['answer']);
  }
}

