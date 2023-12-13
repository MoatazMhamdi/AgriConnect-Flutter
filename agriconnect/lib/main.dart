import 'package:flutter/material.dart';
import 'login_screen.dart';
//import 'register_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login and Register Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignInPage2(),
    );
  }
}
