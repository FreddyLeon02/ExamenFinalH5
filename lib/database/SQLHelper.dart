import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLHelperPerson {
  SQLHelperPerson._();
  static final SQLHelperPerson db = SQLHelperPerson._();
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await createTables();
    return _database;
  }

  static Future<Database> createTables() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "database.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("""CREATE TABLE persons(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        lastname TEXT,
        description TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
    });
  }
  // id: the id of a item
  // title, description: name and description of your activity
  // created_at: the time that the item was created. It will be automatically handled by SQLite

  // Create new item (journal)
  Future<int> createItem(
      String? name, String? lastname, String? description) async {
    Database? db = await database;

    final data = {
      'name': name,
      'lastname': lastname,
      'description': description
    };
    final id = await db!.insert('persons', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (journals)
  Future<List<Map<String, dynamic>>> getItems() async {
    Database? db = await database;
    return db!.query('persons', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  Future<List<Map<String, dynamic>>> getItem(int id) async {
    Database? db = await database;
    return db!.query('persons', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  Future<int> updateItem(
      int id, String name, String? lastname, String? description) async {
    final db = await database;

    final data = {
      'name': name,
      'lastname': lastname,
      'description': description,
      'createdAt': DateTime.now().toString()
    };

    final result =
        await db!.update('persons', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  Future<void> deleteItem(int id) async {
    final db = await database;
    try {
      await db!.delete("persons", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an Person: $err");
    }
  }
}

//tabla GRUPOS

class SQLHelperGroup {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE groups(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        type INTEGER,
        description TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
  // id: the id of a item
  // title, description: name and description of your activity
  // created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'database.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (journal)
  static Future<int> createItem(
      String title, String? descrption, String? type) async {
    final db = await SQLHelperGroup.db();

    final data = {'title': title, 'description': descrption, 'type': type};
    final id = await db.insert('groups', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelperGroup.db();
    return db.query('groups', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelperGroup.db();
    return db.query('groups', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id, String title, String? descrption, String? type) async {
    final db = await SQLHelperGroup.db();

    final data = {
      'title': title,
      'type': type,
      'description': descrption,
      'createdAt': DateTime.now().toString()
    };

    final result =
        await db.update('groups', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelperGroup.db();
    try {
      await db.delete("groups", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
