import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AssistancePage extends StatefulWidget {
  const AssistancePage({Key? key}) : super(key: key);

  @override
  _AssistancePageState createState() => _AssistancePageState();
}

class _AssistancePageState extends State<AssistancePage> {
  String userInput = '';
  String assistantResponse = '';
  String apiKey = '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'; // Replace with your Groq API Key

  Future<void> sendQuestion() async {
    String prompt = "User asked: '$userInput'";

    var response = await sendRequest(prompt);
    if (response != null) {
      setState(() {
        assistantResponse = response;
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
      print('Failed to get assistant response: ${response.statusCode}');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assistance'),
        backgroundColor: const Color.fromARGB(224, 216, 199, 158),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Ask any question'),
              onChanged: (value) {
                setState(() {
                  userInput = value;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                sendQuestion();
              },
              child: const Text('Ask'),
            ),
            const SizedBox(height: 16),
            Text(
              assistantResponse.isNotEmpty
                  ? 'Response: $assistantResponse'
                  : 'No response yet',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
