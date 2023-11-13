import 'dart:convert';

import 'server_event.dart';

class JoinSuccessful extends ServerEvent {
  final String newPlayer;
  final List<String> players;

  JoinSuccessful(this.newPlayer, this.players);
  
  @override
  String encode() {
    return jsonEncode({
      'event': 'join',
      'players': players,
      'new_player': newPlayer,
    });
  }
}