import 'package:volleyspeech/models/typedef.dart';

import '../providers/grammar/grammar.dart';

class RateAction {
  final Action? action;
  /// -1; 0; 1
  final int? rating;
  final List<Player>? playerNumbers;
  final int setIndex;
  final DateTime createdAt = DateTime.now();
  
  RateAction(this.action, this.rating, this.playerNumbers, {this.setIndex = 0});
  
  @override
  String toString() {
    return 'Action: $action, Rating: $rating, Player: $playerNumbers';
  }
  
  @override
  bool operator ==(Object other) {
    if (other is RateAction) {
      return action == other.action && rating == other.rating && playerNumbers == other.playerNumbers;
    }
    return false;
  }
  
  @override
  int get hashCode => action.hashCode ^ rating.hashCode ^ playerNumbers.hashCode;
  
  // json
  RateAction.fromJson(Map<String, dynamic> json)
      : action = json['action'],
        rating = json['rating'],
        playerNumbers = List<Player>.from(json['playerNumber']),
        setIndex = json['setIndex'];
  
  Map<String, dynamic> toJson() => {
    'action': action,
    'rating': rating,
    'playerNumber': playerNumbers,
    'setIndex': setIndex,
  };
  
  static RateAction fromVoskString(String data, int setIndex) {
    final tokens = data.toLowerCase().split(' ');
    String? action;
    int? rating;
    List<Player> playerNumbers = [];
    for (final token in tokens) {
      numberTokens.contains(token) ? playerNumbers.add(numberTokens.indexOf(token).toString()) : null;
      volleyActions.contains(token) ? action = token : null;
      ratingTokens.contains(token) ? rating = ratingTokens.indexOf(token) - 1 : null;
    }
    return RateAction(action, rating, playerNumbers, setIndex: setIndex);
  }
}