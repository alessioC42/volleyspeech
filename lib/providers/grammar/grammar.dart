const List<String> numberTokens = ['null', 'eins', 'zwei', 'drei', 'vier', 'fünf', 'sechs', 'sieben', 'acht', 'neun', 'zehn', 'elf', 'zwölf', 'dreizehn', 'vierzehn', 'fünfzehn', 'sechzehn', 'siebzehn', 'achtzehn', 'neunzehn', 'zwanzig', 'einundzwanzig', 'zweiundzwanzig', 'dreiundzwanzig', 'vierundzwanzig'];
const List<String> volleyActions = ['aufschlag', 'block', 'drive', 'pass', 'sicherung', 'zuspiel', 'angriff', 'abwehr', 'annahme', 'fehler', 'pritschen'];
const List<String> ratingTokens = ['negativ', 'neutral', 'positiv'];


List<String> generateGrammarList({List<String> playerNames = const []}) {
  List<String> grammarList = [];
  for (final number in [...numberTokens, ...playerNames]) {
    for (final action in volleyActions) {
      for (final rating in ratingTokens) {
        grammarList.add('$number $action $rating');
      }
    }
  }
  return grammarList;
}

