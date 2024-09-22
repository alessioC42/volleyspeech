import 'package:flutter/material.dart';
import 'package:volleyspeech/globals.dart';
import 'package:volleyspeech/views/app.dart';
import 'package:flame_audio/flame_audio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the globals
  globals = Globals();
  await globals.initializeGlobals();

  await FlameAudio.audioCache.load('confirmation_sound.mp3');

  runApp(const App());
}