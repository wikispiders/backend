import 'dart:math';
import '../events/server_events/question_results.dart';
import 'constants.dart';
import 'trivia_fetcher.dart';
import 'full_question.dart';

class Questions {
  final List<FullQuestion> questions;
  List<Map<String, String>> answers;
  int currentQuestion;
  late DateTime currentStartTime;
  Map<String, int> pointsResults;
  Map<String, int> lastQuestionResults;

  Questions._(this.questions, this.answers, this.pointsResults, this.lastQuestionResults)
      : currentQuestion = 0;

  static Future<Questions> fromRandomQuestions(List<String> players, String category, int amountQuestions, String type) async {
    List<FullQuestion> q = await fetchTriviaQuestions(category, type, amountQuestions);
    List<Map<String, String>> a = List.generate(q.length, (index) => {});
    Map<String, int> points = {};
    for (final player in players) {
      points[player] = 0;
    }
    return Questions._(q, a, points, points);
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
    int elapsedSinceQuestion =
        answerTime.difference(currentStartTime).inMilliseconds;
    int points = 0;
    if (current.answer == answer) {
      points += BASE_POINTS_CORRECT_ANSWER;
      points += max(
          0,
          MAX_ADDED_POINTS_CORRECT_ANSWER *
              (QUESTION_DURATION_MILLI - elapsedSinceQuestion) ~/
              QUESTION_DURATION_MILLI);
    }
    lastQuestionResults[player] = points;
    pointsResults[player] = (pointsResults[player]! + points);
    return true;
  }

  QuestionResults getResults() {
    final current = questions[currentQuestion];
    List<Answer> answersResult = [];
    pointsResults.forEach((name, points) {
      String playerAnswer = answers[currentQuestion][name] ?? NO_ANSWER;
      answersResult.add(Answer(name, playerAnswer, points, lastQuestionResults[name]!));
    });
    currentQuestion++;
    _cleanPartialResults();
    return QuestionResults(
        current.question, current.answer, answersResult, TIME_STATS_SECONDS);
  }

  void _cleanPartialResults(){
    lastQuestionResults.forEach((player, _) {
      lastQuestionResults[player] = 0;
    });
  }

}
