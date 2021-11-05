import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class ApiService {
  final _dio = Dio();

  ApiService();

  Future<List<dynamic>> getVideos(String url) async {
    _dio.options.contentType = "application/json";
    return _dio.get(url).then((response) {
      return response.data as List<dynamic>;
    }).catchError((onError) {
      throw onError;
    });
  }

  Future<List<dynamic>> getQuestions(String url, int videoId) async {
    _dio.options.contentType = "application/json";
    print(url);
    print(videoId.toString());
    var data = jsonEncode({"video_id": videoId});
    return _dio.post(url, data: data).then((response) {
      if ((response.data as List<dynamic>).isEmpty) {
        throw ("No comments yet");
      }
      return response.data as List<dynamic>;
    }).catchError((onError) {
      throw onError;
    });
  }

  Future<void> postQuestion(
      String url, String author, String question, int videoId) {
    _dio.options.contentType = "application/json";

    var data = jsonEncode(
        {"author": author, "question": question, "video_id": videoId});
    return _dio.post(url, data: data).then((value) {}).catchError((onError) {
      throw (onError);
    });
  }

  Future<void> deleteQuestion(String url, int id) async {
    _dio.options.contentType = "application/json";
    var data = jsonEncode({"id": id});
    return _dio.post(url, data: data).then((value) {}).catchError((onError) {
      throw (onError);
    });
  }

  Future<String> postVideo(
      String url, XFile? file, String title, String description) async {
    String defaultVideoTitle = "avideo";
    String extensionFile = "." + (file!.path).split('.').last;
    String newTitle = title == "" ? defaultVideoTitle : title;
    _dio.options.contentType = "multipart/form-data";

    var formData = FormData.fromMap({
      "title": newTitle,
      "description": description,
      "file": await MultipartFile.fromFile(file.path,
          filename: newTitle + extensionFile),
    });
    return _dio.post(url, data: formData).then((value) {
      return value.data.toString();
    }).catchError((onError) {
      throw (onError);
    });
  }

  Future<void> deleteVideo(String url, int videoId) async {
    _dio.options.contentType = "application/json";
    var data = jsonEncode({"id": videoId});
    return _dio.post(url, data: data).then((value) {}).catchError((onError) {
      throw (onError);
    });
  }
}
