import 'dart:convert';

import 'server_event.dart';

class AnswerSubmitted extends ServerEvent {
  final String question;
  final String answer;

  AnswerSubmitted(this.question, this.answer);
  
  @override
  String encode() {
    return jsonEncode({
      'event': 'answer_submitted',
      'answer': answer,
      'question': question,
    });
  }
}