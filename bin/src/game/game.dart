
import 'dart:async';
import 'dart:convert';
import 'dart:io';

class Game {
  late String token;
  late List<WebSocket> players;
  late Timer timer;

  Game(this.token) {
    players = [];
    timer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (players.length == 2) {
        sendQuestionToPlayers();
        timer.cancel();
      }
    });
  }

  void addPlayer(WebSocket player) {
    if (players.length < 2) {
      players.add(player);
      player.listen((data) {
        var answer = jsonDecode(data);
        // Procesar la respuesta del jugador
        // Ejemplo: guardar la respuesta, etc.
      });
      if (players.length == 2) {
        sendQuestionToPlayers();
        timer.cancel();
      }
    } else {
      player.add('La partida ya está llena.');
      player.close();
    }
  }

  void sendQuestionToPlayers() {
    // Lógica para enviar la pregunta y opciones a los jugadores
    var question = '¿Ejemplo de pregunta?';
    var options = ['Opción 1', 'Opción 2', 'Opción 3'];

    for (var player in players) {
      player.add(jsonEncode({'question': question, 'options': options}));
    }

    Timer(Duration(seconds: 10), () {
      sendResultsToPlayers();
    });
  }

  void sendResultsToPlayers() {
    // Lógica para enviar los resultados a los jugadores
    var results = {'player1': 'resultado', 'player2': 'resultado'};
    for (var player in players) {
      player.add(jsonEncode({'results': results}));
    }
  }
}
