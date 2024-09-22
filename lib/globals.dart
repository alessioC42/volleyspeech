import 'package:intl/intl.dart';
import 'package:volleyspeech/providers/storage.dart';
import 'package:volleyspeech/providers/vosk.dart';

class Globals {
  final dateFormatter = DateFormat('EEE dd.M.yyyy hh:mm a');

  late final StorageProvider database = StorageProvider();
  late final SpeechServiceVosk speech = SpeechServiceVosk();

  Future<void> initializeGlobals() async {
    await database.init();
    await speech.initVosk();
  }
}

late final Globals globals;
