import 'dart:async';
import 'dart:convert';
import 'dart:io';


class Player {
  final String _name;
  final WebSocket _socket;
  String get name => _name;
  Player(this._name, this._socket);

  void send(String message) {
    _socket.add(message);
  }

  // escucha mensajes del cliente y los forwardea a la queue del juego.
  void receiveEvents(WebSocket socket, StreamController<String> eventsQueue) {
    socket.listen(
      (data) {
        print('Received: $data');
        eventsQueue.sink.add(data); // si esto falla, deberia terminar el loop.
      },
      onDone: () {
        print('Connection closed');
      },
      onError: (error) {
        print('Error: $error');
      },
    );
  }

  void createSuccessful(String gameid) {
    send(jsonEncode({'gameid': gameid})); // TODO: manejar el error
  }

}
