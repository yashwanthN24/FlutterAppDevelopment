import 'package:flutter/material.dart';
import 'package:quiz_app/main_page.dart';
import 'package:quiz_app/question.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  var activeScreen = 'start_screen';

  void switchScreen() {
    setState(() {
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
      screen = const Question();
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
