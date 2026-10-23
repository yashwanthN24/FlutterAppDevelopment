import 'package:flutter/material.dart';
import 'package:fresh_app/dice_roller.dart';
// import 'package:fresh_app/styled_test.dart';

const startAlignment = Alignment.topLeft;
const endAlignment = Alignment.bottomRight;

class GradientContainer extends StatelessWidget {
  GradientContainer(this.color1, this.color2, {super.key});

  // secod contructor other way to invoke this widget
  GradientContainer.purple({super.key})
    : color1 = Colors.pink,
      color2 = Colors.red;
  final Color color1;
  final Color color2;

  

  @override
  Widget build(context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: startAlignment,
          end: endAlignment,
        ),
      ),
      child: Center(
        // child: Image.network(
        //   "https://media.gettyimages.com/id/173682323/photo/says.jpg?s=612x612&w=gi&k=20&c=W_TK4E4pGAqhsn9kLia57cw7aV3gitm4h7MkKtpxAYM=",
        // ), // for url
        child: DiceRoller(),
      ),
    );
  }
}

// class GradientContainer extends StatelessWidget {
//   const GradientContainer({super.key, required this.colors});

//   final List<Color> colors;

//   @override
//   Widget build(context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: colors,
//           begin: startAlignment,
//           end: endAlignment,
//         ),
//       ),
//       child: const Center(
//         child: StyledText('Hello World!'),
//       ),
//     );
//   }
// }

// class GradientContainer extends StatelessWidget {
//   final List<Color> colorList;

//   const GradientContainer(this.colorList , {super.key});

//   Widget build(context) {
//     return Container(
//       decoration:  BoxDecoration(
//         gradient: LinearGradient(
//           colors: colorList,
//           begin: startAlignment,
//           end: endAlignment,
//         ),
//       ),
//       child: const Center(
//         child: StyledTest('Hello World2'),
//       ),
//     );
//   }
// }
