import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  var count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(count.toString()),
        ElevatedButton(
          onPressed: () {
            setState(() {
              count++;
            });
          },
          child: const Text('Increment'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              count--;
              if (count < 0) count = 0;
            });
          },
          child: const Text('Decrement'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              count = 0;
            });
          },
          child: const Text('Reset'),
        ),
      ],
    );
  }
}
