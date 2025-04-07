import 'package:flutter/material.dart';
import 'main_navigation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fridge & Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MainNavigation(),
    );
  }
}