import 'package:flutter/foundation.dart';
import 'package:happiness_jar/view/screens/categories/model/messages_categories_model.dart';
import 'package:happiness_jar/view/screens/fadfada/model/fadfada_model.dart';
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
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await openDatabase(
      join(await getDatabasesPath(), 'database.db'),
      version: 4,
      onCreate: (db, version) => createTables(db),
      onUpgrade: (db, oldVersion, newVersion) => updateTables(db),
    );

    return _database!;
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
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
    db.execute(
      'CREATE TABLE today_advice(id INTEGER UNIQUE, body TEXT)',
    );
    db.execute(
      'CREATE TABLE fadfada(id INTEGER PRIMARY KEY AUTOINCREMENT, category TEXT, text TEXT, created_at INTEGER)',
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
    db.execute(
      'CREATE TABLE IF NOT EXISTS today_advice(id INTEGER UNIQUE, body TEXT)',
    );
    db.execute(
      'CREATE TABLE IF NOT EXISTS fadfada(id INTEGER PRIMARY KEY AUTOINCREMENT, category TEXT, text TEXT, created_at INTEGER)',
    );
  }

  Future<void> insertData(Resource resource) async {
    final Database db = await database;
    var batch = db.batch();
    for (var element in resource.data!.content!) {
      batch.insert(
        element.table()!,
        element.toMap()!,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> insert(DatabaseModel model) async {
    final Database db = await database;
    await db.insert(
      model.table()!,
      model.toMap()!,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteById(int? id, String table) async {
    final Database db = await database;
    int count = await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
    return count;
  }

  Future<void> saveFavoriteMessage(String? title, String createdAt) async {
    final Database db = await database;
    await db.insert(
      'favorite_messages',
      {
        'title': title,
        'created_at': createdAt,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteFavoriteMessageByText(String text) async {
    final Database db = await database;
    await db.delete(
      'favorite_messages',
      where: 'title = ?',
      whereArgs: [text],
    );
  }

  Future<List<MessagesCategories>> getMessagesCategories() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db
        .rawQuery('SELECT * FROM messages_categories ORDER BY RANDOM()');
    List<MessagesCategories> data = [];
    for (var item in maps) {
      data.add(MessagesCategories.fromJson(item));
    }
    return data;
  }

  Future<List<MessagesContent>> getMessagesContent(int? categorie) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM messages_content WHERE categorie = $categorie ORDER BY RANDOM()');
    List<MessagesContent> data = [];
    for (var item in maps) {
      data.add(MessagesContent.fromJson(item));
    }
    return data;
  }

  Future<List<MessagesNotifications>> getMessagesNotificationContent() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db
        .rawQuery('SELECT * FROM messages_notifications ORDER BY RANDOM()');
    List<MessagesNotifications> data = [];
    for (var item in maps) {
      data.add(MessagesNotifications.fromJson(item));
    }
    return data;
  }

  Future<List<MessagesNotifications>> getMessageNotificationContentById(
      int id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db
        .rawQuery('SELECT * FROM messages_notifications WHERE id = ?', [id]);
    List<MessagesNotifications> data = [];
    if (maps.isNotEmpty) {
      data.add(MessagesNotifications.fromJson(maps.first));
    }
    return data;
  }

  Future<List<FavoriteMessagesModel>> getFavoriteMessages() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM favorite_messages ORDER BY id DESC');
    List<FavoriteMessagesModel> data = [];
    for (var item in maps) {
      data.add(FavoriteMessagesModel.fromJson(item));
    }
    return data;
  }

  Future<List<PostItem>> getUserPosts() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM user_posts ORDER BY id DESC');
    List<PostItem> data = [];
    for (var item in maps) {
      data.add(PostItem.fromJson(item));
    }
    return data;
  }

  Future<List<FeelingsCategories>> getFeelingsCategories() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM feelings_categories ORDER BY id ASC');
    List<FeelingsCategories> data = [];
    for (var item in maps) {
      data.add(FeelingsCategories.fromJson(item));
    }
    return data;
  }

  Future<List<FeelingsContent>> getFeelingsContent(int? categorie) async {
    final Database db = await database;

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

      final List<Map<String, dynamic>> nasehaMap =
          await db.rawQuery(queryNaseha);
      if (nasehaMap.isNotEmpty) {
        data.add(FeelingsContent.fromJson(nasehaMap.first));
      }

      final List<Map<String, dynamic>> hikmaMap = await db.rawQuery(queryHikma);
      if (hikmaMap.isNotEmpty) {
        data.add(FeelingsContent.fromJson(hikmaMap.first));
      }

      final List<Map<String, dynamic>> khatimaMap =
          await db.rawQuery(queryKhatima);
      if (khatimaMap.isNotEmpty) {
        data.add(FeelingsContent.fromJson(khatimaMap.first));
      }

      return data;
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching feelings content: $e");
      }
      return [];
    } finally {}
  }

  Future<String?> getAdviceMessage() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db
        .rawQuery('SELECT body FROM today_advice ORDER BY RANDOM() LIMIT 1');
    String? data;
    if (maps.isNotEmpty) {
      data = maps.first['body'] as String?;
    }
    return data;
  }

  Future<List<FadfadaModel>> getFadfadaList() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps =
    await db.rawQuery('SELECT * FROM fadfada ORDER BY id DESC');
    List<FadfadaModel> data = [];
    for (var item in maps) {
      data.add(FadfadaModel.fromJson(item));
    }
    return data;
  }
}
