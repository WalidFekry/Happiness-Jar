class TodayAdviceModel {
  int? id;
  String? body;

  TodayAdviceModel(
      {this.id, this.body});

  TodayAdviceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['body'] = body;
    return data;
  }
}