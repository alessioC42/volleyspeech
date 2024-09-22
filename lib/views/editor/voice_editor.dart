import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:volleyspeech/globals.dart';
import 'package:volleyspeech/models/rate_action.dart';
import 'package:volleyspeech/views/editor/rate_action_sheet.dart';
import 'package:volleyspeech/widgets/rate_action_list_tile.dart';

import '../../models/rate_table.dart';
import '../../utils/functions.dart';
import '../../widgets/set_selector.dart';
import '../analyzer/game_analyzer.dart';

class VoiceEditor extends StatefulWidget {
  const VoiceEditor({super.key, required this.dbID});

  final String dbID;

  @override
  State<VoiceEditor> createState() => _VoiceEditorState();
}

class _VoiceEditorState extends State<VoiceEditor> {
  List<RateAction> recognizedPhrases = [];
  RateTable? rateTable;
  late StreamSubscription _speechSubscription;
  int currentSet = 0;

  @override
  initState() {
    super.initState();
    globals.database.getRateTable(widget.dbID).then((value) {
      if (mounted) {
        setState(() {
          rateTable = value;
        });
      }
    });
    _speechSubscription = globals.speech.resultStream.listen(_onResultStream);
  }

  void _onResultStream(String event) {
    FlameAudio.play('confirmation_sound.mp3');
    final rateAction = RateAction.fromVoskString(event, currentSet);
    recognizedPhrases.add(rateAction);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _speechSubscription.cancel();
    super.dispose();
  }

  void _onRateActionConfirmed(RateAction rateAction) {
    if (rateTable != null) {
      rateTable!.addAction(rateAction);
    }
    setState(() {
      recognizedPhrases.remove(rateAction);
    });
    globals.database.saveRateTable(rateTable!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("VolleySpeech POC [${widget.dbID}]"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(onPressed: (){
            if (rateTable == null) return;
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => GameAnalyzer(rateTable: rateTable!,))
            );
          }, icon: const Icon(Icons.analytics))
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                height: 70,
                child: Center(
                  child: ValueListenableBuilder(
                      valueListenable: globals.speech.currentRecognizedPhrase,
                      builder: (context, value, child) {
                        return Text(value == "" ? "Sag etwas!" : value,
                            style: Theme.of(context).textTheme.bodyLarge);
                      }),
                ),
              ),),
              SetSelector(
                currentSet: currentSet,
                onSetChange: (value) {
                  setState(() {
                    currentSet = value;
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: recognizedPhrases.isNotEmpty
                ? ListView.builder(
              itemCount: recognizedPhrases.length,
              itemBuilder: (context, index) {
                return RateActionListTile(
                  deleteDuration: const Duration(seconds: 20),
                  rateAction: recognizedPhrases[recognizedPhrases.length - 1 - index],
                  deleteItem: (rateAction) {
                    setState(() {
                      recognizedPhrases.remove(rateAction);
                    });
                  },
                  onTimeout: _onRateActionConfirmed,
                );
              },
            )
                : const Center(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: 100.0, left: 20.0, right: 20.0),
                child: Text(
                  "Sag etwas, um die Liste zu füllen! Beispielsweise: 'Eins Aufschlag positiv'",
                  style: TextStyle(fontSize: 24.0),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder(
            valueListenable: globals.speech.isListening,
            builder: (BuildContext context, bool isListening, Widget? child) =>
                AvatarGlow(
                  animate: isListening,
                  glowColor: Colors.green,
                  duration: const Duration(milliseconds: 1700),
                  repeat: true,
                  child: FloatingActionButton.large(
                    heroTag: 'btn1',
                    shape: const CircleBorder(),
                    onPressed: globals.speech.toggleListening,
                    backgroundColor: isListening ? Colors.green : Colors.red,
                    child: Icon(
                      isListening ? Icons.mic : Icons.mic_none,
                    ),
                  ),
                ),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'btn2',
            child: const Icon(Icons.keyboard),
            onPressed: () async {
              // show bottom sheet to select player and action
              final result = await showModalBottomSheet<RateAction?>(
                context: context,
                builder: (BuildContext context) {
                  return RateActionSheet(
                    onResult: (data) {
                      Navigator.of(context).pop(data);
                    },
                    playersByRelevance: getPlayerListOrderedByActionCount(rateTable!.getSetRating(currentSet)),
                  );
                },
              );
              if (result != null) {
                setState(() {
                  recognizedPhrases.add(result);
                });
              }
            },
          ),
        ],
      ),
    );
  }
}