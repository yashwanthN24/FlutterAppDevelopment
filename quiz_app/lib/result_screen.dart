import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/data/questions.dart';
import 'package:quiz_app/questionsSummery/questions_summery.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.chosenAnswers,
    required this.onRestart,
  });

  final List<String> chosenAnswers;
  final void Function() onRestart;

  List<Map<String, Object>> getSummery() {
    final List<Map<String, Object>> summery = [];

    for (var i = 0; i < chosenAnswers.length; i++) {
      summery.add({
        'question_index': i,
        'question': questions[i].question,
        'correct_answer': questions[i].answers[0],
        'user_answer': chosenAnswers[i],
      });
    }

    return summery;
  }

  @override
  Widget build(BuildContext context) {
    var summery = getSummery();
    var numberOfQuestions = questions.length;
    var numberOfCorrectAnswers = summery.where((data) {
      return data['user_answer'] == data['correct_answer'];
    }).length;

    print(chosenAnswers);
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'You answered ${numberOfCorrectAnswers} out of $numberOfQuestions Questions',
              style: GoogleFonts.lato(
                color: const Color.fromARGB(255, 201, 153, 251),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              // style: GoogleFonts.abel(
              //   color: const Color.fromARGB(255, 175, 114, 210),
              //   fontSize: 18,
              //   fontWeight: FontWeight.bold,
              // ),
              // TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            QuestionsSummery(summery),
            const SizedBox(height: 30),
            TextButton(onPressed: onRestart, child: Text('Restart Quiz!')),
          ],
        ),
      ),
    );
  }
}
