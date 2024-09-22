import 'package:flutter/material.dart';

import '../../models/rate_action.dart';
import '../../providers/grammar/grammar.dart';

typedef OnResult = void Function(RateAction?);

class RateActionSheet extends StatefulWidget {
  const RateActionSheet(
      {super.key, required this.onResult, required this.playersByRelevance});

  final List<String> playersByRelevance;
  final OnResult onResult;

  @override
  State<RateActionSheet> createState() => _RateActionSheetState();
}

class _RateActionSheetState extends State<RateActionSheet> {
  int currentRating = 0;
  List<String> selectedPlayers = [];
  String selectedAction = 'none';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0 * 2, right: 8.0, left: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 8.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ActionChip(
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                    child: Text("Negativ"),
                  ),
                  backgroundColor: currentRating == -1 ? Colors.red : null,
                  onPressed: () => setState(() {
                    currentRating = -1;
                  }),
                ),
                ActionChip(
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                    child: Text("Neutral"),
                  ),
                  backgroundColor: currentRating == 0 ? Colors.grey : null,
                  onPressed: () => setState(() {
                    currentRating = 0;
                  }),
                ),
                ActionChip(
                    label: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                      child: Text("Positiv"),
                    ),
                    backgroundColor: currentRating == 1 ? Colors.green : null,
                    onPressed: () => setState(() {
                      currentRating = 1;
                    })),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.playersByRelevance
                    .map(
                      (String player) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: ActionChip(
                      label: Text(
                        player,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      backgroundColor: selectedPlayers.contains(player)
                          ? Colors.blueAccent
                          : null,
                      onPressed: () {
                        setState(() {
                          if (selectedPlayers.contains(player)) {
                            selectedPlayers.remove(player);
                          } else {
                            selectedPlayers.add(player);
                          }
                        });
                      },
                    ),
                  ),
                )
                    .toList(),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 16.0,
              runAlignment: WrapAlignment.spaceBetween,
              children: volleyActions.map((String action) {
                return InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: selectedAction == action ? Colors.deepPurple : Colors.amber,
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          action,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    if (selectedPlayers.isEmpty) return;
                    widget.onResult(
                        RateAction(action, currentRating, selectedPlayers)
                    );
                  },
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
