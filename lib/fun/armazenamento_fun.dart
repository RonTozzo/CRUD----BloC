 import 'dart:convert';

import 'package:sqflite/sqflite.dart';

Future<Database> _openDB() async {
    return openDatabase('my_db.db', version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
        'CREATE TABLE tb_main (key STRING PRIMARY KEY, value TEXT)',
      );
    });
  }

   Future<void> zerarStorage() async {
    final db = await _openDB();
    db.delete('tb_main');
  }

   Future<void> salvarStorage(String key, dynamic data) async {
    final db = await _openDB();
    await db.insert(
      'tb_main',
      {'key': key, 'value': json.encode(data)},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

   Future<void> apagarStorage(key) async {
    final db = await _openDB();
    await db.delete('tb_main', where: 'key = ?', whereArgs: [key]);
  }

   Future<dynamic> buscarStorage(String key) async {
    final db = await _openDB();
    final query = await db.query('tb_main', where: 'key = ?', whereArgs: [key]);
    return query.isNotEmpty
        ? jsonDecode((query.elementAt(0)['value'] as String))
        : null;
  }

   Future<List> buscarAllKeysStorage() async {
    final db = await _openDB();
    final query = await db.query('tb_main', columns: ['key']);
    return query.map((val) => val['key'] as String).toList();
  }

   Future<List> buscarAllLikeStorage(String like) async {
    final db = await _openDB();
    var query =
        await db.rawQuery("SELECT * FROM tb_main WHERE key LIKE '%$like%'");

    return query.map((val) {
      return {
        'key': val['key'],
        'value': jsonDecode((val['value'] as String)),
      };
    }).toList();
  }
