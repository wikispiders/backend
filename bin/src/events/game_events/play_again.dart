import '../../game/game.dart';
import 'game_event.dart';

class PlayAgain extends GameEvent {
  final String playerName;
  final int newGameId;

  PlayAgain(this.playerName, this.newGameId);

  // Para jugar denuevo, desde el Front se aprieta en 
  // Play Again. Esto crea un nuevo Socket que crea una
  // partida y recibe un nuevo ID de Partida. Con ese 
  // ID, se envia a traves del socket de la anterior 
  // Partida este evento. Todos los jugadores lo reciben
  // y se unen o no a la partida recien creada.
  @override
  bool execute(Game game) {
    game.playAgainRequest(playerName, newGameId);
    return true;
  }
}
