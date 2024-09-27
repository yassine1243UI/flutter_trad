import 'package:flutter/material.dart';
import 'translate_page.dart';
import 'correct_page.dart';
import 'assistance_page.dart';
import 'culture_quiz_page.dart';   // Import for General Culture Quiz
import 'flutter_quiz_page.dart';   // Import for Flutter Quiz
import 'dart_quiz_page.dart';      // Import for Dart Quiz

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Colors.blueAccent,
      ),
      
      body: Padding(
  padding: const EdgeInsets.only(top: 40.0),
  child: Center(
    child: Wrap(
      spacing: 8.0, // Espacement entre les widgets horizontaux
      runSpacing: 8.0, // Espacement entre les lignes
      children: [
        Card(
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TranslatePage()),
              );
            },
            child: const SizedBox(
              width: 200,
              height: 100,
              child: Center(
                child: Text('Translate'),
              ),
            ),
          ),
        ),
        Card(
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CorrectPage()),
              );
            },
            child: const SizedBox(
              width: 200,
              height: 100,
              child: Center(
                child: Text('Correct'),
              ),
            ),
          ),
        ),

      ],
    ),
  ),
),
    );
  }
}
