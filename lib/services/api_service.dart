import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:happiness_jar/view/screens/categories/model/messages_categories_model.dart';
import 'package:happiness_jar/view/screens/categories/model/messages_content_model.dart';
import 'package:happiness_jar/view/screens/home/model/refresh_token.dart';
import 'package:happiness_jar/view/screens/home/model/today_advice.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../enums/status.dart';
import '../models/resources.dart';
import '../view/screens/messages/model/messages_model.dart';
import '../view/screens/messages/model/wheel_model.dart';
import '../view/screens/notifications/model/notification_model.dart';

class ApiService {
  static const String BASE_URL =
      "https://post.walid-fekry.com/happiness-jar/api/";

  var dio = Dio();

  ApiService() {
    var options = BaseOptions(
      baseUrl: BASE_URL,
    );
    dio.options = options;
    dio.interceptors.add(PrettyDioLogger(
      requestBody: true,
      requestHeader: true,
    ));
  }

  Future<Resource<MessagesCategoriesModel>> getMessagesCategories() async {
    try {
      var response = await dio.get('messages_categories.php');
      var contentMessagesCategories =
          MessagesCategoriesModel.fromJson(response.data);
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
      var contentMessagesNotification =
          NotificationsModel.fromJson(response.data);
      return Resource(Status.SUCCESS, data: contentMessagesNotification);
    } catch (e) {
      debugPrint(e.toString());
      return Resource(Status.ERROR, errorMessage: e.toString());
    }
  }

  Future<Resource<MessagesModel>> getMessages() async {
    try {
      var response = await dio.get('messages.php');
      var contentMessages = MessagesModel.fromJson(response.data);
      return Resource(Status.SUCCESS, data: contentMessages);
    } catch (e) {
      debugPrint(e.toString());
      return Resource(Status.ERROR, errorMessage: e.toString());
    }
  }

  Future<Resource<RefreshTokenModel>> refreshToken(
      String fcmToken, String name) async {
    try {
      var response = await dio.post(
        'register.php',
        data: {'server': 'Register', 'fcm_token': fcmToken, 'name': name},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      var refreshToken = RefreshTokenModel.fromJson(response.data);
      return Resource(Status.SUCCESS, data: refreshToken);
    } catch (e) {
      debugPrint(e.toString());
      return Resource(Status.ERROR, errorMessage: e.toString());
    }
  }

  Future<Resource<TodayAdviceModel>> getAdviceMessage() async {
    try {
      var response = await dio.get('messages_advice.php');
      var contentMessage = TodayAdviceModel.fromJson(response.data);
      return Resource(Status.SUCCESS, data: contentMessage);
    } catch (e) {
      debugPrint(e.toString());
      return Resource(Status.ERROR, errorMessage: e.toString());
    }
  }

  Future<Resource<WheelModel>> getAllWheelImages() async {
    try {
      var response = await dio.get(
        'wheel.php',
      );
      var wheelResponse = WheelModel.fromJson(response.data);
      return Resource(Status.SUCCESS, data: wheelResponse);
    } catch (e) {
      debugPrint(e.toString());
      return Resource(Status.ERROR, errorMessage: e.toString());
    }
  }
}
