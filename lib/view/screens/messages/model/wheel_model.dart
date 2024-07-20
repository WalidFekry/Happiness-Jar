class WheelModel {
  List<WheelImage>? wheel;

  WheelModel({this.wheel});

  WheelModel.fromJson(Map<String, dynamic> json) {
    if (json['wheel'] != null) {
      wheel = <WheelImage>[];
      json['wheel'].forEach((v) {
        wheel!.add(WheelImage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (wheel != null) {
      data['wheel'] = wheel!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WheelImage {
  int? id;
  String? url;

  WheelImage({this.id, this.url});

  WheelImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['url'] = url;
    return data;
  }
}
