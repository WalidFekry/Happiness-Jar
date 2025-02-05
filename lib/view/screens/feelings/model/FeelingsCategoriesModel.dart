import 'package:happiness_jar/models/database_model.dart';

class FeelingsCategoriesModel {
  List<FeelingsCategories>? content;

  FeelingsCategoriesModel({this.content});

  FeelingsCategoriesModel.fromJson(Map<String, dynamic> json) {
    if (json['feelings_categories'] != null) {
      content = <FeelingsCategories>[];
      json['feelings_categories'].forEach((v) {
        content!.add(FeelingsCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (content != null) {
      data['feelings_categories'] =
          content!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FeelingsCategories implements DatabaseModel{
  int? id;
  String? title;
  int? categorie;

  FeelingsCategories({this.id, this.title, this.categorie});

  FeelingsCategories.fromJson(Map<String, dynamic> json) {
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
    return 'feelings_categories';
  }

  @override
  Map<String, dynamic>? toMap() {
    return toJson();
  }
}
