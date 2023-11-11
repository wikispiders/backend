import 'dart:convert';
import 'dart:io';

Future<void> joiner(String gameId) async {
  final socket = await WebSocket.connect('ws://127.0.0.1:4040/join/$gameId');
  var firsAnswer = true;
  socket.listen(
    (data) {
      Map<String, dynamic> receivedData = jsonDecode(data);
      if (firsAnswer) {
        print('Received: ${receivedData['gameid']}');
        // Aca imprimiriamos el juego en el front.
        firsAnswer = false;
      } else {
        print('Received: $receivedData');
      }
    },
    onDone: () {
      print('Connection closed');
    },
    onError: (error) {
      print('Error: $error');
    },
  );

  
  await Future.delayed(Duration(seconds: 5));
  socket.add(jsonEncode({'event': 'data en partida'}));
  socket.close(WebSocketStatus.goingAway, 'Server is shutting down');
}
