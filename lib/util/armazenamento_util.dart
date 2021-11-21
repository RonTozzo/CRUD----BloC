import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ArmazenamentoUtil {
  static Future<Database> _openDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'storage.db');

    return openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
        'CREATE TABLE tb_main (key STRING PRIMARY KEY, value TEXT)',
      );
    });
  }

  static Future<void> zerar() async {
    final db = await _openDB();
    db.delete('tb_main');
  }

  static Future<void> salvar(String key, dynamic data) async {
    final db = await _openDB();
    await db.insert(
      'tb_main',
      {'key': key, 'value': json.encode(data)},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> apagar(key) async {
    final db = await _openDB();
    await db.delete('tb_main', where: 'key = ?', whereArgs: [key]);
  }

  static Future<dynamic> buscar(String key) async {
    final db = await _openDB();
    final query = await db.query('tb_main', where: 'key = ?', whereArgs: [key]);
    return query.isNotEmpty
        ? jsonDecode((query.elementAt(0)['value'] as String))
        : null;
  }

  static Future<List> buscarAllKeys() async {
    final db = await _openDB();
    final query = await db.query('tb_main', columns: ['key']);
    return query.map((val) => val['key'] as String).toList();
  }

  static Future<List> buscarAllLike(String like) async {
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
}
