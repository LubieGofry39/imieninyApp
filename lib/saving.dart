import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        dayMonthId INTEGER,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }


  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'imieniny.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (journal)
  static Future<int> createItem(int day, int month) async {
    final db = await SQLHelper.db();

    final data = {'dayMonthId': month*100+day};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

 // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('items', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  // static Future<List<Map<String, dynamic>>> getItem(int id) async {
    
  //   final db = await SQLHelper.db();
  //   return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  // }

  // Update an item by id
 
  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    
    try {
      await db.delete("items", where: "dayMonthId = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
    
  }

  
}