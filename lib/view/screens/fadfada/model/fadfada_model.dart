import '../../../../models/database_model.dart';

class FadfadaModel implements DatabaseModel {
  int? id;
  String? category;
  String? text;
  int? createdAt;
  bool isPinned;
  int? timeSpent;
  String? audioPath;
  bool hasAudio;

  FadfadaModel({
    this.id,
    required this.category,
    required this.text,
    this.createdAt,
    this.isPinned = false,
    this.timeSpent,
    this.audioPath,
    this.hasAudio = false,
  });

  FadfadaModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        category = json['category'],
        text = json['text'],
        createdAt = json['created_at'],
        isPinned = json['is_pinned'] == 1,
        timeSpent = json['time_spent'] ?? 0,
        audioPath = json['audio_path'],
        hasAudio = json['has_audio'] == 1;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'text': text,
      'created_at': createdAt,
      'is_pinned': isPinned ? 1 : 0,
      'time_spent': timeSpent,
      'audio_path': audioPath,
      'has_audio': hasAudio ? 1 : 0,
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
