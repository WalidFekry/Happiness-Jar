import 'package:sqflite/sqflite.dart';

import '../../../../models/database_model.dart';

class MessagesModel {
  List<Messages>? content;

  MessagesModel({this.content});

  MessagesModel.fromJson(Map<String, dynamic> json) {
    if (json['messages'] != null) {
      content = <Messages>[];
      json['messages'].forEach((v) {
        content!.add(Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (content != null) {
      data['messages'] =
          content!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Messages
{
  int? id;
  String? body;
  String? imageUrl;
  bool isFavourite = false;

  Messages({this.id, this.body, this.imageUrl});

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    body = json['body'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['body'] = body;
    data['image_url'] = imageUrl;
    return data;
  }
}
