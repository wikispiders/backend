import 'dart:convert';

import 'server_event.dart';

class JoinSuccessful implements ServerEvent {
  final String newPlayer;
  final int gameid;
  final List<String> players;

  JoinSuccessful(this.newPlayer, this.players, this.gameid);
  
  @override
  String encode() {
    return jsonEncode({
      'event': 'join',
      'players': players,
      'new_player': newPlayer,
      'gameid': gameid
    });
  }
}