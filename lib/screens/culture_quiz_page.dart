import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CultureQuizPage extends StatefulWidget {
  @override
  _CultureQuizPageState createState() => _CultureQuizPageState();
}

class _CultureQuizPageState extends State<CultureQuizPage> {
  List<String> questions = [];
  List<String> userAnswers = []; // To store user answers
  int currentQuestionIndex = 0;  // Track which question is being asked
  String currentAnswer = ""; // Store the current answer
  bool isQuizCompleted = false;
  String apiKey = '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'; // Replace with your Groq API key

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  // Fetch 10 general knowledge questions from the API
  Future<void> fetchQuestions() async {
    String prompt = "Ask me 10 general knowledge questions.";

    var response = await sendRequest(prompt);
    if (response != null) {
      setState(() {
        questions = response.split('\n').where((q) => q.isNotEmpty).toList(); // Ensure no empty questions
        userAnswers = List.filled(questions.length, ""); // Initialize answers
      });
    }
  }

  // API request for questions
  Future<String?> sendRequest(String prompt) async {
    var url = Uri.parse('https://api.groq.com/openai/v1/chat/completions');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey'
    };
    var body = jsonEncode({
      "messages": [
        {
          "role": "user",
          "content": prompt,
        }
      ],
      "model": "llama3-8b-8192"
    });

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      return responseData['choices'][0]['message']['content'];
    } else {
      print('Failed to fetch questions: ${response.statusCode}');
      return null;
    }
  }

  // Function to submit the answer and move to the next question
  void submitAnswer() {
    if (currentAnswer.isNotEmpty) {
      setState(() {
        userAnswers[currentQuestionIndex] = currentAnswer;

        // Check if there are more questions left
        if (currentQuestionIndex < questions.length - 1) {
          currentQuestionIndex++; // Move to next question
          currentAnswer = ""; // Clear the current answer
        } else {
          isQuizCompleted = true; // Mark the quiz as completed
        }
      });
    } else {
      // Handle empty answer (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter an answer before proceeding.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('General Culture Quiz'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isQuizCompleted
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Quiz Completed! Here are your answers:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Q${index + 1}: ${questions[index]}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('Your answer: ${userAnswers[index]}'),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Q${currentQuestionIndex + 1}: ${questions[currentQuestionIndex]}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        currentAnswer = value; // Update the current answer
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Your answer',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: submitAnswer, // Submit the current answer and move to the next question
                    child: const Text('Submit Answer'),
                  ),
                ],
              ),
      ),
    );
  }
}
