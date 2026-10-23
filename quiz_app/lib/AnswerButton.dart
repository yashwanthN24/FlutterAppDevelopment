import 'package:flutter/material.dart';

class Answerbutton extends StatelessWidget {
  // const Answerbutton(this.answer, this.onTap, {super.key});
  const Answerbutton({super.key, required this.answer, required this.onTap});

  final void Function() onTap;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 33, 1, 95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      ),
      child: Text(answer, textAlign: TextAlign.center),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return SizedBox(
  //     width: 180, // Stretches to the full width of the parent Column
  //     child: ElevatedButton(
  //       onPressed: onTap,
  //       style: ElevatedButton.styleFrom(
  //         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
  //         foregroundColor: Colors.white,
  //         backgroundColor: const Color.fromARGB(255, 33, 1, 95),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(40),
  //         ),
  //       ),
  //       child: Text(answer),
  //     ),
  //   );
  // }
}
