import '../models/typedef.dart';

/// Always returns a list of strings with values of "1" to "24" and adjusts the order to match the most occurring player. Fills in the numbers, that do not exist
/// if setRating is empty, returns an list from "1" to "24"
List<String> getPlayerListOrderedByActionCount(SetRating setRating) {
  final List<String> playerList = [];
  final Map<String, int> playerActionCount = {};
  for (final player in setRating.keys) {
    for (final action in setRating[player]!.keys) {
      if (!playerActionCount.containsKey(player)) {
        playerActionCount[player] = 0;
      }
      playerActionCount[player] = playerActionCount[player]! + setRating[player]![action]!.totalActions;
    }
  }
  playerActionCount.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value))
    ..forEach((element) {
      playerList.add(element.key);
    });
  for (int i = 1; i <= 24; i++) {
    if (!playerList.contains(i.toString())) {
      playerList.add(i.toString());
    }
  }
  return playerList;
}
