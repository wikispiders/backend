import 'dart:io';

import 'package:logging/logging.dart';

import '../events/game_events/game_event.dart';
import '../events/server_events/error.dart';
import '../events/server_events/server_event.dart';
import '../game/game.dart';


class Player {
  final String _name;
  final WebSocket _socket;
  final Logger _logger;
  String get name => _name;
  Player(this._name, this._socket): _logger = Logger('Player-$_name');

  void send(ServerEvent message) {
    _socket.add(message.encode());
  }

  Future<void> receiveEvents(Game game) async {
    await _socket.listen(
      (data) {
        _logger.finest('Received: $data');
        try {
          final GameEvent event = GameEvent.fromEncodedData(data, _name);
          bool success = event.execute(game);
          if (!success) return; // TODO

        } catch (e) {
          _logger.warning('Error: ${e.toString()}');
          send(ErrorEvent(e.toString()));
        }
      },
      onDone: () {
        _logger.finer('Connection closed');
      },
      onError: (error) {
        _logger.severe('Error: $error');
      },
    ).asFuture();
  }

}
