class VideoResponseModel {
  bool? success;
  String? order;
  int? count;
  List<Data>? data;

  VideoResponseModel({this.success, this.order, this.count, this.data});

  VideoResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    order = json['order'];
    count = json['count'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['order'] = order;
    data['count'] = count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? videoName;
  String? videoUrl;
  int? views;
  int? likes;
  bool? isLiked = false;

  Data({this.id, this.videoName, this.videoUrl, this.views, this.likes});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    videoName = json['video_name'];
    videoUrl = json['video_url'];
    views = json['views'];
    likes = json['likes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['video_name'] = videoName;
    data['video_url'] = videoUrl;
    data['views'] = views;
    data['likes'] = likes;
    return data;
  }
}