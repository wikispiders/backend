import 'dart:convert';
import 'dart:io';

Future<bool> joiner(int gameId) async {
  String playerName = 'Mi amiga';
  final socket =
      await WebSocket.connect('ws://127.0.0.1:4040/join/$gameId/$playerName');
  var n = 0;
  await socket.listen(
    (data) {
      n++;
      Map<String, dynamic> receivedData = jsonDecode(data);
      if (receivedData.containsKey('question') &&
          receivedData.containsKey('options')) {
        print("La preg es ${receivedData['question']}");
        for (String elem in receivedData['options']) {
          print('Una opcion es $elem');
        }
      }

      if (n == 1) {
        final players = receivedData['players'];
        print('JOINER: Los jugadores son: $players');
        // Aca imprimiriamos el juego en el front.
      } else if (n == 2) {
        print('JOINER: ');
      } else if (n == 3) {
        String question = receivedData['question'];
        String answer = receivedData['options'][0];
        final msg = {
          'event': 'submit_answer',
          'question': question,
          'answer': answer,
        };
        print("Se recibio la pregunta: $question");
        socket.add(jsonEncode(msg));
        print('JOINER: send: $msg');
      } else if (n == 4) {
        //asd
      } else if (n == 10) {
        socket.close();
      } else if (n == 10) {
        socket.close();
      } else if (n == 10) {
        socket.close();
      } else if (n == 10) {
        socket.close();
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
