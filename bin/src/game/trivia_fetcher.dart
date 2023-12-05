import 'dart:convert';
import 'full_question.dart';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';

Future<List<FullQuestion>> fetchTriviaQuestions(
    String category, String type, int amount) async {
  List<FullQuestion> q = [];
  final response = await http.get(
    Uri.parse(
        'https://opentdb.com/api.php?amount=$amount&category=$category&type=$type'),
  );

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    final results = jsonResponse['results'];

    for (var result in results) {
      final question = HtmlUnescape().convert(result['question']);
      final options = List<String>.from(result['incorrect_answers'])
          .map((e) => HtmlUnescape().convert(e))
          .toList();
      final answer = HtmlUnescape().convert(result['correct_answer']);
      options.add(answer);
      options.shuffle();
      q.add(FullQuestion(question, options, answer));
    }
    return q;
  } else {
    throw Exception(
        "Questions couldn't be parsed. ErrorCode: ${response.statusCode}. Error: ${response.body}");
  }
}
