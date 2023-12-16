import 'package:logging/logging.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../events/game_events/game_event.dart';
import '../events/server_events/error.dart';
import '../events/server_events/server_event.dart';
import '../game/game.dart';


class Player {
  final String _name;
  final WebSocketChannel _socket;
  final Logger _logger;
  String get name => _name;
  Player(this._name, this._socket): _logger = Logger('Player-$_name');

  void send(ServerEvent message) {
    _socket.sink.add(message.encode());
  }

  Future<void> receiveEvents(Game game) async {
    await _socket.stream.forEach((data) { 
      _logger.finest('Received: $data');
      try {
        final GameEvent event = GameEvent.fromEncodedData(data, _name);
        event.execute(game);
      } catch (e) {
        _logger.warning('Error: ${e.toString()}');
        send(ErrorEvent(e.toString()));
      }
    });
    game.removePlayer(_name);
  }

}
