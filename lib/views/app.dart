import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:volleyspeech/globals.dart';
import 'package:volleyspeech/models/rate_table.dart';
import 'package:volleyspeech/views/analyzer/game_analyzer.dart';
import 'package:volleyspeech/views/create/create_match_screen.dart';

import 'editor/voice_editor.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber[900]!),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  bool _isLoading = true;
  List<RateTableListResult>? matches;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await globals.database.getRateTables();
    setState(() {
      matches = data;
      _isLoading = false;
    });
  }

  Widget _lastListTile() {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Text('VolleySpeech', style: Theme.of(context).textTheme.headlineSmall),
          const Divider(),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: (){},
                  child: const Text("GitHub"),
                ),
                ElevatedButton(
                  onPressed: (){},
                  child: const Text("Last release"),
                ),
                ElevatedButton(
                  onPressed: (){},
                  child: const Text("Bug report"),
                ),
              ],
            ),
          ),
          const Divider(),
          Text('Version: 0.0.1 [dev], made by alessioc42', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volley Speech (POC)'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => const CreateMatchScreen())
          );
          loadData();
        },
      ),
      body: RefreshIndicator(
        onRefresh: loadData,
        child: _isLoading ? const Center(child: CircularProgressIndicator.adaptive(),)
         : ListView.builder(
          itemCount: (matches??[]).length + 1,
          itemBuilder: (context, index) {
            if (index == matches!.length) {
              return _lastListTile();
            }

            final match = matches![index];
            return ListTile(
              title: Text(match.name),
              subtitle: Text(globals.dateFormatter.format(match.createdAt), style: Theme.of(context).textTheme.labelLarge),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.sports_volleyball),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) => VoiceEditor(dbID: match.dbID,))
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.analytics),
                    onPressed: () async {
                      RateTable rateTable = await globals.database.getRateTable(match.dbID);
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) => GameAnalyzer(rateTable: rateTable))
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await globals.database.deleteRateTable(int.parse(match.dbID));
                      loadData();
                    },
                  ),
                ],
              ),
            );
         },
        ),
      ),
    );
  }
}