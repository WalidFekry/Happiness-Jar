import 'package:sqflite/sqflite.dart';

import '../../../../models/database_model.dart';

class MessagesCategoriesModel {
  List<MessagesCategories>? content;

  MessagesCategoriesModel({this.content});

  MessagesCategoriesModel.fromJson(Map<String, dynamic> json) {
    if (json['messages_categories'] != null) {
      content = <MessagesCategories>[];
      json['messages_categories'].forEach((v) {
        content!.add(MessagesCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (content != null) {
      data['messages_categories'] =
          content!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MessagesCategories implements DatabaseModel {
  int? id;
  String? title;
  int? categorie;
  bool isFavourite = false;

  MessagesCategories({this.id, this.title, this.categorie});

  MessagesCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    categorie = json['categorie'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['categorie'] = categorie;
    return data;
  }

  @override
  String? database() {
    return 'database';
  }

  @override
  int? getId() {
    return id;
  }

  @override
  String? table() {
    return 'messages_categories';
  }

  @override
  Map<String, dynamic>? toMap() {
    return toJson();
  }
}
