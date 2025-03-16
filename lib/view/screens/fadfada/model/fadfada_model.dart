import '../../../../models/database_model.dart';

class FadfadaModel implements DatabaseModel {
  int? id;
  String? category;
  String? text;
  int? createdAt;

  FadfadaModel(
      {this.id,required this.category, required this.text, this.createdAt});

  FadfadaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    text = json['text'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category'] = category;
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
    return 'fadfada';
  }

  @override
  Map<String, dynamic>? toMap() {
    return toJson();
  }
}
