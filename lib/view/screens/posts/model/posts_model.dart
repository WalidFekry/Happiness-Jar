import 'package:happiness_jar/models/database_model.dart';

class PostsModel {
  List<PostItem>? content;

  PostsModel({this.content});

  PostsModel.fromJson(Map<String, dynamic> json) {
    if (json['posts'] != null) {
      content = <PostItem>[];
      json['posts'].forEach((v) {
        content!.add(PostItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (content != null) {
      data['posts'] =
          content!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PostItem implements DatabaseModel {
  int? id;
  String? userName;
  String? text;
  int? likes;
  String? createdAt;
  bool isFavourite = false;
  bool isLike = false;

  PostItem({required this.userName, required this.text, required this.createdAt});

  PostItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    userName = json['user_name'];
    createdAt = json['created_at'];
    likes = json['likes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['text'] = text;
    data['user_name'] = userName;
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
    return 'user_posts';
  }

  @override
  Map<String, dynamic>? toMap() {
    return toJson();
  }
}