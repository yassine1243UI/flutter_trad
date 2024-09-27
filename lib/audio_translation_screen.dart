import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AudioTranslationScreen extends StatefulWidget {
  @override
  _AudioTranslationScreenState createState() => _AudioTranslationScreenState();
}

class _AudioTranslationScreenState extends State<AudioTranslationScreen> {
  final AudioRecorder record = AudioRecorder();
  String? audioPath;
  String transcribedText = '';
  String apiKey = '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';
  bool isRecording = false;

  Future<void> startRecording() async {
    // Vérifiez si l'application a les permissions
    if (await record.hasPermission()) {
      // Obtenez le chemin du répertoire des fichiers
      final directory = await getApplicationDocumentsDirectory();
      String fullPath = '${directory.path}/myFile.m4a';

      // Démarrez l'enregistrement
      try {
        await record.start(const RecordConfig(), path: fullPath);
        setState(() {
          audioPath = fullPath; // Stockez le chemin pour l'afficher plus tard
          isRecording = true;
        });
      } catch (e) {
        print('Error while starting recording: $e');
      }
    } else {
      print('Permission denied');
    }
  }

  Future<void> stopRecording() async {
    // Arrêtez l'enregistrement et récupérez le chemin du fichier
    try {
      final path = await record.stop();
      setState(() {
        isRecording = false;
      });
      print('Recorded file path: $path');
    } catch (e) {
      print('Error while stopping recording: $e');
    }
  }

  Future<void> transcribeAudio() async {
    if (audioPath == null) return;

    try {
      var url = Uri.parse('https://api.groq.com/openai/v1/audio/transcriptions');
      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $apiKey';
      request.files.add(await http.MultipartFile.fromPath('file', audioPath!));

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var responseData = jsonDecode(responseBody);
        setState(() {
          transcribedText = responseData['text']; // Afficher le texte transcrit
        });
      } else {
        print('Failed to transcribe audio: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while transcribing audio: $e');
    }
  }

  @override
  void dispose() {
    record.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Audio Translation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: isRecording ? null : startRecording,
              child: const Text('Start Recording'),
            ),
            ElevatedButton(
              onPressed: isRecording ? stopRecording : null,
              child: const Text('Stop Recording'),
            ),
            ElevatedButton(
              onPressed: transcribeAudio,
              child: const Text('Transcribe Audio'),
            ),
            const SizedBox(height: 20),
            Text(
              transcribedText.isNotEmpty
                  ? 'Transcription: $transcribedText'
                  : 'No transcription yet',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
