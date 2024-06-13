import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:happiness_jar/view/screens/categories/model/messages_categories_model.dart';
import 'package:happiness_jar/view/screens/categories/model/messages_content_model.dart';

import '../enums/status.dart';
import '../models/resources.dart';
import '../view/screens/notifications/model/notification_model.dart';

class ApiService {

  static const String BASE_URL = "https://post.walid-fekry.com/happiness-jar/api/";

  var dio = Dio();

  ApiService() {
    var options = BaseOptions(
      baseUrl: BASE_URL,
    );
    dio.options = options;
  }

  Future<Resource<MessagesCategoriesModel>> getMessagesCategories() async {
    try {
      var response = await dio.get('messages_categories.php');
      var contentMessagesCategories = MessagesCategoriesModel.fromJson(response.data);
      return Resource(Status.SUCCESS, data: contentMessagesCategories);
    } catch (e) {
      debugPrint(e.toString());
      return Resource(Status.ERROR, errorMessage: e.toString());
    }
  }

  Future<Resource<MessagesContentModel>> getMessagesContent() async {
    try {
      var response = await dio.get('messages_content.php');
      var contentMessages = MessagesContentModel.fromJson(response.data);
      return Resource(Status.SUCCESS, data: contentMessages);
    } catch (e) {
      debugPrint(e.toString());
      return Resource(Status.ERROR, errorMessage: e.toString());
    }
  }

  Future<Resource<NotificationsModel>> getMessagesNotificationContent() async {
    try {
      var response = await dio.get('messages_notifications.php');
      var contentMessagesNotification = NotificationsModel.fromJson(response.data);
      return Resource(Status.SUCCESS, data: contentMessagesNotification);
    } catch (e) {
      debugPrint(e.toString());
      return Resource(Status.ERROR, errorMessage: e.toString());
    }
  }
}
