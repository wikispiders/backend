import 'dart:convert';

import 'server_event.dart';

class Question extends ServerEvent {
  final String question;
  final List<String> options;
  final int timeToAnswer;

  Question(this.question, this.options, this.timeToAnswer);
  
  @override
  String encode() {
    return jsonEncode({
      'event': 'question',
      'question': question,
      'options': options,
      'time': timeToAnswer,
    });
  }
}