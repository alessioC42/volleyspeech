import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:volleyspeech/models/rate_action.dart';
import 'package:volleyspeech/models/typedef.dart';

class RateTable {
  final int? dbID;
  final DateTime createdAt;
  final String name;
  List<SetRating> table = [];

  RateTable({required this.dbID, required this.createdAt, required this.name});

  String get tableJson => jsonEncode(table);

  SetRating getSetRating(int setIndex) {
    if (table.length <= setIndex) {
      table.add({});
    }
    return table[setIndex];
  }

  void addAction(RateAction action) {
    if (action.action == null || action.rating == null || action.playerNumbers == null) return;
    if (table.length <= action.setIndex) {
      table.add({});
    }
    for (final player in action.playerNumbers??['-1']) {
      if (!table[action.setIndex].containsKey(player)) {
        table[action.setIndex][player] = {};
      }
      if (!table[action.setIndex][player]!.containsKey(action.action!)) {
        table[action.setIndex][player]![action.action!] = Rating(0, 0, 0);
      }
      debugPrint('Player: $player, SetIndex: ${action.setIndex} , Action: ${action.action}, Rating: ${action.rating}');
      switch (action.rating) {
        case -1:
          table[action.setIndex][player]![action.action!]!.negativeRating++;
          break;
        case 0:
          table[action.setIndex][player]![action.action!]!.neutralRating++;
          break;
        case 1:
          table[action.setIndex][player]![action.action!]!.positiveRating++;
          break;
      }
    }
  }
}

class Rating {
  int positiveRating;
  int negativeRating;
  int neutralRating;

  Rating(this.positiveRating, this.negativeRating, this.neutralRating);

  int get totalActions => positiveRating + negativeRating + neutralRating;
  double get avgRating => (((positiveRating - negativeRating) / (positiveRating + negativeRating + (neutralRating / 5))) / 2 + 0.5);
  String get avgRatingString => _getAvgRatingString();
  Color get avgRatingColor => _getAvgRatingColor();

  String _getAvgRatingString() {
    if (totalActions == 0) return '#';
    return '${(avgRating * 100).round()}%';
  }

  Color _getAvgRatingColor() {
    if (totalActions == 0) return Colors.grey;
    if (avgRating < 0.4) {
      return Colors.red;
    } else if (avgRating > 0.6) {
      return Colors.green;
    } else {
      return Colors.yellow;
    }
  }

  List<int> toJson() => [positiveRating, negativeRating, neutralRating];

  static Rating fromJson(List<dynamic> json) {
    return Rating(json[0], json[1], json[2]);
  }

  Rating operator +(Rating other) {
    return Rating(positiveRating + other.positiveRating, negativeRating + other.negativeRating, neutralRating + other.neutralRating);
  }
}

class RateTableListResult {
  final String dbID;
  final DateTime createdAt;
  final String name;

  RateTableListResult(this.dbID, this.createdAt, this.name);
}