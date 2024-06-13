import 'package:happiness_jar/models/database_model.dart';

class NotificationsModel {
  List<MessagesNotifications>? content;

  NotificationsModel({this.content});

  NotificationsModel.fromJson(Map<String, dynamic> json) {
    if (json['messages_notifications'] != null) {
      content = <MessagesNotifications>[];
      json['messages_notifications'].forEach((v) {
        content!.add(MessagesNotifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (content != null) {
      data['messages_notifications'] =
          content!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MessagesNotifications implements DatabaseModel {
  int? id;
  String? text;
  String? createdAt;
  bool isFavourite = false;

  MessagesNotifications({this.id, this.text, this.createdAt});

  MessagesNotifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['text'] = text;
    data['created_at'] = createdAt;
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
    return 'messages_notifications';
  }

  @override
  Map<String, dynamic>? toMap() {
    return toJson();
  }
}