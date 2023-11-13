import 'dart:convert';

import 'server_event.dart';

class Answer {
  final String playerName;
  final String answer;
  final int points;
  Answer(this.playerName, this.answer, this.points);
  Map<String, dynamic> toJson() {
    return {
      'name': playerName,
      'answer': answer,
      'points': points,
    };
  }
}

class QuestionResults extends ServerEvent {
  final String question;
  final String correctAnswer;
  final List<Answer> playersAnswers;
  final int timeNextEvent;

  QuestionResults(this.question, this.correctAnswer, this.playersAnswers, this.timeNextEvent);
  
  @override
  String encode() {
    return jsonEncode({
      'event': 'question_results',
      'question': question,
      'correct_answer': correctAnswer,
      'players_answers': playersAnswers.map((answer) => answer.toJson()).toList(),
      'time_next_event': timeNextEvent,
    });
  }
}