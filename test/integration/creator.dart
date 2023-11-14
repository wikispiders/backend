import 'dart:convert';
import 'dart:io';

import 'joiner.dart';

void main() async {
  final socket = await WebSocket.connect('ws://127.0.0.1:4040/create/Mateo');
  var n = 0;
  Future<bool>? waitJoiner;
  await socket.listen(
    (data) async {
      n++;
      Map<String, dynamic> receivedData = jsonDecode(data);
      print('CREATOR: Received: $receivedData}');
      if (n == 1) {
        final gameId = receivedData['gameid'];
        waitJoiner = joiner(gameId);

        // espero a que se una el joiner.
        await Future.delayed(Duration(seconds: 2));
        // Aca imprimiriamos el juego en el front.
      } else if (n == 2) {
        // evento de join successful.
        final players = receivedData['players'];
        print('CREATOR: Los jugadores son: $players');
        print('CREATOR: comenzando la partida');
        final creatorData = {
          'event': 'start_game',
        };
        socket.add(jsonEncode(creatorData));

      } else if (n == 10) {
        socket.close();  
      }
      
    },
    onDone: () {
      print('CREATOR: Connection closed');
    },
    onError: (error) {
      print('CREATOR: Error: $error');
    },
  ).asFuture();

  await waitJoiner;
}
