import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CorrectPage extends StatefulWidget {
  const CorrectPage({Key? key}) : super(key: key);

  @override
  _CorrectPageState createState() => _CorrectPageState();
}

class _CorrectPageState extends State<CorrectPage> {
  String _inputText = '';
  String _correctedText = '';
  List<Map<String, String>> _conversation = [];
  static const String _apiKey = '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'; // Replace with your Groq API key

  Future<void> _correctText() async {
    final String prompt = "Detect the language of the following text and correct any mistakes: '$_inputText'";

    final String? response = await _sendRequest(prompt);
    if (response != null) {
      setState(() {
        _correctedText = response;
        _conversation.add({'prompt': _inputText, 'response': _correctedText});
      });
    }
  }

  Future<String?> _sendRequest(String prompt) async {
    final Uri url = Uri.parse('https://api.groq.com/openai/v1/chat/completions');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey'
    };
    final Map<String, dynamic> body = {
      "messages": [
        {
          "role": "user",
          "content": prompt,
        }
      ],
      "model": "llama3-8b-8192"
    };

    try {
      final http.Response response = await http.post(url, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData['choices'][0]['message']['content'];
      } else {
        print('Failed to correct text: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Correct Text'),
        backgroundColor: Colors.blue.withAlpha(30),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Enter text to correct',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _inputText = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _correctText,
                    child: const Text('Correct Text'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 188, 243, 238),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 20),
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: _conversation.length,
                itemBuilder: (context, index) {
                  return _buildMessageBubble(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              margin: const EdgeInsets.only(bottom: 8.0),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Text(
                _conversation[index]['prompt']!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              margin: const EdgeInsets.only(top: 4.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Text(
                _conversation[index]['response']!,
                style: const TextStyle(color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }
}