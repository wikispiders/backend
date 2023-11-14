import 'dart:convert';

import 'server_event.dart';

class PlayAgainRequest extends ServerEvent {
  final String creator;
  final int gameId;

  PlayAgainRequest(this.gameId, this.creator);
  
  @override
  String encode() {
    return jsonEncode({
      'event': 'play_again',
      'gameid': gameId,
      'creator': creator,
    });
  }
}