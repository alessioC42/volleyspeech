import 'package:flutter/material.dart';

import '../models/rate_table.dart';
import '../models/typedef.dart';

// typedef SetRating = Map<Player, Map<Action, Rating>>;


Map<String, Rating> getSumOfActions(SetRating ratings) {
  Map<String, Rating> actions = {};
  for (var element in ratings.values) {
    // only add keys if they do not already exist
    element.forEach((key, value) {
      if (!actions.containsKey(key)) {
        actions[key] = value;
      } else {
        actions[key] = actions[key]! + value;
      }
    });
  }
  return actions;
}


class RateActionsMapTable extends StatelessWidget {
  final Map<String, Rating> actions;

  const RateActionsMapTable({super.key, required this.actions});
  
  @override
  Widget build(BuildContext context) {

    
    return Card(
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(0.4),
          2: FlexColumnWidth(0.4),
          3: FlexColumnWidth(0.4),
          4: FlexColumnWidth(0.6),
          5: FlexColumnWidth(0.1),
        },
        border: const TableBorder(
          horizontalInside: BorderSide(
            color: Colors.grey,
            style: BorderStyle.solid,
            width: 1.0,
          ),
          verticalInside: BorderSide(
            color: Colors.grey,
            style: BorderStyle.solid,
            width: 1.0,
          ),
        ),
        children: [
          //Header
          TableRow(
            children: [
              const TableCell(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Action'),
                ),
              ),
              const TableCell(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.remove),
                ),
              ),
              const TableCell(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.stay_current_landscape_sharp),
                ),
              ),
              const TableCell(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.add),
                ),
              ),
              const TableCell(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.stacked_line_chart),
                ),
              ),
              TableCell(
                child: Container(),
              ),
            ],
          ),
          //Rows
          for (var entry in actions.entries)
            TableRow(
              children: [
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(entry.key),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(entry.value.negativeRating.toString()),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(entry.value.neutralRating.toString()),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(entry.value.positiveRating.toString()),
                  ),
                ),
                TableCell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: entry.value.avgRatingColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(entry.value.avgRatingString,
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ),
                TableCell(
                  child: Container(),
                ),
              ],
            ),
        ],
      ),
    );
  }
}