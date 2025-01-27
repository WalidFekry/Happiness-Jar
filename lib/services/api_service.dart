import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:happiness_jar/constants/api_constants.dart';
import 'package:happiness_jar/view/screens/categories/model/messages_categories_model.dart';
import 'package:happiness_jar/view/screens/categories/model/messages_content_model.dart';
import 'package:happiness_jar/view/screens/feelings/model/FeelingsCategoriesModel.dart';
import 'package:happiness_jar/view/screens/feelings/model/FeelingsContentModel.dart';
import 'package:happiness_jar/view/screens/home/model/refresh_token.dart';
import 'package:happiness_jar/view/screens/home/model/today_advice.dart';
import 'package:happiness_jar/view/screens/posts/model/add_post_response_model.dart';
import 'package:happiness_jar/view/screens/posts/model/like_post_response_model.dart';
import 'package:happiness_jar/view/screens/posts/model/posts_model.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../enums/status.dart';
import '../models/resources.dart';
import '../view/screens/messages/model/messages_model.dart';
import '../view/screens/messages/model/wheel_model.dart';
import '../view/screens/notifications/model/notification_model.dart';

class ApiService {
  var dio = Dio();

  ApiService() {
    var options = BaseOptions(baseUrl: ApiConstants.baseUrl, headers: {
      "Content-Type": "application/json",
    });
    dio.options = options;
    dio.interceptors.add(PrettyDioLogger(
      requestBody: true,
      requestHeader: true,
    ));
  }

  Future<Resource<MessagesCategoriesModel>> getMessagesCategories() async {
    try {
      var response = await dio.get(ApiConstants.messagesCategories);
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
      var response = await dio.get(ApiConstants.messagesContent);
      var contentMessages = MessagesContentModel.fromJson(response.data);
      return Resource(Status.SUCCESS, data: contentMessages);
    } catch (e) {
      debugPrint(e.toString());
      return Resource(Status.ERROR, errorMessage: e.toString());
    }
  }

  Future<Resource<NotificationsModel>> getMessagesNotificationContent(
      {required int limit, required int offset}) async {
    try {
      var response = await dio.get(
        ApiConstants.messagesNotifications,
        queryParameters: {
          'limit': limit,
          'offset': offset,
        },
      );

      var contentMessagesNotification =
          NotificationsModel.fromJson(response.data);
      return Resource(Status.SUCCESS, data: contentMessagesNotification);
    } catch (e) {
      debugPrint(e.toString());
      return Resource(Status.ERROR, errorMessage: e.toString());
    }
  }

  Future<Resource<PostsModel>> getPosts(
      {required int limit, required int offset}) async {
    try {
      var response = await dio.get(
        ApiConstants.posts,
        queryParameters: {
          'limit': limit,
          'offset': offset,
        },
      );
      var postsContent = PostsModel.fromJson(response.data);
      return Resource(Status.SUCCESS, data: postsContent);
    } catch (e) {
      debugPrint(e.toString());
      return Resource(Status.ERROR, errorMessage: e.toString());
    }
  }

  Future<Resource<MessagesModel>> getMessages() async {
    try {
      var response = await dio.get(ApiConstants.messages);
      var contentMessages = MessagesModel.fromJson(response.data);
      return Resource(Status.SUCCESS, data: contentMessages);
    } catch (e) {
      debugPrint(e.toString());
      return Resource(Status.ERROR, errorMessage: e.toString());
    }
  }

  Future<Resource<RefreshTokenModel>> refreshToken(
      String? fcmToken, String? name) async {
    try {
      var response = await dio.post(
        ApiConstants.register,
        data: {'server': 'Register', 'fcm_token': fcmToken, 'name': name},
      );
      var refreshToken = RefreshTokenModel.fromJson(response.data);
      return Resource(Status.SUCCESS, data: refreshToken);
    } catch (e) {
      debugPrint(e.toString());
      return Resource(Status.ERROR, errorMessage: e.toString());
    }
  }

  Future<Resource<LikePostResponseModel>> likePost(
      String? server, int? postId) async {
    try {
      var response = await dio.post(
        ApiConstants.likePost,
        data: {'server': server, 'post_id': postId},
      );
      var responseModel = LikePostResponseModel.fromJson(response.data);
      return Resource(Status.SUCCESS, data: responseModel);
    } catch (e) {
      debugPrint(e.toString());
      return Resource(Status.ERROR, errorMessage: e.toString());
    }
  }

  Future<Resource<TodayAdviceModel>> getAdviceMessage() async {
    try {
      var response = await dio.get(ApiConstants.messagesAdvice);
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
        ApiConstants.wheel,
      );
      var wheelResponse = WheelModel.fromJson(response.data);
      return Resource(Status.SUCCESS, data: wheelResponse);
    } catch (e) {
      debugPrint(e.toString());
      return Resource(Status.ERROR, errorMessage: e.toString());
    }
  }

  Future<Resource<AddPostResponseModel>> addPost(
      String? fcmToken, String text, String userName) async {
    try {
      var response = await dio.post(
        ApiConstants.addPost,
        data: {
          'server': 'AddPost',
          'fcm_token': fcmToken,
          'text': text,
          'user_name': userName
        },
      );
      var responseModel = AddPostResponseModel.fromJson(response.data);
      return Resource(Status.SUCCESS, data: responseModel);
    } catch (e) {
      debugPrint(e.toString());
      return Resource(Status.ERROR, errorMessage: e.toString());
    }
  }

  Future<Resource<FeelingsCategoriesModel>> getFeelingsCategories() async {
    try {
      var response = await dio.get(ApiConstants.feelingCategories);
      var feelingsCategoriesContent =
          FeelingsCategoriesModel.fromJson(response.data);
      return Resource(Status.SUCCESS, data: feelingsCategoriesContent);
    } catch (e) {
      debugPrint(e.toString());
      return Resource(Status.ERROR, errorMessage: e.toString());
    }
  }

  Future<Resource<FeelingsContentModel>> getFeelingsContent() async {
    try {
      var response = await dio.get(ApiConstants.feelingsContent);
      var feelingsContent = FeelingsContentModel.fromJson(response.data);
      return Resource(Status.SUCCESS, data: feelingsContent);
    } catch (e) {
      debugPrint(e.toString());
      return Resource(Status.ERROR, errorMessage: e.toString());
    }
  }
}
