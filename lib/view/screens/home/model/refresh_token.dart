class RefreshTokenModel {
  bool? success;
  String? message;
  int? id;
  String? name;
  String? lastSeen;

  RefreshTokenModel(
      {this.success, this.message, this.id, this.name, this.lastSeen});

  RefreshTokenModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    id = json['id'];
    name = json['name'];
    lastSeen = json['last_seen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['id'] = id;
    data['name'] = name;
    data['last_seen'] = lastSeen;
    return data;
  }
}