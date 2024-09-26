import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';  // For audio recording
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class AudioTranslationScreen extends StatefulWidget {
  @override
  _AudioTranslationScreenState createState() => _AudioTranslationScreenState();
}

class _AudioTranslationScreenState extends State<AudioTranslationScreen> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  String? audioFilePath;
  String transcribedText = '';
  String apiKey = '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';
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    try {
      if (!_recorder.isRecording) {
        await _recorder.openRecorder();
      }
    } catch (e) {
      print('Error initializing recorder: $e');
    }
  }

  Future<void> startRecording() async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      String path = '${tempDir.path}/recorded_audio.wav';
      await _recorder.startRecorder(toFile: path);
      setState(() {
        isRecording = true;
        audioFilePath = path;
      });
    } catch (e) {
      print('Error while starting recording: $e');
    }
  }

  Future<void> stopRecording() async {
    try {
      await _recorder.stopRecorder();
      setState(() {
        isRecording = false;
      });
    } catch (e) {
      print('Error while stopping recording: $e');
    }
  }

  Future<void> transcribeAudio() async {
    if (audioFilePath == null) return;

    try {
      var url = Uri.parse('https://api.groq.com/openai/v1/audio/transcriptions');
      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $apiKey';
      request.files.add(await http.MultipartFile.fromPath('file', audioFilePath!));

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var responseData = jsonDecode(responseBody);
        setState(() {
          transcribedText = responseData['text']; // Display the transcribed text
        });
      } else {
        print('Failed to transcribe audio: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while transcribing audio: $e');
    }
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
              transcribedText.isNotEmpty ? 'Transcription: $transcribedText' : 'No transcription yet',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }
}
