import 'package:flutter/material.dart';

import 'HomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Absence Tracker',
      theme: ThemeData(
        primaryColor: Colors.green,
        accentColor: Colors.yellow,
      ),
      home: MyHomePage(title: 'Absence Tracker'),
    );
  }
}