import 'package:flutter/material.dart';

import '../../models/rate_table.dart';
import '../../widgets/rate_actions_map_table.dart';

class GameAnalyzer extends StatefulWidget {
  const GameAnalyzer({super.key, required this.rateTable});

  final RateTable rateTable;

  @override
  State<GameAnalyzer> createState() => _GameAnalyzerState();
}

class _GameAnalyzerState extends State<GameAnalyzer> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.rateTable.table.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Game Analyzer"),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            for (int i = 0; i < widget.rateTable.table.length; i++)
              Tab(text: "Set ${i + 1}"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          for (int i = 0; i < widget.rateTable.table.length; i++)
            GameAnalyzerPage(rateTable: widget.rateTable, setIndex: i),
        ],
      ),
    );
  }
}

class GameAnalyzerPage extends StatefulWidget {
  const GameAnalyzerPage({super.key, required this.rateTable, required this.setIndex});

  final RateTable rateTable;
  final int setIndex;

  @override
  State<GameAnalyzerPage> createState() => _GameAnalyzerPageState();
}

class _GameAnalyzerPageState extends State<GameAnalyzerPage> {
  String? selectedPlayer;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 20.0),
        Text("All Players", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: RateActionsMapTable(
            actions: getSumOfActions(widget.rateTable.table[widget.setIndex]),
          ),
        ),
        // chips with line wrap of the players
        Text("Individual", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: [
              for (var player in widget.rateTable.table[widget.setIndex].keys)
                ActionChip(
                  backgroundColor: selectedPlayer == player ? Theme.of(context).colorScheme.secondary : null,
                  label: Text(player.toString()),
                  onPressed: (){
                    setState(() {
                      selectedPlayer = player;
                    });
                  },
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: RateActionsMapTable(
              actions: widget.rateTable.table[widget.setIndex][selectedPlayer] ?? {},
          ),
        ),
      ],
    );
  }

}