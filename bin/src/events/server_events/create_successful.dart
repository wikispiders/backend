import 'dart:convert';

import 'server_event.dart';

class CreateSuccessful extends ServerEvent {
  final int gameid;

  CreateSuccessful(this.gameid);
  
  @override
  String encode() {
    return jsonEncode({
      'event': 'create',
      'gameId': gameid
    });
  }
}