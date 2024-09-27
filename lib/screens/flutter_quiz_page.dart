import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FlutterQuizPage extends StatefulWidget {
  @override
  _FlutterQuizPageState createState() => _FlutterQuizPageState();
}

class _FlutterQuizPageState extends State<FlutterQuizPage> {
  List<String> questions = [];
  String apiKey = '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'; // Replace with your Groq API key

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    String prompt = "Ask me 10 quiz questions about Flutter.";
    
    var response = await sendRequest(prompt);
    if (response != null) {
      setState(() {
        questions = response.split('\n');
      });
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Quiz'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: questions.isNotEmpty
            ? ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(questions[index]),
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
