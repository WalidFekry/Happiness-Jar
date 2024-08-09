
import '../../../../models/database_model.dart';

class MessagesContentModel {
  List<MessagesContent>? content;

  MessagesContentModel({this.content});

  MessagesContentModel.fromJson(Map<String, dynamic> json) {
    if (json['messages_content'] != null) {
      content = <MessagesContent>[];
      json['messages_content'].forEach((v) {
        content!.add(MessagesContent.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (content != null) {
      data['messages_content'] =
          content!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MessagesContent implements DatabaseModel {
  int? id;
  String? title;
  int? categorie;
  bool isFavourite = false;

  MessagesContent({this.id, this.title, this.categorie});

  MessagesContent.fromJson(Map<String, dynamic> json) {
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
    return 'messages_content';
  }

  @override
  Map<String, dynamic>? toMap() {
    return toJson();
  }
}
