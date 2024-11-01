



import 'package:flutter/foundation.dart';
import 'package:happiness_jar/view/screens/categories/model/messages_categories_model.dart';
import 'package:happiness_jar/view/screens/favorite/model/favorite_messages_model.dart';
import 'package:happiness_jar/view/screens/feelings/model/FeelingsCategoriesModel.dart';
import 'package:happiness_jar/view/screens/feelings/model/FeelingsContentModel.dart';
import 'package:happiness_jar/view/screens/posts/model/posts_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/database_model.dart';
import '../models/resources.dart';
import '../view/screens/categories/model/messages_content_model.dart';
import '../view/screens/notifications/model/notification_model.dart';


class AppDatabase {
  Future<Database> mainDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'database.db'),
      onCreate: (db, version) => createTables(db),
      version: 3,
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
    db.execute(
      'CREATE TABLE messages_notifications(id INTEGER UNIQUE, text TEXT, created_at TEXT)',
    );
    db.execute(
      'CREATE TABLE user_posts(id INTEGER PRIMARY KEY AUTOINCREMENT, user_name TEXT, text TEXT, created_at TEXT)',
    );
    db.execute(
      'CREATE TABLE feelings_categories(id INTEGER UNIQUE, title TEXT, categorie INTEGER)',
    );
    db.execute(
      'CREATE TABLE feelings_content(id INTEGER UNIQUE, title TEXT, body TEXT, categorie INTEGER)',
    );
  }

  updateTables(Database db) {
    db.execute(
      'CREATE TABLE IF NOT EXISTS user_posts(id INTEGER PRIMARY KEY AUTOINCREMENT,user_name TEXT, text TEXT, created_at TEXT)',
    );
    db.execute(
      'CREATE TABLE IF NOT EXISTS feelings_categories(id INTEGER UNIQUE, title TEXT, categorie INTEGER)',
    );
    db.execute(
      'CREATE TABLE IF NOT EXISTS feelings_content(id INTEGER UNIQUE, title TEXT, body TEXT, categorie INTEGER)',
    );
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
    db?.close();
  }

  Future<void> insert(DatabaseModel model) async {
  final Database? db = await getDb();
  await db?.insert(
    model.table()!,
    model.toMap()!,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  db?.close();
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
    db?.close();
  }

  Future<void> deleteFavoriteMessageByText(String text) async {
    final Database? db = await getDb();
    await db?.delete(
      'favorite_messages',
      where: 'title = ?',
      whereArgs: [text],
    );
    db?.close();
  }

  Future<void> deleteFavoriteMessage(int? id) async {
    final Database? db = await getDb();
    await db?.delete(
      'favorite_messages',
      where: 'id = ?',
      whereArgs: [id],
    );
    db?.close();
  }

  Future<int?> deleteLocalPost(int? id) async {
    final Database? db = await getDb();
    await db?.delete(
      'user_posts',
      where: 'id = ?',
      whereArgs: [id],
    );
    db?.close();
    return null;
  }

    Future<List<MessagesCategories>> getMessagesCategories() async {
    final Database db = await mainDatabase();
    final List<Map<String, dynamic>> maps =
    await db.rawQuery('SELECT * FROM messages_categories ORDER BY RANDOM()');
    List<MessagesCategories> data = [];
    for (var item in maps) {
      data.add(MessagesCategories.fromJson(item));
    }
    db.close();
    return data;
  }

  Future<List<MessagesContent>> getMessagesContent(int? categorie) async {
    final Database db = await mainDatabase();
    final List<Map<String, dynamic>> maps =
    await db.rawQuery('SELECT * FROM messages_content WHERE categorie = $categorie ORDER BY RANDOM()');
    List<MessagesContent> data = [];
    for (var item in maps) {
      data.add(MessagesContent.fromJson(item));
    }
    db.close();
    return data;
  }

  Future<List<MessagesNotifications>> getMessagesNotificationContent() async {
    final Database db = await mainDatabase();
    final List<Map<String, dynamic>> maps =
    await db.rawQuery('SELECT * FROM messages_notifications ORDER BY RANDOM()');
    List<MessagesNotifications> data = [];
    for (var item in maps) {
      data.add(MessagesNotifications.fromJson(item));
    }
    db.close();
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
    db.close();
    return data;
  }

  Future<List<PostItem>> getUserPosts() async {
    final Database db = await mainDatabase();
    final List<Map<String, dynamic>> maps =
    await db.rawQuery('SELECT * FROM user_posts ORDER BY id DESC');
    List<PostItem> data = [];
    for (var item in maps) {
      data.add(PostItem.fromJson(item));
    }
    db.close();
    return data;
  }

  Future<List<FeelingsCategories>> getFeelingsCategories() async {
    final Database db = await mainDatabase();
    final List<Map<String, dynamic>> maps =
    await db.rawQuery('SELECT * FROM feelings_categories ORDER BY id ASC');
    List<FeelingsCategories> data = [];
    for (var item in maps) {
      data.add(FeelingsCategories.fromJson(item));
    }
    db.close();
    return data;
  }

  Future<List<FeelingsContent>> getFeelingsContent(int? categorie) async {
    final Database db = await mainDatabase();

    final String queryDoaa = '''
    SELECT * FROM feelings_content WHERE title = 'دعاء' AND categorie = $categorie ORDER BY RANDOM() LIMIT 1
  ''';

    final String queryNaseha = '''
    SELECT * FROM feelings_content WHERE title = 'نصيحة' AND categorie = $categorie ORDER BY RANDOM() LIMIT 1
  ''';

    final String queryHikma = '''
    SELECT * FROM feelings_content WHERE title = 'حكمة' AND categorie = $categorie ORDER BY RANDOM() LIMIT 1
  ''';

    final String queryKhatima = '''
    SELECT * FROM feelings_content WHERE title = 'خاتمة' AND categorie = $categorie ORDER BY RANDOM() LIMIT 1
  ''';

    List<FeelingsContent> data = [];

    try {
      final List<Map<String, dynamic>> doaaMap = await db.rawQuery(queryDoaa);
      if (doaaMap.isNotEmpty) {
        data.add(FeelingsContent.fromJson(doaaMap.first));
      }

      final List<Map<String, dynamic>> nasehaMap = await db.rawQuery(queryNaseha);
      if (nasehaMap.isNotEmpty) {
        data.add(FeelingsContent.fromJson(nasehaMap.first));
      }

      final List<Map<String, dynamic>> hikmaMap = await db.rawQuery(queryHikma);
      if (hikmaMap.isNotEmpty) {
        data.add(FeelingsContent.fromJson(hikmaMap.first));
      }

      final List<Map<String, dynamic>> khatimaMap = await db.rawQuery(queryKhatima);
      if (khatimaMap.isNotEmpty) {
        data.add(FeelingsContent.fromJson(khatimaMap.first));
      }

      return data;
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching feelings content: $e");
      }
      return [];
    } finally {
      db.close();
    }
  }


// Future<void> update(DatabaseModel model) async {
//   final Database? db = await getDatabase(model);
//   await db!.update(
//     model.table()!,
//     model.toMap()!,
//     where: 'id = ?',
//     whereArgs: [model.getId()!],
//     conflictAlgorithm: ConflictAlgorithm.replace,
//   );
//   debugPrint('model with id :  ${model.getId()} updated ');
//   // db?.close();
// }

// Future<void> delete(DatabaseModel model) async {
//   final Database? db = await getDatabase(model);
//   db?.delete(
//     model.table()!,
//     where: 'id = ?',
//     whereArgs: [
//       model.getId(),
//     ],
//   );
//   // db?.close();
// }

}