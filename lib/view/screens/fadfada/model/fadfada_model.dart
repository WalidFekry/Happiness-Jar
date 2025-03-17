import '../../../../models/database_model.dart';

class FadfadaModel implements DatabaseModel {
  int? id;
  String? category;
  String? text;
  int? createdAt;
  bool isPinned;
  int? timeSpent;

  FadfadaModel({
    this.id,
    required this.category,
    required this.text,
    this.createdAt,
    this.isPinned = false,
    this.timeSpent,
  });

  FadfadaModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        category = json['category'],
        text = json['text'],
        createdAt = json['created_at'],
        isPinned = json['is_pinned'] == 1,
        timeSpent = json['time_spent'] ?? 0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'text': text,
      'created_at': createdAt,
      'is_pinned': isPinned ? 1 : 0,
      'time_spent': timeSpent,
    };
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
