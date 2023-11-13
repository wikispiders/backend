import 'dart:math';
import '../events/server_events/question_results.dart';
import 'constants.dart';

class FullQuestion {
  final String question;
  final List<String> options;
  final String answer;

  FullQuestion(this.question, this.options, this.answer);
}


class Questions {
  final List<FullQuestion> questions;
  List<Map<String, String>> answers;
  int currentQuestion;
  late DateTime currentStartTime;
  Map<String, int> pointsResults;
  Questions._(this.questions, this.answers, this.pointsResults): currentQuestion = 0;

  factory Questions.fromRandomQuestions(List<String> players) {
    final q = [FullQuestion('q1', ['r1', 'r2', 'r3'], 'r1'), 
               FullQuestion('q2', ['r1', 'r2', 'r3'], 'r1'),
               FullQuestion('q3', ['r1', 'r2', 'r3'], 'r1'),
               FullQuestion('q4', ['r1', 'r2', 'r3'], 'r1'),
               FullQuestion('q5', ['r1', 'r2', 'r3'], 'r1'),
               FullQuestion('q6', ['r1', 'r2', 'r3'], 'r1'),
               FullQuestion('q7', ['r1', 'r2', 'r3'], 'r1'),
               FullQuestion('q8', ['r1', 'r2', 'r3'], 'r1')];
    List<Map<String, String>> a = List.generate(q.length, (index) => {});
    Map<String, int> points =  {};
    for (final player in players) {
      points[player] = 0;
    }
    return Questions._(q, a, points);
  }

  bool moreToProcess() {
    return questions.length > currentQuestion;
  }

  FullQuestion current() {    
    currentStartTime = DateTime.now();
    return questions[currentQuestion];
  }

  // True si puede guardar la respuesta, False si no.
  bool submitAnswer(String question, String answer, String player) {
    DateTime answerTime = DateTime.now();
    if (currentQuestion > questions.length) {
      return false;
    }
    final current = questions[currentQuestion];
    if (question != current.question) {
      return false;
    }
    if (answers[currentQuestion].containsKey(player)) {
      return false;
    }
    if (!pointsResults.containsKey(player)) {
      return false;
    }
    answers[currentQuestion][player] = answer;
    int elapsedSinceQuestion = answerTime.difference(currentStartTime).inMilliseconds;
    int points = 0;
    if (current.answer == answer) {
      points += BASE_POINTS_CORRECT_ANSWER;
      points += max(0, (MAX_ADDED_POINTS_CORRECT_ANSWER * (QUESTION_DURATION_SECONDS - elapsedSinceQuestion) / QUESTION_DURATION_SECONDS) as int);
    } 
    pointsResults[player] = (pointsResults[player]! + points);   
    return true;
  }

  QuestionResults getResults() {
    final current = questions[currentQuestion];
    List<Answer> answersResult = [];
    pointsResults.forEach((name, points) {
      String playerAnswer = answers[currentQuestion][name] ?? NO_ANSWER;
      answersResult.add(Answer(name, playerAnswer, points));
    });
    currentQuestion++;
    return QuestionResults(current.question, current.answer, answersResult, TIME_STATS_SECONDS);
  }

}