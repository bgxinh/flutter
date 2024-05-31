import 'package:flutter/material.dart';
import 'package:memory/screen/home_screen.dart';

void main() {
  runApp(MaterialApp(
    title: "Memory Game",
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: const Color.fromARGB(255, 216, 72, 20),
    ),
    home: const HomeScreen(),
  ));
}
