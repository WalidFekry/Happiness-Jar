class NotificationsCountModel {
  int? notificationsCount;
  int? postsCount;

  NotificationsCountModel({this.notificationsCount, this.postsCount});

  NotificationsCountModel.fromJson(Map<String, dynamic> json) {
    notificationsCount = json['notifications_count'];
    postsCount = json['posts_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['notifications_count'] = notificationsCount;
    data['posts_count'] = postsCount;
    return data;
  }
}