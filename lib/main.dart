import 'dart:convert';
import 'package:flutter/material.dart';
import 'screens/launch_page.dart';

void main() {
  runApp(TranslateApp());
}

class TranslateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Translate App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LaunchPage(), // The initial screen
    );
  }
}
