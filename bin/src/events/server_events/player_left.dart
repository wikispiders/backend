import 'dart:convert';

import 'server_event.dart';

class PlayerLeft implements ServerEvent {
  final String creator;
  final String playerLeft;

  PlayerLeft(this.playerLeft, this.creator);
  
  @override
  String encode() {
    return jsonEncode({
      'event': 'player_left',
      'player': playerLeft,
      'creator': creator,
    });
  }
}