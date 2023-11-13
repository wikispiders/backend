import 'dart:async';
import 'dart:io';

import '../events/game_events/game_event.dart';
import '../events/server_events/server_event.dart';


class Player {
  final String _name;
  final WebSocket _socket;
  String get name => _name;
  Player(this._name, this._socket);

  void send(ServerEvent message) {
    _socket.add(message.encode());
  }

  // escucha mensajes del cliente y los forwardea a la queue del juego.
  void receiveEvents(StreamController<GameEvent> eventsQueue) {
    _socket.listen(
      (data) {
        print('Received: $data');
        try {
          final GameEvent event = GameEvent.fromEncodedData(data, _name);
          eventsQueue.sink.add(event); // si esto falla, deberia terminar el loop.
        } catch (e) {
          print('FALLLLOOOOOOOOO'); // TODO
        }
      },
      onDone: () {
        print('Connection closed');
      },
      onError: (error) {
        print('Error: $error');
      },
    );
  }

}
