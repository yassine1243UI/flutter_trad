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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TranslatePage()),
                );
              },
              child: const Text('Translate'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CorrectPage()),
                );
              },
              child: const Text('Correct'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AssistancePage()),
                );
              },
              child: const Text('Assistance'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CultureQuizPage()),
                );
              },
              child: const Text('General Culture Quiz'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FlutterQuizPage()),
                );
              },
              child: const Text('Flutter Quiz'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DartQuizPage()),
                );
              },
              child: const Text('Dart Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
