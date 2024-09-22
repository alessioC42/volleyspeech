import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../models/rate_table.dart';

class StorageProvider {
  late final Database db;

  Future<void> init() async {
    String databasesPath = await getDatabasesPath();
    String path = ('${databasesPath}volleyspeech.db');
    db = await openDatabase(path);
    await db.execute('''
      CREATE TABLE IF NOT EXISTS KeyValue (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        key TEXT UNIQUE,
        value TEXT
      )''',
    );

    await db.execute('''
      CREATE TABLE IF NOT EXISTS MatchData (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        created_at TEXT,
        match_title TEXT,
        rate_table_json TEXT
      )''',
    );
  }

  /// Set key-value pair in the database
  Future<void> set(String key, String value) async {
    await db.insert('KeyValue', {'key': key, 'value': value}, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Get value by key from the database
  Future<String?> get(String key) async {
    List<Map<String, dynamic>> result = await db.query('KeyValue', where: 'key = ?', whereArgs: [key]);
    if (result.isEmpty) {
      return null;
    }
    return result.first['value'];
  }

  Future<List<RateTableListResult>> getRateTables() async {
    List<Map<String, dynamic>> result = await db.query('MatchData', columns: ['id', 'created_at', 'match_title']);
    return result.map((e) => RateTableListResult(e['id'].toString(), DateTime.parse(e['created_at']), e['match_title'])).toList();
  }

  Future<void> saveRateTable(RateTable rateTable) async {
    await db.insert('MatchData', {
      if (rateTable.dbID != null) 'id': rateTable.dbID,
      'created_at': rateTable.createdAt.toIso8601String(),
      'match_title': rateTable.name,
      'rate_table_json': rateTable.tableJson,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<RateTable> getRateTable(String id) async {
    List<Map<String, dynamic>> result = await db.query('MatchData', where: 'id = ?', whereArgs: [id], limit: 1);
    if (result.isEmpty) {
      throw Exception('RateTable with id $id not found');
    }

    RateTable rateTable = RateTable(dbID: result.first['id'], createdAt: DateTime.parse(result.first['created_at']), name: result.first['match_title']);

    final data = jsonDecode(result.first['rate_table_json']);

    /*
    Convert List<dynamic> to List<Map<String, Map<String, Rating>>>

    typedef Player = String;
    typedef Action = String;
    typedef SetRating = Map<Player, Map<Action, Rating>>;
    */

    for (final set in data) {
      rateTable.table.add({});
      for (final player in set.keys) {
        rateTable.table.last[player] = {};
        for (final action in set[player].keys) {
          rateTable.table.last[player]![action] = Rating.fromJson(set[player][action]);
        }
      }
    }

    return rateTable;
  }

  Future<void> deleteRateTable(int id) async {
    await db.delete('MatchData', where: 'id = ?', whereArgs: [id]);
  }
}