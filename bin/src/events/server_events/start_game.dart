import 'dart:convert';

import 'server_event.dart';

class StartGame extends ServerEvent {
  final int timeToStart;

  StartGame(this.timeToStart);
  
  @override
  String encode() {
    return jsonEncode({
      'event': 'start',
      'time': timeToStart,
    });
  }
}