import 'dart:convert';

import 'server_event.dart';

class Question implements ServerEvent {
  final String question;
  final List<String> options;
  final int timeToAnswer;
  final int numberOfQuestion;
  final int totalQuestions;


  Question(this.question, this.options, this.timeToAnswer, this.numberOfQuestion, this.totalQuestions);
  
  @override
  String encode() {
    return jsonEncode({
      'event': 'question',
      'question': question,
      'options': options,
      'time': timeToAnswer,
      'number_of_question': numberOfQuestion,
      'total_questions': totalQuestions,
    });
  }
}
