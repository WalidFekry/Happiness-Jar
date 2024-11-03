

import 'package:happiness_jar/models/database_model.dart';

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

class TodayAdvice implements DatabaseModel
{
  int? id;
  String? body;

  TodayAdvice({this.id, this.body});

  TodayAdvice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['body'] = body;
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
    return 'today_advice';
  }

  @override
  Map<String, dynamic>? toMap() {
    return toJson();
  }
}
