import 'dart:io';

import '../events/game_events/game_event.dart';
import '../events/server_events/error.dart';
import '../events/server_events/server_event.dart';
import '../game/game.dart';


class Player {
  final String _name;
  final WebSocket _socket;
  int playerId = -1;
  String get name => _name;
  Player(this._name, this._socket);

  void addId(int id) {
    playerId = id;
  }

  // TODO: revisar si hay que usar WebSocket o el channel async.

  void send(ServerEvent message) {
    _socket.add(message.encode());
  }

  // escucha mensajes del cliente y los forwardea a la queue del juego.
  Future<void> receiveEvents(Game game) async {
    await _socket.listen(
      (data) {
        print('Received: $data');
        try {
          final GameEvent event = GameEvent.fromEncodedData(data, _name);
          bool success = event.execute(game);
          if (!success) return; // TODO

        } catch (e) {
          print('Error: ${e.toString()}');
          send(ErrorEvent(e.toString()));
        }
      },
      onDone: () {
        print('Connection closed');
      },
      onError: (error) {
        print('Error: $error');
      },
    ).asFuture();
  }

}
