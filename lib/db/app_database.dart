


import 'dart:ffi';

import 'package:happiness_jar/view/screens/categories/model/messages_categories_model.dart';
import 'package:happiness_jar/view/screens/favorite/model/favorite_messages_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/resources.dart';


class AppDatabase {
  Future<Database> mainDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'database.db'),
      onCreate: (db, version) => createTables(db),
      version: 1,
      onUpgrade: (db, oldVersion, newVersion) => updateTables(db),
    );
  }
  createTables(Database db) {
    db.execute(
      'CREATE TABLE messages_categories(id INTEGER UNIQUE, title TEXT, categorie INTEGER)',
    );
    db.execute(
      'CREATE TABLE messages_content(id INTEGER UNIQUE, title TEXT, categorie INTEGER)',
    );
    db.execute(
      'CREATE TABLE favorite_messages(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, created_at TEXT)',
    );
  }

  updateTables(Database db) {
  }

  Future<Database?> getDb() async {
    return await mainDatabase();
  }

  Future<void> insertData(Resource resource) async {
    final Database? db = await getDb();
    var batch = db?.batch();
    for (var element in resource.data!.content!) {
      batch?.insert(
        element.table()!,
        element.toMap()!,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch?.commit(noResult: true);
  }

  Future<void> saveFavoriteMessage(String? title, String createdAt) async {
    final Database? db = await getDb();
    await db?.insert(
      'favorite_messages',
      {
        'title': title,
        'created_at': createdAt,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int?> deleteFavoriteMessage(int? id) async {
    final Database? db = await getDb();
    await db?.delete(
      'favorite_messages',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


    Future<List<MessagesCategories>> getMessagesCategories() async {
    final Database db = await mainDatabase();
    final List<Map<String, dynamic>> maps =
    await db.rawQuery('SELECT * FROM messages_categories ORDER BY RANDOM()');
    List<MessagesCategories> data = [];
    for (var item in maps) {
      data.add(MessagesCategories.fromJson(item));
    }
    return data;
  }

  Future<List<MessagesCategories>> getMessagesContent(int? categorie) async {
    final Database db = await mainDatabase();
    final List<Map<String, dynamic>> maps =
    await db.rawQuery('SELECT * FROM messages_content WHERE categorie = $categorie ORDER BY RANDOM()');
    List<MessagesCategories> data = [];
    for (var item in maps) {
      data.add(MessagesCategories.fromJson(item));
    }
    return data;
  }

  Future<List<FavoriteMessagesModel>> getFavoriteMessages() async {
    final Database db = await mainDatabase();
    final List<Map<String, dynamic>> maps =
    await db.rawQuery('SELECT * FROM favorite_messages ORDER BY id DESC');
    List<FavoriteMessagesModel> data = [];
    for (var item in maps) {
      data.add(FavoriteMessagesModel.fromJson(item));
    }
    return data;
  }


}