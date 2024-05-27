import 'package:flutter/material.dart';
import 'package:memory/screen/home%20screen.dart';

void main() {
  runApp(MaterialApp(
    title: "Memory Game",
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Color.fromARGB(255, 216, 72, 20),
    ),
    home: HomeScreen(),
  ));
}
