import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../audio_translation_screen.dart'; 

class TranslatePage extends StatefulWidget {
  const TranslatePage({Key? key}) : super(key: key);

  @override
  _TranslatePageState createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  String inputText = '';
  String translatedText = '';
  String fromLang = 'en';
  String toLang = 'fr';

  List<String> languages = ['en', 'es', 'fr', 'it']; 
  List<Map<String, String>> conversation = []; 
  List<Map<String, String>> message = []; // Historique de la conversation
  String apiKey = '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'; // Replace with your Groq API Key

  Future<void> translateText() async {
    String prompt = "Translate the following text from $fromLang to $toLang: '$inputText'";

    var response = await sendRequest(prompt);
    if (response != null) {
      setState(() {
        translatedText = response;
        // Save to conversation history
        conversation.add({'prompt': prompt, 'response': translatedText});
        message.add({'message': inputText, 'response': translatedText});
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
      print('Failed to translate text: ${response.statusCode}');
      return null;
    }
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Translate Page'),
      backgroundColor:  Colors.blue.withAlpha(30),
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
                    labelText: 'Enter text to translate',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      inputText = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildLanguageDropdown(fromLang, (newValue) {
                      setState(() {
                        fromLang = newValue!;
                      });
                    }),
                    const Icon(Icons.arrow_forward),
                    _buildLanguageDropdown(toLang, (newValue) {
                      setState(() {
                        toLang = newValue!;
                      });
                    }),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: translateText,
                  child: const Text('Translate'),
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
              itemCount: conversation.length,
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

Widget _buildLanguageDropdown(String selectedLang, ValueChanged<String?> onChanged) {
  return Column(
    children: [
      Text(
        'Select Language:', // Titre pour le choix de langue
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8), // Espacement entre le titre et le SegmentedButton
      SegmentedButton<String>(
        segments: languages.map((String lang) {
          return ButtonSegment<String>(
            value: lang,
            label: Text(lang.toUpperCase()),
          );
        }).toList(),
        selected: <String>{selectedLang},
        onSelectionChanged: (Set<String> newSelection) {
          if (newSelection.isNotEmpty) {
            onChanged(newSelection.first);
          }
        },
      ),
    ],
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
              message[index]['message']!,
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
              conversation[index]['response']!,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ),
      ],
    ),
  );
}

}
