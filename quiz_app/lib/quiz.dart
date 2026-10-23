import 'package:flutter/material.dart';
import 'package:quiz_app/data/questions.dart';
import 'package:quiz_app/main_page.dart';
import 'package:quiz_app/question.dart';
import 'package:quiz_app/result_screen.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  var activeScreen = 'start_screen';
  List<String> answersList = [];

  void addAnswer(String answer) {
    answersList.add(answer);
    // print(answersList);

    if (answersList.length == questions.length) {
      setState(() {
        // answersList = [];
        // activeScreen = 'start_screen';
        activeScreen = 'result_screen';
      });
    }
  }

  void switchScreen() {
    setState(() {
      activeScreen = 'questions';
    });
  }

  void restartQuiz(){
    setState(() {
      answersList = [];
      activeScreen = 'questions';
    });
  }

  @override
  Widget build(BuildContext context) {
    // final Widget screen = activeScreen == 'start_screen'
    //             ? MainPage(switchScreen)
    //             : const Question();

    Widget screen = MainPage(switchScreen);

    if (activeScreen == 'questions') {
      screen = Question(onAnswerTap: addAnswer);
    } else if (activeScreen == 'result_screen') {
      screen = ResultScreen(chosenAnswers: answersList , onRestart: restartQuiz);
    }

    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 78, 13, 151),
                Color.fromARGB(255, 107, 15, 168),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(child: screen),
        ),
      ),
    );
  }
}
