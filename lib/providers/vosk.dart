import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vosk_flutter/vosk_flutter.dart';

import 'grammar/grammar.dart';

class SpeechServiceVosk {
  late VoskFlutterPlugin vosk;
  late Recognizer recognizer;
  late SpeechService speechService;
  bool _isVoskInitialized = false;
  ValueNotifier<bool> isListening = ValueNotifier(false);
  ValueNotifier<String> currentRecognizedPhrase = ValueNotifier('');
  BehaviorSubject<String> resultStream = BehaviorSubject();
  bool get isVoskInitialized => _isVoskInitialized;

  Future<void> initVosk() async {
    vosk = VoskFlutterPlugin.instance();
    final deSmallModelPath = await ModelLoader().loadFromAssets('assets/models/vosk-model-small-de-0.15.zip');
    recognizer = await vosk.createRecognizer(
        model: await vosk.createModel(deSmallModelPath),
        sampleRate: 16000,
        grammar: generateGrammarList()
    );
    speechService = await vosk.initSpeechService(recognizer);

    speechService.onPartial().listen(_onPartial);
    speechService.onResult().listen(_onResult);
    _isVoskInitialized = true;
  }

  void _onPartial(String data) {
    final decodedData = jsonDecode(data);
    currentRecognizedPhrase.value = decodedData['partial'];
  }

  void _onResult(String data) {
    final decodedData = jsonDecode(data);
    if (decodedData['text'] == null || decodedData['text'].toString().trim() == '') {
      return;
    }
    resultStream.add(decodedData['text']);
  }

  Future<void> toggleListening() async {
    if (!_isVoskInitialized) {
      return;
    }
    if (!isListening.value) {
      await speechService.start();
      isListening.value = true;
    } else {
      await speechService.stop();
      isListening.value = false;
    }
  }
}