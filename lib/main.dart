import 'package:flutter/material.dart';
import 'package:gruporoxo20211/pages/homePage.dart';
import 'package:gruporoxo20211/pages/loginPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlackJack 21',
      home: LoginPage(),
    );
  }
}
