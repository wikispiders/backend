import 'dart:convert';
import 'dart:io';

Future<bool> joiner(int gameId) async {
  final socket = await WebSocket.connect('ws://127.0.0.1:4040/join/$gameId');
  var n = 0;
  await socket.listen(
    (data) {
      n++;
      Map<String, dynamic> receivedData = jsonDecode(data);
      print('JOINER: Received: $receivedData');
      
      if (n == 1) {
        final players = receivedData['players'];
        print('JOINER: Los jugadores son: $players');
        // Aca imprimiriamos el juego en el front.
        
      } else if (n == 2){
        print('JOINER: ');
      } else if (n == 10) {
        socket.close();
      }
    },
    onDone: () {
      print('JOINER: Connection closed');
    },
    onError: (error) {
      print('JOINER: Error: $error');
    },
  ).asFuture();

  
  await Future.delayed(Duration(seconds: 5));
  return true;
}
