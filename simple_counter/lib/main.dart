import 'package:flutter/material.dart';
import 'package:simple_counter/counter.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Container(child: Center(child: Counter())),
      ),
    ),
  );
}
