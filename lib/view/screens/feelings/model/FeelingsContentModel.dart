import 'package:happiness_jar/models/database_model.dart';

class FeelingsContentModel {
  List<FeelingsContent>? content;

  FeelingsContentModel({this.content});

  FeelingsContentModel.fromJson(Map<String, dynamic> json) {
    if (json['feelings_content'] != null) {
      content = <FeelingsContent>[];
      json['feelings_content'].forEach((v) {
        content!.add(FeelingsContent.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (content != null) {
      data['feelings_content'] =
          content!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FeelingsContent implements DatabaseModel {
  int? id;
  String? title;
  String? body;
  int? categorie;

  FeelingsContent({this.id, this.title, this.body, this.categorie});

  FeelingsContent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    categorie = json['categorie'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['body'] = body;
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
    return 'feelings_content';
  }

  @override
  Map<String, dynamic>? toMap() {
    return toJson();
  }
}
