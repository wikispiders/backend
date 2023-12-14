import 'dart:convert';

import 'server_event.dart';

class ErrorEvent extends ServerEvent {
  final String msg;

  ErrorEvent(this.msg);
  
  @override
  String encode() {
    return jsonEncode({
      'event': 'error',
      'details': msg,
    });
  }
}