import '../../../../models/database_model.dart';

class FadfadaModel implements DatabaseModel {
  int? id;
  String? category;
  String? text;
  int? createdAt;
  bool isPinned;

  FadfadaModel(
      {this.id,
        required this.category,
        required this.text,
        this.createdAt,
        this.isPinned = false});

  FadfadaModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        category = json['category'],
        text = json['text'],
        createdAt = json['created_at'],
        isPinned = json['is_pinned'] == 1;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category'] = category;
    data['text'] = text;
    data['created_at'] = createdAt;
    data['is_pinned'] = isPinned ? 1 : 0;
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
    return 'fadfada';
  }

  @override
  Map<String, dynamic>? toMap() {
    return toJson();
  }
}
