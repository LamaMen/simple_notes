import 'package:flutter/material.dart';

import 'data/repository.dart';
import 'pages/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Simple notes",
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 15, 101, 246),
        accentColor: Color.fromARGB(255, 42, 119, 247),
        buttonColor: Color.fromARGB(255, 94, 196, 97),
        errorColor: Color.fromARGB(255, 255, 65, 65),
      ),
      home: LoginPage(),
    );
  }

  @override
  void dispose() {
    Repository.instance.dispose();
    super.dispose();
  }
}
