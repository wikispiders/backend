import '../../game/game.dart';
import 'game_event.dart';

class StartGame implements GameEvent {
  String playerName;
  String category;
  int amountQuestions;
  String type;

  StartGame(this.playerName, this.category, this.amountQuestions, this.type);

  @override
  void execute(Game game) {
    game.startGame(playerName, category, amountQuestions, type);
  }

  factory StartGame.fromJson(String playerName, Map<String, dynamic> json) {
    if (!json.containsKey('category') ||
        !json.containsKey('amount_questions') ||
        !json.containsKey('type')) {
      throw FormatException("Incomplete data for start_game event: $json");
    }
    return StartGame(playerName, json['category'], json['amount_questions'], json['type']);
  }
}
