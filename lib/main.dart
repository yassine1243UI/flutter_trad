import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(TranslateApp());
}

class TranslateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Translate App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TranslationScreen(),
    );
  }
}

class TranslationScreen extends StatefulWidget {
  @override
  _TranslationScreenState createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  String inputText = '';
  String translatedText = '';
  String fromLang = 'en';
  String toLang = 'es';

  List<String> languages = ['en', 'es', 'fr', 'it']; // Add more languages
  List<Map<String, String>> conversation = []; // Stores previous prompts and responses
  String apiKey = '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'; // Replace with your Groq API Key

  Future<void> translateText() async {
    String prompt = "Translate the following text and correct it if needed from $fromLang to $toLang: '$inputText'";

    var response = await sendRequest(prompt);
    if (response != null) {
      setState(() {
        translatedText = response;
        // Save to conversation history
        conversation.add({'prompt': prompt, 'response': translatedText});
      });
    }
  }

  Future<void> correctText() async {
    String prompt = "Correct the following sentence: '$inputText'";

    var response = await sendRequest(prompt);
    if (response != null) {
      setState(() {
        translatedText = response;
        // Save to conversation history
        conversation.add({'prompt': prompt, 'response': translatedText});
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
      print('Failed to translate or correct text: ${response.statusCode}');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Translate App'),
        backgroundColor: Color.fromARGB(224, 216, 199, 158),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Enter text to translate or correct'),
              onChanged: (value) {
                setState(() {
                  inputText = value;
                });
              },
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: fromLang,
                  items: languages.map((String lang) {
                    return DropdownMenuItem<String>(
                      value: lang,
                      child: Text(lang.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      fromLang = newValue!;
                    });
                  },
                ),
                Icon(Icons.arrow_forward),
                DropdownButton<String>(
                  value: toLang,
                  items: languages.map((String lang) {
                    return DropdownMenuItem<String>(
                      value: lang,
                      child: Text(lang.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      toLang = newValue!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                translateText();
              },
              child: Text('Translate'),
            ),
            ElevatedButton(
              onPressed: () {
                correctText();
              },
              child: Text('Correct'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: conversation.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Prompt: ${conversation[index]['prompt']}', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Response: ${conversation[index]['response']}'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
