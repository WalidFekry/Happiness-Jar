import 'package:sqflite/sqflite.dart';

import '../../../../models/database_model.dart';

class TodayAdviceModel {
  List<TodayAdvice>? content;

  TodayAdviceModel({this.content});

  TodayAdviceModel.fromJson(Map<String, dynamic> json) {
    if (json['messages_advice'] != null) {
      content = <TodayAdvice>[];
      json['messages_advice'].forEach((v) {
        content!.add(TodayAdvice.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (content != null) {
      data['messages_advice'] =
          content!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TodayAdvice
{
  int? id;
  String? body;
  String? createdAt;

  TodayAdvice({this.id, this.body, this.createdAt});

  TodayAdvice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    body = json['body'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['body'] = body;
    data['crated_at'] = createdAt;
    return data;
  }
}
